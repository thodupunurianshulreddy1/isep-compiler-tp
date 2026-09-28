# Who does what

**A** = grammar side, **B** = scanner side. We both check each other's work, because they can ask either of us about anything.

TP01
- A: grammar.txt + report parts 1 and 2
- B: scanner.l, tests, Makefile + report parts 3 and 4

Next TPs (plan)
- A: parser (bison) + AST
- B: intermediate code + NASM generation
- last session: we test everything together

Before the presentation: A explains the grammar to B (priorities, why Assignment has no `;`, `=` vs `==`),
and B explains the scanner to A (the 3 parts of the .l file, longest match, keywords before ID, the COMMENT state).

## git

Work on a branch, then open a PR and the other one merges it:

```
git pull
git switch -c my-branch
make check
git add -A
git commit -m "..."
git push -u origin my-branch
gh pr create --fill
```
