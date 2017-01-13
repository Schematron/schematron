<?xml version="1.0"?><?xar XSLT?>
<!-- Skeleton Module for the Schematron 1.6 XML Schema Language.

   WARNING: Schematron 1.6 is obsolete use ISO Schematron

	http://www.ascc.net/xml/schematron/
 
 Copyright (c) 2000,2001 Rick Jelliffe and Academia Sinica Computing Center, Taiwan

 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the authors be held liable for any damages arising from 
 the use of this software.

 Permission is granted to anyone to use this software for any purpose, 
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim
 that you wrote the original software. If you use this software in a product, 
 an acknowledgment in the product documentation would be appreciated but is 
 not required.

 2. Altered source versions must be plainly marked as such, and must not be 
 misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.
-->
<!-- 
       2008-08-06
   		* TT Top-level lets need to be implemented using xsl:param not xsl:variable
   		* TT xsl:param/@select must have XPath or not be specified
   		
    Version 2007-08-06 RJ
    		* update template formal parameters to run under SAXON
	Version: 2003-02-20
			* added <let> for upgrade to 1.6
    Version: 2001-06-13
           * same skeleton now supports namespace or no namespace
           * parameters to handlers updated for all 1.5 attributes 
           * diagnostic hints supported: command-line option diagnose=yes|no
           * phases supported: command-line option phase=#ALL|...
           * abstract rules
           * compile-time error messages  
	   * add utility routine generate-id-from-path
          
    Contributors: Rick Jelliffe (original), Oliver Becker (architecture), 
             Miloslav Nic (diagnostic, phase, options), Ludwig Svenonius (abstract)
             Uche Ogbuji (misc. bug fixes), Jim Ancona (SAXON workaround),
	     Francis Norton (generate-id-from-path)


    XSLT versions tested and working as-is: 
           * SAXON  
           * Instant Saxon 
           * XT n.b. key() not available, will die
	   * MSXML4
	   * Oracle

    XSLT versions tested and requires small workaround from you
           * Sablotron does not support import, so merge meta-stylesheets by hand
           * Xalan for Java 2.0 outputs wrong namespace URI, so alter by hand or script
           * Xalan for C 1.0 has problem with key, so edit by hand. Find "KEY" below  

   If you create your own meta-stylesheet to override this one, it is a
   good idea to have both in the same directory and to run the stylesheet
   from that directory, as many XSLT implementations have ideosyncratic
   handling of URLs: keep it simple.
         
-->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" 
	xmlns:sch="http://www.ascc.net/xml/schematron"
	 >
<!-- Note that this namespace is not version specific.
This program implements schematron 1.6 -->
<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
<!-- Category: top-level-element -->
<xsl:output method="xml" omit-xml-declaration="no" standalone="yes"  indent="yes"/>
<xsl:param name="block"></xsl:param><!-- reserved -->
<xsl:param name="phase">
  <xsl:choose>
    <xsl:when test="//sch:schema/@defaultPhase">
      <xsl:value-of select="//sch:schema/@defaultPhase"/>
    </xsl:when>
    <xsl:otherwise>#ALL</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="hiddenKey"> key </xsl:param><!-- workaround for Xalan4J 2.0 -->

<xsl:param name="output-encoding"/>
 
<xsl:param name="message-newline">true</xsl:param>

