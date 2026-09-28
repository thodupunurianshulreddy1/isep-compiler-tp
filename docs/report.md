# TP 01 — Grammar & Lexical Analysis — Report

**Author:** Anshul · **Course:** Formal Approaches, Languages and Compilers (ISEP) · **Max 2 pages**

<!-- Write each section in your own words. Delete these comments before exporting. -->

## 1. Language overview
<!-- 3–4 lines: what the pseudo-C++ supports (slide 21 minimum + which slide 22 extensions you did). -->

## 2. Grammar design choices (Task 01)
<!-- Suggested points:
     - Why EBNF instead of CNF (readability, { } and [ ] avoid extra non-terminals)
     - Program = sequence of statements (no main / functions)
     - Operator precedence via Expression / Term / Factor
     - Condition: why a comparison is separate from an arithmetic expression
     - "=" vs "==" : slide 21 lists "=" among logical operators — explain your decision
     - print vs prints : one keyword or two, and why
     - if with optional else -->

## 3. Scanner design (Task 02)
<!-- Suggested points:
     - Token list (a small table: token name | regex | example)
     - Rule order: keywords before identifiers; longest match (>= vs >)
     - What is skipped (whitespace, comments) and why comments belong in the scanner
     - Error handling: the catch-all "." rule with line number
     - Build: flex --c++ -> lex.yy.cc -> g++ -->

## 4. Extensions implemented
<!-- One line per extension: syntax + grammar rule name + token(s). -->

## 5. Testing
<!-- Which input files you ran, and a short excerpt of output (e.g. slide 39 example). -->
