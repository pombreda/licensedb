
all: ns.md ns.rdf

%.md: %.rdf markdown.xsl
	@echo "Generating vocabulary markdown ($@)"
	@xsltproc markdown.xsl $< > $@

%.rdf: %.turtle
	@echo Serializing to $@
	@rapper --quiet --input turtle --output rdfxml-abbrev $< > $@

clean:
	$(RM) ns.md ns.rdf
