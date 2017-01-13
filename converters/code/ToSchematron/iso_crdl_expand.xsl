<?xml version="1.0" ?>
<!-- 
   NOTE: Early code, probably does not work 
-->

<!-- 
     OVERVIEW - iso_crdl_expand.xsl
     
	    This is a preprocessor for ISO Schematron, which expands ISO CREPDL 
	    (Character Repertoire Definition Language) properties into Schematron
	    assertions. The CRDL rules must be in property elements linked to
	    assertions.
		
		The implementation below is aimed at following XPath2, to fit with XSLT2 implementation.
		There is scope to add outputs for other regex dialects. 
	
-->
<!-- 
  VERSION INFORMATION
  2010-04-22 RJ   BETA
  		* Get going with complex Xpaths to match code point by codepoint
  		* Works on  CDRL embedded in properties element. 
  		
  2008-09-20 RJ
  		* Add XPath2 Regex code contributed by David Carlisle with thanks
  		
  2008-07-29 RJ 
  		* Beta  
-->	 
<!--
Open Source Initiative OSI - The MIT License:Licensing
[OSI Approved License]

The MIT License

	This code copyright 2010 Rick Jelliffe. 

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

<!--
The code follows the method of Appendix L of the 2010 Committee Draft of the 
updated ISO Schematron. 

The following schema:

============================================================
<sch:rule context="/*">
 <sch:assert test="true()" properties="iso8859-6alt">The document text should be ISO 8859-6</sch:assert>
