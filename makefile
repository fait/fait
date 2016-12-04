export SHELL := /bin/bash
mk-files = $(shell find . -name '*.mk')
md-files = $(patsubst docs/core/%, docs/%, $(patsubst ./%.mk, docs/%.mk.md, $(mk-files)))

main: docs
	cd docs ;\
	git pull ;\
	git add -A ;\
	git commit -m "update" ;\
	git push

	git add docs
	git commit -m "update docs"

docs: $(md-files)

docs/%.mk.md: %.mk
	mkdir -p $(@D)
	node process-docs.js $< > $@

docs/%.mk.md: docs/core/%.mk.md
	mv $< $@