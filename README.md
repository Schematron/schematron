# schematron
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
