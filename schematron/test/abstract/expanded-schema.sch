<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:ns prefix="html" uri="http://www.w3.org/1999/xhtml"/>
    <sch:ns prefix="cals" uri="dummy"/>
  
  
   
  <!--Suppressed abstract pattern table was here-->
 
   
		<!--Start pattern based on abstract table--><pattern id="htmlTable">
     <rule context="html:table">
      <assert test="html:tr">A table has at least one row</assert>
    </rule>
    <rule context="html:tr">
      <assert test="html:td">A table row has at least one cell</assert>
    </rule>
  </pattern>
 
   <!--Start pattern based on abstract table--><pattern id="cals-table">
     <rule context="cals:table">
      <assert test="cals:tbody/cals:row">A table has at least one row</assert>
    </rule>
    <rule context="cals:tbody/cals:row">
      <assert test="cals:entry">A table row has at least one cell</assert>
    </rule>
  </pattern>
 
</sch:schema>