</sch:rule>
...
<sch:property id="iso8859-6alt">
 <union xmlns="http://purl.oclc.org/dsdl/crepdl/ns/structure/1.0" xml:id="iso8859-6alt" >
  <char>\p{IsBasicLatin}</char>
  <char>&#xA0;</char>
  <char>&#xA4;</char>
  <char>&#xAD;</char>
  <char>&#x60C;</char>
  <char>&#x61B;</char>
  <char>&#x61F;</char>
  <char>[&#x621;-&#x63A;]</char>
  <char>[&#x640;-&#x652;]</char>
 </union>
</sch:property>
============================================================

will be transformed to this Schematron schema assertion

============================================================
<sch:rule context="/*">
 <iso:let 
   xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
   xmlns:crdl="http://purl.oclc.org/dsdl/crepdl/ns/structure/1.0" 
   name=" badCharactersString " 
   value="( string-join(                    
    distinct-values (                   
     for $i in string-to-codepoints( . )                      
      return for $c in codepoints-to-string( $i)                        
       return if ( matches($c,'\p{IsBasicLatin}')&#xA;         
        or  matches($c,' ')&#xA;         
        or  matches($c,'¤')&#xA;         
        or  matches($c,'­')&#xA;         
        or  matches($c,'،')&#xA;         
        or  matches($c,'؛')&#xA;         
        or  matches($c,'؟')&#xA;         
        or  matches($c,'[ء-غ]')&#xA;         
        or  matches($c,'[ـ-ْ]') ) 
       then &#34;&#34; 
     else $c ), &#34;&#34;) )"/>
   <iso:assert 
    xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
    xmlns:crdl="http://purl.oclc.org/dsdl/crepdl/ns/structure/1.0" 
    test="true() and not( string-length( $badCharactersString ))" 
    properties="iso8859-6alt"
    >The text is ISO 8859-6: not <iso:value-of select="$badCharactersString"/>
   </iso:assert> 
</sch:rule>
============================================================

This assertion works by
* converting the input string into a sequence of codepoints
* converting each single codepoint back into a string
* testing that string (character) against the referenced CRDL and producing Y or N
Which gives a sequence of Y or N strings as long as the input string. So
* reduce it to only a sequence of the distinct values
* convert it to a string
* test that string for any 'N'
The reason for all this convolution is that XSLT2 does not seem to have a way to apply an AND function to a sequence of booleans. Hence the convoluted approach. I hope there is a better method. 

-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
    xmlns:iso="http://purl.oclc.org/dsdl/schematron"   
    xmlns:crdl="http://purl.oclc.org/dsdl/crepdl/ns/structure/1.0"  
      > 
      
    <!-- First, enable or disable CRDL processing based on 
    whether this is XSLT2 and whether there are any elements.
    -->  
	
    <xsl:template match="/" >
       <xsl:choose>
          <xsl:when test="//iso:properties/iso:property/crdl:* and  
            ( //iso:schema[@queryBinding='xpath2' or 
                             @queryBinding='xslt2'])">
          <!-- ENABLE CRDL PROCESSING -->
          <xsl:message>ENABLE CRDL PROCESSING</xsl:message>
          
          <xsl:copy>
             	<xsl:apply-templates mode="add-crdl" />
          </xsl:copy> 
       </xsl:when>
       <xsl:otherwise>
           <xsl:if test=
           "not(//iso:schema[@queryBinding='xpath2' or 
                             @queryBinding='xslt2'])">
           <xsl:message>Query Language Error: CRDL requires xpath2 or xslt2. Assertions not generated.</xsl:message>
           </xsl:if>
 
          <!-- DISABLE CRDL PROCESSING -->
          
          <xsl:message>DISABLE CRDL PROCESSING</xsl:message>
          <xsl:copy-of select="/"  />
       </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
    
   <!-- =================================================================== -->
   <!-- Generate Regular Expression from CREPDL                             -->
   <!-- Process document. Strip any CRDL from properties. Add assertions    -->
   <!-- for them.                                                           -->
   <!-- =================================================================== -->
 

    <xsl:template mode="add-crdl"  priority="-1"
       match="*" >
       
       
          <xsl:message>COPY <xsl:value-of select=" name() "/></xsl:message>  
       <xsl:copy>
             	<xsl:copy-of select="@*" />
             	<xsl:apply-templates mode="add-crdl" />
          </xsl:copy> 
           
    </xsl:template>
    
    
    
    <!-- Special treatment for asserts which have a properties
    attribute, which contains a reference to a property that
    contains crdl elements.
    -->
	<xsl:template match="iso:assert[@properties]
	               [//iso:property[contains(
	                   concat( ' ', current()/@properties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   [crdl:*]]" 
	     mode="add-crdl" >
	
	    <xsl:variable name="theRegexes">
	       <!-- handle-crdl-regex returns a sequence of elements,
	       each being regexes to be used in an assertion. -->
	      
	          <xsl:call-template name="handle-crdl-regex" >
	         <xsl:with-param name="theProperties" select=" @properties "/>
	       </xsl:call-template> 
	         
	    </xsl:variable>
	    
	   
	       
	    <xsl:variable name="theOriginalTest"  >
	       <xsl:value-of select="@test"  />
	    </xsl:variable>
	        
	    <xsl:variable name="this" as=" element()" >
	       <xsl:copy-of select="." />  
	    </xsl:variable>
	     
	      
		<!-- first copy the current assertion -->
		<xsl:for-each select=" $theRegexes ">
		    <xsl:message>ASSERT  {{ <xsl:value-of select=" . " /> }}</xsl:message>
		    <iso:let name=" badCharactersString " >
		    <xsl:attribute name="value" 
	           select=" concat(   
	               '( string-join( 
	                 distinct-values (
	                 for $i in string-to-codepoints( . ) 
	                   return for $c in codepoints-to-string( $i)
	                      return if ',
	                      . , 
	                      ' then &quot;&quot; else $c ), &quot;&quot;) )' 
	                ) " />
	         </iso:let>          
	      <iso:assert>
	        <xsl:attribute name="test" 
	           select=" concat ( $theOriginalTest , ' and not( string-length( $badCharactersString ))')" />
	
	         
			<xsl:copy-of select="$this/@*[not(name() = 'test')]" />
	
			<xsl:apply-templates mode="add-crdl" select=" $this/node() "  /> 
			<xsl:text>: not </xsl:text>
			<iso:value-of select="$badCharactersString" /> 
		</iso:assert>
		</xsl:for-each> 
	</xsl:template >
	
	
    <!-- Special treatment for reports which have a properties
    attribute, which contains a reference to a property that
    contains crdl elements.
    -->
	<xsl:template match="iso:report[@properties]
	               [//iso:property[contains(
	                   concat( ' ', current()/@properties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   [crdl:*]]
	                "
	                mode="add-crdl" >
	
	    <xsl:variable name="theRegexes">
	       <!-- handle-crdl-regex returns a sequence of elements,
	       each being regexes to be used in an report. -->
	       <xsl:call-template name="handle-crdl-regex" >
	         <xsl:with-param name="theProperties" select=" @properties "/>
	       </xsl:call-template> 
	    </xsl:variable>
	    
	    <xsl:message>REPORT {{ <xsl:value-of select=" $theRegexes " /> }}</xsl:message>
	     
	    
	    <xsl:variable name="this" as=" element()">
	       <xsl:copy-of select="."  />
	    </xsl:variable>
	    
	    
	    <xsl:variable name="theOriginalTest"  >
	       <xsl:value-of select="@test"  />
	    </xsl:variable>
	    
		<!-- first copy the current assertion -->
		<xsl:for-each select=" $theRegexes ">
	  <iso:let name=" badCharactersString " >
		    <xsl:attribute name="value" 
	           select=" concat(   
	               '( string-join( 
	                 distinct-values (
	                 for $i in string-to-codepoints( . ) 
	                   return for $c in codepoints-to-string( $i)
	                      return if ',
	                      . , 
	                      ' then &quot;&quot; else $c ), &quot;&quot;) )' 
	                ) " />
	         </iso:let>          
	      <iso:report>
	        <xsl:attribute name="test" 
	           select=" concat ( $theOriginalTest, ' and not( string-length( $badCharactersString ))')" />
	
	         
			<xsl:copy-of select="$this/@*[not(name() = 'test')]" />
		
			<xsl:apply-templates mode="add-crdl" select=" $this/node() "  />  
		    <xsl:text>: found </xsl:text>
			<iso:value-of select="$badCharactersString" /> 
		</iso:report>
		</xsl:for-each> 
	</xsl:template >
         
	
	<!-- swallow crdl elements -->
	<xsl:template match="crdl:*" mode="add-crdl"  />
        
        

	 
	
   <!-- ==================================================================================  -->
	<!-- Handle embedded ISO DSDL Part 7 crdl character repertoire elements in assertions   -->
	<!-- ================================================================================== -->
	
	<!-- This is a simple non-conforming implementation of crdl. It converts a crdl schema inside a
	Schematron property element into the corresponding assertion using XPath2 regular expressions.
	It has the following limitations:  
	
	
	  *  Except for top-level intersections, the difference and intersection elements are just 
	  treated as unions. This generates no false negatives, which is what we want from an open schema. 
	  * The repertoire element does not work. 
	  * The UCS version attributes  are ignored 
	  
	  The usage is this: 
	    * the crdl elements are children of  iso:schema or iso:pattern
	    * the top-level crdl element has an xml:id attribute
	    * an assertion or report element may have an ext:crdl-type attribute which references a crdl element
	    * such an assert or report is treated as two (or more) asserts or reports, each with the same assertion text, but
	      with different tests: the explicit @test from Schematron, and the generated tests from the crdl elements. 
	  
	  E.g.
	     <iso:schema ...>
	       ...
	       <iso:rule context="para/text()">
	          <iso:assert test="true()"  properties="shiftJIS"  >
	          The para element should only contain characters provided by shift JIS
	          </iso:assert>
	      </iso:rule>
	      ...
	      <iso:properties>
	        <iso:property id="shiftJIS"
	             <crdl:ref href="shiftJIS.credpl"   />
	        </iso:property>
	        ...
	      </iso:properties>
	       ...
	    </iso:schema>
	    
	    The same model can be used for implementing XSD datatypes ( @ext:xsd-type) and DTTL datatypes (@ext:dttl-type).
	    
	  -->
	 
	 
    


    <!-- =================================================================== -->
	<!-- Handles referencing schemas with an @ext:crdl-type reference        -->
	<!-- This is obsolete, and will be reimplemented using @properties       --> 
    <!-- =================================================================== -->
	
	<!-- This template generates the output assert statements, and generates the particular
	     regular expressions for the Xpath2 matches() function (in a mode crdl:xpath).
	     This allows us to have smaller regexes in some cases, because whereever the XPath is
	     a series of matches() functions connected by and, we can instead use multiple assert elements
	     at the output.  --> 
	<xsl:template name="handle-crdl-regex">
	   <xsl:param name="theProperties" />
	<xsl:message>PROPERTIES <xsl:value-of select=" $theProperties " /></xsl:message>
	   <xsl:choose>
	       <xsl:when test="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   /crdl:intersection" >
	      <xsl:message>INTERSECTION </xsl:message>
				<!-- Top-level intersections are handled as multiple assertions -->
					<xsl:for-each select="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   /crdl:intersection/*">
	   				   <regex>matches(., "^[<xsl:apply-templates select="." mode="crdl:xpath" />]*$")</regex>
	   				</xsl:for-each>
	        </xsl:when>
	        
	       <!-- NOT FINISHED --> 
	       <xsl:when test="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   /crdl:difference">
	       		<!-- Top-level differences are handled approximately -->
	       	   <xsl:message>DIFFERENCE </xsl:message>
	       		<!-- So difference(A, B, C) is assert(A or B or C) and assert(not(A and B and C)) -->
	       				<regex>not(<xsl:for-each select="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   /crdl:difference/*"
	       				>matches($c, "^[<xsl:apply-templates select="." mode="crdl:xpath" />]*$")
	       				  <xsl:if test="position() != last()"> and </xsl:if>	
	   		 				</xsl:for-each>)</regex>
			   
	  			
	       </xsl:when>
	       
	       <xsl:when test="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   [crdl:*]">
	       	<!-- Handle the type as a single assertions -->
		  <xsl:message>OTHER   <xsl:value-of select="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))] 
	                   /crdl:*/name() "/> </xsl:message>
		   		<regex> <xsl:apply-templates 
		   		  select="//iso:property[contains(
	                   concat( ' ', $theProperties, ' '), 
	                   concat( ' ', @id, ' '))]
	                   /crdl:*" mode="crdl:xpath" /> </regex>
	 
	    	</xsl:when> 
	       
	       <xsl:otherwise>
	           <xsl:message>Programming Error or Limitation: CRDL case not handled </xsl:message> 
	       </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
	
	  
	<!-- ==================================================================================== --> 
	<!-- crdl-xpath MODE generates regular expressions using the XPath2 regexes               --> 
	<!-- Generate the contents of the regular expressions that implement the char rep testing -->
	<!-- ==================================================================================== -->
	
	<xsl:template mode="crdl:xpath" match="crdl:ref">
	    <!-- Insert subschema -->
       <xsl:variable name="document-uri" select="substring-before(@href, '#')"/>
       <xsl:variable name="fragment-id" select="substring-after(@href, '#')"/>
       
       <xsl:choose> 
          <xsl:when test="string-length( $document-uri ) = 0 and string-length( $fragment-id ) = 0" >
          	<xsl:message>Impossible URL in crdl reference</xsl:message>
          </xsl:when>
          <xsl:when test="string-length( $document-uri ) != 0">
              <xsl:apply-templates select="//crdl:*[@xml:id= $fragment-id ]" mode="crdl:xpath"/>
          </xsl:when>
          <xsl:when test="string-length( $fragment-id ) != 0">
              <xsl:apply-templates select="document( $document-uri )//crdl:*[@xml:id= $fragment-id ]" mode="crdl:xpath"/>
		   </xsl:when>
		   <xsl:otherwise>
       		<xsl:apply-templates select="document( $document-uri )/*" mode="crdl:xpath"/>
       	   </xsl:otherwise>
       </xsl:choose>
       	
   </xsl:template>
	    
	 
	<xsl:template mode="crdl:xpath" match="crdl:repertoire">
		<!-- Dereference repertoires and insert -->
		<!-- TODO: build some charreps in and make some parameter system to allow them -->
		<xsl:message>Named character repertoires not supported in this version</xsl:message>
	</xsl:template>

   	
 
