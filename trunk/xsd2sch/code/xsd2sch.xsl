<?xml version="1.0"?>
<!--
	XSD2SCH
	Convert an XSD schema into a Schematron schema
	This XSLT script is part of a larger package. 
	Version: 2009-08-07
	Release Type: Beta 
	Developers: Rick Jelliffe, Xin Chen, Rahul Grewal
	Updates: Please check for updated versions, e.g. at www.schematron.com
	 
	The primary documentation for the converter is currently through the series
	of blog entries:
	   http://broadcast.oreilly.com/2009/03/post-1.html
	   http://www.oreillynet.com/xml/blog/2007/09/converting_xml_schemas_to_sche.html
	 
	The input to this stylesheet is a combined XSD document.
	This document has the following structure:
	   schemas
	   		namespace
	   	 		xs:schema
	   	 			...
	The schema will have been macroed so that there are no 
	import, include or redefine elements.  References to 
	groups, attribute groups and complexTypes will have been
	expanded out. Equivalence classes will have been replaced
	by choice groups. This results in a much simpler schemafor Xpaths. 
	
    NOTE: This version of the code uses the namespace::node() function
    throughout, and therefore requires an implementation such as SAXON
    which supports it. It would be good to replace this with functions
    instead.	
	
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

<xsl:variable name="version">v0.6</xsl:variable>	
 


<!-- supported by Basic XSLT 2.0 processor and XPath 2.0 -->
<xsl:variable name="standard-datatypes">
	<datatype>anyAtomicType</datatype>
	<datatype>anyURI</datatype>
	<datatype>anySimpleType</datatype>
	<datatype>anyType</datatype>
	<datatype>base64Binary</datatype>
	<datatype>boolean</datatype>
	<datatype>date</datatype>
	<datatype>dateTime</datatype>
	<datatype>dayTimeDuration</datatype>
	<datatype>decimal</datatype>
	<datatype>double</datatype>
	<datatype>duration</datatype>
	<datatype>gDay</datatype>
	<datatype>gMonth</datatype>
	<datatype>gMonthDay</datatype>
	<datatype>gYear</datatype>
	<datatype>gYearMonth</datatype>
	<datatype>hexBinary</datatype>
	<datatype>integer</datatype>
	<datatype>QName</datatype>	
	<datatype>string</datatype>
	<datatype>time</datatype>
	<datatype>untyped</datatype>
	<datatype>untypedAtomic</datatype>
	<datatype>yearMonthDuration</datatype>
	<!-- the following datatypes(extended-datatypes) are not supported by Basic XSLT 2.0 processor,
	but Rick has found a switch which can enable the checking in Saxon by 'castable',
	so we include them here as well -->
	<datatype>byte</datatype>
	<datatype>ENTITIES</datatype>
	<datatype>ENTITY</datatype>
	<datatype>float</datatype>
	<datatype>ID</datatype>
	<datatype>IDREF</datatype>
	<!-- NMTOKENS and IDREFS are still not covered by Saxon even we turn on the switch -->
	<!-- <datatype>IDREFS</datatype> -->
	<datatype>int</datatype>
	<datatype>language</datatype>
	<datatype>long</datatype>
	<datatype>Name</datatype> 
	<datatype>NCName</datatype>
	<datatype>negativeInteger</datatype>
	<datatype>NMTOKEN</datatype>
	<!-- <datatype>NMTOKENS</datatype> -->
	<datatype>nonNegativeInteger</datatype>
	<datatype>nonPositiveInteger</datatype>
	<datatype>normalizedString</datatype>
	<datatype>NOTATION</datatype>
	<datatype>positiveInteger</datatype>
	<datatype>short</datatype>
	<datatype>token</datatype>
	<datatype>unsignedByte</datatype>
	<datatype>unsignedInt</datatype>
	<datatype>unsignedLong</datatype>
	<datatype>unsignedShort</datatype>
	<!-- extended-datatypes ends -->
</xsl:variable>

<!-- not supported by Basic XSLT 2.0 processor -->
<xsl:variable name="extended-datatypes">
	<datatype>byte</datatype>
	<datatype>ENTITIES</datatype>
	<datatype>ENTITY</datatype>
	<datatype>float</datatype>
	<datatype>ID</datatype>
	<datatype>IDREF</datatype>
	<datatype>IDREFS</datatype>
	<datatype>int</datatype>
	<datatype>language</datatype>
	<datatype>long</datatype>
	<datatype>Name</datatype>
	<datatype>NCName</datatype>
	<datatype>negativeInteger</datatype>
	<datatype>NMTOKEN</datatype>
	<datatype>NMTOKENS</datatype>
	<datatype>nonNegativeInteger</datatype>
	<datatype>nonPositiveInteger</datatype>
	<datatype>normalizedString</datatype>
	<datatype>NOTATION</datatype>
	<datatype>positiveInteger</datatype>
	<datatype>short</datatype>
	<datatype>token</datatype>
	<datatype>unsignedByte</datatype>
	<datatype>unsignedInt</datatype>
	<datatype>unsignedLong</datatype>
	<datatype>unsignedShort</datatype>
</xsl:variable>

<!-- <xsl:import href="xhtml2sch.xsl" /> -->

