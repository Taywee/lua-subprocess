.POSIX:

INSTALL ?= install
ASCIIDOC ?= asciidoc
SOURCES := subprocess.c liolib-copy.c
OBJECTS = $(SOURCES:.c=.o)
VERSION := 0.02
DISTDIR := lua-subprocess-$(VERSION)
DISTFILES := Makefile $(SOURCES) liolib-copy.h subprocess.txt subprocess.html

lua_package := lua
INSTALL_CMOD := $(shell pkg-config --variable=INSTALL_CMOD $(lua_package))
ifeq ($(INSTALL_CMOD),)
lua_package := lua5.1
INSTALL_CMOD := $(shell pkg-config --variable=INSTALL_CMOD $(lua_package))
endif

ifeq ($(INSTALL_CMOD),)
$(error Lua package not found)
endif

CFLAGS ?= -Wall -Wextra -pedantic -O2
LUA_CFLAGS := $(shell pkg-config --cflags --libs $(lua_package))

.PHONY: all
all: subprocess.a

subprocess.a: $(OBJECTS)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $(LUA_CFLAGS) -DOS_POSIX -shared -fPIC -o $@ $<

.PHONY: clean
clean:
	$(RM) subprocess.a $(OBJECTS)
