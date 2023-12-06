MODULE = $(notdir $(CURDIR))

D += $(wildcard src/*.d)
J += $(wildcard *.json)

.PHONY: all run
all: bin/$(MODULE)
bin/$(MODULE): $(D) $(J)
	dub build
run: $(D) $(J)
	sub run

.PHONY: format
format: tmp/format_d
tmp/format_d: $(D)
	dub run dfmt -- $? && touch $@