<!-- ========================================================== -->
<!-- =============TOP LEVEL==================================== -->		
<!-- ========================================================== -->	
<xsl:template match="schemas">
	<!-- xs:schema element:
	 targetNamespace matched to sch:ns (prefix ?)
	 -->
	<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
	    <sch:title>ISO Schematron schema of W3C XML Schema
	       <xsl:if test="namespace[string-length(@uri) &gt; 0]">
	       (with <xsl:for-each select="namespace[string-length(@uri) &gt; 0]"><xsl:text> </xsl:text><xsl:value-of select="@prefix"/></xsl:for-each>)
	       </xsl:if>
	    </sch:title>
		<sch:p>Schematron schema generated from XSD schema files by xsd2sch <xsl:value-of select="$version"/>.
		See http://www.topologi.com/ and http://www.schematron.com/ </sch:p> 
		 
		    
		
		<!-- generate limitations notice -->
		
		<xsl:variable name="limitations-notice"> 
		    <xsl:for-each select="//xs:any">
		        <sch:p  class="ul">&#x203B; &lt;xs:any&gt; used inside <xsl:value-of select="ancestor[@name][1]/@name"/></sch:p>
		    </xsl:for-each>
		
		    <xsl:for-each select="//xs:anyAttribute">
		        <sch:p  class="ul">&#x203B; &lt;xs:anyAttribute&gt; used inside <xsl:value-of select="ancestor[@name][1]/@name"/></sch:p>
		    </xsl:for-each> 
		    
		    <xsl:for-each select="//xs:union">
		        <sch:p  class="ul">&#x203B; &lt;xs:union&gt; used inside <xsl:value-of select="ancestor[@name][1]/@name"/></sch:p>
		    </xsl:for-each>
		    
		    <xsl:for-each select="//xs:list">
		        <sch:p  class="ul">&#x203B; &lt;xs:list&gt; used inside <xsl:value-of select="ancestor[@name][1]/@name"/></sch:p>
		    </xsl:for-each>
		
		</xsl:variable>
		<xsl:if test="$limitations-notice/*">
		

	 
	 <sch:p><sch:emph>Limitations</sch:emph>  The XSD schema had constructs that are not supported by this version of the schema.
	 These may cause results that are incorrect to some extent.</sch:p>
	   <xsl:copy-of select="$limitations-notice/*" />

	 </xsl:if> 
		
		
		
		<xsl:for-each select="namespace">
			<!--  No ns element for default empty namespace -->
			<xsl:if test="string-length(@uri) &gt; 0">
			    <xsl:if test="not(preceding-sibling::namespace[@prefix = current()/@prefix])" >
					<sch:ns prefix="{@prefix}" uri="{@uri}"/>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		
		<!-- all the namespace declarations from xs:schema -->
		<xsl:variable name="namespace-string">
			<xsl:for-each select="namespace">
				<xsl:value-of select="@prefix"/>
				<xsl:text>,</xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="newroot-namespace">
			<root>
			    <!-- TODO: replace deprecated namespace axis with dm:namespace-nodes()  -->
				<xsl:for-each select="namespace/xs:schema/namespace::node()
							[ string-length(.) &gt; 0 ]
							[ string-length( ./name()) &gt; 0] ">
				    <!-- <xsl:message> <xsl:value-of select="." /> - <xsl:value-of select="name()" /> - </xsl:message> -->
					<xsl:sort select="name()"/>
					
					<xsl:choose>
					   <!-- Reported by PH
					   	When importing different schemas, if the same prefix is used, these will all be 
					   	propagated up to the root element. This can cause a problem from multiple declarations.
					   	And if the same prefix is used for different namespaces in different schemas,
					   	then that would also be a redefinition problem with namespaces then actively wrong. 
					   	
					   	Workaround: just take the first namespace definition and generate a warning if duplicates 
					   	are found. This means these kinds of schemas with redefined prefixes will not be supported.
					   	
					   	TODO: This probably needs another stage to fix it neatly. Select any schemas with duplicate 
					   	prefixes, then go through element and attribute names and change them to a new prefix. 
					   -->
					   <xsl:when test="preceding::xs:schema[namespace::node()/local-name() = current()/local-name()]" >
					     <xsl:if test="preceding::xs:schema
					            [namespace::node()/local-name() = current()/local-name()]
					            [name() = current()/name()]" >
					     <xsl:message>Multiple schemas define different URIs for prefix <xsl:value-of select="current()/local-name()" />
					     </xsl:message>
					     </xsl:if>
					   </xsl:when>
					   
					   <xsl:otherwise>
						<xsl:namespace select="." name="{name()}"/>
					   </xsl:otherwise>
					</xsl:choose>
					
					
				</xsl:for-each>
			</root>
		</xsl:variable>
		<xsl:for-each select="$newroot-namespace/root/namespace::node()">
			<xsl:sort select="name()"/>
			<xsl:variable name="currentpre" select="concat(name(),',')"/>
			<!-- <xsl:message> <xsl:value-of select="$currentpre"/> - </xsl:message> -->
			<xsl:if test="position() = 1 or name() != preceding-sibling::node()[1]/name()">
				<xsl:if test="not(contains($namespace-string, $currentpre))">
					<xsl:variable name="pre" select="name()"/>
					<xsl:variable name="uri" select="."/>
					<sch:ns prefix="{$pre}" uri="{$uri}"/>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		
		<!-- add the XML Schema namespace manually -->
		<sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
		
		<!-- document namespaces that have been declared -->
		<xsl:for-each select="namespace">
			<xsl:sort order="ascending" select="@prefix"/>
			<xsl:if test="string-length(@uri) &gt; 0">
				<sch:p class="ul">
					<xsl:value-of select="@prefix"/> =
					<xsl:value-of select="@uri"/> </sch:p>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$newroot-namespace/root/namespace::node()">
			<xsl:sort select="name()"/>
			<xsl:variable name="currentpre" select="concat(name(),',')"/>
			<!-- <xsl:message> <xsl:value-of select="$currentpre"/> - </xsl:message> -->
			<xsl:if test="position() = 1 or name() != preceding-sibling::node()/name()">
				<xsl:if test="not(contains($namespace-string, $currentpre))">
					<xsl:variable name="pre" select="name()"/>
					<xsl:variable name="uri" select="."/>
					<sch:p class="ul">
						<xsl:value-of select="$pre"/> =
						<xsl:value-of select="$uri"/> </sch:p>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		
		
	  
	  
	  
		
		<!-- generate phases -->
		
	<xsl:comment>
	 ================================  
	 ================================  
	 PHASES
	 ================================ 
	 ================================  
	 </xsl:comment>
		<xsl:for-each select="namespace">
			<xsl:sort order="ascending" select="@prefix"/>
			<!--  we use the prefix even for the default namespace here -->
			<sch:phase id="{concat('phase-namespace-',@prefix)}">
				<sch:active pattern="{concat('Simple_Types-',@prefix)}">
					This active reference the pattern that check simpleTypes for namespace <xsl:value-of select="@prefix"/>
				</sch:active>
				<sch:active pattern="{concat('Elements-',@prefix)}">
					This active reference the pattern that check Elements for namespace <xsl:value-of select="@prefix"/>
				</sch:active>
				<sch:active pattern="{concat('Attributes-',@prefix)}">
					This active reference the pattern that check Attributes for namespace <xsl:value-of select="@prefix"/>
				</sch:active>
				<sch:active pattern="IDs_and_Keys">
					This active reference the pattern that check IDs_and_Keys for namespace <xsl:value-of select="@prefix"/>
				</sch:active>
				
				<sch:p>This is the Phase that has all patterns for namespace:<xsl:value-of select="@prefix"/>.
				
				<xsl:if test="string-length(@uri) &gt; 0">(No namespace)</xsl:if></sch:p>
			</sch:phase>
		</xsl:for-each>

		<sch:phase id="phase-all-simpletypes">
			<xsl:for-each select="namespace">
				<xsl:sort order="ascending" select="@prefix"/>
				<sch:active pattern="{concat('Simple_Types-',@prefix)}">
					This active reference the pattern that check Simple_Types for namespace <xsl:value-of select="@prefix"/>
				</sch:active>
			</xsl:for-each>
			<sch:p>This is the Phase that has all patterns for SimpleTypes.</sch:p>
		</sch:phase>

		<sch:phase id="phase-all-elements">
			<xsl:for-each select="namespace">
				<xsl:sort order="ascending" select="@prefix"/>
				<sch:active pattern="{concat('Elements-',@prefix)}">
					This active reference the pattern that check Elements for namespace <xsl:value-of select="@prefix"/>					
				</sch:active>
			</xsl:for-each>
			<sch:p>This is the Phase that has all patterns for Elements.</sch:p>
		</sch:phase>

		<sch:phase id="phase-all-attributes">
			<xsl:for-each select="namespace">
				<xsl:sort order="ascending" select="@prefix"/>
				<sch:active pattern="{concat('Attributes-',@prefix)}">
					This active reference the pattern that check Attributes for namespace <xsl:value-of select="@prefix"/>					
				</sch:active>
			</xsl:for-each>
			<sch:p>This is the Phase that has all patterns for Global Attributes.</sch:p>
		</sch:phase>

		<sch:phase id="phase-all-idkeyref">
			<sch:active pattern="IDs_and_Keys">
				This active reference the pattern that check ID Key REFS..			
			</sch:active>
			<sch:p>This is the Phase that has all patterns for ID Key REFS.</sch:p>
		</sch:phase>

		<sch:phase id="phase-typo">
			<sch:active pattern="Element_Name_Typo">
				Pattern for checking for typos in element names.
			</sch:active>
			<sch:active pattern="Attribute_Name_Typo">
				Pattern for checking for typos in attribute names.
			</sch:active>
			<sch:p>This phase has all the patterns for checking typos in names.</sch:p>
		</sch:phase>

		<sch:phase id="phase-allowed">
			<sch:active pattern="Element_Name_Allowed">
				Pattern for checking for Expected in Elements names.
			</sch:active>
			<sch:active pattern="Attribute_Name_Allowed">
				Pattern for checking for Expected in attribute names.
			</sch:active>
			<sch:active pattern="Allowed_Followers">
				Pattern for checking for checking following siblings
			</sch:active> 
			<sch:p>This phase has all the patterns for checking Expected in names.</sch:p>
		</sch:phase>

		<sch:phase id="phase-required">
			<sch:active pattern="Element_Name_Required">
				Pattern for checking for Required in Elements names.
			</sch:active>
			<sch:active pattern="Attribute_Name_Required">
				Pattern for checking for Required in attribute names.
			</sch:active>
			<sch:active pattern="Required_Immediate_Followers">
				Pattern for checking when one element is always followed by another. 
			</sch:active>
			<sch:p>This phase has all the patterns for checking Required in names.</sch:p>
		</sch:phase>
		
	
		
		<!-- there are four kinds of patterns -->
		<!-- pattern 1: SimpleTypes - for top level simple type declarations -->
		
		<xsl:comment>
			============================================================
			============================================================
			                     SIMPLE TYPES
			============================================================
			============================================================
		</xsl:comment>
		
		
		<xsl:for-each select="namespace">
			<xsl:sort order="ascending" select="@prefix"/>
					
		<xsl:comment>
			============================================================ 
			                     SIMPLE TYPES <xsl:if test="string-length(@uri) &gt; 0">for NAMESPACE
			                     <xsl:value-of select="@uri"/></xsl:if>
			============================================================ 
		</xsl:comment>
			<sch:pattern id="{concat('Simple_Types-', @prefix)}">
				<sch:title>Simple Types constraints</sch:title>
				<sch:p>This pattern implements XSD simple type validation
					<xsl:choose><xsl:when test="string-length(@uri) &gt; 0">for the namespace: <xsl:value-of select="@uri"/>.</xsl:when>
				<xsl:otherwise> (which do not belong to any namespace.)</xsl:otherwise>
				</xsl:choose> 
				</sch:p>
				
				<!--  only generate these for the first namespace mentioned (will this have a scope problem?) -->
				<!--xsl:if test="position() =1"-->
				<sch:rule abstract="true" id="{concat('NoDataContent-', @prefix)}">
				<sch:assert test="string-length(normalize-space(string-join(text(), ''))) = 0" 
				diagnostics="unexpected-content">Element "<sch:name/>" should have no text content.</sch:assert>
				</sch:rule>	
				
				
				<sch:rule abstract="true" id="{concat('NoElementContent-', @prefix)}">
						<sch:assert test="count(*|processing-instruction()|comment()) = 0" diagnostics="d1"
						>Element "<sch:name/>" should be completely empty (no XML comments, PIs, or elements).</sch:assert>
				</sch:rule>	
				<!--/xsl:if-->
				
				<sch:rule abstract="true" id="{concat('NoContents-', @prefix)}">
						<sch:extends rule="{concat('NoDataContent-', @prefix)}" />
						<sch:extends rule="{concat('NoDataContent-', @prefix)}" />
						<sch:assert test="count(processing-instruction()|comment()) = 0" diagnostics="d1"
						>Element "<sch:name/>" should be completely empty (no XML comments, PIs).</sch:assert>
				</sch:rule>			
				
				
				<!-- Add standard datatypes library  -->
				<xsl:call-template name="generate-standard-datatypes">
					<xsl:with-param name="prefix" select="@prefix"/>
				</xsl:call-template>
				
				
				<xsl:comment>
			============================================================ 
			                     SIMPLE TYPES <xsl:if test="string-length(@uri) &gt; 0">for NAMESPACE
			                     <xsl:value-of select="@uri"/>
			                     DEREIVED FROM BUILT-IN TYPE </xsl:if>
			============================================================ 
		</xsl:comment>
				<!-- generate abstract rules for each simple type declaration
				that uses @type or @base, derived from the built-in types above -->
				<xsl:apply-templates select="xs:schema/xs:simpleType"
					mode="simpleType"/>
					
				<!-- generate rules for each element declaration, using extend for 
				the @base or @type, and asserts for individual facet overrides -->
				<xsl:apply-templates select="xs:schema//xs:element[@name]"
					mode="simpleType"/>
				<!-- generate rules for each attribute declaration, using extend for 
				the @base or @type, and asserts for individual facet overrides -->
				<xsl:apply-templates select="xs:schema//xs:attribute[@name]"
					mode="simpleType"/>
			</sch:pattern>
		</xsl:for-each>
		
		<!-- pattern 2: Elements
		top-level element constraints
		local element constraints
		-->
		<xsl:comment>
			============================================================
			============================================================
                                   ELEMENTS 
			============================================================
			============================================================
		</xsl:comment>
		<xsl:for-each select="namespace">
			<xsl:sort order="ascending" select="@prefix"/>
			<xsl:comment>
			============================================================ 
			                     ELEMENTS target namespace <xsl:value-of select="@uri"/>
			=========================================================== 
			</xsl:comment>
			<xsl:choose>
			<xsl:when test="string-length(@uri) &gt; 0">
				<sch:pattern id="{concat('Elements-', @prefix)}">
					<sch:title>Element constraints for Namespaces: <xsl:value-of select="@uri"/></sch:title>
					<xsl:comment>Local declarations</xsl:comment>
					<xsl:apply-templates
						select="xs:schema//xs:element[@name][ancestor::xs:element]"/>
					<xsl:comment>Global declarations</xsl:comment>
					<xsl:apply-templates select="xs:schema/xs:element[@name]"/>
				</sch:pattern>
			</xsl:when>
			<xsl:otherwise>
				<sch:pattern id="{concat('Elements-', @prefix)}">
					<sch:title>Element constraints for elements in no namespace </sch:title>
					<xsl:comment>Local declarations</xsl:comment>
					<xsl:apply-templates
						select="xs:schema//xs:element[@name][ancestor::xs:element]"/>
					<xsl:comment>Global declarations</xsl:comment>
					<xsl:apply-templates select="xs:schema/xs:element[@name]"/>
				</sch:pattern>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- pattern 3: Attributes
		top-level attribute constraints
		local attribute constraints
		-->
		
		<xsl:comment>
			============================================================
			============================================================
                             Ref Global ATTRIBUTES 
			============================================================
			============================================================
		</xsl:comment>
		<xsl:for-each select="namespace">
			<xsl:sort order="ascending" select="@prefix"/>
			<sch:pattern id="{concat('Attributes-', @prefix)}">
				<sch:title>Attributes Ref Global Attributes constraints for Namespaces: <xsl:value-of select="@uri"/></sch:title>
				
				<!--
				<xsl:apply-templates
					select="xs:schema//xs:attribute[@name][not(parent::xs:schema)]"/>
				<xsl:apply-templates select="xs:schema/xs:attribute"/>  -->
				<xsl:apply-templates select="xs:schema//xs:attribute[@ref]"/>
			</sch:pattern>
		</xsl:for-each>
		
		<!-- pattern 4: other constraints
		ID/IDREF
		KEYS
		-->
		<xsl:comment>
			============================================================
			============================================================
		                    ID, IDREF, KEY and KEYREF
			============================================================
			============================================================
		</xsl:comment>
		<sch:pattern id="IDs_and_Keys">
			<sch:title>IDs, Keys and References</sch:title>
			<xsl:call-template name="generate-idref-checking-rule"/>
		</sch:pattern>
		
		<!-- pattern 5: Element name typos Elements	-->
		<xsl:comment>
			============================================================
			============================================================
		                          ELEMENT NAMES 
			============================================================
			============================================================
		</xsl:comment>
		<sch:pattern id="Element_Name_Typo">
			<sch:title>Typos in Element Names</sch:title>
			<xsl:call-template name="generate-elements-typo-checking-rule"/>
		</sch:pattern>
		<sch:pattern id="Element_Name_Allowed">
			<sch:title>Elements alowed in Parent</sch:title>
			<xsl:call-template name="generate-elements-expected-checking-rule"/>
		</sch:pattern>
		
		<!-- pattern 6: Attributes name typos Attributes	-->
		<xsl:comment>
			============================================================
			============================================================
	                         Attributes NAMES
			============================================================
			============================================================
		</xsl:comment>
		<sch:pattern id="Attribute_Name_Typo">
			<sch:title>Typos in Attributes names</sch:title>
			<xsl:call-template name="generate-attributes-typo-checking-rule"/>
		</sch:pattern>
		<sch:pattern id="Attribute_Name_Allowed">
			<sch:title>Attributes allowed on Parent</sch:title>
			<xsl:call-template name="generate-attributes-expected-checking-rule"/>
		</sch:pattern>
		<xsl:comment>
			============================================================
			============================================================
	                         OCCURRENCE
			============================================================
			============================================================
		</xsl:comment>
		
		<sch:pattern id="Element_Name_Required">
			<sch:title>Required Elements</sch:title>
			<xsl:call-template name="generate-elements-required-checking-rule"/>
		</sch:pattern>
		
		<sch:pattern id="Attribute_Name_Required">
			<sch:title>Required Attributes</sch:title>
			<xsl:call-template name="generate-attributes-required-checking-rule"/>
		</sch:pattern>
		
		<sch:pattern id="Allowed_Followers">
			<sch:title>Allowed Followers</sch:title>
			<xsl:call-template name="generate-following-elements-checking-rule"/>
		</sch:pattern>
		
		
		<sch:pattern id="Required_Immediate_Followers">
			<sch:title>Required Immediate Followers (Simple)</sch:title>
			<xsl:call-template name="generate-immediate-following-elements-checking-rule"/>
		</sch:pattern>
		 
		<xsl:comment>
			============================================================
			============================================================
                                 DIAGNOSTICS 
			============================================================
			============================================================
		</xsl:comment>
		<sch:diagnostics>
			<sch:diagnostic id="d1">This content was found: "<xsl:value-of select="text()"/>" or this element "<sch:value-of select="*/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="typo-element">This element was found: "<sch:value-of select="name()"/>" in "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="typo-attribute">This attribute was found: "<sch:value-of select="name()"/>" on "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="expected-element">This element was found: "<sch:value-of select="name()"/>" in "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="expected-attribute">This attribute was found: "<sch:value-of select="name()"/>" on "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="unexpected-immediate-follower">This element was found: "<sch:value-of select="following-sibling::*[1]/name()"/>".</sch:diagnostic>
			<sch:diagnostic id="unexpected-content">This content was found: "<sch:value-of select="text()"/>".</sch:diagnostic>
			
			<xsl:comment>Generating Diagnostics for xs:all/elements </xsl:comment>
			<xsl:for-each select="xs:element[.//xs:all]//xs:all/xs:element">
				<xsl:variable name="ancestor-element" select="ancestor::xs:element/@name"/>
				<xsl:variable name="element-name" select="if (@name) then @name else @ref"/>
				<sch:diagnostic id="{concat('d2-',$ancestor-element,'-',$element-name)}"><sch:value-of select="count($element-name)"/> "<xsl:value-of select="$element-name"/>" elements were found</sch:diagnostic>
			</xsl:for-each>
			
			
			<!-- generate diagnostic for each standard datatypes -->
			<xsl:call-template name="generate-standard-datatypes-diagnostics"/>
		</sch:diagnostics>
	</sch:schema>