<!-- The following code courtesy of David Carlisle  --> 
<xsl:template match="crdl:union" mode="crdl:xpath">
  <xsl:text>( </xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="crdl:xpath"/>
    <xsl:if test="position()!=last()"><xsl:text  >
         or  </xsl:text></xsl:if>
  </xsl:for-each>
  <xsl:text> )</xsl:text>
</xsl:template>
    
 <!-- The following code courtesy of David Carlisle  -->
<xsl:template match="crdl:intersection" mode="crdl:xpath">
  <xsl:text>( </xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="crdl:xpath"/>
    <xsl:if test="position()!=last()"><xsl:text   >
          and  </xsl:text></xsl:if>
  </xsl:for-each>
  <xsl:text> )</xsl:text>
</xsl:template> 

 <!-- The following code courtesy of David Carlisle  -->
<xsl:template match="crdl:difference" mode="crdl:xpath">
  <xsl:text>( </xsl:text>
    <xsl:apply-templates select="*[1]" mode="crdl:xpath"/>
  <xsl:for-each select="*[position()!=1]">
    <xsl:if test="position()=1">
          and not( </xsl:if>
    <xsl:apply-templates select="." mode="crdl:xpath"/>
    <xsl:choose>
      <xsl:when  test="position()!=last()"><xsl:text   >
          or  </xsl:text></xsl:when>
      <xsl:otherwise> ) </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text> )</xsl:text>
