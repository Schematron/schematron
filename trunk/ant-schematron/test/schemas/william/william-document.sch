<?xml version="1.0" encoding="UTF-8"?>
<?xar Schematron?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2" >
    <sch:title>Schema of paths found in sample documents</sch:title>
    <sch:ns prefix="w" uri="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
    <sch:ns prefix="r" uri="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
    <sch:ns prefix="ve" uri="http://schemas.openxmlformats.org/markup-compatibility/2006" />
    <sch:ns prefix="o" uri="urn:schemas-microsoft-com:office:office"/>
    <sch:ns prefix="r" uri="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/> 
		<sch:ns prefix="m" uri="http://schemas.openxmlformats.org/officeDocument/2006/math" /> 
		<sch:ns prefix="v" uri="urn:schemas-microsoft-com:vml" />
		<sch:ns prefix="wp" uri="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" />
		<sch:ns prefix="w10" uri="urn:schemas-microsoft-com:office:word" />
		<sch:ns prefix="w" uri="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
		<sch:ns prefix="wne" uri="http://schemas.microsoft.com/office/word/2006/wordml"/>
		
    <!-- 
        ==========================================================================
        This is a usage schema for the corresponding XML file styles.xml from OOXML.
        This usage schema was generated based on the template provided.
        
        @author Christine Feng
        @author William Liem
        @version 2 July 2009
    
        Copyright (C) 2009 Weborganic Systems Pty. Ltd.
        ==========================================================================
     -->
    
    <sch:pattern id="Elements">
  <!--
        	 Non-ASCII characters
        	 Characters that fall outside of the range of 32-126 inclusive are not printable in the CPI output, so need to be reported on in the error report. This is a non-fatal error. 
            Non-ASCII code: <sch:value-of select="for $s in string-to-codepoints(.) return (codepoints-to-string($s[$s &gt; 128]),$s[$s &gt; 128])" />
            <sch:value-of select="." />
    	-->
 
        <sch:rule context="w:t">
    	   	<sch:assert test="every $s in string-to-codepoints(.) satisfies $s &lt; 128 and $s &gt; 0 or $s = 160">Non ASCII Character:<sch:value-of 
    	   	    select="for $s in string-to-codepoints(.) return 
    	   	         (if  ($s &gt; 127)  then concat($s, ' ')  else '')" /></sch:assert>
    	</sch:rule>  
         
         
        <!-- 
         	 Warning: Tables found
         	 If tables are found in the CMI, an entry should be added to the error report and processing should continue - the error is non-fatal.
        -->
        <sch:rule context="w:tbl[not(descendant::w:p/w:pPr/w:pStyle[starts-with(@w:val,'box')])]">
        	<sch:report test="true()">Tables found</sch:report>
        </sch:rule>
         
        <!--
         	 Images found
         	 If images are found in the CMI, an entry should be added to the error report and processing should continue - the error is non-fatal.
        -->
        
        <sch:rule context="w:drawing">
        	<sch:report test="true()">Pictures found</sch:report>
        </sch:rule>
         
        <!--
    		 Boxed warnings found 	
    		 If boxed warnings are found in the CMI, an entry should be added to the error report and processing should continue - the error is non-fatal.
    	-->
    	<sch:rule context="w:tbl[w:tr/w:tc/w:p/w:pPr/w:p/w:pPr/w:pStyle[starts-with(@w:val,'box')]]">
        	<sch:report test="true()">Boxed warnings found</sch:report>
        </sch:rule>
         
    			
    	<!--
    		 Non-DocX CMI	
    		 If a CMI is not recognised as being a DocX file, an error report should be generated and the status of the CMI should not be advanced - the error is fatal.
    	-->
    	<sch:rule context="/">
    		<sch:assert test="w:document">Document must have a w:document node.
[FATAL] CMI is not a DocX file</sch:assert>
    	</sch:rule>
    		
    	<sch:rule context="w:document">
    		<sch:assert test="w:body">Document must have a w:body
[FATAL] CMI is not a DocX file</sch:assert>
    		
    		<sch:assert test="w:body[w:p and w:sectPr]">Document body must have at least an w:p node and a w:sectPr	
[FATAL] CMI is not a DocX file</sch:assert>			
    	</sch:rule>
		<!--
             Style mismatch 
             Where formatting has been overlaid onto the entire text of a paragraph, an entry should be added to the error report containing the text and processing should continue - the error is non-fatal.
        -->
        <sch:rule context="w:p/w:r/w:rPr/w:rStyle[@w:val='Hyperlink']" ><sch:assert test="true()" /></sch:rule>
		<sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Normal']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='name']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Heading1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Heading2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Heading3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Heading2MAINFIRST']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Heading3FIRST']" ><sch:assert test="true()" /></sch:rule>
        <!-- <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='DefaultParagraphFont']" ><sch:assert test="true()" /></sch:rule>-->
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Caption']" ><sch:assert test="true()" /></sch:rule>
        <!-- <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='TableNormal']" ><sch:assert test="true()" /></sch:rule>-->
        <!-- <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='NoList']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='PlainText']" ><sch:assert test="true()" /></sch:rule>-->
       
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='BodyText']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='BodyText2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='genericname']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='CMI']" ><sch:assert test="true()" /></sch:rule>
        
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Header']" ><sch:assert test="true()" /></sch:rule>
        
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='Footer']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='inst']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expl']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explind']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='cont']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='ListParagraph']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instnum2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explChar']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explindChar']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldotChar']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explnum1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot1Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot2Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot3Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldot3Char1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explind2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdotChar']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot1Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot1Char1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot2Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instind']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot2Char1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot3Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdot3Char1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instind2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='explnum2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instnum1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instnum1Char']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldash1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldash2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='expldash3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdash1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdash2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='instdash3']" ><sch:assert test="true()" /></sch:rule>
        
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpl']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexplind']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexplind2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldot']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldot1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldot2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldot3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldash1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldash2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexpldash3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexplnum1']" ><sch:assert test="true()" /></sch:rule>   
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxexplnum2']" ><sch:assert test="true()" /></sch:rule>
       
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinst']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstind']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstind2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdot']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdot1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdot2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdot3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdash1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdash2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstdash3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstnum1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='boxinstnum2']" ><sch:assert test="true()" /></sch:rule>    
        
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='TOC1']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='TOC2']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val='TOC3']" ><sch:assert test="true()" /></sch:rule>
        <sch:rule context="w:p/w:pPr/w:pStyle[@w:val]">
            <sch:report test="true()">Unexpected kind of paragraph found:<sch:value-of select="../../w:r/w:t"/></sch:report>
        </sch:rule>
        
        <sch:rule context="w:p[not(w:pPr)]">
            <sch:report test="true()">Unexpected kind of paragraph found (no properties):<sch:value-of select="w:r/w:t"/></sch:report>
        </sch:rule>
  
    </sch:pattern>
    <!-- pattern has name. 2nd last rule value of path is wrong.  change to reports to true() -->
</sch:schema>