</xsl:template>


<!-- ========================================================== -->
<!-- =============COMMON NODES================================= -->		
<!-- ========================================================== -->		
<!-- xs:annotation element -->
<xsl:template match="xs:annotation">
	<xsl:apply-templates/>
</xsl:template>
	
<!-- xs:documentation element matching details:
	 @source match to sch:p/sch:span class="link"
	 @xml:lang is not matched
	 text() match to sch:p
	 -->
<xsl:template match="xs:documentation">
	<xsl:if test="@source">
		<sch:p>
			<sch:span class="link">
				<xsl:value-of select="@source"/>
			</sch:span>
		</sch:p>
	</xsl:if>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()">
	<xsl:if test="normalize-space(.) != ''">
		<sch:p><xsl:value-of select="."/></sch:p>		
	</xsl:if>
</xsl:template>
	
<xsl:template match="text()" mode="simpleType">
	<xsl:if test="normalize-space(.) != ''"><xsl:value-of select="."/></xsl:if>
</xsl:template>
	

<!-- ========================================================== -->
<!-- =============SIMPLE TYPES================================= -->		
<!-- ========================================================== -->	
<xsl:template match="xs:element | xs:attribute" mode="simpleType">
	<xsl:choose>
		<xsl:when test="@type">
			<sch:rule  role="datatype" >
				<xsl:choose>
					<xsl:when test="self::xs:attribute[parent::xs:schema]">
						<xsl:attribute name="abstract">true</xsl:attribute>
						<xsl:message>+++generating global attributes: <xsl:value-of select="@name"/></xsl:message>
						<xsl:attribute name="id">
							<xsl:choose>
								<!-- attribute has no namespace -->
								<xsl:when test="ancestor::namespace/@uri=''">
									<xsl:value-of select="concat('global_', @name)"/>
								</xsl:when>
								<!-- attribute has namespace (normal case) -->
								<xsl:otherwise>
									<xsl:value-of select="concat('global_', ancestor::namespace/@prefix, '_', @name)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="self::xs:element">
								<xsl:call-template name="generate-element-context"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="generate-attribute-context"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<!-- check whether the namespace is standard xs or xsi by comparing URI -->
				<xsl:variable name="qname">
				    <xsl:call-template name="qualify-type-name">
				        <xsl:with-param name="name" select="@type" />
				    </xsl:call-template>
				</xsl:variable>
				<xsl:variable name="type-prefix" select="substring-before($qname, ':')"/>
				<xsl:variable name="is-this-standard-namespace">
				     <xsl:if test="$type-prefix='xs' 
				     or namespace-uri-for-prefix($type-prefix,.)='http://www.w3.org/2001/XMLSchema' "
				     >true</xsl:if>
				     
				    <!-- method using nodes
					<xsl:for-each select="ancestor::xs:schema/namespace::node()">
						<xsl:if test="$type-prefix = name() and 
							(. = 'http://www.w3.org/2001/XMLSchema-instance' or . = 'http://www.w3.org/2001/XMLSchema')">
							<xsl:text>true</xsl:text>
						</xsl:if>
					</xsl:for-each>
					-->
					
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$is-this-standard-namespace = 'true' and contains($qname, ':')">
						<sch:extends rule="{concat(ancestor::namespace/@prefix, '-xsd-datatype-', substring-after($qname, ':'))}"/>
					</xsl:when>
					<xsl:when test="$is-this-standard-namespace = 'true'">
						<sch:extends rule="{concat(ancestor::namespace/@prefix, '-xsd-datatype-', @qname)}"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="contains($qname,':')">
								<xsl:variable name="prefix"
									select="substring-before($qname, ':')"/>
								<xsl:variable name="typename"
									select="substring-after($qname, ':')"/>
								<sch:extends rule="{concat($prefix, '_', $typename)}"/>
							</xsl:when>
							<xsl:otherwise>
								<sch:extends rule="{concat(ancestor::namespace/@prefix, '_', @type)}"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</sch:rule>
		</xsl:when>
		<xsl:when test="xs:simpleType/xs:restriction[@base]">
			<xsl:variable name="baseon" select="xs:simpleType/xs:restriction/@base"/>
		    <xsl:variable name="qname">
				    <xsl:call-template name="qualify-type-name">
				        <xsl:with-param name="name" select="$baseon" />
				    </xsl:call-template>
			</xsl:variable>
			<sch:rule  role="datatype" >
				<xsl:choose>
					<xsl:when test="self::xs:attribute[parent::xs:schema]">
						<xsl:attribute name="abstract">true</xsl:attribute>
						<xsl:attribute name="id">
							<xsl:choose>
								<!-- attribute has no namespace -->
								<xsl:when test="ancestor::namespace/@uri=''">
									<xsl:value-of select="concat('global_', @name)"/>
								</xsl:when>
								<!-- attribute has namespace (normal case) -->
								<xsl:otherwise>
									<xsl:value-of select="concat('global_', ancestor::namespace/@prefix, '_', @name)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="self::xs:element">
								<xsl:call-template name="generate-element-context"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="generate-attribute-context"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<!-- get base value --> 
				
				<!-- check whether the namespace is standard xs or xsi by comparing URI -->
				<xsl:variable name="baseon-prefix" select="substring-before($qname, ':')"/>
				<xsl:variable name="is-this-standard-namespace">
				    <xsl:if test="$baseon-prefix='xs' 
				    or namespace-uri-for-prefix($baseon-prefix,.)='http://www.w3.org/2001/XMLSchema'"
				     >true</xsl:if>
				    <!--
					<xsl:for-each select="ancestor::xs:schema/namespace::node()">
						<xsl:if test="$baseon-prefix = name() and 
							(. = 'http://www.w3.org/2001/XMLSchema-instance' or . = 'http://www.w3.org/2001/XMLSchema')">
							<xsl:text>true</xsl:text>
						</xsl:if>
					</xsl:for-each>
					-->
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$is-this-standard-namespace = 'true'"> 
						<sch:extends rule="{concat(ancestor::namespace/@prefix, '-xsd-datatype-', substring-after($qname, ':'))}"/>
					</xsl:when>
					<xsl:when test="contains($qname,':')">
						<xsl:variable name="prefix"
							select="substring-before($qname, ':')"/>
						<xsl:variable name="typename"
							select="substring-after($qname, ':')"/>
						<sch:extends rule="{concat($prefix, '_', $typename)}"/>
					</xsl:when>
					<xsl:otherwise>
						<sch:extends rule="{concat(ancestor::namespace/@prefix, '_', $baseon)}"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- check the underneath of restriction -->
				<xsl:if test="xs:simpleType/xs:restriction/xs:enumeration">
					<sch:assert>
						<xsl:attribute name="test">
							<xsl:for-each select="xs:simpleType/xs:restriction/xs:enumeration">
								<xsl:text>(. = "</xsl:text>
								<xsl:value-of select="normalize-space(@value)"/>
								<xsl:text>")</xsl:text>
								<xsl:if test="following-sibling::xs:enumeration">
									<xsl:text> or </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute> The value of "<sch:name/>" should be one of
						<xsl:for-each select="xs:simpleType/xs:restriction/xs:enumeration">
							<xsl:value-of select="@value"/>
							<xsl:if test="following-sibling::xs:enumeration">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>. (It is of type "
						<xsl:value-of select="normalize-space(@name)"/>".)
					</sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:minLength">
					<sch:assert test="string-length(.) &lt; xs:simpleType/xs:restriction/xs:minLength/@value"> 
					The value of "<sch:name/>" is a simpleType (<xsl:value-of select="@name"/>). 
					It should be longer than <xsl:value-of select="xs:simpleType/xs:restriction/xs:minLength/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:maxLength">
					<sch:assert test="string-length(.) &gt; xs:simpleType/xs:restriction/xs:maxLength/@value"> 
					The value of "<sch:name/>" is a simpleType (<xsl:value-of select="@name"/>). 
					It should be  shorter than <xsl:value-of select="xs:simpleType/xs:restriction/xs:maxLength/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:length">
					<sch:assert test="string-length(.) != xs:simpleType/xs:restriction/xs:length/@value">  
					The value of "<sch:name/>" is a simpleType (<xsl:value-of select="@name"/>). 
					It should be of length <xsl:value-of select="xs:simpleType/xs:restriction/xs:length/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:whiteSpace">
					<sch:assert test="true()"> WhiteSpace would be treated as 'preserve',
						'replace' or 'collapse' </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:totalDigits">
					<xsl:comment>The counting doesn't include dot, leading and trailing zeros.</xsl:comment>
					<sch:assert test="string-length(replace(string(.),'.','')) &lt; xs:simpleType/xs:restriction/xs:totalDigits/@value"> The maximum number of digits for <sch:name/>
						should be smaller than <xsl:value-of select="xs:simpleType/xs:restriction/xs:totalDigits/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:minExclusive">
					<sch:assert test=". &gt; xs:simpleType/xs:restriction/xs:minExclusive/@value"> The value for <sch:name/> should be 
						bigger than <xsl:value-of select="xs:simpleType/xs:restriction/xs:minExclusive/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:minInclusive">
					<sch:assert test=". &gt; xs:simpleType/xs:restriction/xs:minExclusive/@value or . = xs:simpleType/xs:restriction/xs:minExclusive/@value"> The value for <sch:name/> should be 
						bigger than and equal with <xsl:value-of select="xs:simpleType/xs:restriction/xs:minExclusive/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:maxExclusive">
					<sch:assert test=". &lt; xs:simpleType/xs:restriction/xs:maxExclusive/@value"> The value for <sch:name/> should be 
						smaller than <xsl:value-of select="xs:simpleType/xs:restriction/xs:maxExclusive/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:maxInclusive">
					<sch:assert test=". &lt; xs:simpleType/xs:restriction/xs:maxExclusive/@value or . = xs:simpleType/xs:restriction/xs:maxExclusive/@value"> The value for <sch:name/> should be 
						smaller than and equal with <xsl:value-of select="xs:simpleType/xs:restriction/xs:maxExclusive/@value"/> </sch:assert>
				</xsl:if>
				<xsl:if test="xs:simpleType/xs:restriction/xs:pattern">
					<!-- This assertion check xs:pattern, xs:pattern could be more than one, but the value is valid when one of them is matched.-->
					<xsl:variable name="testString">
						<xsl:for-each select="xs:simpleType/xs:restriction/xs:pattern">
							<xsl:variable name="apost" select='"&apos;"'/>
							<xsl:value-of select="concat('matches(.,', $apost,@value,$apost,')')"/>
							<xsl:if test="position() != last()"> or </xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<sch:assert>
						<xsl:attribute name="test">
							<xsl:value-of select="$testString"/>
						</xsl:attribute> The value for "<sch:name/>" should match 
						<xsl:choose>
							<xsl:when test="count(xs:simpleType/xs:restriction/xs:pattern) = 1">
								the pattern:
							</xsl:when>
							<xsl:otherwise>
								one of patterns:
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="xs:simpleType/xs:restriction/xs:pattern">
							<!-- HACK: This is strange to make span into a list value, but better than nothing -->
							<sch:span class="li"><xsl:value-of select="@value"/></sch:span>
						</xsl:for-each> 
					</sch:assert>
				</xsl:if>
			</sch:rule>
		</xsl:when> 
		<xsl:when test="xs:simpleType/xs:restriction/xs:simpleType">
			<xsl:comment>Processing the simpleType inside the xs:restriction</xsl:comment>
 	        <xsl:message>I don't know how to handle this kind of simple type yet. (simpleType inside the xs:restriction.) (Derivation by union or list)</xsl:message>			
		</xsl:when>
		<!-- attributes that doesn't have @type and simpleType child -->
		<xsl:when test="self::xs:attribute">
			<sch:rule role="datatype" >
				<xsl:choose>
					<xsl:when test="self::xs:attribute[parent::xs:schema]">
						<xsl:attribute name="abstract">true</xsl:attribute>
						<xsl:attribute name="id">
							<xsl:choose>
								<!-- attribute has no namespace -->
								<xsl:when test="ancestor::namespace/@uri=''">
									<xsl:value-of select="concat('global_', @name)"/>
								</xsl:when>
								<!-- attribute has namespace (normal case) -->
								<xsl:otherwise>
									<xsl:value-of
										select="concat('global_', ancestor::namespace/@prefix, '_', @name)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generate-attribute-context"/>
					</xsl:otherwise>
				</xsl:choose>
				<sch:assert test="true()">This kind of attribute hasn't been checked, or don't need to check</sch:assert>
			</sch:rule>
		</xsl:when>
	</xsl:choose>
</xsl:template>

				
<!-- ========================================================== -->	
<!-- global (top-level) xs:simpleType match to sch:pattern
	 check 1: check enumerations
	 check 2: string length -->
<xsl:template match="xs:schema/xs:simpleType[xs:restriction]" priority="1" mode="simpleType">
	<xsl:variable name="prefix" select="ancestor::namespace[1]/@prefix"/>
	<sch:rule abstract="true"
		id="{if ($prefix != '') then concat($prefix,'_',@name) else @name}">
		<xsl:if test="xs:restriction/xs:enumeration">
			<sch:assert>
				<xsl:attribute name="test">
					<xsl:for-each select="xs:restriction/xs:enumeration">
						<xsl:text>(. = "</xsl:text>
						<xsl:value-of select="normalize-space(@value)"/>
						<xsl:text>")</xsl:text>
						<xsl:if test="following-sibling::xs:enumeration">
							<xsl:text> or </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:attribute> The value of "<sch:name/>" should be one of
				<xsl:for-each select="xs:restriction/xs:enumeration">
					<xsl:value-of select="@value"/>
					<xsl:if test="following-sibling::xs:enumeration">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>. (It is of type "<xsl:value-of select="normalize-space(@name)"/>".) </sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:minLength">
			<sch:assert
				test="string-length(.) &lt; xs:restriction/xs:minLength/@value">
				A simpleType
				<xsl:value-of select="@name"/>'s value must be longer than
				<xsl:value-of select="xs:restriction/xs:minLength/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:maxLength">
			<sch:assert
				test="string-length(.) &gt; xs:restriction/xs:maxLength/@value">
				A simpleType
				<xsl:value-of select="@name"/>'s value must be shorter than
				<xsl:value-of select="xs:restriction/xs:maxLength/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:length">
			<sch:assert
				test="string-length(.) != xs:restriction/xs:length/@value"> A
				length of this simpleType
				<xsl:value-of select="@name"/>'s value must be
				<xsl:value-of select="xs:restriction/xs:length/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:whiteSpace">
			<sch:assert test="true()"> WhiteSpace would be 'preserve',
				'replace' or 'collapse' </sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:totalDigits">
			<!-- The counting doesn't include dot, leading and trailing
				zeros.-->
			<sch:assert
				test="string-length(replace(string(.),'.','')) &lt; xs:restriction/xs:totalDigits/@value">
				The maximum number of digits for "<sch:name/>"
				should smaller than
				<xsl:value-of select="xs:restriction/xs:totalDigits/@value"/>
				</sch:assert>xsl:comment
		</xsl:if>
		<xsl:if test="xs:restriction/xs:minExclusive">
			<sch:assert test=". &gt; xs:restriction/xs:minExclusive/@value"> The
				value for "<sch:name/>" should be bigger than
				<xsl:value-of select="xs:restriction/xs:minExclusive/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:minInclusive">
			<sch:assert
				test=". &gt; xs:restriction/xs:minExclusive/@value or . = xs:restriction/xs:minExclusive/@value">
				The value for "<sch:name/>" should be bigger than or equal with
				<xsl:value-of select="xs:restriction/xs:minExclusive/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:maxExclusive">
			<sch:assert test=". &lt; xs:restriction/xs:maxExclusive/@value"> The
				value for "<sch:name/>" should be smaller than
				<xsl:value-of select="xs:restriction/xs:maxExclusive/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:maxInclusive">
			<sch:assert
				test=". &lt; xs:restriction/xs:maxExclusive/@value or . = xs:restriction/xs:maxExclusive/@value">
				The value for "<sch:name/>" should be smaller than or equal with
				<xsl:value-of select="xs:restriction/xs:maxExclusive/@value"/>
				</sch:assert>
		</xsl:if>
		<xsl:if test="xs:restriction/xs:pattern">
			<xsl:comment>This assertion check xs:pattern, xs:pattern could be more than
				one, but the value is valid when one of them is matched.</xsl:comment>
			<xsl:variable name="testString">
				<xsl:for-each select="xs:restriction/xs:pattern">
					<xsl:variable name="apost" select='"&apos;"'/>
					<xsl:value-of select="concat('matches(.,', $apost,@value,$apost,')')"/>
					<xsl:if test="position() != last()"> or </xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<sch:assert>
				<xsl:attribute name="test">
					<xsl:value-of select="$testString"/>
				</xsl:attribute> The value for "<sch:name/>" should match 
				<xsl:choose>
					<xsl:when test="count(xs:restriction/xs:pattern) = 1"> the pattern: </xsl:when>
					<xsl:otherwise> one of patterns: </xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="xs:restriction/xs:pattern">
					<!-- HACK: This is strange to make span into a list value, but better than nothing -->
					<sch:span class="li"><xsl:value-of select="@value"/></sch:span>
				</xsl:for-each> 
			</sch:assert>
		</xsl:if>
	</sch:rule>
</xsl:template>


<xsl:template match="xs:schema/xs:simpleType[xs:union or xs:list]" mode="simpleType">
	<xsl:comment>Global simpleType, that doesn't have xs:restriction and has list or union, hasn't been processed.</xsl:comment>
	<xsl:message>I don't know how to handle this kind of simple type yet. (Derivation by union or list)</xsl:message>
</xsl:template>

<xsl:template match="xs:schema/xs:simpleType" mode="simpleType" priority="-1">
	<xsl:comment>Global simpleType, that doesn't have xs:restriction , hasn't been processed.</xsl:comment>
	<xsl:message>I don't know how to handle this kind of simple type yet.</xsl:message>
</xsl:template>

<!-- ========================================================== -->
<!-- =============ELEMENTS===================================== -->		 	
<!-- ========================================================== -->
<!-- global and local declarations for elements (not references) -->
	
<!-- ========== Special Cases =========== -->
 

<!-- Elements with no content: EMPTY
	 Ref: http://www.w3schools.com/schema/schema_complex_empty.asp -->
<xsl:template match="xs:element[xs:complexType[not(xs:simpleContent)][not(@mixed='true')][not(.//xs:element)][not(.//xs:any)]]
   |  xs:element[@name][not(@type)][not(*)]" priority="100">
	<sch:rule  role="structure" >
		<xsl:call-template name="generate-element-context"/>  
		<sch:extends rule="{concat('NoContents-', ancestor::namespace/@prefix)}" />

	</sch:rule>
</xsl:template>

<!-- Elements text only content (could have attributes)
	  -->
<xsl:template match="xs:element[xs:complexType[xs:simpleContent]]  " priority="99">
	<sch:rule  role="structure">
		<xsl:call-template name="generate-element-context"/> 
		<sch:extends rule="{concat('NoElementContent-', ancestor::namespace/@prefix)}" />
	</sch:rule>
</xsl:template>

<!-- Element content should have empty text content
	  -->
<xsl:template match="xs:element[xs:complexType[not(@mixed='true')][not(xs:simpleContent)] 
      or xs:complexType/xs:complexContent[not(@mixed='true')]]" priority="98">
	<sch:rule  role="structure">
		<xsl:call-template name="generate-element-context"/>
		<!-- Check no text found: They can't have any-->
		<sch:extends rule="{concat('NoDataContent-', ancestor::namespace/@prefix)}" />
	</sch:rule>
</xsl:template>
		

	
<!-- handle ALL content models -->	
<xsl:template match="xs:element[.//xs:all]" priority="90">
	<xsl:comment>======= Handle XS:ALL ========</xsl:comment>
	<sch:rule  role="structure">
		<xsl:call-template name="generate-element-context"/>
		<xsl:comment>check allowed elements</xsl:comment>
		<sch:assert diagnostics="d1">
			<xsl:attribute name="test">
				<!-- get names of each allowed element -->
				<xsl:for-each select=".//xs:all/xs:element">
					<xsl:text>count(</xsl:text>
					<xsl:value-of select="if (@name) then @name else @ref" />
					<xsl:text>)</xsl:text>
					<xsl:if test="following-sibling::xs:element"> + </xsl:if>
				</xsl:for-each>
				<xsl:text> = count(*)</xsl:text>
			</xsl:attribute>
			The element "<xsl:value-of select ="@name"/>" can only have the following child elements:
			<!-- get names of each allowed element -->
			<xsl:for-each select=".//xs:all/xs:element">
				<xsl:value-of select="if (@name) then @name else @ref" />
				<xsl:if test="following-sibling::xs:element">, </xsl:if>
			</xsl:for-each>.
		</sch:assert>
		<xsl:comment>check occurs for each elements</xsl:comment>
		<xsl:for-each select=".//xs:all/xs:element">
			<xsl:variable name="ancestor-element" select="ancestor::xs:element/@name"/>
			<xsl:variable name="element-name" select="if (@name) then @name else @ref"/>
			<xsl:variable name="MAXOccurs" select="if (@maxOccurs) then (if (number(@maxOccurs)) then @maxOccurs  else '1') else '1'"/>
			<xsl:variable name="MINOccurs" select="if (@minOccurs) then (if (number(@minOccurs)) then @minOccurs  else '1') else '1'"/>
			<xsl:choose>
				<xsl:when test="$MAXOccurs = $MINOccurs">
					<sch:assert diagnostics="{concat('d2-',$ancestor-element,'-',$element-name)}">
						<xsl:attribute name="test">
							count(<xsl:value-of select="$element-name"/>) = <xsl:value-of select="$MAXOccurs"/>
						</xsl:attribute>
						There should be <xsl:value-of select="$MAXOccurs"/> of element "<xsl:value-of select="$element-name"/>"
					</sch:assert>
				</xsl:when>
				<xsl:otherwise>
					<sch:assert diagnostics="{concat('d2-',$ancestor-element,'-',$element-name)}">
						<xsl:attribute name="test">
							count(<xsl:value-of select="$element-name"/>) &lt;= <xsl:value-of select="$MAXOccurs"/>
						</xsl:attribute>
						There should be at most <xsl:value-of select="$MAXOccurs"/> of element "<xsl:value-of select="$element-name"/>"
					</sch:assert>
					<sch:assert diagnostics="{concat('d2-',$ancestor-element,'-',$element-name)}">
						<xsl:attribute name="test">
							count(<xsl:value-of select="$element-name"/>) &gt;= <xsl:value-of select="$MINOccurs"/>
						</xsl:attribute>
						There should be at least <xsl:value-of select="$MINOccurs"/> of element "<xsl:value-of select="$element-name"/>"
					</sch:assert>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</sch:rule>
</xsl:template>
 
<xsl:template match="xs:element[xs:complexType/xs:sequence or xs:sequence
                  or xs:complexType/xs:choice or xs:choice]" priority="80">
	<xsl:variable name="ancestor-element" select="name()"/>
	<sch:rule  role="structure">
		<xsl:call-template name="generate-element-context"/>
		<xsl:comment>check elements sequence</xsl:comment>
		<xsl:for-each select="xs:complexType/xs:sequence | xs:sequence | xs:complexType/xs:choice | xs:choice">
			<xsl:for-each select="xs:element">
				<xsl:choose>
					<!-- only one element in this sequene -->
					<xsl:when test="position() = 1 and position() = last()">
						<sch:assert>
							<xsl:attribute name="test">true()</xsl:attribute>
						</sch:assert>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:for-each>
	</sch:rule>
</xsl:template>	
	 
<xsl:template match="xs:element[@ref]" priority="1" >
	<xsl:message>PROGRAMMING ERROR: trying to process an element reference.</xsl:message>
</xsl:template>

 
<!-- This is the rule for elements that are mixed content, but not complexTypes containind
   sequence, choice or all. We just swallow them. RJ
   TODO: check whether attributes are still handled. -->
<xsl:template match="xs:element[not(@type)]
       [xs:complexType/@mixed='true' or xs:complexType/xs:complexContent/@mixed='true']" />
        
<xsl:template match="xs:element[not(@type)]
        [not(xs:complexType/@mixed='true' or xs:complexType/xs:complexContent/@mixed='true')]" >
	<!-- before outputing 'not handled message', filter the one has already been checked by SIMPLETYPE templates at patter one -->
	<xsl:variable name="filtermessage">
		<xsl:apply-templates select="." mode="simpleType"/>
	</xsl:variable>
	<!-- if there is some output, that means has been handled, if there is no output, that means not handled -->
	<!-- TODO: this approach seems rather BFI and expensive: perhaps it can be revisited -->
	<xsl:if test="$filtermessage = ''">
		<xsl:message>I don't know how to handle this kind of element declaration yet. (<xsl:value-of select="@name"/>)</xsl:message>
	</xsl:if>	
</xsl:template>
	
	

<!-- ========================================================== -->
<!-- =============ATTRIBUTES=================================== -->		
<!-- ========================================================== -->	
<!-- global attribute match 
<xsl:template match="xs:schema/xs:attribute[@name]" priority="1">
	<xsl:choose>
		<!- attribute has no namespace ->
		<xsl:when test="ancestor::namespace/@uri=''">
			<sch:rule abstract="true" id="{concat('global_', @name)}">
				
			</sch:rule>
		</xsl:when>
		<!- attribute has namespace (normal case) ->
		<xsl:otherwise>
			<sch:rule abstract="true" id="{concat('global_', ancestor::namespace/@prefix, '_', @name)}">
			</sch:rule>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	-->

<!-- local attributes with name( already been covered by the templates for simpleType 
<xsl:template match="xs:attribute[@name][not(parent::xs:schema)]">
		<sch:assert test="true()">Assertions for attribute <xsl:value-of select="@name"/> go here</sch:assert>
</xsl:template>	-->

<!-- local attributes with ref -->
<xsl:template match="xs:attribute[@ref][not(parent::xs:schema)]">
	<sch:rule  role="attribute"> 
		<xsl:call-template name="generate-attribute-context-ref"/>
		<xsl:choose>
			<xsl:when test="contains(@ref,':')">
				<xsl:variable name="prefix"
					select="substring-before(@ref, ':')"/>
				<xsl:variable name="attrname"
					select="substring-after(@ref, ':')"/>
				<sch:extends rule="{concat('global_',$prefix,'_',$attrname)}"/>
			</xsl:when>
			<!-- attribute doesn't have namespace (normal case) -->
			<xsl:otherwise>
				<sch:extends
					rule="{concat('global_', @ref)}"/>
			</xsl:otherwise>
		</xsl:choose>
	</sch:rule>
</xsl:template>	
	
		

<!-- ========================================================== -->
<!-- =============INTEGRITY==================================== -->		
<!-- ========================================================== -->	
<!-- IDs, Keys and References match -->
<xsl:template match="xs:key">

</xsl:template>

<xsl:template match="xs:keyref">

</xsl:template>
		
<xsl:template match="xs:unique">

</xsl:template>
		

<!-- ========================================================== -->
<!-- =============RESTRICTION================================== -->		
<!-- ========================================================== -->	
<!-- match all restriction: 
	 three cases: parent is simpleTyple
	              parent is simpleContent
	              parent is complexContent
	              
	              CURRENTLY UNUSED!
	-->
<xsl:template match="xs:restriction" mode="restriction">
</xsl:template> 
	

<!-- ========================================================== -->
<!-- =============UTILITIES==================================== -->		
<!-- ========================================================== -->	 
<!-- determine whether a name needs a prefix -->	
<xsl:template name="make-prefixed-name">
	<xsl:param name="theName"/>
	  <xsl:choose>
	      <!-- A prefixed name loses the prefix it should be no namespace -->
	      <xsl:when test="contains($theName, ':')">
	      	 <xsl:variable name="theSuffix" select="substring-after($theName,':')"/>
	      	
	      	 <xsl:choose>
	      	 <xsl:when test="ancestor::namespace/@uri=''">
			  <xsl:value-of select="$theSuffix"/>
			 </xsl:when>
			 <xsl:otherwise>
				<xsl:value-of select="$theName"/>
			 </xsl:otherwise>
			 </xsl:choose>
		  </xsl:when>
		  
	  
		  <!-- A prefixed name keeps its prefix -->
		  <xsl:when test="contains($theName, ':')">
			  <xsl:value-of select="$theName"/>
		  </xsl:when>
		  
		  <!-- An unprefixed name when there is no namespace does not take one on -->
		  <xsl:when test="ancestor::namespace/@uri=''">
			  <xsl:value-of select="$theName"/>
		  </xsl:when>
		  <!-- Otherwise we add the prefix -->
		  <xsl:otherwise>
			  <xsl:value-of select="ancestor::namespace/@prefix"/>:<xsl:value-of select="$theName"/>
		  </xsl:otherwise>
	  </xsl:choose>
</xsl:template>	

<!-- loop over to get the full context -->
<xsl:template match="xs:element" mode="context">
	<xsl:if test="ancestor::xs:element">
		<xsl:apply-templates select="ancestor::xs:element[1]" mode="context"/>
	</xsl:if>
	<xsl:call-template name="make-prefixed-name">
		<xsl:with-param name="theName" select="@name"/>
	</xsl:call-template>
	<xsl:text>/</xsl:text>
</xsl:template>	
	
<!-- generate context for rule for element -->
<xsl:template name="generate-element-context">
	<xsl:choose>
		<xsl:when test="ancestor::xs:element">
		    <!-- local declarations -->
			<xsl:attribute name="context">
				<xsl:apply-templates select="ancestor::xs:element[1]" mode="context"/>
				<xsl:call-template name="make-prefixed-name">
					<xsl:with-param name="theName" select="@name"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<!-- global declaration -->
			<xsl:attribute name="context">
				<xsl:call-template name="make-prefixed-name">
					<xsl:with-param name="theName" select="@name"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<!-- generate context for rule for attribute -->
<xsl:template name="generate-attribute-context">
	<xsl:choose>
		<xsl:when test="ancestor::xs:element">
			<xsl:attribute name="context">
				<xsl:apply-templates select="ancestor::xs:element[1]" mode="context"/>
				<xsl:text>@</xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<!-- global declaration -->
			<xsl:attribute name="context">
				<xsl:text>@</xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:attribute>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
			
<!-- generate context for rule for attribute -->
<xsl:template name="generate-attribute-context-ref">
	<xsl:choose>
		<xsl:when test="ancestor::xs:element">
			<xsl:attribute name="context">
				<xsl:apply-templates select="ancestor::xs:element[1]" mode="context"/>
				<xsl:text>@</xsl:text>
				<xsl:value-of select="@ref"/>
			</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<!-- global declaration -->
			<xsl:attribute name="context">
				<xsl:text>@</xsl:text>
				<xsl:value-of select="@ref"/>
			</xsl:attribute>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<xsl:template name="generate-standard-datatypes">
	<xsl:param name="prefix" />
	
	<!-- XSD simple type library. Version 0.1 stubs only -->
	<!-- To use this library, place it at the beginning 
	  of a pattern, then use the extends element in the
	  subsequent rules for the pattern. -->

	<xsl:comment>
		 ============================================== 
	</xsl:comment>
	<xsl:comment>
		 W3C XML SCHEMAS SIMPLE TYPES - PRIMITIVE TYPES 
		 One abstract rule per type.                   
	</xsl:comment>
	<xsl:comment>
		 ============================================== 
	</xsl:comment> 
	
	<xsl:for-each select="$standard-datatypes/datatype">
		<xsl:variable name="dataType" select="."/>
		<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-', $dataType)}">
			<sch:let name="norm" value="normalize-space(.)"/>
			<!-- Facet: check if it is a float type -->
			<xsl:choose>
				<xsl:when test=" $dataType = 'string' ">
					<!--  strings don't need checking -->	
					<sch:assert test="true()"
						diagnostics="{concat($dataType, '-diagnostic')}">
						<xsl:text>"</xsl:text><sch:name/><xsl:text>" elements or attributes should have value of type "</xsl:text>
						<xsl:value-of select="$dataType"/><xsl:text>".</xsl:text>
					</sch:assert>
				</xsl:when>
				<xsl:when test=" $dataType = 'anyType' ">
				  <!-- Reported by PH -->
				  <!-- don't generate anything in this case -->
				</xsl:when>
				<xsl:otherwise>	  
					<sch:assert test="{concat('$norm castable as xs:', $dataType)}"
						diagnostics="{concat($dataType, '-diagnostic')}">
						<xsl:text>"</xsl:text><sch:name/><xsl:text>"  elements or attributes should have a value of type"</xsl:text>
						<xsl:value-of select="$dataType"/><xsl:text>".</xsl:text>
					</sch:assert>
				</xsl:otherwise>
			</xsl:choose>
		</sch:rule>
	</xsl:for-each>
	
	<!-- well, even we open the switch for saxon to check all builtin types, there are still two
	datatypes that saxon not covered (AFAIK), which are IDREFS and NMTOKENS, we define them below -->
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-IDREFS')}" > 
		<sch:assert test="true()">
			<xsl:text>"</xsl:text><sch:name/><xsl:text>"  elements or attributes should have a value of type </xsl:text>
			<xsl:text>"IDREFS".</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NMTOKENS')}" > 
		<sch:assert test="true()">
			<xsl:text>"</xsl:text><sch:name/><xsl:text>"  elements or attributes should have value of type </xsl:text>
			<xsl:text>"NMTOKENS".</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<!-- comment out because Rick has found a switch that can enable Saxon check all buildin types by castable  -->
	<!-- this template is now in a separate file, datatypes.xsl 
	<xsl:call-template name="generate-extended-datatypes">
		<xsl:with-param name="prefix" select="$prefix"/>
	</xsl:call-template>
	-->
	
	<xsl:comment>
		 ============================================== 
		 W3C XML SCHEMAS SIMPLE TYPES - END             
		 ==============================================   
	</xsl:comment>
</xsl:template>


<xsl:template name="generate-elements-typo-checking-rule">
<!--
	Old code: we were trying to put all elements context in one rule,
	buy it will break because the rule will be fired for each element,
	and the context is quit long, that make the SVRL output out of memory,
	that is why we are now breaking them into one rule for each element.
	<xsl:variable name="all-element-names-context">
		<xsl:for-each select="//xs:element[@name]">
			<xsl:value-of select="@name"/>
			<xsl:if test="position() != last()">
				<xsl:text> | </xsl:text>http://www.oreillynet.com/xml/blog/2007/11/converting_schematron_to_xml_s.html
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<sch:rule context="{$all-element-names-context}">
		<sch:assert test="true()">This assertion should never happen!</sch:assert>
	</sch:rule>
-->
	<!--  Go through each element name that is declared -->
	
	<xsl:comment>
	 ================================
	PASS OK ELEMENT NAMES
	================================ </xsl:comment>
	
	
		<sch:rule id="DefinedElement" abstract="true">
			<sch:assert test="true()">The element name "<sch:name/>" is defined.</sch:assert>
		</sch:rule>
	
	<xsl:for-each select="//xs:element[@name]">
		<xsl:sort select="@name"/>
		<xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="@name"/>
		   </xsl:call-template>
		</xsl:variable>   
		<sch:rule context="{$qname}'">
			<sch:extends rule="DefinedElement" />
		</sch:rule>
	</xsl:for-each>
	 
	 
	<!--  Go through each element name that is declared, and see if it is in the document 
	    with the wrong namespace-->
	
	
	<xsl:comment>
	 ================================ 
	FIND ELEMENT NAMES THAT ARE CLOSE 
	 ================================ 
	</xsl:comment>
	   
	<xsl:for-each select="//xs:element[@name]">
		<xsl:sort select="@name"/>
		<xsl:variable name="theLocalName" select="replace( @name, '^(.*):(.*)', '$2' )" /> 
		<xsl:if test="string-length( $theLocalName ) > 0">
			<sch:rule context="{concat('*[upper-case(local-name())=upper-case(&quot;', $theLocalName, '&quot;)]')}">
				<sch:report test="true()" role="Note">The unexpected element "<sch:name/>" has been used, which is close to an
				element in the schema: the element "<xsl:value-of select="@name"/>"<xsl:if test="contains(@name, ':')">
				in the {<xsl:value-of select="ancestor::xs:schema/@targetNamespace"/>} namespace</xsl:if>. 
				</sch:report> 
			</sch:rule>
		</xsl:if>
	</xsl:for-each>
	 
	
	<xsl:comment> 
	================================ 
	REPORT UNKNOWN ELEMENT NAMES
	 ================================ 
	 </xsl:comment>
	<sch:rule context="*">
		<sch:report test="true()" diagnostics="typo-element">Only elements declared in the schema may be used.</sch:report>
	</sch:rule>
</xsl:template>

<xsl:template name="generate-elements-expected-checking-rule">
 
	
	<xsl:comment>
	
	 ================================
	 CHECK CHILD ELEMENTS 
	 ================================ 
	 </xsl:comment>
	<xsl:for-each select="//xs:element[ancestor::xs:element[1][@name | @ref]]">
		<xsl:sort select="@name or @ref"/>
		<xsl:variable name="parentelement">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="ancestor::xs:element[1]/@name"  />
		   </xsl:call-template>
		</xsl:variable>      
		<xsl:variable name="elementname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name">
				<xsl:choose>
					<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
					<xsl:when test="@ref"><xsl:value-of select="@ref"/></xsl:when>
				</xsl:choose>
			  </xsl:with-param>
	 		</xsl:call-template>
		</xsl:variable>
		<sch:rule context="{$parentelement}/{$elementname}">
			<!-- This assertion should never fail! -->
			<sch:assert test="true()">The "<xsl:value-of select="$elementname"/>" element is allowed to appear under element "<xsl:value-of select="$parentelement"/>".</sch:assert>
		</sch:rule>
	</xsl:for-each>
		
	<xsl:comment>
	 ================================ 
	CHECK GLOBAL ELEMENTS (ROOT)
	 ================================
	 Because we already check all the elements that can appear in particular context, 
	 global element declarations can be used for elements that can appear as the
	 root (or in wildcarded uses).
	  </xsl:comment>
	  
		<sch:rule id="GlobalElement" abstract="true">
			<sch:assert test="true()">The "<sch:name/>" element is allowed as the root element.</sch:assert><!-- This assertion should never happen! -->
		</sch:rule>
	<xsl:for-each select="//xs:schema/xs:element[@name]">
		<xsl:sort select="@name"/>
		<xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="@name"/>
		   </xsl:call-template>
		</xsl:variable>  
		<sch:rule context="/{$qname}">
			<sch:extends rule="GlobalElement" />
		</sch:rule>
	</xsl:for-each>  
	<xsl:comment> 
	================================ 
	 REPORT ELEMENTS IN UNEXPECTED POSITIONS
	 ================================ 
	</xsl:comment>
	<sch:rule context="*">
		<sch:report test="true()" diagnostics="expected-element">Elements are only allowed in the document in particular parent elements.</sch:report>
	</sch:rule>
</xsl:template>

<xsl:template name="generate-elements-required-checking-rule">
    
	<xsl:comment>
	 ================================ 
	CHECK REQUIRED ELEMENTS 
	 ================================ 
	 </xsl:comment>
	 <!--  For each element which has a name attribute and has child elements,
	      except for elements that have a choice at their top level -->
	<xsl:for-each select="//xs:element[@name][.//xs:element]
		[not(xs:choice)][not(xs:complexType/xs:choice)][not(xs:complexType/xs:complexContent/xs:choice)]">
		<xsl:variable name="parent-element-name" select="@name"/>
		<!-- we are not gonna output sch:rule for this element if it doesn't have any elements underneath that match the conditions -->
		<xsl:if test=".//xs:element[@minOccurs='unbounded' or not(@minOccurs = '0')][ancestor::xs:element[1]/@name = $parent-element-name]">
		  <xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="@name"/>
		   </xsl:call-template>
		</xsl:variable>  
			<sch:rule context="{$qname}">	
				<xsl:for-each select=".//xs:element[@minOccurs='unbounded' or not(@minOccurs = '0')][ancestor::xs:element[1]/@name = $parent-element-name]">
					<!-- check if it is under xs:choice, or under others that have minOccurs = 0, such as(xs:all,xs:sequence) -->
					<xsl:variable name="nodeset-between-two-element" select="ancestor::* except ancestor::xs:element[1]/ancestor-or-self::*"/>
					<xsl:variable name="element-name" select="if (@name) then @name else @ref"/>
				  	<xsl:variable name="child-qname">
		   				<xsl:call-template name="qualify-element-name">
		      				<xsl:with-param name="name" select="$element-name"/>
		   				</xsl:call-template>
					</xsl:variable>  
					<!-- variable to store whether is required or not -->
					<xsl:variable name="required">
						<xsl:choose>
							<xsl:when test="$nodeset-between-two-element/self::xs:choice">false</xsl:when>
							<xsl:when test="$nodeset-between-two-element/self::*[not(@minOccurs='unbounded') and @minOccurs='0']">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$parent-element-name = 'admin'">  <!--  WTF ???? I presume this is some hack for JSTOR -->
						<xsl:comment><xsl:value-of select="$nodeset-between-two-element/name()"/>==<xsl:value-of select="$required"/></xsl:comment>
					</xsl:if>
					<xsl:if test="$required = 'true'">
						<sch:assert test="{$child-qname}">Element "<xsl:value-of select="$element-name"/>" is required under element "<sch:name/>" </sch:assert>
					</xsl:if>
				</xsl:for-each>
			</sch:rule>
		</xsl:if>
	</xsl:for-each>
</xsl:template>
	
<xsl:template name="generate-attributes-typo-checking-rule">
	<xsl:variable name="attributes-list">
		<root>
			<xsl:for-each select="//xs:attribute[@name]">
				<xsl:sort select="@name"/>
				<att><xsl:value-of select="@name"/></att>
			</xsl:for-each>
		</root>
	</xsl:variable>
	
	<xsl:comment>
	 ================================ 
	 PASS OK ATTRIBUTE NAMES  
	 ================================
	  </xsl:comment>
	<xsl:for-each select="$attributes-list/root/att">
		<xsl:if test="position() = 1 or . != preceding-sibling::att[1]">
			<sch:rule context="*/@{.}">
				<sch:assert test="true()">The attribute "<sch:name/>" is allowed.</sch:assert><!-- This assertion should never happen! -->
			</sch:rule>
		</xsl:if>
	</xsl:for-each> 
	
	<xsl:comment>
	 ================================ 
	 REPORT UNKNOWN ATTRIBUTE NAMES 
	 ================================ 
	 </xsl:comment>
	<sch:rule context="*/@*">
		<sch:report test="true()" diagnostics="typo-attribute">Typo: Only attributes declared in the schema may be used.</sch:report>
	</sch:rule>
</xsl:template>

<xsl:template name="generate-attributes-expected-checking-rule">

	<xsl:comment> 
	================================ 
	CHECK POSSIBLE ATTRIBUTES 
	 ================================ 
	 </xsl:comment>
	<xsl:for-each select="//xs:attribute[@name][ancestor::xs:element]">
		<xsl:sort select="@name"/>
		<xsl:variable name="parentelement" select="ancestor::xs:element[1]/@name"/>
		
		<xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="$parentelement"/>
		   </xsl:call-template>
		</xsl:variable> 
		<sch:rule context="{$qname}/@{@name}">
			<sch:assert test="true()">The attribute <xsl:value-of select="@name" /> is allowed on element: <xsl:value-of select="$parentelement"/>. </sch:assert><!-- This assertion should never happen! -->
		</sch:rule>
	</xsl:for-each>
	<xsl:for-each select="//xs:attribute[@ref][ancestor::xs:element]">
		<xsl:sort select="@ref"/>
		<xsl:variable name="parentelement" select="ancestor::xs:element[1]/@name"/>
		<xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="$parentelement"/>
		   </xsl:call-template>
		</xsl:variable>
		<sch:rule context="{$qname}/@{@ref}">
			<sch:assert test="true()">The attribute "<xsl:value-of select="@name" />" is allowed under element "<xsl:value-of select="$parentelement"/>". </sch:assert><!-- This assertion should never happen! -->
		</sch:rule>
	</xsl:for-each>
	<sch:rule context="*/@*">
		<sch:report test="true()" diagnostics="expected-attribute">Only attributes declared in the schema may be used.</sch:report>
	</sch:rule>
</xsl:template>

<xsl:template name="generate-attributes-required-checking-rule">
	<!-- element that have @name, and has direct xs:attribute children that has @name and @use = 'required' -->
	 
	<xsl:comment>
	 ================================ 
	 CHECK REQUIRED ATTRIBUTES 
	 ================================
	 </xsl:comment>
	<xsl:for-each select="//xs:element[@name]">
		<xsl:sort select="@name"/>
		<xsl:variable name="element-name" select="@name"/>
		<xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="@name"/>
		   </xsl:call-template>
		</xsl:variable> 
		<xsl:if test=".//xs:attribute[@use='required'][ancestor::xs:element[1]/@name = $element-name]">
			<sch:rule context="{$qname}">	
				<xsl:for-each select=".//xs:attribute[@name][@use='required'][ancestor::xs:element[1]/@name = $element-name]">
					<sch:assert test="@{@name}">The attribute "<xsl:value-of select="@name"/>" is required for element "<sch:name/>". </sch:assert>
				</xsl:for-each>
				<xsl:for-each select=".//xs:attribute[@ref][@use='required'][ancestor::xs:element[1]/@name = $element-name]">
					<sch:assert test="@{@ref}">The attribute "<xsl:value-of select="@ref"/>" is required for element "<sch:name/>". </sch:assert>
				</xsl:for-each>
			</sch:rule>
		</xsl:if>
	</xsl:for-each>
	<!-- not working because same element, the first rule will be fired and the following rules will not be processed 
	<xsl:for-each select="//xs:attribute[@name][@use = 'required'][ancestor::xs:element]">
		<xsl:sort select="@name"/>
		<xsl:variable name="parentelement" select="ancestor::xs:element[1]/@name"/>
	    <xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="$parentelement"/>
		   </xsl:call-template>
		</xsl:variable> 
		<sch:rule context="{$qname}">
			<sch:assert test="@{@name}">The attribute: <xsl:value-of select="@name"/> is required for element: <sch:name/> . </sch:assert>
		</sch:rule>
	</xsl:for-each>
	<xsl:for-each select="//xs:attribute[@ref][@use = 'required'][ancestor::xs:element]">
		<xsl:sort select="@ref"/>
		<xsl:variable name="parentelement" select="ancestor::xs:element[1]/@name"/>
		
	    <xsl:variable name="qname">
		   <xsl:call-template name="qualify-element-name">
		      <xsl:with-param name="name" select="$parentelement"/>
		   </xsl:call-template>
		</xsl:variable> 
		<sch:rule context="{$qname}">
			<sch:assert test="@{@ref}">The attribute: <xsl:value-of select="@ref"/> is required for element: <sch:name/> . </sch:assert>
		</sch:rule>
	</xsl:for-each>
	-->
	
</xsl:template> 
	
	<!--  RJ -->
	<xsl:template name="generate-following-elements-checking-rule">
    
	<xsl:comment>
	 ======================================== 
	CHECK FOLLOWING ELEMENTS - PARTIAL ORDER
	 ======================================== 
	 Partial ordering: Element B comes after element A if
	   1) They have same parent element (same content model)  AND EITHER
	   
	   2) B is in a repeating branch which has A under it OR
	         	loosely ancestor-or-self::*[@maxOccurs > 1]//element
	   3) B is under a  following particle of a sequence which has A under it.
	          loosely ancestor::sequence/following-sibling::*//element
	   Note that 2) and 3) are not mutually exclusive.  (This may fall over
	   when the same element appears on multiple paths?)  
	   
	   This does not check requirement constraints.		
	   		
	 </xsl:comment>
	 
	 
	<!--  For every use of an element in any content model --> 
	<xsl:for-each select="//xs:schema/xs:element//xs:element[not(parent::xs:all)]">
		<!-- Sort them so that local declarations come before globals, and so that deep path
		declarations come before shallow ones -->
		<xsl:sort select="count(ancestor::xs:element)" order="descending" />
		<!--  Store the name of the parent element -->
		<xsl:variable name="parent-element-name" select="ancestor::xs:element[1]/@name"/>
		<xsl:variable name="parent-element" select="ancestor::xs:element[1]"/>
		<!--  Store the context path -->
		<xsl:variable name="path-to-parent">
			<xsl:for-each select="ancestor::xs:element">
		       <xsl:call-template name="qualify-element-name">
		          <xsl:with-param name="name" select="@name"/>
		        </xsl:call-template>/</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
		
		<!--  Handle special cases -->
		<xsl:when test="parent::xs:choice
					[@maxOccurs='unbounded' or @maxOccurs > 1 ]
					[parent::xs:complexType
						[count(xs:choice)=1]
						[count(xs:sequence)=0]
					or parent::xs:element
						[count(xs:choice)=1]
						[count(xs:sequence)=0]]
					[count(child::xs:choice)=0]
					[count(child::xs:sequence)=0]">
					<!--  If the parent is a repeating choice element and its parents only have that choice,
					and that choice element only has element particles for children
					then we can treat it as a special case: it has no extra positional constraints than the 
					presence constraints don't catch. -->
					
					<!--  only generate the rule when we come to the first subelement -->
					<xsl:if test="not(preceding-sibling::xs:element)">
					<xsl:comment> No sequence constraints for element <xsl:value-of select="$parent-element-name"/>.</xsl:comment>
			 		</xsl:if>
		</xsl:when>
		
		
		<!--  Handle the normal case -->
		<xsl:otherwise>
		
		<xsl:variable name="repeating-cousins"
		    select="$parent-element//*[@maxOccurs='unbounded' or @maxOccurs > 1][.//*=current() or .=current()]/descendant-or-self::xs:element[ancestor::xs:element[1] is $parent-element]" />
		<xsl:variable name="subsequent-cousins"
			select="ancestor-or-self::*[parent::xs:sequence][ancestor::xs:element[1] is $parent-element]/following-sibling::xs:element "/>
		<xsl:variable name="subsequent-nephews"
			select="ancestor-or-self::*[parent::xs:sequence][ancestor::xs:element[1] is $parent-element]/following-sibling::*//xs:element "/>
			
			
		<xsl:variable name="followers"
			select="$repeating-cousins | $subsequent-cousins | $subsequent-nephews" />
			<!-- 
			<xsl:comment>DEBUG <xsl:value-of select="@name" />   <xsl:value-of select="@ref" />  
			parent: <xsl:value-of select="$parent-element-name" />  
			path: <xsl:value-of select="$path-to-parent" />  
			 <xsl:value-of select="count( $repeating-cousins )"/>: <xsl:value-of select="count($subsequent-cousins)"/> 
			 : <xsl:value-of select="count($subsequent-nephews)"/> 
			</xsl:comment>
			-->   
		    <!--  Make a rule using the current context path -->
		    <xsl:variable name="qname">
		       <xsl:call-template name="qualify-element-name">
		          <xsl:with-param name="name" select="@name | @ref"/>
		        </xsl:call-template>
		    </xsl:variable>
		  	<sch:rule context="{concat($path-to-parent, $qname)}">	
		  	<!--  select  all the elements that are under any choice or sequence group which allows 
		  	repetition and has the current element under it-->
		  	
		<xsl:if test=" $followers " > 
		  	    <sch:assert>
		  	    	<xsl:attribute name="test">
		  	    	<xsl:text>not (following-sibling::*)  or (</xsl:text>
				<xsl:for-each select=" $followers ">
				    <xsl:choose>
				        <!-- hack: local-name() used but it should be qname -->
				    	<xsl:when test="@name">	
	    					<xsl:variable name="child-qname">
		   						<xsl:call-template name="qualify-element-name">
		      						<xsl:with-param name="name" select="@name"/>
		   						</xsl:call-template>
							</xsl:variable>following-sibling::*[1][name() ='<xsl:value-of select="$child-qname  " />']</xsl:when>
				    	<xsl:when test="@ref">
	    					<xsl:variable name="child-qname">
		   						<xsl:call-template name="qualify-element-name">
		      						<xsl:with-param name="name" select="@ref"/>
		   						</xsl:call-template>
							</xsl:variable>following-sibling::*[1][name() ='<xsl:value-of select="$child-qname  " />']</xsl:when>
				    	
				    </xsl:choose>	
					<xsl:if test="position()!=last()"> or </xsl:if>
				</xsl:for-each>	
					<xsl:text>)</xsl:text>
				     </xsl:attribute>
					When in a  "<xsl:value-of select=" $parent-element-name" />" element, the element "<xsl:value-of select="concat(@ref, @name)" />" can only be followed 
					<xsl:if test="count( $followers ) != 1">(perhaps with other elements intervening)</xsl:if>
					by the following elements:
						<xsl:for-each select=" $followers">
						<xsl:value-of select="@name | @ref" />
					<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
			</sch:assert>
		</xsl:if>
		<xsl:if test=" not( $followers ) ">
			<sch:assert test="not(following-sibling::*)">
			When in a "<xsl:value-of select=" $parent-element-name" />" element, the element "<xsl:value-of select="concat(@ref, @name)"/>" should not be
			followed by any other element.
			</sch:assert>
		</xsl:if>
		</sch:rule>
	  </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
