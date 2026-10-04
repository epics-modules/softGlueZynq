#!/usr/bin/env python3
"""
softglue_connections.py

Build a signal-connection report for softGlueZynq from a dbl-all.txt file.

Intended deployment:
  - This script lives in the softGlueZynq support module in $(SOFTGLUEZYNQ)/utils

  - An IOC-local wrapper script lives in the IOC startup directory.
    That wrapper should find dbl-all.txt and call this script.

Details:
  - Candidate connection records are PVs ending in "_Signal".
  - Live values are read from <PV>.VAL.
  - Direction is determined by:
        FI#_Signal -> driver/source
        FO#_Signal -> load/destination
        otherwise use <PV>.DESC:
            DESC starts with "OUT" -> driver/source
            DESC starts with "IN"  -> load/destination
  - Optional live state is read from companion *_BI records when requested.
  - If any required PV cannot be read, the script exits with an error.

Requires: pyepics
"""



from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass, field
from typing import Literal, Optional

try:
    import epics
except ImportError:
    epics = None


Direction = Literal["DRIVER", "LOAD", "UNKNOWN"]

ValueKind = Literal[
    "blank",
    "constant",
    "pulse",
    "named",
    "named_inverted",
    "invalid_driver_inverted",
]


class PVConnectionError(RuntimeError):
    """Raised when one or more required PVs cannot be read."""


@dataclass
class SignalRecord:
    pv: str
    direction: Direction
    desc: str
    raw_value: str
    value_kind: ValueKind
    signal_name: Optional[str]
    inverted: bool = False
    state_pv: Optional[str] = None
    state_value: Optional[str] = None
    notes: list[str] = field(default_factory=list)


@dataclass
class SignalUse:
    signal_name: str
    drivers: list[SignalRecord] = field(default_factory=list)
    loads: list[SignalRecord] = field(default_factory=list)
    inverted_loads: list[SignalRecord] = field(default_factory=list)


@dataclass
class Report:
    signals: list[SignalUse]
    constants: list[SignalRecord]
    pulses: list[SignalRecord]
    blank_drivers: list[SignalRecord]
    blank_loads: list[SignalRecord]
    unknown_direction: list[SignalRecord]
    warnings: list[str]


def read_dbl_all(path: str) -> list[str]:
    pvs: list[str] = []

    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("#"):
                continue

            pv = line.split()[0].strip()

            if pv:
                pvs.append(pv)

    return pvs


def find_signal_pvs(all_pvs: list[str]) -> list[str]:
    return sorted({pv for pv in all_pvs if pv.endswith("_Signal")})


def clean_ca_string(value) -> Optional[str]:
    if value is None:
        return None

    if isinstance(value, bytes):
        value = value.decode(errors="replace")

    return str(value).strip()


def format_missing_pv_error(context: str, missing: list[str], total: int) -> str:
    shown = missing[:20]
    extra = len(missing) - len(shown)

    msg = [
        f"Could not read {len(missing)} of {total} PV(s) while reading {context}.",
        "",
        "This usually means the IOC is not running, CA address settings are wrong,",
        "or dbl-all.txt does not match the running IOC.",
        "",
        "First missing PVs:",
    ]

    msg.extend(f"  {pv}" for pv in shown)

    if extra > 0:
        msg.append(f"  ... and {extra} more")

    return "\n".join(msg)


