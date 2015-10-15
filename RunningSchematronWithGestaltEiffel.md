# Running Schematron with Gestalt Eiffel #

```
c:\users\ricko\documents\gestalt-win32-1-0\gestalt.exe  iso_dsdl_include.xsl test\include\master.xml > temp\includeOut-eiffel.xml
c:\users\ricko\documents\gestalt-win32-1-0\gestalt.exe  iso_abstract_expand.xsl test\abstract\abstract-test.sch > temp\abstract-test-eiffel.xml 
c:\users\ricko\documents\gestalt-win32-1-0\gestalt.exe  iso_svrl_for_xslt2.xsl test\schematron\universalTests-xslt2.sch > temp\universalTests_eiffel_xslt2.xsl 
c:\users\ricko\documents\gestalt-win32-1-0\gestalt.exe  temp\universalTests_eiffel_xslt2.xsl test\include\data.xml > temp\universalTests-eiffel-xslt2.svrl
```