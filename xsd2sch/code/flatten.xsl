<?xml version="1.0"?>
<!-- FLATTEN
	Extract each nested schema (the result of import from the previous INCLUDE stage)
	and put it at the top level in a <namespace> element. But only do it for the 
	first encountered schema for each namespace: no need for duplicates.
-->

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
                              xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="/">
	<schemas>
		<xsl:for-each select="//xs:schema"> 
			<xsl:choose>
				<!-- strip out duplicates -->
				<!-- CX: I think it should be use @schemaLocation to judge if it is the same schema -->
				<xsl:when test="preceding::xs:schema[@targetNamespace=current()/@targetNamespace]">
					<xsl:comment>Duplicate schema import for <xsl:value-of select="@targetNamespace"/></xsl:comment>
				</xsl:when>
				<xsl:otherwise>
					<namespace uri="{@targetNamespace}"	schemaLocation="{@schemaLocation}">
						<xsl:attribute name="prefix">
						    <!-- memoize the current node -->
						    <xsl:variable name="schema" select="." as="node()" /> 
						    <!-- find the prefix used for the target namespace (what if two prefixes?) -->
						    <xsl:variable name="declaredPrefix">
						    	<xsl:for-each select="in-scope-prefixes(.)">
						    		<xsl:if test="namespace-uri-for-prefix(., $schema) 
						    		   = $schema/@targetNamespace"
						    		><xsl:value-of select="."/></xsl:if>
						    	</xsl:for-each>
						    </xsl:variable>
							<xsl:choose>
							    <!-- Try to use the prefix used by the schema -->
								<xsl:when test="not($declaredPrefix ='')">
								   <xsl:value-of select="$declaredPrefix" />
								</xsl:when> 
								
								<!-- build in some well-known cases -->
								<xsl:when test="@targetNamespace='http://www.w3.org/1999/xlink'">xlink</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/XML/1998/namespace'">xml</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/1998/Math/MathML'">mathml</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/1999/xhtml'">xhtml</xsl:when>
								<xsl:otherwise>ns<xsl:value-of select="position()"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xs:schema>
							<xsl:copy-of select="@*[not(name()= 'schemaLocation')] | namespace::node()"/>
							<!-- copy over all child nodes except xs:schema inside xs:schema -->
							<xsl:copy-of select="*[not(self::xs:schema)]"/>
						</xs:schema>
					</namespace>
			</xsl:otherwise>
		   </xsl:choose>	
		</xsl:for-each>
	</schemas>
</xsl:template>
	
</xsl:stylesheet>