</xsl:template>

 <!-- The following code courtesy of David Carlisle  --> 
<xsl:template match="crdl:char[not(*)]" mode="crdl:xpath">
  <xsl:text>matches($c,'</xsl:text>
  <xsl:value-of select="replace(.,'''','''''')"/>
  <xsl:text>')</xsl:text>
</xsl:template>
 
<!--
  Obsolete code.  This code was to help convert between different regex syntaxes.
  CREPDL now uses XSLT2 regex syntax, so we only need to worry about escaping
  string delimiters.
		<xsl:choose>
			<xsl:when test=".='\'"><xsl:text>\\</xsl:text></xsl:when>
			<xsl:when test=".='.'"><xsl:text>\.</xsl:text></xsl:when>
			<xsl:when test=".='['"><xsl:text>\[</xsl:text></xsl:when>
			<xsl:when test=".=']'"><xsl:text>\]</xsl:text></xsl:when>
			<xsl:when test=".='-'"><xsl:text>\-</xsl:text></xsl:when>
			<xsl:when test=".='('"><xsl:text>\(</xsl:text></xsl:when>
			<xsl:when test=".=')'"><xsl:text>\)</xsl:text></xsl:when>
			<xsl:when test=".=' '"><xsl:text>\s</xsl:text></xsl:when>
			<xsl:when test=".='	'"><xsl:text>\t</xsl:text></xsl:when>
			<xsl:when test=".='|'"><xsl:text>\|</xsl:text></xsl:when>
			<xsl:when test=".='&amp;'"><xsl:text>\&amp;</xsl:text></xsl:when> 
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>

-->

<xsl:template match="crdl:char[crdl:kernel]" mode="crdl:xpath">
  <!-- Note: no hull processing because ???  -->
  <xsl:text>matches($c,'</xsl:text>
  <xsl:value-of select="replace(crdl:kernel,'''','''''')"/>
  <xsl:text>')</xsl:text>
</xsl:template>
 
   		  
	  <!-- FIX THIS -->
	<xsl:template mode="crdl:xpath" match="crdl:hull">
		<xsl:text>^</xsl:text><xsl:value-of select="." /><xsl:text></xsl:text>
	</xsl:template> 
   
   	<xsl:template mode="crdl:xpath" match="*"  priority="-1">
   		<xsl:comment>Unhandled element <xsl:value-of select="name(.)"/></xsl:comment>
   	</xsl:template>
   	
   
 </xsl:stylesheet>
	