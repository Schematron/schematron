<?xml version='1.0'?>
<!-- XML Schema schema for XML Schemas: Part 2: Datatypes -->
<!--
<!DOCTYPE schema PUBLIC "-//W3C//DTD XMLSCHEMA 200010//EN"
	"XMLSchema.dtd" [


	<!ENTITY % schemaAttrs 'xmlns:hfp CDATA #IMPLIED'>

	<!ELEMENT hfp:hasFacet EMPTY>
	<!ATTLIST hfp:hasFacet
		name NMTOKEN #REQUIRED>
		
	<!ELEMENT hfp:hasProperty EMPTY>
	<!ATTLIST hfp:hasProperty
		name NMTOKEN #REQUIRED
		value CDATA #REQUIRED>
	<!ATTLIST simpleType id ID #IMPLIED>
	<!ATTLIST maxExclusive id ID #IMPLIED>
	<!ATTLIST minExclusive id ID #IMPLIED>
	<!ATTLIST maxInclusive id ID #IMPLIED>
	<!ATTLIST minInclusive id ID #IMPLIED>
	<!ATTLIST precision id ID #IMPLIED>
	<!ATTLIST scale id ID #IMPLIED>
	<!ATTLIST length id ID #IMPLIED>
	<!ATTLIST minLength id ID #IMPLIED>
	<!ATTLIST maxLength id ID #IMPLIED>
	<!ATTLIST enumeration id ID #IMPLIED>
	<!ATTLIST pattern id ID #IMPLIED>
	<!ATTLIST appinfo id ID #IMPLIED>
	<!ATTLIST documentation id ID #IMPLIED>
	<!ATTLIST list id ID #IMPLIED>
	<!ATTLIST union id ID #IMPLIED>
	]>

  -->

<schema xmlns="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	targetNamespace="http://www.w3.org/2001/XMLSchema"
	version="$Id: datatypes.xsd,v 1.30 2000/10/24 08:04:50 ht Exp $"
	xmlns:hfp="foo"
	elementFormDefault="qualified">
<!-- aaung    

replace    &XMLSchemaNS;-hasFacetAndProperty  with   foo  
	&XSP2.URI; with foo