def caget_many_string(
    pvs: list[str],
    timeout: float,
    context: str,
    require_all: bool = True,
) -> list[Optional[str]]:
    """
    Read many PVs as strings.

    If require_all=True, any unreadable PV causes PVConnectionError.
    This prevents IOC-down cases from becoming bogus report entries.
    """
    if epics is None:
        raise RuntimeError("pyepics is not installed. Install with: pip install pyepics")

    if not pvs:
        return []

    values: list[Optional[str]]

    if hasattr(epics, "caget_many"):
        try:
            raw_values = epics.caget_many(pvs, as_string=True, timeout=timeout)
            values = [clean_ca_string(v) for v in raw_values]
        except Exception as exc:
            raise PVConnectionError(
                f"Channel Access read failed while reading {context}: {exc}"
            ) from exc
    else:
        values = []

        for pv in pvs:
            try:
                value = epics.caget(pv, as_string=True, timeout=timeout)
            except Exception:
                value = None

            cleaned = clean_ca_string(value)
            values.append(cleaned)

            if require_all and cleaned is None:
                raise PVConnectionError(
                    format_missing_pv_error(context, [pv], len(pvs))
                )

    if require_all:
        missing = [pv for pv, value in zip(pvs, values) if value is None]

        if missing:
            raise PVConnectionError(
                format_missing_pv_error(context, missing, len(pvs))
            )

    return values


def final_component(pv: str) -> str:
    return pv.split(":")[-1]


def direction_from_pv_and_desc(pv: str, desc: Optional[str]) -> Direction:
    comp = final_component(pv)

    if re.fullmatch(r"FI\d+_Signal", comp):
        return "DRIVER"

    if re.fullmatch(r"FO\d+_Signal", comp):
        return "LOAD"

    if not desc:
        return "UNKNOWN"

    d = desc.strip().upper()

    if d.startswith("OUT"):
        return "DRIVER"

    if d.startswith("IN"):
        return "LOAD"

    return "UNKNOWN"


def classify_signal_value(
    raw_value: Optional[str],
    direction: Direction,
) -> tuple[ValueKind, Optional[str], bool, list[str]]:
    notes: list[str] = []
    value = (raw_value or "").strip()

    if value == "":
        return "blank", None, False, notes

    if re.match(r"^\d", value):
        if direction == "DRIVER":
            notes.append(
                "Numeric value appears on a driver/source record. "
                "Usually numeric values are intended for loads/inputs."
            )

        if value.endswith("!"):
            return "pulse", None, False, notes

        return "constant", None, False, notes

    if value.endswith("*"):
        base = value[:-1].strip()

        if direction == "DRIVER":
            notes.append(
                "Driver/source value ends in '*'. "
                "Inversion is normally used on loads/inputs, not drivers."
            )
            return "invalid_driver_inverted", base or None, True, notes

        return "named_inverted", base or None, True, notes

    return "named", value, False, notes


def companion_bi_pv(signal_pv: str, all_pv_set: set[str]) -> Optional[str]:
    if not signal_pv.endswith("_Signal"):
        return None

    bi = signal_pv[: -len("_Signal")] + "_BI"

    if bi in all_pv_set:
        return bi

    return None


def build_records(
    dbl_path: str,
    timeout: float,
    with_states: bool,
) -> list[SignalRecord]:
    all_pvs = read_dbl_all(dbl_path)
    all_pv_set = set(all_pvs)

    signal_pvs = find_signal_pvs(all_pvs)

    if not signal_pvs:
        return []

    values = caget_many_string(
        signal_pvs,
        timeout=timeout,
        context="_Signal values",
        require_all=True,
    )

    desc_pvs = [pv + ".DESC" for pv in signal_pvs]

    descs = caget_many_string(
        desc_pvs,
        timeout=timeout,
        context="_Signal DESC fields",
        require_all=True,
    )

    if with_states:
        state_pvs: list[Optional[str]] = [
            companion_bi_pv(pv, all_pv_set) for pv in signal_pvs
        ]

        real_state_pvs = [pv for pv in state_pvs if pv is not None]

        real_state_values = caget_many_string(
            real_state_pvs,
            timeout=timeout,
            context="companion _BI state records",
            require_all=True,
        )

        state_values_by_pv = dict(zip(real_state_pvs, real_state_values))
    else:
        state_pvs = [None for _ in signal_pvs]
        state_values_by_pv = {}

    records: list[SignalRecord] = []

    for pv, value, desc, state_pv in zip(signal_pvs, values, descs, state_pvs):
        desc_clean = desc or ""

        direction = direction_from_pv_and_desc(pv, desc_clean)

        value_kind, signal_name, inverted, notes = classify_signal_value(
            raw_value=value,
            direction=direction,
        )

        state_value = None
        if state_pv:
            state_value = state_values_by_pv.get(state_pv)

        records.append(
            SignalRecord(
                pv=pv,
                direction=direction,
                desc=desc_clean,
                raw_value=value or "",
                value_kind=value_kind,
                signal_name=signal_name,
                inverted=inverted,
                state_pv=state_pv,
                state_value=state_value,
                notes=notes,
            )
        )

    return records


