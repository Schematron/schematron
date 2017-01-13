<?xml version="1.0"?>


<?xml-stylesheet type="text/xsl" href="../../iso_abstract_expand.xsl"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
			xmlns="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
    <sch:ns prefix="html" uri="http://www.w3.org/1999/xhtml"  />
    <sch:ns prefix="cals" uri="dummy"  />
  <!-- See
      http://www-128.ibm.com/developerworks/xml/library/x-stron.html
      
		However, note that ISO Schematron uses @name and @value attributes on
		the iso:param element, and @id not @name on the pattern element.
  -->
  
   <!-- Simple test of abstract schemas -->
  <pattern abstract="true" id="table" >
     <rule context="$table">
      <assert test="$row">A table has at least one row</assert>
    </rule>
    <rule context="$row">
      <assert test="$cell">A table row has at least one cell</assert>
    </rule>
  </pattern>
 
   
		<pattern id="htmlTable" is-a="table">
			<param name="row" value="html:tr"/>
			<param name="cell" value="html:td" />
			<param name="table" value="html:table" />
		</pattern>
 
   <pattern id="cals-table" is-a="table">
    <param name="table" value="cals:table"/>
    <param name="row"  value="cals:tbody/cals:row"/>
    <param name="cell"  value="cals:entry"/>
  </pattern>
 
</sch:schema> 