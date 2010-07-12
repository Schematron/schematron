
<!--
 Programmers: Rick Jelliffe, Cheney Xin, Rahul Grewel
--> 
<!--
	The code was written under sponsorship of JSTOR The Scholarly Journal Archive
	 
	This code is also available under the GPL (v3. http://www.gnu.org/copyleft/gpl.html)	
 -->
 
 <!--
Open Source Initiative OSI - The MIT License:Licensing
[OSI Approved License]

The MIT License

	This code copyright 2007-2009 jointly and severally
		Allette Systems Pty. Ltd. (www.allette.com.au), 
		Topologi Pty. Ltd. (www.topologi.com), 
		JSTOR (http://www.jstor.org/)
		and Rick Jelliffe. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

-->

<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				xmlns:sch="http://www.ascc.net/xml/schematron"
				xmlns:iso="http://purl.oclc.org/dsdl/schematron"
				xmlns="http://www.w3.org/1999/xhtml">

<xsl:output encoding="UTF-8" method="xhtml" />

<xsl:template match="/">
	<html>
		<xsl:comment>no seeding</xsl:comment>
		<head>
			<title>SVRL Validation Report</title>
			<link rel="stylesheet" href="svrl-report.css" type="text/css" />
		</head>
		<body>
			<h1>SVRL Validation Report</h1>
			
			<xsl:for-each select="fileset/file">
				<div class="file">
					<xsl:apply-templates select="." />
				</div>
			</xsl:for-each>
			
			<p><b>Date: </b> <xsl:value-of select="format-date(xs:date(current-date()), '[D] [MNn], [Y]')" /></p>
		</body>
	</html>
</xsl:template>

<xsl:template match="file">
	<div class="filename">
		<h2>Instance File Name: <xsl:value-of select="@name" /></h2>
	</div>
	<div class="status">
		<xsl:choose>
			<xsl:when test="(count(svrl:schematron-output/svrl:successful-report) + count(svrl:schematron-output/svrl:failed-assert)) != 0">
				<h3 class="no">Results: The file is Not Validated!</h3>
			</xsl:when>
			<xsl:otherwise>
				<h3 class="yes">Results: The file is Validated!</h3>
			</xsl:otherwise>
		</xsl:choose>
	</div>
	<div class="schematron">
		<div class="schematron-title">
			<p>Schematron Title: <xsl:value-of select="svrl:schematron-output/@title" /></p>
		</div>
		<div class="schematron-version">
			<p>Schematron Version: <xsl:value-of select="svrl:schematron-output/@schemaVersion" /></p>
		</div>
		<!--
		<xsl:for-each select="svrl:ns-prefix-in-attribute-values">
			<div class="schematron-ns">
				<p>Schematron Namespace Prefix: <xsl:value-of select="@prefix" /></p>
				<p>Schematron Namespace URI: <xsl:value-of select="@uri" /></p>
			</div>
		</xsl:for-each>
		-->
		<div class="result">
			<xsl:apply-templates />
		</div>
	</div>
</xsl:template>

<xsl:template match="svrl:successful-report">
	<div class="result-report">
		<div class="result-report-test">
			<span class="label"><b>Test: </b></span>
			<xsl:value-of select="@test" />
		</div>
		<div class="result-report-location">
			<span class="label"><b>Location: </b></span>
			<xsl:value-of select="@location" />
		</div>
		<div class="result-report-text">
			<span class="label"><b>Description: </b></span>
			<xsl:value-of select="svrl:text" />
		</div>
	</div>
</xsl:template>

<xsl:template match="svrl:failed-assert">
	<div class="result-assert">
		<div class="result-assert-test">
			<span class="label"><b>Test: </b></span>
			<xsl:value-of select="@test" />
		</div>
		<div class="result-assert-location">
			<span class="label"><b>Location: </b></span>
			<xsl:value-of select="@location" />
		</div>
		<div class="result-assert-text">
			<span class="label"><b>Description: </b></span>
			<xsl:value-of select="svrl:text" />
		</div>
	</div>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>

