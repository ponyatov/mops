# var
MODULE  = $(notdir $(CURDIR))
module  = $(shell echo $(MODULE) | tr A-Z a-z)
OS      = $(shell uname -o|tr / _)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES  ?= $(shell grep processor /proc/cpuinfo | wc -l)

# version
JQUERY_VER       = 3.7.1
JQUERY_UI        = 1.13.2
JQUERY_THEME     = dark-hive
JQUERY_THEME_VER = 1.12.1

# CONFIG = mini
# CONFIG = webface
CONFIG = grid

# dir
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz

# tool
CURL = curl -L -o
DC   = dmd
DUB  = /usr/bin/dub
BLD  = $(DUB) build --compiler=$(DC) -c $(CONFIG)
RUN  = $(DUB) run   --compiler=$(DC) -c $(CONFIG)

# src
D += $(wildcard src/*.d) $(wildcard grid/src/*.d)
J += $(wildcard *.json)  $(wildcard grid/*.json)
T += $(wildcard views/*.dt)

# all
.PHONY: all run
all: bin/$(MODULE)
run: $(D) $(J) $(T)
	DISPLAY=:1 $(RUN)

.PHONY: grid
grid: $(D) $(J) $(T) Makefile
	dub run :grid

.PHONY: X
X:
	Xephyr -br -ac -noreset -screen 420x240 :1

# format
.PHONY: format
format: tmp/format_d
tmp/format_d: $(D)
	$(RUN) dfmt -- -i $? && touch $@

# rule
bin/$(MODULE): $(D) $(J) $(T) Makefile
	$(BLD)

# doc
doc: doc/yazyk_programmirovaniya_d.pdf doc/Programming_in_D.pdf \
     doc/BuildWebAppsinVibe.pdf doc/BuildTimekeepWithVibe.pdf

doc/yazyk_programmirovaniya_d.pdf:
	$(CURL) $@ https://www.k0d.cc/storage/books/D/yazyk_programmirovaniya_d.pdf
doc/Programming_in_D.pdf:
	$(CURL) $@ http://ddili.org/ders/d.en/Programming_in_D.pdf
doc/BuildWebAppsinVibe.pdf:
	$(CURL) $@ https://raw.githubusercontent.com/reyvaleza/vibed/main/BuildWebAppsinVibe.pdf
doc/BuildTimekeepWithVibe.pdf:
	$(CURL) $@ https://raw.githubusercontent.com/reyvaleza/vibed/main/BuildTimekeepWithVibe.pdf

# install
.PHONY: install update gz
install: doc gz
	$(MAKE) update
	dub fetch dfmt
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`

gz: \
    static/cdn/jquery.js static/cdn/jquery-ui.js \
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