</xsl:template>
	
	

	<xsl:template name="generate-immediate-following-elements-checking-rule">
		<xsl:comment>
	 ======================================================== 
	CHECK FOLLOWING ELEMENTS - REQUIRED IMMEDIATELY FOLLOWING
	 ======================================================== 
	    </xsl:comment>
	
		<!--  TODO: All these 'od' sections for maxOccurs and minOccurs
		 need to be rewritten because XPath 2 is not guaranteed to shortcut.
		 See M Kay Xpath 2 book page 198 para at bottom of page.  -->
		<!--  for every element that is required and has a required successor,
			and is part of a sequence -->
    	<xsl:for-each select="//xs:element 
		    	[not(@maxOccurs='unbounded') and not(@maxOccurs &gt; 1) and not(@maxOccurs=0)]
		    	[@minOccurs='unbounded' or not(@minOccurs=0)]
    			[parent::xs:sequence]	
    			[following-sibling::*
    				[self::xs:element
    					[@maxOccurs='unbounded' or not(@maxOccurs=0)][@minOccurs='unbounded' or not(@minOccurs=0)]]]">
    			 	<!--  Store the name of the parent element -->
		<xsl:variable name="parent-element-name" select="ancestor::xs:element[1]/@name"/>
		<xsl:variable name="parent-element" select="ancestor::xs:element[1]"/>
		<!--  Store the context path -->
		
		<xsl:variable name="path-to-parent">
			<xsl:for-each select="ancestor::xs:element">
		       <xsl:call-template name="qualify-element-name">
		          <xsl:with-param name="name" select="@name"/>
		        </xsl:call-template>/</xsl:for-each>
		</xsl:variable>
    	<xsl:variable name="qname">
		       <xsl:call-template name="qualify-element-name">
		          <xsl:with-param name="name" select="@name | @ref"/>
		        </xsl:call-template>
		    </xsl:variable>	
		  	<sch:rule context="{concat($path-to-parent, $qname)}">	
		  	    <xsl:variable name="qname">
		  	       <xsl:call-template name="qualify-element-name">
		  	          <xsl:with-param name="name" select="concat(following-sibling::*[1]/@name, following-sibling::*[1]/@ref)" />
		  	       </xsl:call-template>
		  	    </xsl:variable>
		  		<sch:assert diagnostics="unexpected-immediate-follower">
		  			<xsl:attribute name="test">following-sibling::*[1][self::<xsl:value-of
		  			select="$qname"/>]</xsl:attribute>
		  			When in a "<xsl:value-of select=" $parent-element-name" />" element, the element "<xsl:value-of select="concat(@ref, @name)"/>" should be immediately followed by 
		  			the element "<xsl:value-of select="$qname"/>".
		  		</sch:assert>
		  	</sch:rule>
    					
    	</xsl:for-each>
    				
    </xsl:template>	
	
	<!--  RJ -->
	
