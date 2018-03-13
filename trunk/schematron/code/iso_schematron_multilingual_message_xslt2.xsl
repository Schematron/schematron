<?xml version="1.0" ?><?xar XSLT?> 
<!-- Implementation for the Schematron XML Schema Language. 
     Generates simple text output messages using XSLT2 engine
-->
<!--
Open Source Initiative OSI - The MIT License:Licensing
[OSI Approved License]

This source code was previously available under the zlib/libpng license. 
Attribution is polite.

The MIT License

Copyright (c)  2000-2010 Rick Jellife and Academia Sinica Computing Centre, Taiwan.

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

<!-- Schematron message -->

<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
   xmlns:iso="http://purl.oclc.org/dsdl/schematron"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
   
   <!-- The diagnostics elements -->  
   <xsl:key name="diag" match="iso:diagnostic" use="@id"/>   
   
   <!-- Generate the message dependeng on the language 
         - if a language code is set in the value of the $langCode parameter, the message in thet language will be presented
         - Otherwise, all messages will be presented  
   -->
   <xsl:template name="generateTextMassage">
      <xsl:param name="diagnostics"/>
      <xsl:param name="currentLanguage" required="yes"/>

      <!-- Get all localization (diagnostics) nodes. -->
      <xsl:variable name="localizationNodes" as="item()*">
         <xsl:if test="$diagnostics != ''">
            <xsl:variable name="assert" select="."/>
            <xsl:for-each select="tokenize($diagnostics, ' ')">
               <xsl:sequence select="key('diag', current(), root($assert))"/>
            </xsl:for-each>
         </xsl:if>
      </xsl:variable>

      <!-- Generate the (localization) diagnostics messages for the current language-->
      <xsl:variable name="localizationMessages" as="item()*">
         <xsl:for-each select="$localizationNodes">
            <xsl:call-template name="getMessage">
               <xsl:with-param name="reqLang" select="$currentLanguage"/>
               <xsl:with-param name="isAddId" select="false()"/>
            </xsl:call-template>
         </xsl:for-each>
      </xsl:variable>

      <!-- Generate the message from assert only if matches the current language -->
      <xsl:variable name="assertMsg" as="item()*">
         <xsl:call-template name="getMessage">
            <xsl:with-param name="reqLang" select="$currentLanguage"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <xsl:when
            test="not(empty($localizationMessages)) or (not(empty($assertMsg)) and $localizationNodes)">
            <!-- Generate the message for the current language, both from the assertion and from localization nodes  -->
            <xsl:sequence select="$assertMsg"/>
            <xsl:sequence select="$localizationMessages"/>
         </xsl:when>
         <xsl:when test="$currentLanguage != 'default'">
            <!-- If no localization (diagnostics) for a specific language-->
            <xsl:choose>
               <!-- Generate the assertion message for the current language-->
               <xsl:when test="not(empty($assertMsg))">
                  <xsl:sequence select="$assertMsg"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- Generate the messages for all languages. -->
                  <!-- Print assertion message -->
                  <xsl:variable name="assertMsgDef">
                     <xsl:call-template name="getMessage">
                        <xsl:with-param name="reqLang" select="'default'"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <xsl:sequence select="$assertMsgDef"/>
                  <!-- Print distinct diagnostics messages. -->
                  <xsl:variable name="allMessages" as="item()*">
                     <xsl:for-each select="$localizationNodes">
                        <xsl:call-template name="getMessage">
                           <xsl:with-param name="reqLang" select="'default'"/>
                           <xsl:with-param name="isAddId" select="true()"/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:sequence select="$allMessages"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <!-- Generate the assertion message, if no language match-->
            <xsl:variable name="assertMsgDef">
               <xsl:call-template name="getMessage">
                  <xsl:with-param name="reqLang" select="'default'"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:sequence select="$assertMsgDef"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- Function used to obtain the message from the current node -->
   <xsl:template name="getMessage">
      <xsl:param name="reqLang" as="xs:string" required="yes"/>
      <xsl:param name="isAddId" as="xs:boolean" select="false()"/>
      
      <xsl:choose>
         <xsl:when test="$reqLang != 'default'">
            <!-- Get the language from the current node -->
            <xsl:variable name="lang">
               <xsl:variable name="currentLang" select="(ancestor-or-self::*/@xml:lang)[last()]"/>
               <xsl:value-of select="if ($currentLang) then ($currentLang) else ('#NONE')"/>
            </xsl:variable>
            <!-- Generate the message from assert only if matches the current language -->
            <xsl:if test="starts-with($lang, $reqLang)">
               <xsl:if test="$isAddId">[#<xsl:value-of select="@id"/>]</xsl:if>
               <xsl:apply-templates mode="text"/>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <!-- Generate the message with the language in front. -->
            <xsl:if test="$isAddId">[#<xsl:value-of select="@id"/>]</xsl:if>
            <xsl:if test="@xml:lang">[<xsl:value-of select="@xml:lang"/>]</xsl:if>
            <xsl:apply-templates mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>