-->


  <annotation>
   <documentation xml:lang="en" source="foo">
      The schema corresponding to this document is normative,
      with respect to the syntactic constraints it expresses in the
      XML Schema language.  The documentation (within &lt;documentation>
      elements) below, is not normative, but rather highlights important
      aspects of the W3C Recommendation of which this is a part
    </documentation>
  </annotation>

  <annotation>
    <documentation xml:lang="en">
      First the built-in primitive datatypes.  These definitions are for
      information only, the real built-in definitions are magic.  Note in
      particular that there is no type named 'anySimpleType'.  The
      primitives should really be derived from no type at all, and
      anySimpleType should be derived as a union of all the primitives.
    </documentation>

    <documentation xml:lang="en">
      For each built-in datatype in this schema (both primitive and
      derived) can be uniquely addressed via a URI constructed
      as follows:
        1) the base URI is the URI of the XML Schema namespace
        2) the fragment identifier is the name of the datatype
        
      For example, to address the int datatype, the URI is:
      
        http://www.w3.org/2000/10/XMLSchema#int
      
      Additionally, each facet definition element can be uniquely
      addressed via a URI constructed as follows:
        1) the base URI is the URI of the XML Schema namespace
        2) the fragment identifier is the name of the facet
        
      For example, to address the maxInclusive facet, the URI is:
      
        http://www.w3.org/2000/10/XMLSchema#maxInclusive

      Additionally, each facet usage in a built-in datatype definition
      can be uniquely addressed via a URI constructed as follows:
        1) the base URI is the URI of the XML Schema namespace
        2) the fragment identifier is the name of the datatype, followed
           by a period (".") followed by the name of the facet
        
      For example, to address the usage of the maxInclusive facet in
      the definition of int, the URI is:
      
        http://www.w3.org/2000/10/XMLSchema#int.maxInclusive
        
    </documentation>
  </annotation>
 
  <simpleType name="string" id="string">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality" value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
		source="http://www.w3.org/TR/xmlschema-2/#string"/>
    </annotation>
    <restriction base="anySimpleType" />
  </simpleType>

  <simpleType name="boolean" id="boolean">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality" value="finite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#boolean"/>
    </annotation>
    <restriction base="anySimpleType" />
  </simpleType>

  <simpleType name="float" id="float">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="total"/>
        <hfp:hasProperty name="bounded" value="true"/>
        <hfp:hasProperty name="cardinality" value="finite"/>
        <hfp:hasProperty name="numeric" value="true"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#float"/>
    </annotation>
    <restriction base="anySimpleType"/>
  </simpleType>

  <simpleType name="double" id="double">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="total"/>
        <hfp:hasProperty name="bounded" value="true"/>
        <hfp:hasProperty name="cardinality" value="finite"/>
        <hfp:hasProperty name="numeric" value="true"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#double"/>
    </annotation>
    <restriction base="anySimpleType">
    </restriction>
  </simpleType>

  <simpleType name="decimal" id="decimal">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="precision"/>
        <hfp:hasFacet name="scale"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="total"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="true"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#decimal"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
   </simpleType>

   <simpleType name="duration" id="duration">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#duration"/>
    </annotation>
    <restriction base="anySimpleType">
      

    </restriction>
   </simpleType>

 <simpleType name="dateTime" id="dateTime">
    <annotation>
    <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#dateTime"/>
    </annotation>
    <restriction base="anySimpleType">
    </restriction>
  </simpleType>

  <simpleType name="time" id="time">
    <annotation>
    <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#time"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
  </simpleType>

  <simpleType name="date" id="date">
   <annotation>
    <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#date"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
  </simpleType>

  <simpleType name="yearMonth" id="yearMonth">
   <annotation>
    <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#yearMonth"/>
    </annotation>
    <restriction base="anySimpleType">
     
    </restriction>
  </simpleType>

  <simpleType name="year" id="year">
    <annotation>
    <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#year"/>
    </annotation>
    <restriction base="anySimpleType">
      
    </restriction>
  </simpleType>

 <simpleType name="monthDay" id="monthDay">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
       <documentation xml:lang="en"
       	source="http://www.w3.org/TR/xmlschema-2/#monthDay"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
  </simpleType>

  <simpleType name="day" id="day">
    <annotation>
  <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#day"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
  </simpleType>

 <simpleType name="month" id="month">
    <annotation>
  <appinfo>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasFacet name="maxInclusive"/>
        <hfp:hasFacet name="maxExclusive"/>
        <hfp:hasFacet name="minInclusive"/>
        <hfp:hasFacet name="minExclusive"/>
        <hfp:hasProperty name="ordered" value="partial"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#month"/>
    </annotation>
    <restriction base="anySimpleType">
 
    </restriction>
  </simpleType>

   <simpleType name="hexBinary" id="hexBinary">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#binary"/>
    </annotation>
    <restriction base="anySimpleType">
    </restriction>
   </simpleType>

  <simpleType name="base64Binary" id="bae64Binary">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#binary"/>
    </annotation>
    <restriction base="anySimpleType">

    </restriction>
   </simpleType>

   <simpleType name="anyURI" id="anyURI">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#anyURI"/>
    </annotation>
    <restriction base="anySimpleType">
    </restriction>
   </simpleType>

  <simpleType name="QName" id="QName">
    <annotation>
        <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="pattern"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#QName"/>
    </annotation>
    <restriction base="anySimpleType">
    
    </restriction>
  </simpleType>

  <annotation>
    <documentation xml:lang="en">
      Now the derived primitive types
    </documentation>

  </annotation>

  <simpleType name="normalizedString" id="normalizedString">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#normalizedString"/>
    </annotation>
    <restriction base="string">

    </restriction>
  </simpleType>
  
  <simpleType name="token" id="token">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#token"/>
    </annotation>
    <restriction base="normalizedString">
      <whiteSpace value="collapse" id='token.whiteSpace'/>
    </restriction>
  </simpleType>
  
  <simpleType name="language" id="language">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#language"/>
    </annotation>
    <restriction base="token">
      <pattern
      	value="([a-zA-Z]{2}|[iI]-[a-zA-Z]+|[xX]-[a-zA-Z]+)(-[a-zA-Z]+)*"
      		id="language.pattern">
        <annotation>
          <documentation xml:lang="en"
          	source="http://www.w3.org/TR/REC-xml#NT-LanguageID">
            pattern matches production 33 from the XML spec
          </documentation>
        </annotation>
      </pattern>
    </restriction>
  </simpleType>

  <simpleType name="IDREFS" id="IDREFS">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#IDREFS"/>
    </annotation>
    <restriction>
      <simpleType>
        <list itemType="IDREF"/>    
      </simpleType>
        <minLength value='1' id='IDREFS.minLength'/>
    </restriction>
  </simpleType>

  <simpleType name="ENTITIES" id="ENTITIES">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#ENTITIES"/>
    </annotation>
    <restriction>
      <simpleType>
        <list itemType="ENTITY"/>
      </simpleType>
        <minLength value='1' id='ENTITES.minLength'/>
    </restriction>
  </simpleType>

  <simpleType name="NMTOKEN" id="NMTOKEN">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#NMTOKEN"/>
    </annotation>
    <restriction base="token">
      <pattern value="\c+" id="NMTOKEN.pattern">
        <annotation>
          <documentation xml:lang="en"
          		source="http://www.w3.org/TR/REC-xml#NT-Nmtoken">
            pattern matches production 7 from the XML spec
          </documentation>
        </annotation>
      </pattern>
    </restriction>
  </simpleType>

  <simpleType name="NMTOKENS" id="NMTOKENS">
    <annotation>
      <appinfo>
        <hfp:hasFacet name="length"/>
        <hfp:hasFacet name="minLength"/>
        <hfp:hasFacet name="maxLength"/>
        <hfp:hasFacet name="enumeration"/>
        <hfp:hasFacet name="whiteSpace"/>
        <hfp:hasProperty name="ordered" value="false"/>
        <hfp:hasProperty name="bounded" value="false"/>
        <hfp:hasProperty name="cardinality"
        	value="countably infinite"/>
        <hfp:hasProperty name="numeric" value="false"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#NMTOKENS"/>
    </annotation>
    <restriction>
      <simpleType>
        <list itemType="NMTOKEN"/>
      </simpleType>
        <minLength value='1' id='NMTOKENS.minLength'/>
    </restriction>
  </simpleType>

  <simpleType name="Name" id="Name">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#Name"/>
    </annotation>
    <restriction base="token">
      <pattern value="\i\c*" id="Name.pattern">
        <annotation>
          <documentation xml:lang="en"
          		source="http://www.w3.org/TR/REC-xml#NT-Name">
            pattern matches production 5 from the XML spec
          </documentation>
        </annotation>
      </pattern>
    </restriction>
  </simpleType>

  <simpleType name="NCName" id="NCName">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#NCName"/>
    </annotation>
    <restriction base="Name">
      <pattern value="[\i-[:]][\c-[:]]*" id="NCName.pattern">
        <annotation>
          <documentation xml:lang="en"
          		source="http://www.w3.org/TR/REC-xml-names/#NT-NCName">
            pattern matches production 4 from the Namespaces
            in XML spec
          </documentation>
        </annotation>
      </pattern>
    </restriction>
  </simpleType>

   <simpleType name="ID" id="ID">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#ID"/>
    </annotation>
    <restriction base="NCName"/>
   </simpleType>

   <simpleType name="IDREF" id="IDREF">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#IDREF"/>
    </annotation>
    <restriction base="NCName"/>
   </simpleType>

   <simpleType name="ENTITY" id="ENTITY">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#ENTITY"/>
    </annotation>
    <restriction base="NCName"/>
   </simpleType>

   <simpleType name="NOTATION" id="NOTATION">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#NOTATION"/>
      <documentation xml:lang="en">
        NOTATION cannot be used directly in a schema; rather a type
        must be derived from it by specifying at least one enumeration
        facet whose value is the name of a NOTATION declared in the
        schema.
      </documentation>
      <documentation xml:lang="en">
        the value/lexical spaces of NOTATION are not the full
        value/lexical spaces of NOTATION even though there are
        no additional constraining facets.  The true value/lexical
        spaces are limited to the set of names of NOTATIONs declared
        in the schema.
      </documentation>
    </annotation>
    <restriction base="QName"/>
  </simpleType>

  <simpleType name="integer" id="integer">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#integer"/>
    </annotation>
    <restriction base="decimal">