<xsl:template name="generate-idref-checking-rule">
 
	<xsl:comment>
	 ================================ 
	 CHECK IDS 
	 ================================ 
	 </xsl:comment>
	<xsl:variable name="idref-list">
		<root>
			<xsl:for-each select="//xs:attribute[@name][@type='xs:IDREF']">
				<xsl:sort select="@name"/>
				<idref><xsl:value-of select="@name"/></idref>
			</xsl:for-each>
		</root>
	</xsl:variable>
	<xsl:variable name="id-list">
		<root>
			<xsl:for-each select="//xs:attribute[@name][@type='xs:ID']">
				<xsl:sort select="@name"/>
				<id><xsl:value-of select="@name"/></id>
			</xsl:for-each>
		</root>
	</xsl:variable>
	<xsl:variable name="id-distinct-list">
		<root>
			<xsl:for-each select="$id-list/root/id">
				<xsl:if test="position() = 1 or . != preceding-sibling::id[1]">
					<id><xsl:value-of select="."/></id> 
				</xsl:if>
			</xsl:for-each>
		</root>
	</xsl:variable>
	
	<xsl:for-each select="$idref-list/root/idref">
		<xsl:if test="position() = 1 or . != preceding-sibling::idref[1]">
			<sch:rule context="*/@{.}">
				<sch:assert>
					<xsl:attribute name="test">
						<xsl:for-each select="$id-distinct-list/root/id">
							<xsl:text>//@</xsl:text>
							<xsl:value-of select="."/>
							<xsl:text> = . </xsl:text>
							<xsl:if test="position() != last()"> or </xsl:if>
						</xsl:for-each>
					</xsl:attribute>
					An element with an ID matching the IDREF supplied by "<sch:name/>" has not been found. IDREF: <sch:value-of select="."/>.
				</sch:assert>
			</sch:rule>
		</xsl:if>
	</xsl:for-each>
