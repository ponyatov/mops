# var
MODULE = $(notdir $(CURDIR))

# version
JQUERY_VER       = 3.7.1
JQUERY_UI        = 1.13.2
JQUERY_THEME     = dark-hive
JQUERY_THEME_VER = 1.12.1

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

gz: static/cdn/jquery.js static/cdn/jquery-ui.js \
	static/cdn/$(JQUERY_THEME).css

static/cdn/jquery.js:
	$(CURL) $@ https://code.jquery.com/jquery-$(JQUERY_VER).min.js
static/cdn/jquery-ui.js:
	$(CURL) $@ https://code.jquery.com/ui/$(JQUERY_UI)/jquery-ui.min.js
static/cdn/$(JQUERY_THEME).css:
	$(CURL) $@ https://code.jquery.com/ui/$(JQUERY_UI)/themes/$(JQUERY_THEME)/jquery-ui.css