<!--aaung
      <scale value="0" fixed="true" id="integer.scale"/>
-->
    </restriction>
  </simpleType>

  <simpleType name="nonPositiveInteger" id="nonPositiveInteger">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#nonPositiveInteger"/>
    </annotation>
    <restriction base="integer">
      <maxInclusive value="0" id="nonPositiveInteger.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="negativeInteger" id="negativeInteger">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#negativeInteger"/>
    </annotation>
    <restriction base="nonPositiveInteger">
      <maxInclusive value="-1" id="negativeInteger.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="long" id="long">
    <annotation>
      <appinfo>
        <hfp:hasProperty name="bounded" value="true"/>
        <hfp:hasProperty name="cardinality" value="finite"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#long"/>
    </annotation>
    <restriction base="integer">
      <minInclusive value="-9223372036854775808" id="long.minInclusive"/>
      <maxInclusive value="9223372036854775807" id="long.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="int" id="int">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#int"/>
    </annotation>
    <restriction base="long">
      <minInclusive value="-2147483648" id="int.minInclusive"/>
      <maxInclusive value="2147483647" id="int.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="short" id="short">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#short"/>
    </annotation>
    <restriction base="int">
      <minInclusive value="-32768" id="short.minInclusive"/>
      <maxInclusive value="32767" id="short.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="byte" id="byte">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#byte"/>
    </annotation>
    <restriction base="short">
      <minInclusive value="-128" id="byte.minInclusive"/>
      <maxInclusive value="127" id="byte.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="nonNegativeInteger" id="nonNegativeInteger">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#nonNegativeInteger"/>
    </annotation>
    <restriction base="integer">
      <minInclusive value="0" id="nonNegativeInteger.minInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="unsignedLong" id="unsignedLong">
    <annotation>
      <appinfo>
        <hfp:hasProperty name="bounded" value="true"/>
        <hfp:hasProperty name="cardinality" value="finite"/>
      </appinfo>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#unsignedLong"/>
    </annotation>
    <restriction base="nonNegativeInteger">
      <maxInclusive value="18446744073709551615"
      	id="unsignedLong.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="unsignedInt" id="unsignedInt">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#unsignedInt"/>
    </annotation>
    <restriction base="unsignedLong">
      <maxInclusive value="4294967295"
      	id="unsignedInt.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="unsignedShort" id="unsignedShort">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#unsignedShort"/>
    </annotation>
    <restriction base="unsignedInt">
      <maxInclusive value="65535"
      	id="unsignedShort.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="unsignedByte" id="unsignedBtype">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#unsignedByte"/>
    </annotation>
    <restriction base="unsignedShort">
      <maxInclusive value="255" id="unsignedByte.maxInclusive"/>
    </restriction>
  </simpleType>

  <simpleType name="positiveInteger" id="positiveInteger">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#positiveInteger"/>
    </annotation>
    <restriction base="nonNegativeInteger">
      <minInclusive value="1" id="positiveInteger.minInclusive"/>
    </restriction>
  </simpleType>

  <complexType name="simpleType" abstract="true">
    <complexContent>
      <extension base="annotated">
        <sequence>
          <element ref="simpleDerivation"/>
        </sequence>
        <attribute name="final" type="boolean" default="false"/>
        <attribute name="name" type="NCName">
          <annotation>
            <documentation xml:lang="en">
              Can be restricted to required or forbidden
            </documentation>
          </annotation>
        </attribute>
      </extension>
    </complexContent>
  </complexType>

  <complexType name="topLevelSimpleType">
    <complexContent>
      <restriction base="simpleType">
        <sequence>
          <element ref="annotation" minOccurs="0"/>
          <element ref="simpleDerivation"/>
        </sequence>
        <attribute name="name" use="required" type="NCName">
          <annotation>
            <documentation xml:lang="en">
              Required at the top level
            </documentation>
          </annotation>
        </attribute>   
      </restriction>
    </complexContent>
  </complexType>

  <complexType name="localSimpleType">
    <complexContent>
      <restriction base="simpleType">
        <sequence>
          <element ref="annotation" minOccurs="0"/>
          <element ref="simpleDerivation"/>
        </sequence>
        <attribute name="name" use="prohibited">
          <annotation>
            <documentation xml:lang="en">
              Forbidden when nested
            </documentation>
          </annotation>
        </attribute>   
      </restriction>
    </complexContent>
  </complexType>

