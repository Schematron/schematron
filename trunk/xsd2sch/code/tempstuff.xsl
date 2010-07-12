<!-- Probably this is dead code -->
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
<xsl:template name="generate-standard-datatypes">
	<xsl:param name="prefix" />
	<!-- TODO make use of prefix -->
	
	<!-- XSD simple type library. Version 0.1 stubs only -->
	<!-- To use this library, place it at the beginning 
	  of a pattern, then use the extends element in the
	  subsequent rules for the pattern. -->

	<!-- ============================================== -->
	<!-- W3C XML SCHEMAS SIMPLE TYPES - PRIMITIVE TYPES -->
	<!-- One abstract rule per type.                    -->
	<!-- ============================================== -->  
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-anySimpleType')}" >
		<!-- should never occur -->
		<sch:assert test="true()">Every value is a valid anySimpleType.</sch:assert>
	</sch:rule>  
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-string')}" >
		<sch:assert test="true()">Every value is a valid string.</sch:assert>
	</sch:rule>  
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-boolean')}" >
		<sch:let  name="norm" value="space-normalize(.)"/>
		<sch:assert test="$norm = '0' or $norm = '1' or $norm = 'true' or $norm = 'false'"
		>A boolan type should only have values of 0, 1, true or false.</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-float')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<!-- Facet: check if it is a float type -->
		<sch:assert test="$norm castable as xs:float" diagnostics="float-diagnostic">
			<xsl:text>An element or attribute of this type should have a float type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-decimal')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-double')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-duration')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-dateTime')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-time')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-date')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-gYearMonth')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-gYear')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-gMonthDay')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-gMonth')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-gDay')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-hexBinary')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-base64Binary')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-anyURI')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-QName')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NOTATION')}" >
		<sch:let name="norm" value="space-normalize(.)"/>
		<sch:assert test="string-length( $norm ) &gt; 0"
			>An element or attribute of this type should have a value.</sch:assert>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	
	<!-- ============================================== -->
	<!-- W3C XML SCHEMAS SIMPLE TYPES - DERIVED TYPES   -->
	<!-- One abstract rule per type, extends primites   -->
	<!-- ============================================== -->  
	
	<!-- IMPLEMENTERS: the trick is that when you are using
	   <extends> you only want assertions for the 
	   differences from the abstract pattern being extended.
	   So the difference between a byte and short is that
	   there is a value between 2^8 and 2^16, not that 
	   there is a negative value or a value over 2^16. -->
	<!-- ============ -->
	<!-- STRING TYPES -->
	<!-- ============ -->
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-normalizedString')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-string')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-token')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-normalizedString')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-language')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-token')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-id')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-token')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NCName')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-id')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NMTOKEN')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule> 
	   
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ID')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-IDREF')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ENTITY')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	
	<!-- ============ -->
	<!-- NUMBER TYPES -->
	<!-- ============ -->
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-integer')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-decimal')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-nonPositiveInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-negativeInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-nonPositiveInteger')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
		
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-positiveInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-nonNegativeInteger')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
		
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-nonNegativeInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedInteger')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedLong')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedInteger')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedInt')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedLong')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedShort')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedLong')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedByte')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedShort')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-long')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-int')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-long')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-short')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-int')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-byte')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-short')}"/>
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<!-- ============================================== -->
	<!-- W3C XML SCHEMAS SIMPLE TYPES - LIST TYPES      -->
	<!-- One abstract rule per type.                    -->
	<!-- ============================================== --> 
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-IDREFS')}" > 
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	 
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ENTITIES')}" > 
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule> 
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NMTOKENS')}" > 
	
		<!-- Facet: -->
		<sch:assert test="true()">TODO</sch:assert>
	</sch:rule>
	
	<!-- ============================================== -->
	<!-- W3C XML SCHEMAS SIMPLE TYPES - END             -->
	<!-- ============================================== -->  
</xsl:template>	


<!-- temp stuff -->
	<!--
<xsl:template name="standard-datatypes-diagnostics">
	<sch:diagnostic id="float-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:float datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="decimal-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:decimal datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="double-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:double datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="duration-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:duration datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="dateTime-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:dateTime datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="time-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:time datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="date-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:date datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="gYearMonth-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:gYearMonth datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="gYear-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:gYear datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="gMonthDay-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:gMonthDay datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="gMonth-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:gMonth datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="gDay-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:gDay datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="hexBinary-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:hexBinary datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="base64Binary-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:base64Binary datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="anyURI-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:anyURI datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="Qid-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:Qid datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="NOTATION-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:NOTATION datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="normalizedString-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:normalizedString datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="token-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:token datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="language-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:language datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="id-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:id datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="NCName-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:NCName datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="NMTOKEN-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:NMTOKEN datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="ID-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:ID datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="IDREF-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:IDREF datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="ENTITY-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:ENTITY datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="integer-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:integer datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="nonPositiveInteger-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:nonPositiveInteger datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="negativeInteger-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:negativeInteger datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="unsignedInteger-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:unsignedInteger datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="positiveInteger-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:positiveInteger datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="nonNegativeInteger-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:nonNegativeInteger datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="unsignedLong-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:unsignedLong datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="unsignedInt-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:unsignedInt datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="unsignedShort-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:unsignedShort datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="unsignedByte-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:unsignedByte datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="long-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:long datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="int-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:int datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="short-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:short datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="byte-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:byte datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="IDREFS-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:IDREFS datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="ENTITIES-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:ENTITIES datatypes.</xsl:text>
	</sch:diagnostic>
	<sch:diagnostic id="NMTOKENS-diagnostic">
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/>
		<xsl:text>" is not a value allowed for xs:NMTOKENS datatypes.</xsl:text>
	</sch:diagnostic>
</xsl:template>
	-->

