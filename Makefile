.PHONY: test
test: test-saxon test-xalan test-xsltproc

test-saxon:
	java -jar bin/testsuite-cli.jar -c testsuite.xml -t tests/ -b saxon 2>/dev/null

test-xalan:
	java -jar bin/testsuite-cli.jar -c testsuite.xml -t tests/ -b xalan 2>/dev/null

test-xsltproc:
	java -jar bin/testsuite-cli.jar -c testsuite.xml -t tests/ -b xsltproc 2>/dev/null
