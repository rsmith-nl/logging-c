# Define the C compiler to be used, if not the default cc.
#CC = gcc13

# The next lines are for debug builds.
CFLAGS = -pipe -std=c11 -fPIC -g3 -Wall -Wextra -Wstrict-prototypes -Wpedantic \
		-Wshadow-all -Wmissing-field-initializers -Wpointer-arith \
		-fsanitize=address,undefined
LFLAGS += -s -pipe -fmerge-constants -fsanitize=address,undefined

# The next lines are for release builds.
#CFLAGS = -Os -pipe -std=c11 -fPIC -ffast-math -march=native
#CFLAGS += -DNDEBUG=1
#LFLAGS = -s -pipe -fmerge-constants -flto

# Extra libraries to be linked.
LIBS += 

# Where to search for additional header files.
#HDIRS = -I/usr/X11R6/include

# Where to install the library and header file.
# THESE SHOULD BE CHECKED AND CHANGED IF NECESSARY!
LDEST = /usr/local/lib
HDEST = /usr/local/include
MDEST = /usr/local/share/man/man3

# 'lib' wil be prepended automagically to the basename.
# for libfoo.so.0.1.2 the basename is foo, version_major is 0,
# version_minor is 1 and patchlevel is 2.
BASENAME      = logging
VERSION_MAJOR = 2026
VERSION_MINOR = 02
PATCHLEVEL    = 18

# Name of the library header file.
HDRS = logging.h

# list of source files
SRC = logging.c

# Name of the manual pages.
MPAGES = .3

# Regular files to include in the distribution
DISTFILES = Makefile README LICENSE $(MPAGES)

# Name and source of the test program
TEST = _test
TESTSRC = $(TEST).c

# Extra stuff to add into the distribution.
XTRA_DIST = 

##### No editing necessary beyond this point ####
.SUFFIXES:
.SUFFIXES: .c .o .3 .txt .pdf .html

.PHONY:	clean help all shared static install_shared install_static \
install uninstall dist is_root check_dir log depend

NUM2 = $(VERSION_MAJOR).$(VERSION_MINOR)
NUM3 = $(VERSION_MAJOR).$(VERSION_MINOR).$(PATCHLEVEL)
SHARED = lib$(BASENAME).so.$(NUM3)
STATIC = lib$(BASENAME).a
PKGDIR = lib$(BASENAME)-$(NUM3)
TARFILE = lib$(BASENAME)-$(NUM3).tar.gz
OBJS = $(SRC:.c=.o)
LOG = ChangeLog

INSTALL   = install

# This is the default target.
help::
	@echo "Command  Meaning"
	@echo "-------  -------"
	@sed -n -e '/##/s/:.*\#\# /\t/p' -e '/@sed/d' Makefile

static: $(STATIC)  ## Build static library
shared: $(SHARED)  ## Build shared library
all: $(SHARED) $(STATIC)  ## Build static and shared library
test: $(TEST)  ## Build a test program

$(SHARED): $(OBJS)
	$(CC) -shared -Wl,-soname,lib$(BASENAME).so.$(VERSION_MAJOR) \
	-o $(SHARED) $(OBJS) $(LIBS)

$(STATIC): $(OBJS)
	ar crus $(STATIC) $(OBJS)

$(TEST): $(TESTSRC) $(STATIC)
	$(CC) -o $(TEST) $(TESTSRC) $(STATIC)

clean:  ## Remove all generated files
	-rm -f $(OBJS) core *~ $(SHARED) $(STATIC) $(TARFILE) \
	$(LOG) $(TEST) $(MPAGES:.3=.ps) \
	$(MPAGES:.3=.txt) $(MPAGES:.3=.html)

.PHONY: style
style:  ## Reformat source code using astyle.
	astyle -n *.c *.h

.PHONY: tidy
tidy:  ## Run static code checker clang-tidy.
	clang-tidy19 --use-color --quiet *.c *.h --

# Check if the user has root privileges.
is_root:;
	@if [ `id -u` != 0 ]; then \
		echo "You must be root to install the library!"; \
		exit 1; \
	fi

# Check if the install directory isn't the current directory.
check_dir:;
	@if [ $(LDEST) = . -o $(HDEST) = . ]; then \
		echo "Can't install in current directory!";\
		exit 1; \
	fi

install_hdr: $(HDRS)  ## Install the header files
	list='$(HDRS)'; \
	for i in $$list; do \
		rm -f $(MDEST)/$$i; \
		$(INSTALL) -m 644 $$i $(MDEST); \
	done

install_man: $(MPAGES)  ## Install the manual pages
	list='$(MPAGES)'; \
	for i in $$list; do \
		rm -f $(MDEST)/$$i; \
		$(INSTALL) -m 644 $$i $(MDEST); \
	done

install_shared: $(SHARED) is_root check_dir install_hdr install_man  ## Install the shared library
   # Remove the old library.
	rm -f $(LDEST)/$(SHARED)
	rm -f $(LDEST)/lib$(BASENAME).so.$(VERSION_MAJOR)
	rm -f $(LDEST)/lib$(BASENAME).so
   # Install new library and make the usual links.
	$(INSTALL) -m 755 $(SHARED) $(LDEST) ; cd $(LDEST) ;\
	ln -s $(SHARED) lib$(BASENAME).so.$(VERSION_MAJOR) ;\
	ln -s $(SHARED) lib$(BASENAME).so

install_static: $(STATIC) is_root check_dir install_hdr install_man  ## Install the static library
   # Remove the old library.
	rm -f $(LDEST)/$(STATIC)
   # Install new library.
	$(INSTALL) -m 644 $(STATIC) $(LDEST)

install: install_shared install_static ## Installs both libraries

.PHONY: uninstall
uninstall: is_root  ## Remove the installed libraries, header and man-page
	rm -f $(LDEST)/$(SHARED)
	rm -f $(LDEST)/$(STATIC)
	rm -f $(LDEST)/lib$(BASENAME).so.$(VERSION_MAJOR)
	rm -f $(LDEST)/lib$(BASENAME).so
	list='$(HDRS)'; \
	for i in $$list; do \
		rm -f $(HDEST)/$$i; \
	done
	list='$(MPAGES)'; \
	for i in $$list; do \
		rm -f $(MDEST)/$$i; \
	done

dist: $(LOG)  ## Make a source distribution file.
	rm -rf $(PKGDIR)
	mkdir -p $(PKGDIR)
	cp $(DISTFILES) $(XTRA_DIST) *.c *.h $(PKGDIR)
	tar -czf $(TARFILE) $(PKGDIR)
	rm -rf $(PKGDIR)

pdf: $(MPAGES:.3=.ps)  ## Manual pages in PDF format

txt: $(MPAGES:.3=.txt)  ## Manual pages in utf-8 text format

html: $(MPAGES:.3=.html) ## Manual pages in html format

# Implicit rule (is needed because of HDIRS!)
.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) $(HDIRS) -c -o $@ $<

.3.pdf:
	mandoc -Tpdf -mdoc $< >$@

.3.txt:
	mandoc -Tlatin1 -mdoc $< >$@

.3.html:
	mandoc -Thtml -mdoc $< >$@
