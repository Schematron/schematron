# Running Schematron with GNOME xsltproc #

```
#!/bin/bash

echo Step1 ...
xsltproc iso_dsdl_include.xsl $1 > step1.xsl

echo Step2 ...
xsltproc iso_abstract_expand.xsl step1.xsl > step2.xsl

echo Step3 ...
xsltproc iso_svrl_for_xslt1.xsl step2.xsl > step3.xsl

echo Validation ...
xsltproc step3.xsl $2 > result.svrl 
```

Source: post by Marco Ciriacks on [[comp.text.xml](http://groups.google.com/group/comp.text.xml/browse_thread/thread/c71e04dffd97c3e7/eb86f0b5a1c0551?pli=1)