# makefile for snapsched project
PROJ_NAME=snapsched

PROGS=snapsched
LIBS=scheduled snapsched-funcs
COMP=ssched.comp

PREFIX=/usr/local

INSTALL_BIN=bin
INSTALL_LIB=lib/$(PROJ_NAME)

INSTALLED_PROGS = $(addprefix $(PREFIX)/$(INSTALL_BIN)/,$(PROGS))
INSTALLED_LIBS =  $(addprefix $(PREFIX)/$(INSTALL_LIB)/,$(LIBS))
INSTALLED_COMP = /etc/bash_completion.d/$(COMP)

all:	install

$(PREFIX)/$(INSTALL_LIB):
	mkdir -p $@

$(INSTALLED_PROGS): $(PROGS)
	install -o root -g sys -p $? $(PREFIX)/$(INSTALL_BIN)

$(INSTALLED_COMP): $(COMP)
	install -o root -g sys -p $? /etc/bash_completion.d

$(PREFIX)/$(INSTALL_LIB)/scheduled: scheduled
	install -D -o root -g sys -p $(@F) $@
$(PREFIX)/$(INSTALL_LIB)/snapsched-funcs: snapsched-funcs
	install -D -o root -g sys -p $(@F) $@

install: $(INSTALLED_PROGS) $(INSTALLED_LIBS) $(INSTALLED_COMP)
