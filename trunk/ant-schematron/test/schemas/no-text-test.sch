<!--
  This schema file is used for testing the Schematron Ant task

  Empty assertions.
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>Dog Stuff</title>
  <p> hi </p>
  <pattern> 
     <rule context="Dog">
     	<assert test="count(leg) = 4"></assert>
     	<report test="count(leg) &lt; 3"></report></rule>
     <rule context="Dog/leg">
     	<assert test="count(paw) = 1"></assert>
     </rule>
  </pattern>
</schema>