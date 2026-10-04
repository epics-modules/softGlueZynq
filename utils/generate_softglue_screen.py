#!/usr/bin/env python3
"""Generate a pair of MEDM ADL screens for a softGlueZynq module.

The input is a small YAML file describing the module and its ordered input/output
pins.  Two files are written:

  softGlueZynq_<file_stem>.adl
  softGlueZynq_<file_stem>_bare.adl

The top-level screen supplies the title bar, optional description field, and
embeds the bare screen.  The bare screen contains only the module/pin drawing.
"""

from __future__ import annotations

import argparse
import math
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

GENERATOR_VERSION = "1.5.0"

try:
    import yaml
except ImportError as exc:  # pragma: no cover - depends on the target host
    raise SystemExit(
        "PyYAML is required. Install it with: python3 -m pip install PyYAML"
    ) from exc


COLOR_MAP = """\
\"color map\" {
\tncolors=65
\tcolors {
\t\tffffff,
\t\tececec,
\t\tdadada,
\t\tc8c8c8,
\t\tbbbbbb,
\t\taeaeae,
\t\t9e9e9e,
\t\t919191,
\t\t858585,
\t\t787878,
\t\t696969,
\t\t5a5a5a,
\t\t464646,
\t\t2d2d2d,
\t\t000000,
\t\t00d800,
\t\t1ebb00,
\t\t339900,
\t\t2d7f00,
\t\t216c00,
\t\tfd0000,
\t\tde1309,
\t\tbe190b,
\t\ta01207,
\t\t820400,
\t\t5893ff,
\t\t597ee1,
\t\t4b6ec7,
\t\t3a5eab,
\t\t27548d,
\t\tfbf34a,
\t\tf9da3c,
\t\teeb62b,
\t\te19015,
\t\tcd6100,
\t\tffb0ff,
\t\td67fe2,
\t\tae4ebc,
\t\t8b1a96,
\t\t610a75,
\t\ta4aaff,
\t\t8793e2,
\t\t6a73c1,
\t\t4d52a4,
\t\t343386,
\t\tc7bb6d,
\t\tb79d5c,
\t\ta47e3c,
\t\t7d5627,
\t\t58340f,
\t\t99ffff,
\t\t73dfff,
\t\t4ea5f9,
\t\t2a63e4,
\t\t0a00b8,
\t\tebf1b5,
\t\td4db9d,
\t\tbbc187,
\t\ta6a462,
\t\t8b8239,
\t\t73ff6b,
\t\t52da3b,
\t\t3cb420,
\t\t289315,
\t\t1a7309,
\t}
}
"""


@dataclass(frozen=True)
class Pin:
    kind: str
    pv: str
    label: str
    inverted: bool = False
    clock: bool = False
    fmt: str = "decimal"
    width: int | None = None


@dataclass(frozen=True)
class Module:
    name: str
    pv_stem: str
    file_stem: str
    numbered: bool
    block_label: str
    description: bool
    exact_pvs: bool
    inputs: tuple[Pin, ...]
    outputs: tuple[Pin, ...]


@dataclass(frozen=True)
class Layout:
    # Zero means no enforced minimum; natural content width plus margins is used.
    min_width: int = 0
    margin: int = 4
    gap: int = 16
    signal_widget_width: int = 156
    register_width: int = 90
    title_height: int = 28
    description_height: int = 22
    block_header_height: int = 18
    row_height: int = 25
    text_height: int = 13
    min_half_block_width: int = 55
    char_width: float = 6.2


@dataclass(frozen=True)
class Geometry:
    width: int
    bare_height: int
    main_height: int
    left_x: int
    left_width: int
    block_x: int
    block_y: int
    block_width: int
    block_height: int
    right_x: int
    right_width: int
    row_centers: tuple[int, ...]
    description_offset: int


class ConfigError(ValueError):
    pass


