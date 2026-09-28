# Team split (2 people)

Each person **owns** one side of the compiler and **reviews** the other side.
The teacher can ask either of us about any part, so reviewing is not optional.

| Stage (slide 7) | Person A — *language / front end* | Person B — *tokens / back end* |
|---|---|---|
| **TP 01** 1. Grammar | ✅ owner — `grammar/grammar.txt` | reviewer |
| **TP 01** 2. Scanner | reviewer | ✅ owner — `scanner/scanner.l`, `tests/`, `Makefile` |
| **TP 01** Report | §1 overview, §2 grammar | §3 scanner, §4 testing |
| 3. Parser (Bison) | ✅ owner | writes the parser test programs |
| 4. AST | ✅ owner | reviewer |
| 5. Intermediate code | reviewer | ✅ owner |
| 6. NASM code generation | reviewer | ✅ owner |
| 7. Executable + final tests | together | together |

Why this split: the grammar and the parser are two views of the same rules, so one person keeps
them consistent. The scanner produces the tokens, and the code generator consumes the final tree.
Person B owns both ends of the pipeline plus the test suite that checks them.

## Presentation prep (both of us)

- A explains to B: EBNF notation, precedence levels (Expression/Term/Factor), why `Assignment` has no `;`, `=` vs `==`.
- B explains to A: the 3 sections of a `.l` file, longest match + first-rule-wins, `%x COMMENT`, error rule, `flex --c++` → `lex.yy.cc`.

## Git workflow

```bash
git pull                              # always start from the latest main
git switch -c grammar-else-if         # one branch per feature
# ... edit ...
make check                            # must PASS before pushing
git add -A && git commit -m "Grammar: add else-if"
git push -u origin grammar-else-if
gh pr create --fill                   # open a Pull Request
```

The other person reviews the Pull Request on GitHub and merges it. Nobody pushes directly to `main`.
