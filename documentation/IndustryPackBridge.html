<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
       "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
  <title>Industry Pack Bridge SOPC Component</title>
  <meta name="generator" content="amaya 8.6, see http://www.w3.org/Amaya/" />
</head>

<body>
<h1 style="text-align: center">Industry Pack Bridge</h1>

<p></p>

<h2>1. Introduction</h2>

<p>The Industry Pack Bridge appears as a 16-bit master component in an Altera
Avalon Bus SOPC system. Only 8 MHz operation is supported.</p>

<p></p>

<h2>2. Industry Pack Bus Transactions</h2>

<h3>2.1 ID Prom</h3>

<p>The 16-bit ID Prom is initialized with the contents of the
<code>IDProm.mif</code> memory initialization file. A script is available to
compute the CRC value to be loaded into this file.</p>

<h3>2.2 I/O (Register) Space</h3>

<p>Industry Pack I/O space accesses are mapped to Avalon addresses 000000
through 00007F.</p>

<h3>2.3 Memory Space</h3>

<p>Industry Pack memory space accesses are mapped to Avalon addresses 800000
through FFFFFF.</p>

<h3>2.4 Interrupts</h3>

<p>All Avalon interrupts are funneled through the module IntReq0* line. The
interrupt vector is the 8 bit sum of the value on the VectorBase input lines
and the Avalon interrupt number.</p>

<h3>2.5 DMA</h3>

<p>Industry Pack DMA operation is not supported.</p>

<p></p>

<h2>3. ID PROM Modification</h2>

<p>To make changes to the ID PROM perform these steps</p>
<ol>
  <li>Copy the PROM initialization file IDProm.mif to your application source
    directory
    <p><code>cp ...../IDProm.mif MyProm.mif</code></p>
  </li>
  <li>Make your changes
    <ul>
      <li>Locations 03 and 04 are the manufacturer ID code</li>
      <li>Location 05 is the model number</li>
      <li>Location 06 is the revision number</li>
      <li>Locations 08 and 09 are the driver ID code</li>
      <li>Location 0B is the number of checksummed bytes in the ID PROM
      header</li>
      <li>Location 0C is the CRC</li>
    </ul>
  </li>
  <li>To compute the CRC
    <ul>
      <li>Copy the <code>crc.c</code> program to your application directory
        <p><code>cp ...../crc.c crc.c</code></p>
      </li>
      <li>Compile it (<code>cc -o crc crc.c</code>)</li>
      <li>Run your memory initialization file through the crc program
        <p><code>./crc &lt;MyProm.mif &gt;IDProm.mif</code></p>
      </li>
      <li>Use Quartus to compile your application</li>
    </ul>
  </li>
</ol>

<p></p>

<p></p>
</body>
</html>
