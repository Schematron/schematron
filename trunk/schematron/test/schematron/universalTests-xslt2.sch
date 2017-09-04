<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
   queryBinding="xslt2" >
  <sch:title>Universal Tests</sch:title>
  <sch:p>This schema gives the most basic tests for checking an ISO Schematron implementation.
  It does not test the XPath implementation in any significant way, just the basics of assertions,
  rules, patterns, and phases. Use it to "validate" any WF XML document. </sch:p>
  
  <sch:p>The result of running this should be four assertion messages:
 U7, U8, U9, and U10 only.</sch:p>
 
  <sch:phase id="positive">
    <sch:active pattern="p1"/>
  </sch:phase>
  
  <sch:phase id="negative">
    <sch:active pattern="p2"/>
  </sch:phase>
  
  <sch:pattern  id="p1">
     <sch:title>Always True</sch:title>
     
     <sch:rule context="/">
     	<sch:assert test="true()" id="U1">U1: This assertion should never fail.</sch:assert>
     	<sch:report test="false()" id="U2">U2: This report should never succeed.</sch:report>
     </sch:rule>
 
     <sch:rule context="/*">
     	<sch:assert test="true()" id="U3">U3: This assertion should never fail.</sch:assert>
     	<sch:report test="false()" id="U4">U4: This report should never succeed.</sch:report>
     </sch:rule> 
     
     <!-- Test rule fallthrough -->
     <sch:rule context="/*">
     	<sch:assert test="false()" id="U5">U5: This assertion should never succeed because the rule should never fire.</sch:assert>
     	<sch:report test="true()" id="U6">U6: This report should never succeed because the rule should never fire.</sch:report>
     </sch:rule> 
 
  </sch:pattern>
  
  <sch:pattern  id="p2">
     <sch:title>Always False</sch:title>
     
     <sch:rule context="/">
     	<sch:assert test="false()" id="U7">U7: This assertion should always fail.</sch:assert>
     	<sch:report test="true()" id="U8">U8: This report should always succeed.</sch:report>
     </sch:rule>
     
     <sch:rule context="/*">
     	<sch:assert test="false()" id="U9">U9: This assertion should always fail.</sch:assert>
     	<sch:report test="true()" id="U10">U10: This report should always succeed.</sch:report>
     </sch:rule>
     
     <!-- Test rule fallthrough -->
     <sch:rule context="/*">
     	<sch:assert test="false()" id="U11">U11: This assertion should never succeed because the rule should never fire.</sch:assert>
     	<sch:report test="true()" id="U12">U12: This report should never succeeed because the rule should never fire.</sch:report>
     </sch:rule> 
  </sch:pattern>
  
</sch:schema>
