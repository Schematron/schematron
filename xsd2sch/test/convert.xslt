<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xhtml"  />

<xsl:template  match="report">
    <html>
    <head><title>XML Schema to Schematron result</title></head>
    <body>
    <p>Green = valid. Blue = invalid. Red = false invalid. Yellow = false valid.</p> 
    <table>
    <tr>
       <th>Name</th>
       <th>Test</th>
       <th>Expected</th>
       <th>Found</th>
       <th>OK</th>
    </tr>
	<xsl:apply-templates />
	</table>
    </body>
    </html>
</xsl:template>

<xsl:template  match="file">
    <tr>
	<xsl:apply-templates />
    </tr>
</xsl:template>

<xsl:template  match="name">
    <td>
	<xsl:apply-templates />
    </td>
</xsl:template>

<xsl:template  match="testing">
    <td>
	<xsl:apply-templates />
    </td>
</xsl:template>


<xsl:template  match="sameresults">
	<td> 
		<xsl:attribute name="bgcolor">
			<xsl:choose>
				<xsl:when test="../expectedresult = 'valid' and ../schematronresult ='valid'">green</xsl:when>
				<xsl:when test="../expectedresult = 'invalid' and ../schematronresult ='invalid'">blue</xsl:when>
				<xsl:when test="../expectedresult = 'valid' and ../schematronresult = 'invalid'">red</xsl:when>
				<xsl:otherwise>yellow</xsl:otherwise>
				</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates />
	</td>
</xsl:template>

<xsl:template  match="expectedresult">
	<td> 
		<xsl:attribute name="bgcolor">
			<xsl:choose>
				<xsl:when test=".='valid'">green</xsl:when>
				<xsl:otherwise>blue</xsl:otherwise>
			</xsl:choose>	
		</xsl:attribute>
		<xsl:apply-templates />
	</td>
</xsl:template>


<xsl:template  match="schematronresult">
	<td> 
		<xsl:attribute name="bgcolor">
			<xsl:choose>
				<xsl:when test=".='valid'">green</xsl:when>
				<xsl:otherwise>blue</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:apply-templates />
	</td>
</xsl:template>



</xsl:stylesheet>