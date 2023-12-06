# var
MODULE = $(notdir $(CURDIR))

# tool
CURL = curl -L -o

# src
D += $(wildcard src/*.d)
J += $(wildcard *.json)

# all
.PHONY: all run
all: bin/$(MODULE)
run: $(D) $(J)
	dub run

# rule
bin/$(MODULE): $(D) $(J)
	dub build

# format
.PHONY: format
format: tmp/format_d
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# install
.PHONY: install update gz
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`

gz:
