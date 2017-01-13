<?xml version="1.0"?>
<!--
	XSD2SCH
	Compress Big Schematron. 
	1, handle some sch:extend
	
	Author: Rick Jelliffe
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

<xsl:variable name="version">v0.1</xsl:variable>	

<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ===========================================================
 Handle contexts with no "/" 
     =========================================================== -->

<!-- match the first rule that has only one child and which is the first
rule that extends that particular element -->

<xsl:template match=
    "sch:pattern/sch:rule
    [@context]
    [not(contains(@context, '/'))]
    [count(sch:extends) = 1 and count(*) = 1]
    [not(preceding-sibling::sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "13" >			
    <sch:rule>
		<xsl:attribute name="context">
			<!-- merge all the contexts into an | list -->
			<xsl:for-each select=
			"../sch:rule[count(sch:extends) = 1 and count(*) = 1]
				[@context]
				[sch:extends/@rule = current()/sch:extends/@rule]
				[not(contains(@context, '*'))]
				[not(contains(@context, '/'))]">
				<!-- <xsl:text>(</xsl:text> -->
				<xsl:value-of select="@context"/>
				<!-- <xsl:text>)</xsl:text> -->
				<!-- don't generate the | the first time-->
				<xsl:if test="not(position() = last())"> | </xsl:if>
			</xsl:for-each>
		</xsl:attribute>
		<xsl:apply-templates/>
    </sch:rule>
 </xsl:template>

<!-- strip out the rules that have been merged -->
<xsl:template match=
    "sch:pattern/sch:rule
    [@context]
    [not(contains(@context, '/'))]
    [count(sch:extends) = 1 and count(*) = 1]
    [not(preceding-sibling::sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "8" />

<!-- ===========================================================
 Handle contexts with any "/" 
     =========================================================== -->


<!-- match the first rule that has only one child and which is the first
     rule that extends that particular element -->
<xsl:template match=
    "sch:pattern/sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [@context]
    [contains(@context, '/')]
	[not(contains(@context, '*'))]
    [not(preceding-sibling::sch:rule
    	[count(sch:extends)=1 and count(*) = 1]
    	[sch:extends/@rule=current()/sch:extends/@rule]  
		[@context]
    	[contains(@context, '/')])]" 
	priority = "10" >			<!-- I bet the bug is the sch:extends where something else than "=" should be used -->
    <sch:rule>
		<xsl:attribute name="context">
			<!-- merge all the contexts into an | list -->
			<xsl:for-each select=
			"../sch:rule[count(sch:extends)=1 and count(*) = 1]
				[@context]
				[contains(@context, '/')]
				[sch:extends/@rule = current()/sch:extends/@rule]
				[not(contains(@context, '*'))]">
				<!-- <xsl:text>(</xsl:text> -->
				<xsl:value-of select="@context"/>
				<!-- <xsl:text>)</xsl:text> -->
				<!-- don't generate the | the first time-->
				<xsl:if test="not(position() = last())"> | </xsl:if>
			</xsl:for-each>
		</xsl:attribute>
		<xsl:apply-templates/>
    </sch:rule>
 </xsl:template>

<!-- strip out the rules that have been merged -->
<xsl:template match=
    "sch:pattern/sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [@context]
	[contains(@context, '/')]
    [not(preceding-sibling::rule[count(sch:extends)=1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "5" />


<!-- ===========================================================
 copy everything else
     =========================================================== -->
 
 <xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy> 
 </xsl:template>

</xsl:stylesheet>
