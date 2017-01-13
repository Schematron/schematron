<!--
  This schema file is used for testing the Schematron Ant task
  
  @author Christophe Lauret
  @version 4 January 2007
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:grunt="http:jpierpointgruntfuttock.com" 
    grunt:someAttribute="TEST ON THE SCHEMA"
    xml:lang="en">

  <title>Dog Stuff</title>
  <p class="info"  grunt:someAttribute="TEST ON THE P" xml:lang="en"> hi <span class="person">everyone!</span> </p>
  <pattern grunt:someAttribute="TEST ON THE PATTERN"> 
     <rule context="Dog"  grunt:someAttribute="TEST ON THE RULE">
     	<assert grunt:someAttribute="TEST ON THE ASSERT" diagnostics="d1"
     		test="count(leg) = 4">A <span xml:lang="en" class="doggy"
     		    grunt:someAttribute="TEST ON THE SPAN" >dog</span> should have four legs, because then they can have four paws.</assert>
     	<report  grunt:someAttribute="TEST ON THE REPORT"  
     		test="count(leg) &lt; 3">A dog with less than three legs is unstable</report>
     </rule>
     <rule context="Dog/leg">
     	<assert test="count(paw) = 1">Each dog's leg should have a single paw, as an element or attribute, because this meets the business requirement "Dog must be walkable".</assert>
     </rule>
  </pattern>
  
  
  <diagnostics>
  	<diagnostic id="d1"  grunt:someAttribute="TEST ON THE DIAGNOSTIC"> This was in the file:
  	   <value-of select=" $archiveDirParameter "/>
  	   <value-of select=" $archiveNameParameter "/>
  	   <value-of select=" $fileDirParameter "/>
  	   <value-of select=" $fileNameParameter "/>
  	 </diagnostic>
  	</diagnostics> 
</schema>