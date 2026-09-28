# isep-compiler-tp

Compiler project for the *Formal Approaches, Languages and Compilers* course at ISEP.
The goal is to compile a small C++-like language into NASM, over 4 sessions.

We're at **TP01**: the grammar (EBNF) and the scanner (flex).

- `grammar/grammar.txt` - the grammar
- `scanner/scanner.l` - the flex scanner (C++ mode)
- `tests/` - small programs to test with
- `docs/report.md` - our report

## How to run

You need flex (`brew install flex` on mac, `sudo apt-get install flex` on linux).

```
cd scanner
flex --c++ scanner.l
g++ -o scanner lex.yy.cc -lfl
./scanner < ../tests/input_minimal.txt
```

or just `make run` from the root. `make check` runs all the tests.

On mac, if `-lfl` doesn't work, remove it; it still compiles because we use `noyywrap`.

## What the language supports

- `int a;`, `int a = 5, b;`
- `a = b + 2 * c;`, `a += 1;`, `a -= 1;`, `a++;`, `a--;`
- `if (...) { } else { }`, `while (...) { }`, `for (i = 0; i < 10; i++) { }`
- comparisons `== != < <= > >=`, logic `&& || !`
- `print(a);` and `prints("hello");`
- `// comments` and `/* comments */`
