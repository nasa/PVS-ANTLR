ANTLR_VERSION = 4.11.1

all:
	make pvs-parser

pvs-parser: download-antlr
	@echo "\033[0;32m** Generating PvsParser (Java Target) **\033[0m"
	@if [ ! -e "dist" ]; then \
		mkdir dist; \
	fi
	@cd src && java -jar lib/antlr-$(ANTLR_VERSION)-complete.jar -Dlanguage=Java PvsLanguage.g4 -o ../dist/pvs-parser/javaTarget/out
	@cp src/pvs-parser/javaTarget/*.java dist/pvs-parser/javaTarget/out
	# creating manifest file
	@cd dist/pvs-parser/javaTarget/out && echo "Main-Class: PvsParser\nClass-Path: antlr-$(ANTLR_VERSION)-complete.jar\n" > MANIFEST.MF
	@cp src/lib/antlr-$(ANTLR_VERSION)-complete.jar dist
	# creating pvs-parser...
	@cd dist/pvs-parser/javaTarget/out && javac -Xlint -classpath ../../../antlr-$(ANTLR_VERSION)-complete.jar:./ *.java
	# creating jar file...
	@cd dist/pvs-parser/javaTarget/out && jar -cfm PvsParser.jar ./MANIFEST.MF *.class && rm *.class && cd ../../..
	@mv dist/pvs-parser/javaTarget/out/PvsParser.jar dist/
	# removing temporary files...
	@cd dist && rm -r pvs-parser
	@echo "\033[0;32m** Done with generating PvsParser! **\033[0m"
	@echo "\033[0;32m** Usage: \033[0mjava -jar dist/PvsParser.jar <pvs-file>"
	@echo "\033[0;32m** Example: \033[0mjava -jar dist/PvsParser.jar src/pvs-parser/examples/helloworld.pvs"

quick-test-pvs-parser: download-antlr
	@echo "\033[0;32m** Testing PvsParser.jar **\033[0m"
	# Parsing example files in folder src/pvs-parser/examples
	java -jar dist/PvsParser.jar src/pvs-parser/examples/test.pvs src/pvs-parser/examples/helloworld.pvs
	@echo "\033[0;32m** Done with testing! **\033[0m"

test-pvs-parser: download-antlr
	@echo "\033[0;32m** Testing PvsParser.jar **\033[0m"
	# Parsing example files in folder src/pvs-parser/examples
	java -jar dist/PvsParser.jar src/pvs-parser/examples/test.pvs src/pvs-parser/examples/helloworld.pvs src/pvs-parser/examples/alaris2lnewmodes.pvs src/pvs-parser/examples/alaris2lnewmodes.types_and_constants.pvs src/pvs-parser/examples/alaris2lnewmodes.pump.pvs
	@echo "\033[0;32m** Done with testing! **\033[0m"

testrig-pvs-parser: download-antlr
	@echo "\033[0;32m** Testing PvsParser.jar with ANTLR TestRig framework **\033[0m"
	@if [ ! -e "testrig" ]; then \
		mkdir testrig; \
	fi
	@cd src && java -jar lib/antlr-$(ANTLR_VERSION)-complete.jar -Dlanguage=Java PvsLanguage.g4 -o ../testrig/java
	@cd testrig/java && javac -Xlint -classpath ../../src/lib/antlr-$(ANTLR_VERSION)-complete.jar:./ *.java
	@cd testrig/java && java -classpath ../../src/lib/antlr-$(ANTLR_VERSION)-complete.jar:./ org.antlr.v4.gui.TestRig PvsLanguage parse ../../src/pvs-parser/examples/helloworld.pvs -gui
	@rm -r testrig

download-antlr:
	@if [ ! -e "src/lib" ]; then \
		mkdir src/lib; \
	fi
	@if [ ! -e "src/lib/antlr-$(ANTLR_VERSION)-complete.jar" ]; then \
		echo Downloading ANTLR version $(ANTLR_VERSION) from https://www.antlr.org; \
		cd src/lib && $(if $(shell which curl), curl, wget) -O https://www.antlr.org/download/antlr-$(ANTLR_VERSION)-complete.jar; \
	else \
		echo ANTLR version: antlr-$(ANTLR_VERSION)-complete.jar; \
	fi

clean:
	@echo "\033[0;32m** Cleaning folders ... **\033[0m"
	@if [ -e "src/lib" ]; then \
		echo removing ./src/lib; \
		rm -r src/lib; \
	fi
	@if [ -e "src/.antlr" ]; then \
		echo removing ./dist/.antlr; \
		rm -r src/.antlr; \
	fi
	@if [ -e "dist" ]; then \
		echo removing ./dist; \
		rm -r dist; \
	fi
	@echo "\033[0;32m** Done with cleaning! **\033[0m"