<!-- SCHEMA -->
<xsl:template match="sch:schema | schema">
	<axsl:stylesheet version="1.0">
		<xsl:for-each select="sch:ns | ns">
			<xsl:attribute name="{concat(@prefix,':dummy-for-xmlns')}" namespace="{@uri}"/>
		</xsl:for-each>
 
		<xsl:if test="count(sch:title/* | title/* )">
			<xsl:message>
				<xsl:text>Warning: </xsl:text>
				<xsl:value-of select="name(.)"/>
				<xsl:text> must not contain any child elements</xsl:text>
			</xsl:message>
		</xsl:if>
 
		 <xsl:if test="not($phase = '#ALL')">
			  <xsl:if test="not(sch:phase[@id = $phase] | phase[@id = $phase])">
				  <xsl:message>Phase Error: no phase with name <xsl:value-of select="$phase"
				  /> has been defined.</xsl:message>
		         </xsl:if>
              </xsl:if>


   <!-- These parameters may contain strings with the name and directory of the file being
   validated. For convenience, if the caller only has the information in a single string,
   that string could be put in fileDirParameter. The archives parameters are available
   for ZIP archives.
	-->

	<axsl:param name="archiveDirParameter"  />
	<axsl:param name="archiveNameParameter" />
	<axsl:param name="fileNameParameter" />
	<axsl:param name="fileDirParameter" />
		<xsl:call-template name="process-prolog"/>

		<!-- SCHEMATRON-FULL-PATH -->
		<!-- utility routine for implementations -->
   		<axsl:template match="*|@*" mode="schematron-get-full-path">

			<axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
			<axsl:text>/</axsl:text>
			<axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
			<axsl:value-of select="name()"/>
			<axsl:text>[</axsl:text>
	  		<axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
	  		<axsl:text>]</axsl:text>
       	 	</axsl:template>

		<!-- GENERATE-ID-FROM-PATH -->
		<!-- repeatable-id maker derived from Francis Norton's. -->
		<!-- use this if you need generate ids in seperate passes,
		     because generate-id() is not guaranteed to produce the same
		     results each time -->
			  <!--
		<axsl:template match="/" mode="generate-id-from-path"/>
		<axsl:template match="text()" mode="generate-id-from-path">
			<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
			<axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
		</axsl:template>
		<axsl:template match="comment()" mode="generate-id-from-path">
			<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
			<axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
		</axsl:template>
		<axsl:template match="processing-instruction()" mode="generate-id-from-path">
			<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
			<axsl:value-of 
			select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
		</axsl:template>
		<axsl:template match="@*" mode="generate-id-from-path">
			<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
			<axsl:value-of select="concat('.@', name())"/>
		</axsl:template>
		<axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
			<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
			<axsl:text>.</axsl:text>
			<axsl:choose>
				<axsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
					<axsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
				</axsl:when>                                          
				<axsl:otherwise>
				<axsl:value-of 
				select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
				</axsl:otherwise>
			</axsl:choose>
		</axsl:template>
		-->

		<xsl:apply-templates mode="do-keys" 
                select="sch:pattern/sch:rule/sch:key | pattern/rule/key "/>


		<axsl:template match="/">
			<xsl:call-template name="process-root">
				<xsl:with-param name="fpi" select="@fpi"/>
				<xsl:with-param 	xmlns:sch="http://www.ascc.net/xml/schematron"
				name="title" select="./sch:title | title"/>
				<xsl:with-param name="id" select="@id"/>
				<xsl:with-param name="icon" select="@icon"/>
				<xsl:with-param name="lang" select="@xml:lang"/>
				<xsl:with-param name="version" select="@version" />
				<xsl:with-param name="schemaVersion" select="@schemaVersion" />
				<xsl:with-param name="contents">
					<xsl:apply-templates mode="do-all-patterns"/>
				</xsl:with-param>
			</xsl:call-template>
		</axsl:template>
 
		<xsl:apply-templates/>
		<axsl:template match="text()" priority="-1">
			<!-- strip characters -->
		</axsl:template>
	</axsl:stylesheet>
</xsl:template>

	<!-- ACTIVE -->
	<xsl:template match="sch:active | active">
                <xsl:if test="not(@pattern)">
                    <xsl:message>Markup Error: no pattern attribute in &lt;active></xsl:message>
                </xsl:if>
