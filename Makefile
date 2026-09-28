# make / make run / make test / make check / make clean

FLEX ?= flex
CXX ?= g++
CXXFLAGS ?= -Wall
LDLIBS ?= -lfl

# brew installs flex in its own folder on mac
ifeq ($(shell uname),Darwin)
  BREW_FLEX := $(shell brew --prefix flex 2>/dev/null)
  ifneq ($(BREW_FLEX),)
    FLEX := $(BREW_FLEX)/bin/flex
    CXXFLAGS += -I$(BREW_FLEX)/include
    LDFLAGS += -L$(BREW_FLEX)/lib
  endif
endif

all: scanner/scanner

scanner/lex.yy.cc: scanner/scanner.l
	cd scanner && $(FLEX) --c++ scanner.l

scanner/scanner: scanner/lex.yy.cc
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

run: scanner/scanner
	./scanner/scanner < tests/input_minimal.txt

test: scanner/scanner
	@for f in tests/*.txt; do echo "--- $$f"; ./scanner/scanner < $$f; done

# compares the output with tests/expected/, the errors file must fail
check: scanner/scanner
	@ok=1; \
	for e in tests/expected/*.out; do \
	  f=tests/$$(basename $$e .out).txt; \
	  if ./scanner/scanner < $$f | diff -q - $$e > /dev/null; then echo "ok    $$f"; \
	  else echo "FAIL  $$f"; ok=0; fi; \
	done; \
	if ./scanner/scanner < tests/input_errors.txt > /dev/null 2>&1; then echo "FAIL  tests/input_errors.txt"; ok=0; \
	else echo "ok    tests/input_errors.txt"; fi; \
	[ $$ok -eq 1 ]

clean:
	rm -f scanner/lex.yy.cc scanner/scanner

.PHONY: all run test check clean
