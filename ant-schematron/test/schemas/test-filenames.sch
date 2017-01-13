<!--
  This schema file is used for testing the Schematron Ant task
  
  @author Christophe Lauret
  @version 4 January 2007
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>Dog Stuff</title>
  <p> hi </p>
  <pattern> 
     <rule context="Dog">
     	<assert test="count(leg) = 4" diagnostics="d1">A dog should have four legs, because then they can have four paws.</assert>
     	<report test="count(leg) &lt; 3">A dog with less than three legs is unstable</report>
     </rule>
     <rule context="Dog/leg">
     	<assert test="count(paw) = 1">Each dog's leg should have a single paw, as an element or attribute, because this meets the business requirement "Dog must be walkable".</assert>
     </rule>
  </pattern>
  <diagnostics>
  	<diagnostic id="d1"> This was in the file:
  	   <value-of select=" $archiveDirParameter "/>
  	   <value-of select=" $archiveNameParameter "/>
  	   <value-of select=" $fileDirParameter "/>
  	   <value-of select=" $fileNameParameter "/>
  	 </diagnostic>
  	</diagnostics>  
</schema>