def _require_mapping(value: Any, where: str) -> Mapping[str, Any]:
    if not isinstance(value, Mapping):
        raise ConfigError(f"{where} must be a mapping")
    return value


def _require_sequence(value: Any, where: str) -> Sequence[Any]:
    if value is None:
        return []
    if not isinstance(value, Sequence) or isinstance(value, (str, bytes)):
        raise ConfigError(f"{where} must be a list")
    return value


def _clean_file_stem(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9_.-]+", "_", value.strip())
    value = value.strip("_.-")
    if not value:
        raise ConfigError("module.file_stem resolves to an empty name")
    return value


def _parse_pin(item: Any, where: str, side: str) -> Pin:
    data = _require_mapping(item, where)
    kind = str(data.get("type", "")).strip().lower()
    aliases = {"reg": "register", "sig": "signal"}
    kind = aliases.get(kind, kind)
    if kind not in {"signal", "register"}:
        raise ConfigError(f"{where}.type must be 'signal' or 'register'")

    pv = str(data.get("pv", "")).strip()
    if not pv:
        raise ConfigError(f"{where}.pv is required")

    label = str(data.get("label", pv.replace("_", " "))).strip()
    inverted = bool(data.get("inverted", False))
    if inverted and kind != "signal":
        raise ConfigError(f"{where}.inverted is only valid for signal pins")

    clock = bool(data.get("clock", False))
    if clock and kind != "signal":
        raise ConfigError(f"{where}.clock is only valid for signal pins")
    if clock and side != "input":
        raise ConfigError(f"{where}.clock is only valid for signal inputs")

    fmt = str(data.get("format", "decimal")).strip() or "decimal"
    width_value = data.get("width")
    width: int | None
    if width_value is None:
        width = None
    else:
        try:
            width = int(width_value)
        except (TypeError, ValueError) as exc:
            raise ConfigError(f"{where}.width must be an integer") from exc
        if width < 35:
            raise ConfigError(f"{where}.width must be at least 35 pixels")

    return Pin(
        kind=kind,
        pv=pv,
        label=label,
        inverted=inverted,
        clock=clock,
        fmt=fmt,
        width=width,
    )