<!--                <xsl:if test="//sch:rule[@id = current()/@pattern]"> -->
                <xsl:if test="not(//sch:pattern[@id = current()/@pattern])">
                           <xsl:message>Reference Error: the pattern  "<xsl:value-of select="@pattern"
						   />" has been activated but is not declared</xsl:message>
                </xsl:if>
        </xsl:template>

	<!-- ASSERT and REPORT -->
	<xsl:template match="sch:assert | assert">
  
                <xsl:if test="not(@test)">
                    <xsl:message>Markup Error: no test attribute in &lt;assert></xsl:message>
                </xsl:if>
		<axsl:choose>
			<axsl:when test="{@test}"/>
			<axsl:otherwise>
				<xsl:call-template name="process-assert">
					<xsl:with-param name="role" select="@role"/>
					<xsl:with-param name="id" select="@id"/>
					<xsl:with-param name="test" select="normalize-space(@test)" />
					<xsl:with-param name="icon" select="@icon"/>
					<xsl:with-param name="subject" select="@subject"/>
					<xsl:with-param name="diagnostics" select="@diagnostics"/>
				</xsl:call-template>  
			</axsl:otherwise>
		</axsl:choose>
	</xsl:template>
	<xsl:template match="sch:report | report">
		 
                <xsl:if test="not(@test)">
                    <xsl:message>Markup Error: no test attribute in &lt;report></xsl:message>
                </xsl:if>
		<axsl:if test="{@test}">
			<xsl:call-template name="process-report">
				<xsl:with-param name="role" select="@role"/>
				<xsl:with-param name="test" select="normalize-space(@test)" />
				<xsl:with-param name="icon" select="@icon"/>
				<xsl:with-param name="id" select="@id"/>
				<xsl:with-param name="subject" select="@subject"/>
				<xsl:with-param name="diagnostics" select="@diagnostics"/>
			</xsl:call-template>
		</axsl:if>
	</xsl:template>


	<!-- DIAGNOSTIC -->
	<xsl:template match="sch:diagnostic | diagnostic"
              ><xsl:if test="not(@id)"
                    ><xsl:message>Markup Error: no id attribute in &lt;diagnostic></xsl:message
                ></xsl:if><xsl:call-template name="process-diagnostic">
                <xsl:with-param name="id" select="@id" />
               </xsl:call-template>
        </xsl:template>

	<!-- DIAGNOSTICS -->
	<xsl:template match="sch:diagnostics | diagnostics"/>

	<!-- DIR -->
	<xsl:template match="sch:dir | dir"  mode="text"
		><xsl:call-template name="process-dir">
			<xsl:with-param name="value" select="@value"/>
		</xsl:call-template>
	</xsl:template>

	<!-- EMPH -->
	<xsl:template match="sch:emph | emph"  mode="text"
		><xsl:call-template name="process-emph"/>
	</xsl:template>

	<!-- EXTENDS -->
	<xsl:template match="sch:extends | extends">
		<xsl:if test="not(@rule)"
                    ><xsl:message>Markup Error: no rule attribute in &lt;extends></xsl:message
                ></xsl:if>
     		<xsl:if test="not(//sch:rule[@abstract='true'][@id= current()/@rule] )
                    and not(//rule[@abstract='true'][@id= current()/@rule])">
                    <xsl:message>Reference Error: the abstract rule  "<xsl:value-of select="@rule"
					/>" has been referenced but is not declared</xsl:message>
                </xsl:if>
	        <xsl:call-template name="IamEmpty" />

  		<xsl:if test="//sch:rule[@id=current()/@rule]">
    			<xsl:apply-templates select="//sch:rule[@id=current()/@rule]"
				mode="extends"/>
  		</xsl:if>

	</xsl:template>

	<!-- KEY -->
	<!-- do we need something to test uniqueness too? --> 
	<!-- NOTE: if you get complaint about "key" here (e.g. Xalan4C 1.0) replace
		"key" with "$hiddenKey" -->
	<xsl:template  match="sch:key | key" mode="do-keys" >
                <xsl:if test="not(@name)">
                    <xsl:message>Markup Error: no name attribute in &lt;key></xsl:message>
                </xsl:if>
                <xsl:if test="not(@path)">
                    <xsl:message>Markup Error: no path attribute in &lt;key></xsl:message>
                </xsl:if>
	        <xsl:call-template name="IamEmpty" />
		<axsl:key match="{../@context}" name="{@name}" use="{@path}"/>
	</xsl:template>
	<xsl:template match="sch:key | key"  /><!-- swallow -->

	<!-- LET -->
	<xsl:template match="sch:let | let" >
       	<xsl:choose>
       		<xsl:when test="parent::sch:schema or parent::schema ">
       			<!-- it is an error to have an empty param/@select because an XPath is expected -->
	      		 <axsl:param name="{@name}"  >
	      		 		<xsl:if test="string-length(@value) &gt; 0">
	      		 			<xsl:attribute name="select"><xsl:value-of select="@value"/></xsl:attribute>
	      		 		</xsl:if>
	      		 </axsl:param> 
       		</xsl:when>
       		<xsl:otherwise>
				<axsl:variable name="{@name}" select="{@value}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<!-- NAME -->
	<xsl:template match="sch:name | name" mode="text">
		<axsl:text xml:space="preserve"> </axsl:text>
			<xsl:if test="@path"
				><xsl:call-template name="process-name">
					<xsl:with-param name="name" select="concat('name(',@path,')')"/>
					<!-- SAXON needs that instead of  select="'name({@path})'"  -->
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="not(@path)"
				><xsl:call-template name="process-name">
					<xsl:with-param name="name" select="'name(.)'"/>
				</xsl:call-template>
			</xsl:if>
	        	<xsl:call-template name="IamEmpty" />
		<axsl:text xml:space="preserve"> </axsl:text>
	</xsl:template>

	<!-- NS -->
	<xsl:template match="sch:ns | ns"  mode="do-all-patterns" >
               <xsl:if test="not(@uri)">
                    <xsl:message>Markup Error: no uri attribute in &lt;ns></xsl:message>
                </xsl:if>
               <xsl:if test="not(@prefix)">
                    <xsl:message>Markup Error: no prefix attribute in &lt;ns></xsl:message>
                </xsl:if>
	        <xsl:call-template name="IamEmpty" />
		<xsl:call-template name="process-ns" >
			<xsl:with-param name="prefix" select="@prefix"/>
			<xsl:with-param name="uri" select="@uri"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="sch:ns | ns"  /><!-- swallow -->

	<!-- P -->
	<xsl:template match="sch:schema/sch:p | schema/p" mode="do-schema-p" >
		<xsl:call-template name="process-p">
			<xsl:with-param name="class" select="@class"/>
			<xsl:with-param name="icon" select="@icon"/>
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="lang" select="@xml:lang"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="sch:pattern/sch:p | pattern/p" mode="do-pattern-p" >
		<xsl:call-template name="process-p">
			<xsl:with-param name="class" select="@class"/>
			<xsl:with-param name="icon" select="@icon"/>
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="lang" select="@xml:lang"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="sch:phase/sch:p" /><!-- We don't use these -->
	<xsl:template match="sch:p | p" />

	<!-- PATTERN -->
	<xsl:template match="sch:pattern | pattern" mode="do-all-patterns">
	<xsl:if test="($phase = '#ALL') 
	or (../sch:phase[@id= ($phase)]/sch:active[@pattern= current()/@id])
	or (../phase[@id= ($phase)]/active[@id= current()/@id])">
		<xsl:call-template name="process-pattern">
			<xsl:with-param name="name" select="@name"/>
			<xsl:with-param name="id" select="@id"/>
			<xsl:with-param name="see" select="@see"/>
			<xsl:with-param name="fpi" select="@fpi"/>
			<xsl:with-param name="icon" select="@icon"/>
		</xsl:call-template>
		<axsl:apply-templates select="/" mode="M{count(preceding-sibling::*)}"/>
        </xsl:if>
	</xsl:template>
	
	<xsl:template match="sch:pattern | pattern">
        <xsl:if test="($phase = '#ALL') 
	or (../sch:phase[@id= ($phase)]/sch:active[@pattern= current()/@id])
	or (../phase[@id= ($phase)]/active[@id= current()/@id])">
		<xsl:apply-templates/>
		<axsl:template match="text()" priority="-1" mode="M{count(preceding-sibling::*)}">
			<!-- strip characters -->
		</axsl:template>
        </xsl:if>
	</xsl:template>

	<!-- PHASE -->
	<xsl:template match="sch:phase | phase" >
                <xsl:if test="not(@id)">
                    <xsl:message>Markup Error: no id attribute in &lt;phase></xsl:message>
                </xsl:if>
		  <xsl:apply-templates/>
	</xsl:template>

	<!-- RULE -->
	<xsl:template match="sch:rule[not(@abstract='true')] | rule[not(@abstract='true')]">
                <xsl:if test="not(@context)">
                    <xsl:message>Markup Error: no context attribute in &lt;rule></xsl:message>
                </xsl:if>
		<axsl:template match="{@context}" 
		priority="{4000 - count(preceding-sibling::*)}" mode="M{count(../preceding-sibling::*)}">
			<xsl:call-template name="process-rule">
				<xsl:with-param name="id" select="@id"/>
				<xsl:with-param name="context" select="@context"/>
				<xsl:with-param name="role" select="@role"/>
			</xsl:call-template>
			<xsl:apply-templates/>
			<axsl:apply-templates mode="M{count(../preceding-sibling::*)}"/>
		</axsl:template>
	</xsl:template>


	<!-- ABSTRACT RULE -->
	<xsl:template match="sch:rule[@abstract='true'] | rule[@abstract='true']" >
		<xsl:if test=" not(@id)">
                    <xsl:message>Markup Error: no id attribute on abstract &lt;rule></xsl:message>
                </xsl:if>
 		<xsl:if test="@context">
                    <xsl:message>Markup Error: (2) context attribute on abstract &lt;rule></xsl:message>
                </xsl:if>
	</xsl:template>

	<xsl:template match="sch:rule[@abstract='true'] | rule[@abstract='true']"
		mode="extends" >
                <xsl:if test="@context">
                    <xsl:message>Markup Error: context attribute on abstract &lt;rule></xsl:message>
                </xsl:if>
			<xsl:apply-templates/>
	</xsl:template>

	<!-- SPAN -->
	<xsl:template match="sch:span | span" mode="text">
		<xsl:call-template name="process-span"
			><xsl:with-param name="class" select="@class"/>
		</xsl:call-template>
	</xsl:template>

	<!-- TITLE -->
	<!-- swallow -->
	<xsl:template match="sch:title | title" /> 

	<!-- VALUE-OF -->
	<xsl:template match="sch:value-of | value-of" mode="text" >
               <xsl:if test="not(@select)">
                    <xsl:message>Markup Error: no select attribute in &lt;value-of></xsl:message>
                </xsl:if>
	        <xsl:call-template name="IamEmpty" />
		<axsl:text xml:space="preserve"> </axsl:text>
		<xsl:choose>
			<xsl:when test="@select"
				><xsl:call-template name="process-value-of">
					<xsl:with-param name="select" select="@select"/>  
                                   <!-- will saxon have problem with this too?? -->
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise >
				<xsl:call-template name="process-value-of"
					><xsl:with-param name="select" select="'.'"/>
				</xsl:call-template>
			</xsl:otherwise>
                </xsl:choose>
		<axsl:text xml:space="preserve"> </axsl:text>
	</xsl:template>

<!-- ============================================================== -->
	<!-- Text -->
	<xsl:template match="text()" priority="-1" mode="do-keys">
		<!-- strip characters -->
	</xsl:template>
	<xsl:template match="text()" priority="-1" mode="do-all-patterns">
		<!-- strip characters -->
	</xsl:template>
        <xsl:template match="text()" priority="-1" mode="do-schema-p">
		<!-- strip characters -->
	</xsl:template>
        <xsl:template match="text()" priority="-1" mode="do-pattern-p">
		<!-- strip characters -->
	</xsl:template>
	<xsl:template match="text()" priority="-1">
		<!-- strip characters -->
	</xsl:template>
	<xsl:template match="text()" mode="text">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

	<xsl:template match="text()" mode="inline-text">
		<xsl:value-of select="."/>
	</xsl:template>

<!-- ============================================================== -->
<!-- utility templates -->
<xsl:template name="IamEmpty">
	<xsl:if test="count( * )">
		<xsl:message>
			<xsl:text>Warning: </xsl:text>
			<xsl:value-of select="name(.)"/>
			<xsl:text> must not contain any child elements</xsl:text>
		</xsl:message>
	</xsl:if>
</xsl:template>

<xsl:template name="diagnosticsSplit">
  <!-- Process at the current point the first of the <diagnostic> elements
       referred to parameter str, and then recurse -->
  <xsl:param name="str"/>
  <xsl:variable name="start">
    <xsl:choose>
      <xsl:when test="contains($str,' ')">
	<xsl:value-of  select="substring-before($str,' ')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="end">
    <xsl:if test="contains($str,' ')">
      <xsl:value-of select="substring-after($str,' ')"/>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="not(string-length(normalize-space($start)) = 0)
	and not(//sch:diagnostic[@id = ($start)]) and not(//diagnostic[@id = ($start)])">
	<xsl:message>Reference error: A diagnostic "<xsl:value-of select="string($start)"
	/>" has been referenced but is not declared</xsl:message>
  </xsl:if>

  <xsl:if test="string-length(normalize-space($start)) > 0">
     <xsl:apply-templates 
        select="//sch:diagnostic[@id = ($start) ] | //diagnostic[@id= ($start) ]"/>
  </xsl:if>

  <xsl:if test="not($end='')">
    <xsl:call-template name="diagnosticsSplit">
      <xsl:with-param name="str" select="$end"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- ============================================================== -->

	<xsl:template match="*">
		<xsl:message>
			<xsl:text>Warning: unrecognized element </xsl:text>
			<xsl:value-of select="name(.)"/>
		</xsl:message>
	</xsl:template>
	<xsl:template match="*" mode="text">
		<xsl:message>
			<xsl:text>Warning: unrecognized element </xsl:text>
			<xsl:value-of select="name(.)"/>
		</xsl:message>
	</xsl:template>

<!-- ============================================================== -->
<!-- DEFAULT NAMED TEMPLATES -->
<!-- These are the actions that are performed unless overridden -->
<!-- ============================================================== -->
<xsl:template name="process-prolog"/>
	<!-- no params -->

	<xsl:template name="process-root">
		<xsl:param name="contents"/>
		<xsl:param name="id" />
		<xsl:param name="version" />
		<xsl:param name="schemaVersion" />
		<xsl:param name="queryBinding" />
		<xsl:param name="title" />


		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />

		<xsl:copy-of select="$contents"/>
	</xsl:template>

	<xsl:template name="process-assert">

		<xsl:param name="test"/>
		<xsl:param name="diagnostics" />
		<xsl:param name="id" />
		<xsl:param name="flag" />

           	<!-- "Linkable" parameters -->
		<xsl:param name="role"/>
		<xsl:param name="subject"/>

		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />


		<xsl:call-template name="process-message">
			<xsl:with-param name="pattern" select="$test"/>
			<xsl:with-param name="role" select="$role"/>
		</xsl:call-template>
		
		
	</xsl:template>

	<xsl:template name="process-report">
		<xsl:param name="test"/>
		<xsl:param name="diagnostics" />
		<xsl:param name="id" />
		<xsl:param name="flag" />

           	<!-- "Linkable" parameters -->
		<xsl:param name="role"/>
		<xsl:param name="subject"/>

		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" /> 
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />

		<xsl:call-template name="process-message">
			<xsl:with-param name="pattern" select="$test"/>
			<xsl:with-param name="role" select="$role"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="process-diagnostic">
		<xsl:param name="id" />

		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />
		
	    <!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<xsl:apply-templates mode="text"/>
		<axsl:text> </axsl:text>
	</xsl:template>

	<xsl:template name="process-dir">
      	<xsl:param name="value" />

	    <!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<xsl:apply-templates mode="inline-text"/>
		<axsl:text> </axsl:text>
	</xsl:template>

	<xsl:template name="process-emph"> 
	    <!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<xsl:apply-templates mode="inline-text"/>
		<axsl:text> </axsl:text>
	</xsl:template>
	
	<xsl:template name="process-name">
		<xsl:param name="name"/>
		
		<!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<axsl:value-of select="{$name}"/>
		<axsl:text> </axsl:text>
		
    </xsl:template>

	<xsl:template name="process-ns" >
	<!-- Note that process-ns is for reporting. The sch:ns elements are 
	     independently used in the sch:schema template to provide namespace bindings -->
		<xsl:param name="prefix"/>
		<xsl:param name="uri" />
      </xsl:template>

	<xsl:template name="process-p">
		<xsl:param name="id" />
		<xsl:param name="class" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
      </xsl:template>

	<xsl:template name="process-pattern">
		<xsl:param name="id" />
		<xsl:param name="name" />
		<xsl:param name="is-a" />

		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />
      </xsl:template>
      

	<xsl:template name="process-rule">
		<xsl:param name="context" />

		<xsl:param name="id" />
		<xsl:param name="flag" />

           	<!-- "Linkable" parameters -->
		<xsl:param name="role"/>
		<xsl:param name="subject"/>
  
		<!-- "Rich" parameters -->
		<xsl:param name="fpi" />
		<xsl:param name="icon" />
		<xsl:param name="lang" />
		<xsl:param name="see" />
		<xsl:param name="space" />
      </xsl:template>

	<xsl:template name="process-span" >
		<xsl:param name="class" />

	    <!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<xsl:apply-templates mode="inline-text"/>
		<axsl:text> </axsl:text>		
	</xsl:template>

	<xsl:template name="process-title" >
		<xsl:param name="class" />
	   <xsl:call-template name="process-p">
	      <xsl:with-param  name="class">title</xsl:with-param>
	   </xsl:call-template>
	</xsl:template>
		
	<xsl:template name="process-schema-title" >
		<xsl:param name="class" />
	   <xsl:call-template name="process-title">
	      <xsl:with-param  name="class">schema-title</xsl:with-param>
	   </xsl:call-template>
	</xsl:template>

	<xsl:template name="process-value-of">
		<xsl:param name="select"/>
		
	    <!-- We generate too much whitespace rather than risking concatenation -->
		<axsl:text> </axsl:text>
		<axsl:value-of select="{$select}"/>
		<axsl:text> </axsl:text>
	</xsl:template>

	<!-- default output action: the simplest customization is to just override this -->
	<xsl:template name="process-message">
		<xsl:param name="pattern" />
            <xsl:param name="role" />

		<xsl:apply-templates mode="text"/>	
		 <xsl:if test=" $message-newline = 'true'" >
			<axsl:value-of  select="string('&#10;')"/>
		</xsl:if>
		
	</xsl:template>
</xsl:stylesheet>




