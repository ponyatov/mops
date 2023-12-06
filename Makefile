# var
MODULE = $(notdir $(CURDIR))

# version
JQUERY_VER       = 3.7.1
JQUERY_UI        = 1.13.2
JQUERY_THEME     = dark-hive
JQUERY_THEME_VER = 1.12.1

# dir
GZ = $(HOME)/gz

# tool
CURL = curl -L -o

# src
D += $(wildcard src/*.d)
J += $(wildcard *.json)
T += $(wildcard views/*.dt)

# all
.PHONY: all run
all: bin/$(MODULE)
run: $(D) $(J) $(T)
	dub run

# rule
bin/$(MODULE): $(D) $(J) $(T)
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

static/cdn/jquery-ui.js: $(GZ)/jquery-ui-$(JQUERY_UI).zip
	unzip $< -d tmp
	cp tmp/jquery-ui-$(JQUERY_UI)/jquery-ui.min.js $@
	touch $@
	rm -r tmp/jquery-ui-$(JQUERY_UI)
static/cdn/$(JQUERY_THEME).css: $(GZ)/jquery-ui-themes-$(JQUERY_UI).zip
	unzip $< -d tmp
	cp tmp/jquery-ui-themes-$(JQUERY_UI)/themes/$(JQUERY_THEME)/jquery-ui.min.css $@
	cp -r tmp/jquery-ui-themes-$(JQUERY_UI)/themes/$(JQUERY_THEME)/images/* static/cdn/images/
	touch $@
	rm -r tmp/jquery-ui-themes-$(JQUERY_UI)

$(GZ)/jquery-ui-$(JQUERY_UI).zip:
	$(CURL) $@ https://jqueryui.com/resources/download/jquery-ui-$(JQUERY_UI).zip
$(GZ)/jquery-ui-themes-$(JQUERY_UI).zip:
	$(CURL) $@ https://jqueryui.com/resources/download/jquery-ui-themes-$(JQUERY_UI).zip
