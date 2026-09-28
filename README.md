# ISEP Compiler Project — TP 01: Grammar & Lexical Analysis

Pseudo-C++ → NASM compiler, built step by step over 4 sessions.
This repo covers **TP 01**: Task 01 (grammar in EBNF) and Task 02 (scanner with FLEX, C++ mode).

**Deadline: 12/10/2026** — submit on Teams.

```
.
├── grammar/grammar.txt     Task 01 — EBNF grammar (deliverable: .txt)
├── scanner/scanner.l       Task 02 — FLEX scanner (deliverable: scanner.l)
├── tests/*.txt             pseudo-code input files
├── docs/report.md          1–2 page report (export to PDF)
└── Makefile                build / run / test helpers
```

## 0. Setup (macOS)

```bash
brew install flex          # slide 41
xcode-select --install     # gives you g++ (clang) if you don't have it
```

## 1. Build & run

Exactly like slide 42 (this is how the teacher will test it):

```bash
cd scanner
flex --c++ scanner.l
g++ -o scanner lex.yy.cc -lfl        # on Mac, if -lfl fails, drop it (see note)
./scanner < ../tests/input_minimal.txt
```

Or with the Makefile from the repo root: `make`, `make run`, `make test`, `make clean`.

> **Mac note:** Homebrew's flex is "keg-only". The Makefile finds it automatically.
> By hand: `$(brew --prefix flex)/bin/flex --c++ scanner.l` and
> `g++ -I$(brew --prefix flex)/include -o scanner lex.yy.cc -L$(brew --prefix flex)/lib -lfl`.
> `scanner.l` uses `%option noyywrap`, so it also links **without** `-lfl`.

## 2. The plan — work in this order

### Step 1 — Task 01, minimum grammar (write it yourself)
Open `grammar/grammar.txt`. Section 1 is done as an example. Fill every `TODO`
in sections 1–4, in this order:

1. Terminals: `Integer`, `String`, `CompareOp`, `AddOp`, `MulOp`
2. `Program`, `StatementList`, `Statement`
3. `Assignment`, `IfStatement`, `WhileStatement`, `PrintStatement`, `Block`
4. `Condition`, `Expression`, `Term`, `Factor`

Self-check: can you derive `var1 = var1 - var2;` and `while (var1 > var2) { ... }`
from `Program` by hand? If yes, your grammar covers them.

Commit: `git commit -am "Task 01: minimum grammar"`

### Step 2 — Task 02, minimum scanner
Build it now (`make run`): the skeleton already compiles, and every
`LEXICAL ERROR` it prints is a token you still have to add. Fill the `TODO`s in
`scanner/scanner.l` until `make test` shows **no errors** on
`input_minimal.txt`, `input_slide39.txt` and `input_all_operators.txt`
(`input_errors.txt` *should* still show errors — that's its job).

Compare your output on `input_slide39.txt` with slide 39.

Commit: `git commit -am "Task 02: minimum scanner"`

### Step 3 — Extensions (slide 22, needed for a grade above the pass mark)
Add to both grammar and scanner: `int x = 0;`, `//` and `/* */` comments,
`++ -- += -=`, `for`, `&& || !`. Target: `input_extensions.txt` scans with no errors.
Commit after each feature.

### Step 4 — Report (max 2 pages, `docs/report.md`)
Explain your design choices, not just the rules. Export to PDF.

## 3. Things you must be able to explain (the teacher will ask)

- Why `Expression / Term / Factor` gives `*` higher priority than `+`
- Why keywords come **before** `{ID}` in the scanner (tie → first rule wins)
- Why `>=` is one token and not `>` then `=` (longest match)
- Difference between `=` (assignment) and `==` (comparison)
- What the three sections of a `.l` file do and what `flex --c++` generates
- What the scanner does vs. what the parser will do (tokens vs. rules)
