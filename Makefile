# vim:fileencoding=utf-8:ft=make
# Use as many jobs as the computer has cores.
.MAKEFLAGS: -j C

CFLAGS = -pipe -std=c99 -Wall -Wextra -Wstrict-prototypes -Wpedantic \
	-Wshadow-all -Wmissing-field-initializers -Wpointer-arith

all: test single_header/logging.h

test: test.c single_header/logging.h
	$(CC) $(CFLAGS) -o test test.c

single_header/logging.h: logging.c logging.h  ## Build single header library (POSIX only).
	cp logging.h single_header/logging.h
	echo "" >>single_header/logging.h
	echo "#ifdef LOGGING_IMPLEMENTATION" >>single_header/logging.h
	tail -n +11 logging.c >>single_header/logging.h
	echo "" >>single_header/logging.h
	echo "#endif // LOGGING_IMPLEMENTATION" >>single_header/logging.h

.PHONY: clean
clean: ## Remove all generated files.
	rm -f *.o test single_header/logging.h

.PHONY: style
style:  ## Reformat source code using astyle.
	astyle -n --style=1tbs -s2 -p --indent-switches --delete-empty-lines --add-braces *.c *.h

.PHONY: tidy
tidy:  ## Run clang-tidy on the code.
	clang-tidy19 --quiet *.c *.h 2>/dev/null

.PHONY: help
help:  ## List available commands
	@echo "make targets:"
	@sed -n -e '/##/s/:.*\#\#/\t/p' Makefile
	@echo