def build_report(records: list[SignalRecord]) -> Report:
    by_signal: dict[str, SignalUse] = {}

    constants: list[SignalRecord] = []
    pulses: list[SignalRecord] = []
    blank_drivers: list[SignalRecord] = []
    blank_loads: list[SignalRecord] = []
    unknown_direction: list[SignalRecord] = []
    warnings: list[str] = []

    for rec in records:
        if rec.direction == "UNKNOWN":
            unknown_direction.append(rec)

        if rec.value_kind == "blank":
            if rec.direction == "DRIVER":
                blank_drivers.append(rec)
            elif rec.direction == "LOAD":
                blank_loads.append(rec)
            continue

        if rec.value_kind == "constant":
            constants.append(rec)
            continue

        if rec.value_kind == "pulse":
            pulses.append(rec)
            continue

        if not rec.signal_name:
            continue

        if rec.signal_name not in by_signal:
            by_signal[rec.signal_name] = SignalUse(signal_name=rec.signal_name)

        use = by_signal[rec.signal_name]

        if rec.direction == "DRIVER":
            use.drivers.append(rec)
        elif rec.direction == "LOAD":
            if rec.inverted:
                use.inverted_loads.append(rec)
            else:
                use.loads.append(rec)

    for name, use in sorted(by_signal.items()):
        all_loads = use.loads + use.inverted_loads

        if len(use.drivers) > 1:
            warnings.append(
                f"Multiple drivers/sources for signal '{name}': "
                + ", ".join(rec.pv for rec in use.drivers)
            )

        if len(use.drivers) == 0 and all_loads:
            warnings.append(
                f"No driver/source for signal '{name}', used by: "
                + ", ".join(rec.pv for rec in all_loads)
            )

        if len(use.drivers) == 1 and not all_loads:
            warnings.append(
                f"Driver/source has no loads/destinations for signal '{name}': "
                f"{use.drivers[0].pv}"
            )

    for rec in records:
        for note in rec.notes:
            warnings.append(f"{rec.pv}: {note}")

    return Report(
        signals=[by_signal[name] for name in sorted(by_signal)],
        constants=constants,
        pulses=pulses,
        blank_drivers=blank_drivers,
        blank_loads=blank_loads,
        unknown_direction=unknown_direction,
        warnings=warnings,
    )


def pv_with_state(rec: SignalRecord) -> str:
    if rec.state_value is None:
        return rec.pv

    return f"{rec.pv} [BI={rec.state_value}]"


def print_record_list(
    title: str,
    records: list[SignalRecord],
    show_value: bool = True,
) -> None:
    if not records:
        return

    print()
    print(title)
    print("-" * len(title))

    for rec in records:
        if show_value:
            print(f"  {pv_with_state(rec)} = {rec.raw_value!r}")
        else:
            print(f"  {pv_with_state(rec)}")


