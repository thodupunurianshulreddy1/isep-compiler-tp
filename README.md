# ISEP Compiler Project — Pseudo-C++ → NASM

Semester project (4 sessions) for *Formal Approaches, Languages and Compilers* at ISEP.
**TP 01 (this stage): grammar in EBNF + lexical analyser with FLEX (C++).** Deadline 12/10/2026.

```
grammar/grammar.txt     Task 01 – EBNF grammar                 (deliverable)
scanner/scanner.l       Task 02 – FLEX scanner, C++ mode       (deliverable)
docs/report.md          1–2 page report                        (deliverable, export to PDF)
tests/input_*.txt       pseudo-code test programs
tests/expected/*.out    expected token output (regression tests)
Makefile                build / run / test
```

## Build & run

```bash
brew install flex            # macOS   (Linux: sudo apt-get install flex)

cd scanner
flex --c++ scanner.l
g++ -o scanner lex.yy.cc -lfl
./scanner < ../tests/input_minimal.txt
```

From the repo root: `make` · `make run` · `make test` · `make check` · `make clean`

> macOS: Homebrew's flex is keg-only; the Makefile finds it automatically. The scanner uses
> `%option noyywrap`, so it also links without `-lfl`.

## Example (slide 39)

```
$ ./scanner < ../tests/input_slide39.txt
WHILE_TOKEN: while
L1_TOKEN: (
VAR_TOKEN: var1
COMPARISON_TOKEN: >
...
```

## Supported language

| Feature | Example |
|---|---|
| Declaration (+ init, multiple) | `int a;` `int i = 0, j;` |
| Assignment / compound | `a = b * 2;` `a += 1;` `a -= 1;` `a++;` `--a;` |
| If / else if / else | `if (a > b) { … } else { … }` |
| While | `while (a != 0) { … }` |
| For | `for (int i = 0; i < 10; i++) { … }` |
| Conditions | `== != < <= > >=` `&& \|\| !` |
| Arithmetic | `+ - * /`, parentheses, unary `-` |
| Output | `print(expr);` `prints("text");` |
| Comments | `// …` `/* … */` |

## Team workflow

See [docs/TEAM.md](docs/TEAM.md) for who owns what and how we use branches.
