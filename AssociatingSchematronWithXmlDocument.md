# Associating Schematron with XML Document #

The W3C and the ISO working group in charge of ISO Schematron have recently cooperated on a note [Associating Schemas with XML documents 1.0](http://www.w3.org/XML/2010/01/xml-model/).

This note gives a processing instruction that can be put near the start of an XML document, to tell an application, such as an editor, which schema to use. It is hoped that implementers of different editors and applications will make use of this, starting later 2010.

An example of use is

```
 <?xml-model href="xhtml-strict-additional-constraints.sch" 
   group="Strict"
   title="Check against strict document type complex constraints"
   phase="tables" ?>  
```