</xsl:template> 

 <!-- Utility function -->
 <!-- Takes a name and if it has no prefix then adds the appropriate one --> 
 
 <xsl:template name="qualify-element-name">
    <xsl:param name="name"/>
    <xsl:choose>
        <!-- already prefixed: just keep it -->
		<xsl:when test="contains($name, ':')">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<!-- no namespace therefore no prefix -->
		<xsl:when test="ancestor::namespace/@uri=''  
		     or not(ancestor::namespace) or not(ancestor::namespace/@uri)">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<!-- Explicit qualification -->
		<xsl:when test="@form='qualified'">
			<xsl:value-of select="concat(ancestor::namespace/@prefix, ':', $name)"/>
		</xsl:when>
		
		<xsl:when test="ancestor::schema/@elementFormDefault='qualified'">
			<xsl:value-of select="concat(ancestor::namespace/@prefix, ':', $name)"/>
		</xsl:when>
		
		<!-- Explicit unqualification -->
		<xsl:when test="@form='unqualified'">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<xsl:when test="ancestor::schema/@elementFormDefault='unqualified'">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<!-- DEFAULT -->
		<xsl:otherwise>
			<xsl:value-of select="concat(ancestor::namespace/@prefix, ':', $name)"/>
		</xsl:otherwise>
	</xsl:choose>   
 </xsl:template>
  
  
