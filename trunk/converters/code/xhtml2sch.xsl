<?xml version="1.0"?>


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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
							  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
							  xmlns:xhtml="http://www.w3.org/1999/xhtml">
	
<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="xhtml:h1 | xhtml:H1" >
	<sch:p class="h1">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h2 | xhtml:H2" >
	<sch:p class="h2">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h3 | xhtml:H3" >
	<sch:p class="h3">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h4 | xhtml:H4" >
	<sch:p class="h4">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h5 | xhtml:H5" >
	<sch:p class="h5">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h6 | xhtml:H6" >
	<sch:p class="h6">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:li | xhtml:LI" >
	<sch:p class="li">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<!-- both IE and firefox must cover , this is for firefox -->
<xsl:template match="xhtml:span | xhtml:SPAN" >
	<!-- for firefox -->
	<xsl:choose>
		<xsl:when test="contains(@style, 'font-weight: bold;')">
			<sch:emph>
				<xsl:value-of select="text()"/>
			</sch:emph>
		</xsl:when>
		<xsl:when test="contains(@style, 'font-style: italic;')">
			<sch:span class="italic">
				<xsl:value-of select="text()"/>
			</sch:span>
		</xsl:when>
		<xsl:when test="contains(@style, 'text-decoration: underline;')">
			<sch:span class="underline">
				<xsl:value-of select="text()"/>
			</sch:span>
		</xsl:when>
		<xsl:when test="@class = 'valueof'">
			<value-of xmlns="http://purl.oclc.org/dsdl/schematron">
				<xsl:attribute name="select">
					<xsl:value-of select="." />
				</xsl:attribute>
			</value-of>
		</xsl:when>
		<xsl:when test="@class = 'name'">
			<name xmlns="http://purl.oclc.org/dsdl/schematron">
				<xsl:attribute name="path">
					<xsl:value-of select="." />
				</xsl:attribute>
			</name>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="text()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- for IE -->
<xsl:template match="xhtml:strong | xhtml:STRONG" >
	<sch:emph>
		<xsl:value-of select="text()"/>
	</sch:emph>
</xsl:template>	

<xsl:template match="xhtml:em | xhtml:EM" >
	<sch:span class="italic">
		<xsl:value-of select="text()"/>
	</sch:span>
</xsl:template>	

<xsl:template match="xhtml:u | xhtml:U" >
	<sch:span class="underline">
		<xsl:value-of select="text()"/>
	</sch:span>
</xsl:template>

	
</xsl:stylesheet>

