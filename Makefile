# ---------------------------------------------------------------
# Build the FLEX scanner in C++ mode (same commands as slide 42)
#   make            -> build scanner/scanner
#   make run        -> run it on tests/input_minimal.txt
#   make test       -> run it on every file in tests/
#   make clean
# ---------------------------------------------------------------
FLEX     ?= flex
CXX      ?= g++
CXXFLAGS ?= -std=c++17 -Wall
LDLIBS   ?= -lfl

# macOS + Homebrew: brew's flex is "keg-only", so point at it explicitly
ifeq ($(shell uname),Darwin)
  BREW_FLEX := $(shell brew --prefix flex 2>/dev/null)
  ifneq ($(BREW_FLEX),)
    FLEX      := $(BREW_FLEX)/bin/flex
    CXXFLAGS  += -I$(BREW_FLEX)/include
    LDFLAGS   += -L$(BREW_FLEX)/lib
  endif
endif

SCANNER = scanner/scanner

all: $(SCANNER)

scanner/lex.yy.cc: scanner/scanner.l
	cd scanner && $(FLEX) --c++ scanner.l

$(SCANNER): scanner/lex.yy.cc
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

run: $(SCANNER)
	./$(SCANNER) < tests/input_minimal.txt

test: $(SCANNER)
	@for f in tests/*.txt; do \
	  echo "=============== $$f ==============="; \
	  ./$(SCANNER) < $$f; \
	done

clean:
	rm -f scanner/lex.yy.cc $(SCANNER)

.PHONY: all run test clean