<!--aaung
substitutionGroup="redefinable"
-->
  <element name="simpleType" 
  		type="topLevelSimpleType" id="simpleType">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-simpleType"/>
    </annotation>
  </element>

  <element name="simpleDerivation" abstract="true" type="annotated"/>

  <group name="simpleRestrictionModel">
   <sequence>
    <element name="simpleType" type="localSimpleType" minOccurs="0"/>
    <element ref="facet" minOccurs="0" maxOccurs="unbounded"/>
   </sequence>
  </group>

  <element name="restriction" substitutionGroup="simpleDerivation"
  	id="restriction">
   <complexType>
    <annotation>
      <documentation xml:lang="en"
      		source="http://www.w3.org/TR/xmlschema-2/#element-restriction">
          base attribute and simpleType child are mutually
          exclusive, but one or other is required
        </documentation>
      </annotation>
      <complexContent>
        <extension base="annotated">
         <group ref="simpleRestrictionModel"/>
         <attribute name="base" type="QName" use="optional"/>
        </extension>
      </complexContent>
    </complexType>
  </element>

  <element name="list" substitutionGroup="simpleDerivation" id="list">
   <complexType>
    <annotation>
      <documentation xml:lang="en"
      		source="http://www.w3.org/TR/xmlschema-2/#element-list">
          itemType attribute and simpleType child are mutually
          exclusive, but one or other is required
        </documentation>
      </annotation>
      <complexContent>
        <extension base="annotated">
          <sequence>
            <element name="simpleType" type="localSimpleType"
            	minOccurs="0"/>
          </sequence>
          <attribute name="itemType" type="QName" use="optional"/>
        </extension>
      </complexContent>
    </complexType>
  </element>

  <element name="union" substitutionGroup="simpleDerivation" id="union">
   <complexType>
    <annotation>
      <documentation xml:lang="en"
      		source="http://www.w3.org/TR/xmlschema-2/#element-union">
          memberTypes attribute must be non-empty or there must be
          at least one simpleType child
        </documentation>
      </annotation>
      <complexContent>
        <extension base="annotated">
          <sequence>
            <element name="simpleType" type="localSimpleType"
            	minOccurs="0" maxOccurs="unbounded"/>
          </sequence>
          <attribute name="memberTypes" use="optional">
            <simpleType>
              <list itemType="QName"/>
            </simpleType>
          </attribute>
        </extension>
      </complexContent>
    </complexType>
  </element>
  
  <complexType name="facet">
    <complexContent>
      <extension base="annotated">
        <attribute name="value" use="required"/>
        <attribute name="fixed" type="boolean" use="optional"/>
      </extension>
    </complexContent>
  </complexType>

  <element name="facet" type="facet" abstract="true"/>

  <element name="minBound" abstract="true" substitutionGroup="facet"/>

  <element name="minExclusive" id="minExclusive" substitutionGroup="minBound">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-minExclusive"/>
    </annotation>
  </element>
  <element name="minInclusive" id="minInclusive" substitutionGroup="minBound">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-minInclusive"/>
    </annotation>
  </element>

  <element name="maxBound" abstract="true" substitutionGroup="facet"/>

  <element name="maxExclusive" id="maxExclusive" substitutionGroup="maxBound">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-maxExclusive"/>
    </annotation>
  </element>
  <element name="maxInclusive" id="maxInclusive" substitutionGroup="maxBound">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-maxInclusive"/>
    </annotation>
  </element>

  <complexType name="numFacet">
    <complexContent>
      <restriction base="facet">
        <sequence>
          <element ref="annotation" minOccurs="0"/>
        </sequence>
        <attribute name="value" type="nonNegativeInteger"/>
      </restriction>
    </complexContent>
  </complexType>

  <element name="precision" id="precision" substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-precision"/>
    </annotation>
    <complexType>
      <complexContent>
        <restriction base="numFacet">
          <sequence>
            <element ref="annotation" minOccurs="0"/>
          </sequence>
          <attribute name="value" type="positiveInteger"/>
        </restriction>
      </complexContent>
    </complexType>
  </element>
  <element name="scale" id="scale" type="numFacet"
  		substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-scale"/>
    </annotation>
  </element>

  <element name="length" id="length" type="numFacet"
  		substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-length"/>
    </annotation>
  </element>
  <element name="minLength" id="minLength" type="numFacet"
  		substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-minLength"/>
    </annotation>
  </element>
  <element name="maxLength" id="maxLength" type="numFacet"
  		substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-maxLength"/>
    </annotation>
  </element>
