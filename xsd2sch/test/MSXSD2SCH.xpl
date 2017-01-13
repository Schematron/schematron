<?xml version="1.0" encoding="UTF-8"?>
<?oxygen RNGSchema="file:/Applications/oxygen%2011.2/frameworks/xproc/xproc.rnc" type="compact"?>

<!-- RUNNING FROM THE COMMAND LINE -->
<!-- C:\Program Files\xmlcalabash-0.9.32\ SET -Xmx to 1500m
    calabash C:\Users\Paul\XSD2SCH\trunk\xsd2sch\test\MSXSD2SCH.xpl -->
<!-- C:\Program Files\calumet-1.0.12\bin>
    calumet -c config.xml C:\Users\Paul\XSD2SCH\trunk\xsd2sch\test\MSXSD2SCH.xpl-->

<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:wts="http://www.w3.org/XML/2004/xml-schema-test-suite/"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:emx="http://www.emc.com/documentum/xml/xproc" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xpath-version="1.0" 
    name="generatereport" 
    version="1.0">
    
    <!-- namespaces with prefixes emx and cx needed for Calabash and Calumet specific steps -->
    
    <!-- Dummy file for grabbing the base uri later on -->
    <p:input port="source">
        <p:inline>
            <input/>
        </p:inline>
    </p:input>
    
    <p:output port="result" sequence="true">
        <p:pipe port="result" step="fileloop"/>
    </p:output>
    
    <!-- grabbing the base uri -->
    <p:variable name="filepath" select="p:base-uri()"/>
    <p:variable name="folderpath" select="concat($filepath,'/../')"/>
    <!-- setting the directory with the tests -->
    <p:variable name="testpath" select="concat($folderpath,'msMeta/')"/>
    
    <!-- Importing the Calabash extension steps -->    
    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
    
    <!-- Building the list of xml files with the description of the MS XSD tests  -->
    <p:directory-list name="list" include-filter=".*\.xml">
        <p:with-option name="path" select="$testpath"/>
    </p:directory-list>
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
                    <xsl:template match="*">
                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
                            <xsl:if test="local-name() = 'file'">
                                <xsl:attribute name="file">
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:apply-templates/>
                        </xsl:copy>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <!-- Generate an absolute URI for all these xml files -->
    <p:make-absolute-uris match="c:file/@name" name="absuri">
        <p:with-option name="base-uri" select="$testpath"/>
    </p:make-absolute-uris>

    <p:for-each name="fileloop">
        <p:output port="result" sequence="true">
            <p:pipe port="result" step="store"/>
        </p:output>
        <!--  Loop over these files  -->
        <p:iteration-source select="/c:directory/c:file"/>
        <p:variable name="path" select="/c:file/@name"/>
        <p:variable name="file" select="/c:file/@file"/>
        <!-- Detecting the XProc processor used -->
        <p:variable name="product" select="p:system-property('p:product-name')"/>
        
        <cx:message p:use-when="contains(p:system-property('p:product-name'),'Calabash')">
            <p:with-option name="message" select="concat('FILE: ', $file)"/>
        </cx:message>
        <emx:message p:use-when="contains(p:system-property('p:product-name'),'Calumet')">
            <p:with-option name="message" select="concat('FILE: ', $file)"/>
        </emx:message>
        
        
        <!-- Read the file-->
        <p:load>
            <p:with-option name="href" select="$path"/>
        </p:load>
 
        <p:for-each name="testloop">
            <!-- Loop over every test having both an instance Document and a valid schema-->
            <p:iteration-source
                select="/wts:testSet/wts:testGroup[wts:instanceTest/wts:instanceDocument][wts:schemaTest/wts:expected[@validity ='valid']]"/>
            <p:output port="result" sequence="true">
                <p:pipe port="result" step="xslt"/>
            </p:output>
            
            <p:variable name="xsd"
                select="substring-after(/wts:testGroup/wts:schemaTest/wts:schemaDocument[1]/@xlink:href,'/')"/>
            <p:variable name="xml"
                select="substring-after(/wts:testGroup/wts:instanceTest/wts:instanceDocument/@xlink:href,'/')"/>
            
            <emx:message p:use-when="contains(p:system-property('p:product-name'),'Calumet')">
                <p:with-option name="message" select="concat('XSD: ', $xsd)"/>
            </emx:message>
            <emx:message p:use-when="contains(p:system-property('p:product-name'),'Calumet')">
                <p:with-option name="message" select="concat('XML: ', $xml)"/>
            </emx:message>
            <cx:message p:use-when="contains(p:system-property('p:product-name'),'Calabash')">
                <p:with-option name="message" select="concat('XSD: ', $xsd)"/>
            </cx:message>
            <cx:message p:use-when="contains(p:system-property('p:product-name'),'Calabash')">
                <p:with-option name="message" select="concat('XML: ', $xml)"/>
            </cx:message>
            
            
            
            <!-- Load the respective schema -->
            <p:load name="schema">
                <p:with-option name="href" select="concat('./',$xsd)"/>
            </p:load>
            <!-- Load the related instance -->
            <p:load name="instance">
                <p:with-option name="href" select="concat('./',$xml)"/>
            </p:load>
            <!-- Convert the schema to schematron using the XSD2SCH stylesheets -->
            <p:group name="xsd2sch">
                <p:output port="result">
                    <p:pipe port="result" step="compress"/>
                </p:output>
                <p:xslt name="xsd-include">
                    <p:input port="source">
                        <p:pipe port="result" step="schema"/>
                    </p:input>
                    <p:input port="stylesheet">
                        <p:document href="../code/include.xsl"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
                <p:xslt name="xsd-flatten">
                    <p:input port="source"/>
                    <p:input port="stylesheet">
                        <p:document href="../code/flatten.xsl"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
                <p:xslt name="xsd-expand-ref">
                    <p:input port="source"/>
                    <p:input port="stylesheet">
                        <p:document href="../code/expand.xsl"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
                <p:xslt name="xsd-to-sch">
                    <p:input port="source"/>
                    <p:input port="stylesheet">
                        <p:document href="../code/xsd2sch.xsl"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
                <p:xslt name="compress">
                    <p:input port="source"/>
                    <p:input port="stylesheet">
                        <p:document href="../code/compress.xsl"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
            </p:group>
            <!-- run an instance validation with the xsd -->
            <p:try name="tryxsd">
                <p:group>
                    <p:output port="result">
                        <p:pipe port="result" step="xsdpos"/>
                    </p:output>
                    <p:validate-with-xml-schema assert-valid="true" mode="strict" name="vs1">
                        <p:input port="source">
                            <p:pipe port="result" step="instance"/>
                        </p:input>
                        <p:input port="schema">
                            <p:pipe port="result" step="schema"/>
                        </p:input>
                    </p:validate-with-xml-schema>
                    <p:sink/>
                    <p:identity name="xsdpos">
                        <p:input port="source">
                            <p:inline>
                                <c:result>valid</c:result>
                            </p:inline>
                        </p:input>
                    </p:identity>
                </p:group>
                <p:catch name="catch">
                    <p:output port="result">
                        <p:pipe port="result" step="xsdneg"/>
                    </p:output>
                    <p:identity name="xsdneg">
                        <p:input port="source">
                            <p:inline>
                                <c:result>invalid</c:result>
                            </p:inline>
                        </p:input>
                    </p:identity>
                </p:catch>
            </p:try>
            <!-- run an instance validation with the generated schematron -->    
            <p:try name="trysch">
                <p:group>
                    <p:output port="result">
                        <p:pipe port="result" step="schpos"/>
                    </p:output>
                    <p:validate-with-schematron assert-valid="true" name="schemavalid">
                        <p:input port="source">
                            <p:pipe port="result" step="instance"/>
                        </p:input>
                        <p:input port="schema">
                            <p:pipe port="result" step="xsd2sch"/>
                        </p:input>
                        <p:input port="parameters">
                            <p:empty/>
                        </p:input>
                    </p:validate-with-schematron>
                    <p:sink/>
                    <p:identity name="schpos">
                        <p:input port="source">
                            <p:inline>
                                <c:result>valid</c:result>
                            </p:inline>
                        </p:input>
                    </p:identity>
                </p:group>
                <p:catch name="catchsch">
                    <p:output port="result">
                        <p:pipe port="result" step="schneg"/>
                    </p:output>
                    <p:identity name="schneg">
                        <p:input port="source">
                            <p:inline>
                                <c:result>invalid</c:result>
                            </p:inline>
                        </p:input>
                    </p:identity>
                </p:catch>
            </p:try>
            <!-- Compare the results of the two validations -->
            <p:compare name="compare">
                <p:input port="source">
                    <p:pipe port="result" step="tryxsd"/>
                </p:input>
                <p:input port="alternate">
                    <p:pipe port="result" step="trysch"/>
                </p:input>
                <p:with-option name="fail-if-not-equal" select="'false'">
                    <p:empty/>
                </p:with-option>
            </p:compare>

            <!-- Generate a report per test -->
            <p:xslt name="xslt">
                <p:input port="source">
                    <p:pipe port="result" step="compare"/>
                </p:input>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                            version="1.0">
                            <xsl:output indent="yes"/>
                            <xsl:param name="xml"/>
                            <xsl:param name="schresult"/>
                            <xsl:param name="file"/>
                            <xsl:template match="/">
                                <file>
                                    <name>
                                        <xsl:value-of select="$xml"/>
                                    </name>
                                    <testing>
                                        <xsl:value-of
                                            select="doc($file)/wts:testSet/wts:testGroup[wts:instanceTest/wts:instanceDocument/@xlink:href = concat('../',$xml)]/wts:annotation/wts:documentation"
                                        />
                                    </testing>
                                    <expectedresult>
                                        <xsl:value-of
                                            select="doc($file)/wts:testSet/wts:testGroup/wts:instanceTest[wts:instanceDocument/@xlink:href = concat('../',$xml)]/wts:expected/@validity"
                                        />
                                    </expectedresult>
                                    <schematronresult>
                                        <xsl:value-of select="$schresult"/>
                                    </schematronresult>
                                    <sameresults>
                                        <xsl:value-of select="c:result"/>
                                    </sameresults>
                                </file>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
                <p:with-param name="xml" select="$xml">
                    <p:empty/>
                </p:with-param>
                <p:with-param name="schresult" select="c:result">
                    <p:pipe port="result" step="trysch"/>
                </p:with-param>
                <p:with-param name="file" select="$path">
                    <p:empty/>
                </p:with-param>
            </p:xslt>
        </p:for-each>
        
        <!-- Generate report per file -->
        <p:wrap-sequence name="wrap" wrapper="report">
            <p:input port="source">
                <p:pipe port="result" step="testloop"/>
            </p:input>
        </p:wrap-sequence>
        
        <p:choose name="output">
            <p:when test="/descendant::file">
                <p:xslt>
                    <p:input port="stylesheet">
                        <p:document href="convert.xslt"/>
                    </p:input>
                    <p:input port="parameters">
                        <p:empty/>
                    </p:input>
                </p:xslt>
            </p:when>
            <p:otherwise>
                <p:identity>
                    <p:input port="source">
                        <p:inline>
                            <html>
                                <body>No instance validation in this collection.</body>
                            </html>
                        </p:inline>
                    </p:input>
                </p:identity>
            </p:otherwise>
        </p:choose>
        <!-- Store the report on the file system -->
        <p:store name="store">
            <p:with-option name="href"
                select="concat('../results/',substring-before($file,'.'),'_report','.html')">
                <p:empty/>
            </p:with-option>
        </p:store>
    </p:for-each>
   
</p:declare-step>
