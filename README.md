**This repository was archived and made read-only on 1 October 2020.**

**At that time, new applications of Schematron were advised to use the SchXslt Schematron implementation at https://github.com/schxslt/schxslt. The list of currently known Schematron implementations is maintained in the 'Awesome Schematron' repository at https://github.com/Schematron/awesome-schematron#software.**

# schematron [![Release](https://img.shields.io/github/release/schematron/schematron.svg)](https://github.com/schematron/schematron/releases/latest)
This is the most recent version of the "skeleton" XSLT implementation of ISO Schematron by Rick Jelliffe and many others. 
Notable early contributions were made by Oliver Becker and his students. 

It is a library of XSLT scripts suitable for embedding in applications or servers, or running from command shells. 
There is a version for XSLT1 and one for XSLT2. There is an XSLT API to allow easy integration, but most popular is to use the
generated output XML documents which use the flat SVRL (Schematron Validation Reporting Language) defined as part of ISO Schematron.

This Open Source software was first released in 2000, and has had various homes since them: xml.ascc.net (Academia Sinica, Taiwan), 
Schematron.com (Rick Jelliffe's information site, courtesy Allette Systems), GoogleCode and now GitHub. There are several other 
minor forks of Schematron on the web: as at January 2017, this site is Rick's "official" distribution site for the code. 

Status: The code has tracked the various versions of Schematron from version 1.1 to ISO Schematron 2006 and draft ISO Schematron 
2nd edition  (now ISO Schematron 2016). The scripts are currently being checked against the released ISO Schematron 2016 
International Standard to confirm conformance, and to merge various bug fixes and enhancements that have been requested over the last decade. 

## Bugs and Limitations

As of October 2020 this implementation is not conformant to the ISO specification with regards to the following requirements:

- The language tag of a diagnostic is not copied to the SVRL output.
- Property references are not copied to the SVRL output.
- The xsl:copy-of instruction is not executed inside a sch:property element.
- The sch:name element with a @path attribute does not expand into the value of evaluating the expression in @path.
- An xsl:key element cannot contain a sequence constructor.
- A variable defined for a phase is not scoped to this phase, but has global scope.
- A variable defined for a patter is not scoped to this pattern, but has global scope.
- The rule context cannot be a comment node.
- The rule context cannot be a processing instruction node.
- A subordinate document expressions cannot contain a variable.
- A rule can extend an abstract rule that is defined in a different pattern.

