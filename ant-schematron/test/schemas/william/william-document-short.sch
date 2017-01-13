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
      
    </sch:pattern>
    <!-- pattern has name. 2nd last rule value of path is wrong.  change to reports to true() -->
</sch:schema>