def print_text_report(
    report: Report,
    print_blank_drivers: bool,
    print_blank_loads: bool,
) -> None:
    print("softGlue connection report")
    print("==========================")

    if report.signals:
        print()
        print("Named signals")
        print("-------------")

    for use in report.signals:
        print()
        print(f"Signal: {use.signal_name}")

        if use.drivers:
            print("  Drivers / sources:")
            for rec in use.drivers:
                print(f"    {pv_with_state(rec)} = {rec.raw_value!r}")
        else:
            print("  Drivers / sources: none")

        if use.loads:
            print("  Loads / destinations:")
            for rec in use.loads:
                print(f"    {pv_with_state(rec)} = {rec.raw_value!r}")

        if use.inverted_loads:
            print("  Inverted loads / destinations:")
            for rec in use.inverted_loads:
                print(f"    {pv_with_state(rec)} = {rec.raw_value!r}")

        if not use.loads and not use.inverted_loads:
            print("  Loads / destinations: none")

    print_record_list(
        "Direct constants / numeric records",
        report.constants,
        show_value=True,
    )

    print_record_list(
        "Pulse command records",
        report.pulses,
        show_value=True,
    )

    if print_blank_drivers:
        print_record_list(
            "Blank drivers / unassigned sources",
            report.blank_drivers,
            show_value=False,
        )

    if print_blank_loads:
        print_record_list(
            "Blank loads / unassigned destinations",
            report.blank_loads,
            show_value=False,
        )

    print_record_list(
        "Unclassified _Signal records",
        report.unknown_direction,
        show_value=True,
    )

    if report.warnings:
        print()
        print("Warnings")
        print("--------")

        for warning in report.warnings:
            print(f"  WARNING: {warning}")


def report_to_jsonable(report: Report) -> dict:
    return {
        "signals": [
            {
                "signal_name": use.signal_name,
                "drivers": [asdict(rec) for rec in use.drivers],
                "loads": [asdict(rec) for rec in use.loads],
                "inverted_loads": [asdict(rec) for rec in use.inverted_loads],
            }
            for use in report.signals
        ],
        "constants": [asdict(rec) for rec in report.constants],
        "pulses": [asdict(rec) for rec in report.pulses],
        "blank_drivers": [asdict(rec) for rec in report.blank_drivers],
        "blank_loads": [asdict(rec) for rec in report.blank_loads],
        "unknown_direction": [asdict(rec) for rec in report.unknown_direction],
        "warnings": report.warnings,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Report softGlueZynq signal connections using dbl-all.txt "
            "and live EPICS PV values."
        )
    )

    parser.add_argument(
        "--dbl-all",
        default="dbl-all.txt",
        help="Path to dbl-all.txt. Default: ./dbl-all.txt",
    )

    parser.add_argument(
        "--timeout",
        type=float,
        default=2.0,
        help="Channel Access read timeout in seconds. Default: 2.0",
    )

    parser.add_argument(
        "--format",
        choices=("text", "json"),
        default="text",
        help="Output format. Default: text",
    )

    parser.add_argument(
        "--with-states",
        action="store_true",
        help="Also read companion *_BI records when present in dbl-all.txt.",
    )

    parser.add_argument(
        "--print-blank-drivers",
        action="store_true",
        help="Print blank/unassigned driver/source records.",
    )

    parser.add_argument(
        "--print-blank-loads",
        action="store_true",
        help="Print blank/unassigned load/destination records.",
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        records = build_records(
            dbl_path=args.dbl_all,
            timeout=args.timeout,
            with_states=args.with_states,
        )
    except FileNotFoundError:
        print(f"ERROR: could not find {args.dbl_all!r}", file=sys.stderr)
        return 2
    except PVConnectionError as e:
        print("ERROR: Could not connect to one or more required PVs.", file=sys.stderr)
        print("", file=sys.stderr)
        print(str(e), file=sys.stderr)
        return 3
    except RuntimeError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 2

    if not records:
        print("No PVs ending in '_Signal' were found.")
        return 1

    report = build_report(records)

    if args.format == "json":
        print(json.dumps(report_to_jsonable(report), indent=2, sort_keys=True))
    else:
        print_text_report(
            report=report,
            print_blank_drivers=args.print_blank_drivers,
            print_blank_loads=args.print_blank_loads,
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
