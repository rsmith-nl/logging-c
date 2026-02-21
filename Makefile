CFLAGS = -pipe -std=c11 -fPIC -g3 -Wall -Wextra -Wstrict-prototypes -Wpedantic \
	-Wshadow-all -Wmissing-field-initializers -Wpointer-arith

check:  ## checks if the code builds cleanly.
	$(CC) $(CFLAGS) -c logging.c
	rm -f *.o

.PHONY: clean
	rm -f *.o

.PHONY: style
style:  ## Reformat source code using astyle.
	astyle -n *.c *.h

.PHONY: tidy
tidy:  ## Run clang-tidy on the code.
	clang-tidy19 --quiet *.c *.h 2>/dev/null

.PHONY: help
help:  ## List available commands
	@echo "make targets:"
	@sed -n -e '/##/s/:.*\#\#/\t/p' Makefile
	@echo
