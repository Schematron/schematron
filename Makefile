.PHONY: test
test: test-saxon

test-saxon:
	java -jar bin/testsuite-cli.jar -c testsuite.xml -t tests/ -b saxon 2>/dev/null