def load_config(path: Path) -> tuple[Module, Layout]:
    try:
        raw = yaml.safe_load(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ConfigError(f"cannot read {path}: {exc}") from exc
    except yaml.YAMLError as exc:
        raise ConfigError(f"invalid YAML in {path}: {exc}") from exc

    root = _require_mapping(raw, "document")
    m = _require_mapping(root.get("module"), "module")

    name = str(m.get("name", "")).strip()
    if not name:
        raise ConfigError("module.name is required")

    exact_pvs = bool(m.get("exact_pvs", False))
    pv_stem = str(m.get("pv_stem", name)).strip()
    if not pv_stem:
        if exact_pvs:
            # Pin PVs do not use pv_stem in exact-PV mode. Keep a sensible
            # module root for optional module-level fields such as _desc.
            pv_stem = name
        else:
            raise ConfigError("module.pv_stem cannot be empty")

    file_stem = _clean_file_stem(str(m.get("file_stem", name)))
    numbered = bool(m.get("numbered", False))
    block_label = str(m.get("block_label", pv_stem)).strip()
    description = bool(m.get("description", True))

    inputs = tuple(
        _parse_pin(item, f"inputs[{index}]", "input")
        for index, item in enumerate(_require_sequence(root.get("inputs"), "inputs"))
    )
    outputs = tuple(
        _parse_pin(item, f"outputs[{index}]", "output")
        for index, item in enumerate(_require_sequence(root.get("outputs"), "outputs"))
    )
    if not inputs and not outputs:
        raise ConfigError("at least one input or output pin is required")

    layout_data = root.get("layout", {})
    layout_map = _require_mapping(layout_data, "layout")
    defaults = Layout()
    layout_values: dict[str, Any] = {}
    for field_name in defaults.__dataclass_fields__:
        if field_name in layout_map:
            current = getattr(defaults, field_name)
            try:
                layout_values[field_name] = type(current)(layout_map[field_name])
            except (TypeError, ValueError) as exc:
                raise ConfigError(f"layout.{field_name} has the wrong type") from exc
    layout = Layout(**layout_values)

    module = Module(
        name=name,
        pv_stem=pv_stem,
        file_stem=file_stem,
        numbered=numbered,
        block_label=block_label,
        description=description,
        exact_pvs=exact_pvs,
        inputs=inputs,
        outputs=outputs,
    )
    return module, layout


def pv_root(module: Module, include_prefix: bool) -> str:
    prefix = "$(P)$(H)" if include_prefix else ""
    instance = "-$(N)" if module.numbered else ""
    return f"{prefix}{module.pv_stem}{instance}"


def channel(module: Module, pin: Pin) -> str:
    if module.exact_pvs:
        return f"$(P)$(H){pin.pv}"
    return f"{pv_root(module, include_prefix=True)}_{pin.pv}"


def signal_name(module: Module, pin: Pin) -> str:
    if module.exact_pvs:
        return pin.pv
    return f"{pv_root(module, include_prefix=False)}_{pin.pv}"


def estimate_text_width(text: str, layout: Layout) -> int:
    return int(math.ceil(len(text) * layout.char_width))


def calculate_side_width(pins: Sequence[Pin], layout: Layout) -> int:
    """Return the width required by widgets that actually exist on one side."""
    widths = [
        pin.width or layout.register_width
        for pin in pins
        if pin.kind == "register"
    ]
    if any(pin.kind == "signal" for pin in pins):
        widths.append(layout.signal_widget_width)
    return max(widths, default=0)


def calculate_geometry(module: Module, layout: Layout) -> Geometry:
    all_pins = (*module.inputs, *module.outputs)
    left_width = calculate_side_width(module.inputs, layout)
    right_width = calculate_side_width(module.outputs, layout)

    # A clock marker occupies the first 10 pixels inside the left half of the
    # component body. Reserve that extra space when sizing labels.
    label_requirements = [
        estimate_text_width(pin.label, layout) + (20 if pin.clock else 10)
        for pin in all_pins
    ]
    half_block_width = max(layout.min_half_block_width, max(label_requirements, default=0))
    block_width = 2 * half_block_width

    natural_width = (
        2 * layout.margin
        + left_width
        + right_width
        + block_width
        + 2 * layout.gap
    )
    width = max(layout.min_width, natural_width)
    extra = width - natural_width

    left_x = layout.margin + extra // 2
    block_x = left_x + left_width + layout.gap
    right_x = block_x + block_width + layout.gap

    description_offset = layout.description_height if module.description else 0
    block_y = 2
    row_count = max(len(module.inputs), len(module.outputs))
    block_height = layout.block_header_height + row_count * layout.row_height + 6
    bare_height = block_y + block_height + 2
    main_height = layout.title_height + 2 + description_offset + bare_height

    first_center = block_y + layout.block_header_height + layout.row_height // 2
    row_centers = tuple(first_center + i * layout.row_height for i in range(row_count))

    return Geometry(
        width=width,
        bare_height=bare_height,
        main_height=main_height,
        left_x=left_x,
        left_width=left_width,
        block_x=block_x,
        block_y=block_y,
        block_width=block_width,
        block_height=block_height,
        right_x=right_x,
        right_width=right_width,
        row_centers=row_centers,
        description_offset=description_offset,
    )


def esc(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def file_display_header(filename: str, width: int, height: int, snap: int = 0) -> str:
    return f'''file {{
\tname="{esc(filename)}"
\tversion=030111
}}
display {{
\tobject {{
\t\tx=0
\t\ty=0
\t\twidth={width}
\t\theight={height}
\t}}
\tclr=14
\tbclr=2
\tcmap=""
\tgridSpacing=5
\tgridOn=0
\tsnapToGrid={snap}
}}
{COLOR_MAP}'''


def rectangle(x: int, y: int, width: int, height: int, *, clr: int = 14, line_width: int = 2, fill: str = "outline") -> str:
    return f'''rectangle {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\t"basic attribute" {{
\t\tclr={clr}
\t\tfill="{fill}"
\t\twidth={line_width}
\t}}
}}
'''


def polyline(points: Sequence[tuple[int, int]], *, clr: int = 14, line_width: int = 2) -> str:
    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    x = min(xs)
    y = min(ys)
    width = max(xs) - x + 1
    height = max(2, max(ys) - y + 1)
    point_text = "\n".join(f"\t\t({px},{py})" for px, py in points)
    return f'''polyline {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\t"basic attribute" {{
\t\tclr={clr}
\t\tfill="outline"
\t\twidth={line_width}
\t}}
\tpoints {{
{point_text}
\t}}
}}
'''


def oval(x: int, y: int, width: int = 10, height: int = 10, *, clr: int = 14, line_width: int = 2) -> str:
    return f'''oval {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\t"basic attribute" {{
\t\tclr={clr}
\t\tfill="outline"
\t\twidth={line_width}
\t}}
}}
'''


def text(x: int, y: int, width: int, height: int, value: str, *, align: str | None = None, clr: int = 14) -> str:
    align_line = f'\talign="{align}"\n' if align else ""
    return f'''text {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\t"basic attribute" {{
\t\tclr={clr}
\t}}
\ttextix="{esc(value)}"
{align_line}}}
'''


def text_entry(x: int, y: int, width: int, height: int, chan: str, *, fmt: str, bclr: int = 51) -> str:
    return f'''"text entry" {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\tcontrol {{
\t\tchan="{esc(chan)}"
\t\tclr=14
\t\tbclr={bclr}
\t}}
\tformat="{esc(fmt)}"
\tlimits {{
\t}}
}}
'''


def text_update(x: int, y: int, width: int, height: int, chan: str, *, fmt: str) -> str:
    format_line = "" if fmt == "decimal" else f'\tformat="{esc(fmt)}"\n'
    return f'''"text update" {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\tmonitor {{
\t\tchan="{esc(chan)}"
\t\tclr=54
\t\tbclr=2
\t}}
\talign="horiz. right"
{format_line}\tlimits {{
\t}}
}}
'''


def composite_file(x: int, y: int, width: int, height: int, filename_and_macros: str) -> str:
    return f'''composite {{
\tobject {{
\t\tx={x}
\t\ty={y}
\t\twidth={width}
\t\theight={height}
\t}}
\t"composite name"=""
\t"composite file"="{esc(filename_and_macros)}"
}}
'''


def register_output_border(x: int, y: int, width: int, height: int) -> str:
    # A small static bevel, based on the visual treatment used in existing screens.
    return (
        polyline([(x, y + height - 1), (x, y), (x + width - 1, y)], clr=10, line_width=2)
        + polyline(
            [(x + width - 1, y), (x + width - 1, y + height - 1), (x, y + height - 1)],
            clr=0,
            line_width=2,
        )
    )


def module_instance_label(module: Module) -> str:
    return f"{module.block_label}-$(N)" if module.numbered else module.block_label


def render_pin_label(module: Module, geometry: Geometry, layout: Layout, pin: Pin, side: str, center_y: int) -> str:
    if not pin.label:
        return ""

    half = geometry.block_width // 2
    label_y = center_y - layout.text_height // 2
    if side == "left":
        # Clock inputs use a > marker at the body boundary. Move their label
        # right so the marker and text cannot overlap.
        clock_offset = 10 if pin.clock else 0
        return text(
            geometry.block_x + 5 + clock_offset,
            label_y,
            half - 9 - clock_offset,
            layout.text_height,
            pin.label,
            align=None,
        )
    return text(
        geometry.block_x + half + 4,
        label_y,
        half - 9,
        layout.text_height,
        pin.label,
        align="horiz. right",
    )


def render_clock_marker(boundary: int, center_y: int) -> str:
    # Match the edge-trigger marker used by existing softGlueZynq screens,
    # such as GateDly: a > shape extending into the component body.
    return polyline(
        [
            (boundary, center_y - 7),
            (boundary + 9, center_y),
            (boundary, center_y + 7),
        ],
        clr=14,
        line_width=2,
    )


def render_input(module: Module, geometry: Geometry, layout: Layout, pin: Pin, center_y: int) -> str:
    pieces: list[str] = [render_pin_label(module, geometry, layout, pin, "left", center_y)]
    boundary = geometry.block_x

    if pin.kind == "signal":
        widget_x = geometry.left_x
        # Align the embedded signal-input composite one pixel above the pin line.
        widget_y = center_y - 14
        pieces.append(
            composite_file(
                widget_x,
                widget_y,
                layout.signal_widget_width,
                26,
                f"softGlueZynq_Input.adl;P=$(P),H=$(H),SIG={signal_name(module, pin)}",
            )
        )
        line_start = widget_x + layout.signal_widget_width - 1
    else:
        field_width = pin.width or layout.register_width
        widget_x = geometry.left_x + geometry.left_width - field_width
        widget_y = center_y - 10
        pieces.append(text_entry(widget_x, widget_y, field_width, 20, channel(module, pin), fmt=pin.fmt))
        line_start = widget_x + field_width - 1

    if pin.inverted:
        bubble_size = 10
        bubble_x = boundary - bubble_size + 1
        pieces.append(polyline([(line_start, center_y), (bubble_x, center_y)]))
        pieces.append(oval(bubble_x, center_y - bubble_size // 2, bubble_size, bubble_size))
    else:
        pieces.append(polyline([(line_start, center_y), (boundary, center_y)]))

    if pin.clock:
        pieces.append(render_clock_marker(boundary, center_y))

    return "".join(pieces)


def render_output(module: Module, geometry: Geometry, layout: Layout, pin: Pin, center_y: int) -> str:
    pieces: list[str] = [render_pin_label(module, geometry, layout, pin, "right", center_y)]
    boundary = geometry.block_x + geometry.block_width

    if pin.kind == "signal":
        # The stock output composite aligns best one pixel left and one pixel up.
        # Shift only the composite left. Keep the wire endpoint at its
        # nominal position so the composite moves relative to the wire.
        nominal_x = geometry.right_x
        widget_x = nominal_x - 1
        widget_y = center_y - 14
        pieces.append(
            composite_file(
                widget_x,
                widget_y,
                layout.signal_widget_width,
                26,
                f"softGlueZynq_Output.adl;P=$(P),H=$(H),SIG={signal_name(module, pin)}",
            )
        )
        line_end = nominal_x
    else:
        field_width = pin.width or layout.register_width
        widget_x = geometry.right_x
        widget_y = center_y - 10
        pieces.append(register_output_border(widget_x, widget_y, field_width, 20))
        pieces.append(text_update(widget_x + 2, widget_y + 2, field_width - 4, 16, channel(module, pin), fmt=pin.fmt))
        line_end = widget_x

    if pin.inverted:
        bubble_size = 10
        bubble_x = boundary - 1
        pieces.append(oval(bubble_x, center_y - bubble_size // 2, bubble_size, bubble_size))
        pieces.append(polyline([(bubble_x + bubble_size, center_y), (line_end, center_y)]))
    else:
        pieces.append(polyline([(boundary, center_y), (line_end, center_y)]))

    return "".join(pieces)


def render_bare(module: Module, layout: Layout, geometry: Geometry, filename: str) -> str:
    pieces = [file_display_header(filename, geometry.width, geometry.bare_height, snap=1)]

    pieces.append(
        rectangle(
            geometry.block_x,
            geometry.block_y,
            geometry.block_width,
            geometry.block_height,
            clr=14,
            line_width=2,
        )
    )
    pieces.append(
        text(
            geometry.block_x + 4,
            geometry.block_y + 2,
            geometry.block_width - 8,
            layout.block_header_height - 4,
            module_instance_label(module),
            align="horiz. centered",
            clr=53,
        )
    )

    for index, center_y in enumerate(geometry.row_centers):
        if index < len(module.inputs):
            pieces.append(render_input(module, geometry, layout, module.inputs[index], center_y))
        if index < len(module.outputs):
            pieces.append(render_output(module, geometry, layout, module.outputs[index], center_y))

    return "".join(pieces)


def render_main(module: Module, layout: Layout, geometry: Geometry, filename: str, bare_filename: str) -> str:
    pieces = [file_display_header(filename, geometry.width, geometry.main_height, snap=0)]

    pieces.append(rectangle(0, 0, geometry.width, layout.title_height, clr=0, line_width=1, fill="solid"))

    prefix_width = min(175, max(120, geometry.width // 3))
    title = f"{module.name} $(N)" if module.numbered else module.name
    # Center the module title across the complete screen. The prefix remains
    # independently left-aligned and does not bias the title to the right.
    pieces.append(
        text(
            0,
            1,
            geometry.width,
            layout.title_height - 3,
            title,
            align="horiz. centered",
            clr=14,
        )
    )
    pieces.append(text(10, 1, prefix_width - 10, layout.title_height - 3, "$(P)$(H)", clr=14))
    pieces.append(polyline([(1, layout.title_height - 2), (geometry.width - 3, layout.title_height - 2)], clr=54, line_width=3))

    content_y = layout.title_height + 2
    if module.description:
        pieces.append(
            text_entry(
                layout.margin,
                content_y + 3,
                geometry.width - 2 * layout.margin,
                16,
                f"{pv_root(module, include_prefix=True)}_desc",
                fmt="string",
                bclr=2,
            )
        )
        content_y += layout.description_height

    macros = "P=$(P),H=$(H)" + (",N=$(N)" if module.numbered else "")

    # MEDM normalizes an external composite to the bounding box of the objects
    # inside the referenced display; blank outer space from the bare display is
    # not retained. Place that normalized bounding box at the same coordinates
    # used by the standalone bare screen so the module stays centered.
    content_left = geometry.left_x if geometry.left_width else geometry.block_x
    content_right = (
        geometry.right_x + geometry.right_width
        if geometry.right_width
        else geometry.block_x + geometry.block_width
    )
    content_width = content_right - content_left
    pieces.append(
        composite_file(
            content_left,
            content_y + geometry.block_y,
            content_width,
            geometry.block_height,
            f"{bare_filename};{macros}",
        )
    )
    return "".join(pieces)


def generate(config_path: Path, output_dir: Path) -> tuple[Path, Path]:
    module, layout = load_config(config_path)
    geometry = calculate_geometry(module, layout)

    base = f"softGlueZynq_{module.file_stem}"
    main_filename = f"{base}.adl"
    bare_filename = f"{base}_bare.adl"

    output_dir.mkdir(parents=True, exist_ok=True)
    main_path = output_dir / main_filename
    bare_path = output_dir / bare_filename

    main_path.write_text(
        render_main(module, layout, geometry, main_filename, bare_filename),
        encoding="utf-8",
    )
    bare_path.write_text(
        render_bare(module, layout, geometry, bare_filename),
        encoding="utf-8",
    )
    return main_path, bare_path


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Generate top-level and bare MEDM ADL screens for one softGlueZynq module."
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {GENERATOR_VERSION}",
    )
    parser.add_argument("config", type=Path, help="YAML module description")
    parser.add_argument(
        "-o",
        "--output-dir",
        type=Path,
        default=Path("."),
        help="directory for generated ADL files (default: current directory)",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        main_path, bare_path = generate(args.config, args.output_dir)
    except ConfigError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
    print(main_path)
    print(bare_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
