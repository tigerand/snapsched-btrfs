# makefile for snapsched project
PROJ_NAME=snapsched

PROGS=snapsched
LIBS=scheduled snapsched-funcs

PREFIX=/usr/local

INSTALL_BIN=bin
INSTALL_LIB=lib/$(PROJ_NAME)

INSTALLED_PROGS = $(addprefix $(PREFIX)/$(INSTALL_BIN)/,$(PROGS))
INSTALLED_LIBS =  $(addprefix $(PREFIX)/$(INSTALL_LIB)/,$(LIBS))

all:	install

$(PREFIX)/$(INSTALL_LIB):
	mkdir -p $@

$(INSTALLED_PROGS): $(PROGS)
	install -D -o root -g sys -p $(PROGS) $(PREFIX)/$(INSTALL_BIN)

$(INSTALLED_LIBS): $(PREFIX)/$(INSTALL_LIB) $(LIBS)
	install -D -o root -g sys -p -t $(PREFIX)/$(INSTALL_LIB) $(LIBS)

install: $(INSTALLED_PROGS) $(INSTALLED_LIBS)
