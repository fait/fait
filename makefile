export SHELL := /bin/bash
mk-files = $(shell find . -name '*.mk')
md-files = $(patsubst docs/core/%, docs/%, $(patsubst ./%.mk, docs/%.mk.md, $(mk-files)))

main: docs
	cd docs ;\
	git pull ;\
	git add -A ;\
	git commit -am "update" ;\
	git push

	git commit -am "update docs"

docs: $(md-files)

docs/%.mk.md: %.mk
	mkdir -p $(@D)
	tail +8 < $< | sed 's/^\([^#]\)/    \1/ ; s/^# *//' > $@

docs/%.mk.md: docs/core/%.mk.md
	mv $< $@