<!-- This template takes a type name and returns the prefixed form, if available.
This is to cope with, in particular, the case where the XSD namespace is the default
namespaces, and therefore base types are written without prefixes.
Thanks to David Carlisle for a code hint. -->  
<xsl:template name="qualify-type-name">
    <xsl:param name="name"/>
      
    <xsl:choose>
        <!-- already prefixed: just keep it -->
		<xsl:when test="contains($name, ':')">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<!-- no prefix and no default namespace --> 
		<xsl:when test="namespace-uri-for-prefix('',.) = ''">
			<xsl:value-of select="$name"/>
		</xsl:when>
		
		<!-- no prefix therefore use default namespace-->
		<!-- default namespace isxs: -->
		<xsl:when test="namespace-uri-for-prefix('',.)='http://www.w3.org/2001/XMLSchema'">
			<xsl:value-of select="concat('xs:', $name)"/>
		</xsl:when>
		
		<!-- default namespace is used and it is not the xsd -->
		<!-- TODO: do something clever here, like track down the appropriate prefix -->
		<xsl:otherwise>
			<xsl:value-of select="$name"/>
		</xsl:otherwise>		     
	</xsl:choose>	
	
</xsl:template>


<!-- generate disgnostics for standard datatypes check -->
<xsl:template name="generate-standard-datatypes-diagnostics">

	<xsl:comment> 
	================================ 
	DIAGNOSTICS FOR STANDARD DATATYPES 
	 ================================ 
	 </xsl:comment>
	<xsl:for-each select="$standard-datatypes/datatype">
		<xsl:variable name="dataType" select="."/>
		<sch:diagnostic id="{concat($dataType, '-diagnostic')}">Subsequent Siblings
			<xsl:text> "</xsl:text><sch:value-of select="."/>
			<xsl:text>" is not a value allowed for xs:</xsl:text>
			<xsl:value-of select="$dataType"/><xsl:text> datatypes.</xsl:text>
		</sch:diagnostic>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