<!--
  <element name="encoding" id="encoding" substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-encoding"/>
    </annotation>
    <complexType>
      <complexContent>
        <restriction base="facet">
          <sequence>
            <element ref="annotation" minOccurs="0"/>
          </sequence>
          <attribute name="value">
            <simpleType>
              <restriction base="NMTOKEN">
                <enumeration value="hex">
                  <annotation>
                    <documentation xml:lang="en">
                      each (8-bit) byte is encoded as a sequence
                      of 2 hexidecimal digits
                    </documentation>
                  </annotation>
                </enumeration>
                <enumeration value="base64">
                  <annotation>
                    <documentation xml:lang="en">
                      value is encoded in base64 as defined
                      in RFC 2045
                    </documentation>
                  </annotation>
                </enumeration>
              </restriction>
            </simpleType>
          </attribute>
        </restriction>
      </complexContent>
    </complexType>
  </element>
-->
  <element name="enumeration" id="enumeration" substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-enumeration"/>
    </annotation>
  </element>

  <element name="whiteSpace" id="whiteSpace" substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-whiteSpace"/>
    </annotation>
    <complexType>
      <complexContent>
        <restriction base="facet">
          <sequence>
            <element ref="annotation" minOccurs="0"/>
          </sequence>
          <attribute name="value">
            <simpleType>
              <restriction base="NMTOKEN">
                <enumeration value="preserve"/>
                <enumeration value="replace"/>
                <enumeration value="collapse"/>
              </restriction>
            </simpleType>
          </attribute>
        </restriction>
      </complexContent>
    </complexType>
  </element>

  <element name="pattern" id="pattern" substitutionGroup="facet">
    <annotation>
      <documentation xml:lang="en"
      	source="http://www.w3.org/TR/xmlschema-2/#element-pattern"/>
    </annotation>
  </element>
  
  <simpleType name="anySimpleType" >
	<restriction base="string">
	</restriction>
  </simpleType>


</schema>
