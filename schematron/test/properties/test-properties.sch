
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:zzz="zzzz"
	queryLanguageBinding="xslt2">

  <title>Dog Stuff</title>
  <p> hi </p>
  <pattern> 
     <rule context="Dog" id="r1"  xml:lang="xx" zzz:xxxx="AAAAA" 
         properties="dog-species  faithful" >
     	<assert test="count(leg) = 4"  id="a1"
     	   properties="graceful">A dog should have four legs, because then they can have four paws.</assert>
     	<report test="count(leg) &lt; 3">A dog with less than three legs is unstable</report>
     </rule>
     <rule context="Dog/leg" id="r2">
     	<assert test="count(paw) = 1">Each dog's leg should have a single paw, as an element or attribute, because this meets the business requirement "Dog must be walkable".</assert>
     </rule>
  </pattern>
  
  
  <properties> 
    <property id="dog-species" name="species" value="canine" />
    <property id="graceful" name="gait"><gait xmlns="">Graceful</gait></property>
    <property id="faithful" name="nature">faithful</property>
    
  </properties>
</schema>