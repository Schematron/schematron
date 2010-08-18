<sch:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" queryBinding="xslt2"><sch:title>ISO Schematron schema of W3C XML Schema
	       </sch:title><!--
		Schematron schema generated from XSD schema files by xsd2sch v0.4.
		See http://www.topologi.com/
		--><sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/><sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/><sch:p class="ul">sch =
						http://purl.oclc.org/dsdl/schematron</sch:p><!--
	 ================================  
	 ================================  
	 PHASES
	 ================================ 
	 ================================  
	 --><sch:phase id="phase-namespace-ns1"><sch:active pattern="Simple_Types-ns1">
					This active reference the pattern that check simpleTypes for namespace ns1</sch:active><sch:active pattern="Elements-ns1">
					This active reference the pattern that check Elements for namespace ns1</sch:active><sch:active pattern="Attributes-ns1">
					This active reference the pattern that check Attributes for namespace ns1</sch:active><sch:active pattern="IDs_and_Keys">
					This active reference the pattern that check IDs_and_Keys for namespace ns1</sch:active><sch:p>This is the Phase that has all patterns for namespace:ns1.
				
				</sch:p></sch:phase><sch:phase id="phase-all-simpletypes"><sch:active pattern="Simple_Types-ns1">
					This active reference the pattern that check Simple_Types for namespace ns1</sch:active><sch:p>This is the Phase that has all patterns for SimpleTypes.</sch:p></sch:phase><sch:phase id="phase-all-elements"><sch:active pattern="Elements-ns1">
					This active reference the pattern that check Elements for namespace ns1</sch:active><sch:p>This is the Phase that has all patterns for Elements.</sch:p></sch:phase><sch:phase id="phase-all-attributes"><sch:active pattern="Attributes-ns1">
					This active reference the pattern that check Attributes for namespace ns1</sch:active><sch:p>This is the Phase that has all patterns for Global Attributes.</sch:p></sch:phase><sch:phase id="phase-all-idkeyref"><sch:active pattern="IDs_and_Keys">
				This active reference the pattern that check ID Key REFS..			
			</sch:active><sch:p>This is the Phase that has all patterns for ID Key REFS.</sch:p></sch:phase><sch:phase id="phase-typo"><sch:active pattern="Element_Name_Typo">
				Pattern for checking for typos in element names.
			</sch:active><sch:active pattern="Attribute_Name_Typo">
				Pattern for checking for typos in attribute names.
			</sch:active><sch:p>This phase has all the patterns for checking typos in names.</sch:p></sch:phase><sch:phase id="phase-allowed"><sch:active pattern="Element_Name_Allowed">
				Pattern for checking for Expected in Elements names.
			</sch:active><sch:active pattern="Attribute_Name_Allowed">
				Pattern for checking for Expected in attribute names.
			</sch:active><sch:active pattern="Allowed_Followers">
				Pattern for checking for checking following siblings
			</sch:active><sch:p>This phase has all the patterns for checking Expected in names.</sch:p></sch:phase><sch:phase id="phase-required"><sch:active pattern="Element_Name_Required">
				Pattern for checking for Required in Elements names.
			</sch:active><sch:active pattern="Attribute_Name_Required">
				Pattern for checking for Required in attribute names.
			</sch:active><sch:active pattern="Required_Immediate_Followers">
				Pattern for checking when one element is always followed by another. 
			</sch:active><sch:p>This phase has all the patterns for checking Required in names.</sch:p></sch:phase><!--
			============================================================
			============================================================
			                     SIMPLE TYPES
			============================================================
			============================================================
		--><!--
			============================================================ 
			                     SIMPLE TYPES 
			============================================================ 
		--><sch:pattern id="Simple_Types-ns1"><sch:title>Simple Types constraints</sch:title><sch:p>This pattern implements XSD simple type validation
					 (which do not belong to any namespace.)</sch:p><sch:rule abstract="true" id="NoDataContent-ns1"><sch:assert test="string-length(normalize-space(string-join(text(), ''))) = 0" diagnostics="unexpected-content">Element "<sch:name/>" should have no text content.</sch:assert></sch:rule><sch:rule abstract="true" id="NoElementContent-ns1"><sch:assert test="count(*|processing-instruction()|comment()) = 0" diagnostics="d1">Element "<sch:name/>" should be completely empty (no XML comments, PIs, or elements).</sch:assert></sch:rule><sch:rule abstract="true" id="NoContents-ns1"><sch:extends rule="NoDataContent-ns1"/><sch:extends rule="NoDataContent-ns1"/><sch:assert test="count(processing-instruction()|comment()) = 0" diagnostics="d1">Element "<sch:name/>" should be completely empty (no XML comments, PIs).</sch:assert></sch:rule><!--
		 ============================================== 
	--><!--
		 W3C XML SCHEMAS SIMPLE TYPES - PRIMITIVE TYPES 
		 One abstract rule per type.                   
	--><!--
		 ============================================== 
	--><sch:rule abstract="true" id="ns1-xsd-datatype-anyAtomicType"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:anyAtomicType" diagnostics="anyAtomicType-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"anyAtomicType".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-anyURI"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:anyURI" diagnostics="anyURI-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"anyURI".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-anySimpleType"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:anySimpleType" diagnostics="anySimpleType-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"anySimpleType".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-anyType"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:anyType" diagnostics="anyType-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"anyType".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-base64Binary"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:base64Binary" diagnostics="base64Binary-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"base64Binary".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-boolean"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:boolean" diagnostics="boolean-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"boolean".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-date"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:date" diagnostics="date-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"date".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-dateTime"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:dateTime" diagnostics="dateTime-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"dateTime".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-dayTimeDuration"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:dayTimeDuration" diagnostics="dayTimeDuration-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"dayTimeDuration".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-decimal"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:decimal" diagnostics="decimal-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"decimal".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-double"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:double" diagnostics="double-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"double".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-duration"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:duration" diagnostics="duration-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"duration".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-gDay"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:gDay" diagnostics="gDay-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"gDay".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-gMonth"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:gMonth" diagnostics="gMonth-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"gMonth".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-gMonthDay"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:gMonthDay" diagnostics="gMonthDay-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"gMonthDay".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-gYear"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:gYear" diagnostics="gYear-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"gYear".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-gYearMonth"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:gYearMonth" diagnostics="gYearMonth-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"gYearMonth".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-hexBinary"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:hexBinary" diagnostics="hexBinary-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"hexBinary".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-integer"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:integer" diagnostics="integer-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"integer".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-QName"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:QName" diagnostics="QName-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"QName".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-string"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="true()" diagnostics="string-diagnostic">"<sch:name/>" elements or attributes should have value of type "string".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-time"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:time" diagnostics="time-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"time".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-untyped"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:untyped" diagnostics="untyped-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"untyped".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-untypedAtomic"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:untypedAtomic" diagnostics="untypedAtomic-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"untypedAtomic".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-yearMonthDuration"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:yearMonthDuration" diagnostics="yearMonthDuration-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"yearMonthDuration".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-byte"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:byte" diagnostics="byte-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"byte".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-ENTITIES"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:ENTITIES" diagnostics="ENTITIES-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"ENTITIES".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-ENTITY"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:ENTITY" diagnostics="ENTITY-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"ENTITY".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-float"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:float" diagnostics="float-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"float".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-ID"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:ID" diagnostics="ID-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"ID".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-IDREF"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:IDREF" diagnostics="IDREF-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"IDREF".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-int"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:int" diagnostics="int-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"int".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-language"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:language" diagnostics="language-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"language".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-long"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:long" diagnostics="long-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"long".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-Name"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:Name" diagnostics="Name-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"Name".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-NCName"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:NCName" diagnostics="NCName-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"NCName".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-negativeInteger"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:negativeInteger" diagnostics="negativeInteger-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"negativeInteger".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-NMTOKEN"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:NMTOKEN" diagnostics="NMTOKEN-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"NMTOKEN".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-nonNegativeInteger"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:nonNegativeInteger" diagnostics="nonNegativeInteger-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"nonNegativeInteger".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-nonPositiveInteger"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:nonPositiveInteger" diagnostics="nonPositiveInteger-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"nonPositiveInteger".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-normalizedString"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:normalizedString" diagnostics="normalizedString-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"normalizedString".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-NOTATION"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:NOTATION" diagnostics="NOTATION-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"NOTATION".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-positiveInteger"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:positiveInteger" diagnostics="positiveInteger-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"positiveInteger".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-short"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:short" diagnostics="short-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"short".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-token"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:token" diagnostics="token-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"token".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-unsignedByte"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:unsignedByte" diagnostics="unsignedByte-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"unsignedByte".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-unsignedInt"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:unsignedInt" diagnostics="unsignedInt-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"unsignedInt".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-unsignedLong"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:unsignedLong" diagnostics="unsignedLong-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"unsignedLong".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-unsignedShort"><sch:let name="norm" value="normalize-space(.)"/><sch:assert test="$norm castable as xs:unsignedShort" diagnostics="unsignedShort-diagnostic">"<sch:name/>"  elements or attributes should have a value of type"unsignedShort".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-IDREFS"><sch:assert test="true()">"<sch:name/>"  elements or attributes should have a value of type "IDREFS".</sch:assert></sch:rule><sch:rule abstract="true" id="ns1-xsd-datatype-NMTOKENS"><sch:assert test="true()">"<sch:name/>"  elements or attributes should have value of type "NMTOKENS".</sch:assert></sch:rule><!--
		 ============================================== 
		 W3C XML SCHEMAS SIMPLE TYPES - END             
		 ==============================================   
	--></sch:pattern><!--
			============================================================
			============================================================
                                   ELEMENTS 
			============================================================
			============================================================
		--><!--
			============================================================ 
			                     ELEMENTS namespace 
			=========================================================== 
			--><sch:pattern id="Elements-ns1"><sch:title>Element constraints for elements in no namespace </sch:title><!--Local declarations--><!--Global declarations--></sch:pattern><!--
			============================================================
			============================================================
                             Ref Global ATTRIBUTES 
			============================================================
			============================================================
		--><sch:pattern id="Attributes-ns1"><sch:title>Attributes Ref Global Attributes constraints for Namespaces: </sch:title></sch:pattern><!--
			============================================================
			============================================================
		                    ID, IDREF, KEY and KEYREF
			============================================================
			============================================================
		--><sch:pattern id="IDs_and_Keys"><sch:title>IDs, Keys and References</sch:title><!--
	 ================================ 
	 CHECK IDS 
	 ================================ 
	 --></sch:pattern><!--
			============================================================
			============================================================
		                          ELEMENT NAMES 
			============================================================
			============================================================
		--><sch:pattern id="Element_Name_Typo"><sch:title>Typos in Element Names</sch:title><!--
	 ================================
	PASS OK ELEMENT NAMES
	================================ --><sch:rule id="DefinedElement" abstract="true"><sch:assert test="true()">The element name "<sch:name/>" is defined.</sch:assert></sch:rule><sch:rule context="root"><sch:extends rule="DefinedElement"/></sch:rule><!--
	 ================================ 
	FIND ELEMENT NAMES THAT ARE CLOSE 
	 ================================ 
	--><sch:rule context="*[upper-case(local-name())=upper-case(&#34;root&#34;)]"><sch:report test="true()" role="Note">The unexpected element "<sch:name/>" has been used, which is close to an
				element in the schema: the element "root". 
				</sch:report></sch:rule><!-- 
	================================ 
	REPORT UNKNOWN ELEMENT NAMES
	 ================================ 
	 --><sch:rule context="*"><sch:report test="true()" diagnostics="typo-element">Only elements declared in the schema may be used.</sch:report></sch:rule></sch:pattern><sch:pattern id="Element_Name_Allowed"><sch:title>Elements alowed in Parent</sch:title><!--
	
	 ================================
	 CHECK CHILD ELEMENTS 
	 ================================ 
	 --><!--
	 ================================ 
	CHECK GLOBAL ELEMENTS (ROOT)
	 ================================
	 Because we already check all the elements that can appear in particular context, 
	 global element declarations can be used for elements that can appear as the
	 root (or in wildcarded uses).
	  --><sch:rule id="GlobalElement" abstract="true"><sch:assert test="true()">The "<sch:name/>" element is allowed as the root element.</sch:assert></sch:rule><sch:rule context="/root"><sch:extends rule="GlobalElement"/></sch:rule><!-- 
	================================ 
	 REPORT ELEMENTS IN UNEXPECTED POSITIONS
	 ================================ 
	--><sch:rule context="*"><sch:report test="true()" diagnostics="expected-element">Elements are only allowed in the document in particular parent elements.</sch:report></sch:rule></sch:pattern><!--
			============================================================
			============================================================
	                         Attributes NAMES
			============================================================
			============================================================
		--><sch:pattern id="Attribute_Name_Typo"><sch:title>Typos in Attributes names</sch:title><!--
	 ================================ 
	 PASS OK ATTRIBUTE NAMES  
	 ================================
	  --><!--
	 ================================ 
	 REPORT UNKNOWN ATTRIBUTE NAMES 
	 ================================ 
	 --><sch:rule context="*/@*"><sch:report test="true()" diagnostics="typo-attribute">Typo: Only attributes declared in the schema may be used.</sch:report></sch:rule></sch:pattern><sch:pattern id="Attribute_Name_Allowed"><sch:title>Attributes allowed on Parent</sch:title><!-- 
	================================ 
	CHECK POSSIBLE ATTRIBUTES 
	 ================================ 
	 --><sch:rule context="*/@*"><sch:report test="true()" diagnostics="expected-attribute">Only attributes declared in the schema may be used.</sch:report></sch:rule></sch:pattern><!--
			============================================================
			============================================================
	                         OCCURRENCE
			============================================================
			============================================================
		--><sch:pattern id="Element_Name_Required"><sch:title>Required Elements</sch:title><!--
	 ================================ 
	CHECK REQUIRED ELEMENTS 
	 ================================ 
	 --></sch:pattern><sch:pattern id="Attribute_Name_Required"><sch:title>Required Attributes</sch:title><!--
	 ================================ 
	 CHECK REQUIRED ATTRIBUTES 
	 ================================
	 --></sch:pattern><sch:pattern id="Allowed_Followers"><sch:title>Allowed Followers</sch:title><!--
	 ======================================== 
	CHECK FOLLOWING ELEMENTS - PARTIAL ORDER
	 ======================================== 
	 Partial ordering: Element B comes after element A if
	   1) They have same parent element (same content model)  AND EITHER
	   
	   2) B is in a repeating branch which has A under it OR
	         	loosely ancestor-or-self::*[@maxOccurs > 1]//element
	   3) B is under a  following particle of a sequence which has A under it.
	          loosely ancestor::sequence/following-sibling::*//element
	   Note that 2) and 3) are not mutually exclusive.  (This may fall over
	   when the same element appears on multiple paths?)  
	   
	   This does not check requirement constraints.		
	   		
	 --></sch:pattern><sch:pattern id="Required_Immediate_Followers"><sch:title>Required Immediate Followers (Simple)</sch:title></sch:pattern><!--
			============================================================
			============================================================
                                 DIAGNOSTICS 
			============================================================
			============================================================
		--><sch:diagnostics><sch:diagnostic id="d1">This content was found: "" or this element "<sch:value-of select="*/name()"/>".</sch:diagnostic><sch:diagnostic id="typo-element">This element was found: "<sch:value-of select="name()"/>" in "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic><sch:diagnostic id="typo-attribute">This attribute was found: "<sch:value-of select="name()"/>" on "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic><sch:diagnostic id="expected-element">This element was found: "<sch:value-of select="name()"/>" in "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic><sch:diagnostic id="expected-attribute">This attribute was found: "<sch:value-of select="name()"/>" on "<sch:value-of select="parent::*/name()"/>".</sch:diagnostic><sch:diagnostic id="unexpected-immediate-follower">This element was found: "<sch:value-of select="following-sibling::*[1]/name()"/>".</sch:diagnostic><sch:diagnostic id="unexpected-content">This content was found: "<sch:value-of select="text()"/>".</sch:diagnostic><!--Generating Diagnostics for xs:all/elements --><!-- 
	================================ 
	DIAGNOSTICS FOR STANDARD DATATYPES 
	 ================================ 
	 --><sch:diagnostic id="anyAtomicType-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:anyAtomicType datatypes.</sch:diagnostic><sch:diagnostic id="anyURI-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:anyURI datatypes.</sch:diagnostic><sch:diagnostic id="anySimpleType-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:anySimpleType datatypes.</sch:diagnostic><sch:diagnostic id="anyType-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:anyType datatypes.</sch:diagnostic><sch:diagnostic id="base64Binary-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:base64Binary datatypes.</sch:diagnostic><sch:diagnostic id="boolean-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:boolean datatypes.</sch:diagnostic><sch:diagnostic id="date-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:date datatypes.</sch:diagnostic><sch:diagnostic id="dateTime-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:dateTime datatypes.</sch:diagnostic><sch:diagnostic id="dayTimeDuration-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:dayTimeDuration datatypes.</sch:diagnostic><sch:diagnostic id="decimal-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:decimal datatypes.</sch:diagnostic><sch:diagnostic id="double-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:double datatypes.</sch:diagnostic><sch:diagnostic id="duration-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:duration datatypes.</sch:diagnostic><sch:diagnostic id="gDay-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:gDay datatypes.</sch:diagnostic><sch:diagnostic id="gMonth-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:gMonth datatypes.</sch:diagnostic><sch:diagnostic id="gMonthDay-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:gMonthDay datatypes.</sch:diagnostic><sch:diagnostic id="gYear-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:gYear datatypes.</sch:diagnostic><sch:diagnostic id="gYearMonth-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:gYearMonth datatypes.</sch:diagnostic><sch:diagnostic id="hexBinary-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:hexBinary datatypes.</sch:diagnostic><sch:diagnostic id="integer-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:integer datatypes.</sch:diagnostic><sch:diagnostic id="QName-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:QName datatypes.</sch:diagnostic><sch:diagnostic id="string-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:string datatypes.</sch:diagnostic><sch:diagnostic id="time-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:time datatypes.</sch:diagnostic><sch:diagnostic id="untyped-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:untyped datatypes.</sch:diagnostic><sch:diagnostic id="untypedAtomic-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:untypedAtomic datatypes.</sch:diagnostic><sch:diagnostic id="yearMonthDuration-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:yearMonthDuration datatypes.</sch:diagnostic><sch:diagnostic id="byte-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:byte datatypes.</sch:diagnostic><sch:diagnostic id="ENTITIES-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:ENTITIES datatypes.</sch:diagnostic><sch:diagnostic id="ENTITY-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:ENTITY datatypes.</sch:diagnostic><sch:diagnostic id="float-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:float datatypes.</sch:diagnostic><sch:diagnostic id="ID-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:ID datatypes.</sch:diagnostic><sch:diagnostic id="IDREF-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:IDREF datatypes.</sch:diagnostic><sch:diagnostic id="int-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:int datatypes.</sch:diagnostic><sch:diagnostic id="language-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:language datatypes.</sch:diagnostic><sch:diagnostic id="long-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:long datatypes.</sch:diagnostic><sch:diagnostic id="Name-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:Name datatypes.</sch:diagnostic><sch:diagnostic id="NCName-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:NCName datatypes.</sch:diagnostic><sch:diagnostic id="negativeInteger-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:negativeInteger datatypes.</sch:diagnostic><sch:diagnostic id="NMTOKEN-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:NMTOKEN datatypes.</sch:diagnostic><sch:diagnostic id="nonNegativeInteger-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:nonNegativeInteger datatypes.</sch:diagnostic><sch:diagnostic id="nonPositiveInteger-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:nonPositiveInteger datatypes.</sch:diagnostic><sch:diagnostic id="normalizedString-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:normalizedString datatypes.</sch:diagnostic><sch:diagnostic id="NOTATION-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:NOTATION datatypes.</sch:diagnostic><sch:diagnostic id="positiveInteger-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:positiveInteger datatypes.</sch:diagnostic><sch:diagnostic id="short-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:short datatypes.</sch:diagnostic><sch:diagnostic id="token-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:token datatypes.</sch:diagnostic><sch:diagnostic id="unsignedByte-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:unsignedByte datatypes.</sch:diagnostic><sch:diagnostic id="unsignedInt-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:unsignedInt datatypes.</sch:diagnostic><sch:diagnostic id="unsignedLong-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:unsignedLong datatypes.</sch:diagnostic><sch:diagnostic id="unsignedShort-diagnostic">Subsequent Siblings
			 "<sch:value-of select="."/>" is not a value allowed for xs:unsignedShort datatypes.</sch:diagnostic></sch:diagnostics></sch:schema>