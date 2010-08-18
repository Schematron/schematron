<xs:schema xmlns:xs='http://www.w3.org/2001/XMLSchema' 
elementFormDefault="unqualified"
>

<xs:complexType name="personName">
  <xs:sequence>
   <xs:element name="title" minOccurs="0"/>
   <xs:element name="forename" minOccurs="0" maxOccurs="unbounded"/>
  </xs:sequence>
 </xs:complexType>

</xs:schema>
