This site has code for four related projects:

  * `schematron`: ISO Schematron validators {XSLT1 and XSLT2}
  * `converters` including Schematron embedded in XSD or RELAX NG, and pretty printing
  * `ant_schematron`: Ant Task for Schematron {Java}
  * `XSD2SCH`: XML Schemas to Schematron converter {XSLT2}

The site is under construction, for activation in later July 2010. Currently it is only loaded with the distributions for these projects, the source code and some of the test files: in particular, the various build scripts are not ported yet.

---

# ISO Schematron #
ISO Schematron is a validation and reporting language, based on the presence or absence of XPaths in one or more XML documents. It has an emphasis on human-understandability and simplicity of use and implementation.

Schematron is an ISO standard frequently used to complement ISO RELAX NG grammars.

The ISO standard is available for free download at the ISO website: see http://www.schematron.com for details and many links to tutorials, adopters and related material. The code here tracks the proposed new version of the ISO Standardhttp://www.itscj.ipsj.or.jp/sc34/open/1419.pdf.

## Implementation History ##

Status: Released.
(Note test and build files on system are being loaded currently and should not work.)

This open source implementation was started by Rick Jelliffe at Academia Sinica, Taiwan, in 1999, and has been maintained over the years with many contributions from an active user community. It is usually called the "skeleton" implementation, the "Academia Sinica" implementation, or the "unofficial reference" implementation.

Rick Jelliffe would also like to acknowledge the contributions of Academia Sinica Computing Centre, Geotempo Inc, Allette Systems and Topologi in supporting this project in the past decade. The initial version and pre-processors were developed by Rick Jelliffe. The skeleton/meta-stylesheet system was contributed by Oliver Becker. For license details, see the [wiki](http://code.google.com/p/schematron/wiki/ContributorLicensingGrants).

## Implementation Structure ##

The implementation consists of

  * preprocessor XSLT scripts (XML macro processors) for various kinds of inclusions and expansions,

  * a '''skeleton''' XSLT scripts which implements Schematron, with

  * various '''meta-stylesheets''' which are XSLT scripts that invoke the skeleton but provide specific output routines for different purposes,

  * localization files to allow generic error messages in different languages,


There are three distributions of the implementation: ISO Schematron for XSLT2 engines, ISO Schematron for XSLT1 engines, and a legacy distribution of Schematron 1.6 for XSLT1. The legacy distribution is obsolete and users of Schematron 1.5 or 1.6 (which has XML namespace http://www.ascc.net/xml/schematron) should adopt ISO Schematron (which has the XML namespace http://purl.oclc.org/dsdl/schematron.)

---

# Converters #

These are various scripts that help integrate Schematron into other systems.

## Implementation History ##

  * Embedded Schematron extractors for RELAX NG and XSD. Status: released
  * ISO CRDL preprocessor to generate Schematron. Status: early beta, probably not correct
  * ISO SVRL to HTML pretty-printer: Status: released
  * HTML to Schematron converter: Status: unknown
  * Schematron to ISO 9573-11 converter: Status: released

## Implementation Structure ##

XSLT or XSLT scripts.


---

# Ant Task for Schematron #

An ANT file which implements Schematron validation and report generation. Generate SVRL and use it as part of a pipeline!

## Implementation History ##

Status: Released.
(Note test and build files on system are being loaded currently and should not work.)

This subproject was developed at Allete Systems for WebOrganics. Programmers for Allette Systems included Christophe Lauret, Willy Eskalim and Rick Jelliffe.

There have been three versions:

  * The first version implemented Schematron 1.5 with plain text output.
  * The second version implemented ISO Schematron with SVRL output
  * This third version implemented more ISO Schematron with SVRL and text output, and many more options.

## Implementation Structure ##

The Ant task is a Java jar file.

The file has grown beyond its original design: it seems that half the code is just shuffling the arguments into an different object. I want (me or someone) to rewrite this in Scala.

---

# XSD to Schematron Converter #

Converts a series of XML Schemas files to Schematron.

The code is documented with [a long series of blogs](http://broadcast.oreilly.com/2009/03/post-1.html) on O'Reilly.com.

## Implementation History ##

Status: beta
(Note build files on system are being loaded currently and should not work. An existing test suite using the W3C XML Schema test suite is kindly being made available in August (expected) by its maintainer.)

This project was initially funded by JSTOR and Allette Systems. Developers for Allette have included Rick Jelliffe, Rahul Grewel and Cheney Xin.

## Implementation Structure ##

The implementation is a pipeline of XSLT2 scripts. All the component files of the XML schemas are combined into a single file, various references are resolved (denormalized), then outputs are converted.

---

# Contributors solicited #
It is hoped that this site will provide an opportunity for better management and participation in Schematron now it is mature, and a home for the various scattered independent runners for Schematron.

One very easy way to contribute is to make new non-English version of the help messages: translators welcome. There is only about 25 of these error messages.