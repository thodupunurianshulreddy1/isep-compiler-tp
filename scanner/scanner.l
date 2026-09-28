/* =====================================================================
   ISEP - Formal Approaches, Languages and Compilers
   TP 01 - Task 02 : Lexical analyser (scanner) written with FLEX, C++ mode
   Author : Anshul

   Build & run (exactly as on slide 42):
       flex --c++ scanner.l
       g++ -o scanner lex.yy.cc -lfl
       ./scanner < ../tests/input_minimal.txt

   Structure (slide 36):  definitions  %%  rules  %%  user code
   ===================================================================== */

%{
/* ---------- C++ code copied verbatim to the top of lex.yy.cc ---------- */
#include <iostream>
#include <string>

/* Print one token in the format of slide 39:  NAME: lexeme */
static void emit(const char* name, const char* lexeme) {
    std::cout << name << ": " << lexeme << std::endl;
}
%}

/* ---------- Options ---------- */
%option c++
%option noyywrap
%option yylineno
/* noyywrap = stop at end of input (so we do not depend on libfl's yywrap) */

/* ---------- Definitions: named regular expressions (macros) ---------- */
DIGIT       [0-9]
LETTER      [A-Za-z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+

/* TODO: STRING  \"...\"   hint: a quote, then any char that is NOT a quote
         or a newline, repeated, then a quote.  [^"\n] means "any char except
         a quote or newline".                                               */

%%
    /* ================== RULES:  regex  ->  C++ action ==================
       Two rules flex applies when several patterns match:
         1. LONGEST match wins        (">=" beats ">")
         2. On a tie, the rule written FIRST wins  -> keywords BEFORE {ID}
       ================================================================== */

    /* ---- Keywords (worked example) ---- */
"int"           { emit("INT_TOKEN", yytext); }

    /* TODO: "if"  "else"  "while"  "print"  "prints"
       Must be placed BEFORE the {ID} rule. Why? (tie-breaking rule 2)   */


    /* ---- Literals and identifiers (worked example) ---- */
{INTEGER}       { emit("NUMBER_TOKEN", yytext); }
{ID}            { emit("VAR_TOKEN", yytext); }

    /* TODO: {STRING} -> STRING_TOKEN */


    /* ---- Operators ---- */
    /* TODO: comparison  >  <  >=  <=  ==  !=   -> COMPARISON_TOKEN
       TODO: assignment  =                      -> ASSIGN_TOKEN
       TODO: arithmetic  +  -  *  /             -> PLUS_TOKEN, MINUS_TOKEN ...
       Question for your report: why does "==" never get split into two "=" ? */


    /* ---- Punctuation (worked example for ';') ---- */
";"             { emit("SEMICOLON_TOKEN", yytext); }

    /* TODO: (  )  {  }  ,   -> L1_TOKEN, R1_TOKEN, L2_TOKEN, R2_TOKEN, COMMA_TOKEN
       (names taken from slide 39; you may choose clearer ones)          */


    /* ---- Things to skip ---- */
[ \t\r]+        { /* whitespace: ignore */ }
\n              { /* newline: ignore (lineno() still counts it) */ }

    /* TODO (extension): line comments  "//".*   and block comments */


    /* ---- Anything else is a lexical error (keep this rule LAST) ---- */
.               { std::cerr << "LEXICAL ERROR line " << lineno()
                            << ": unexpected character '" << yytext << "'"
                            << std::endl; }

%%
/* ---------- User code ---------- */

int main() {
    yyFlexLexer lexer;   /* reads std::cin by default -> ./scanner < input.txt */
    lexer.yylex();       /* our actions never 'return', so this scans the whole file */
    return 0;
}
