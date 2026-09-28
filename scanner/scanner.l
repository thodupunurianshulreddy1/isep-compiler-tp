/* =====================================================================
   ISEP - Formal Approaches, Languages and Compilers
   TP 01 - Task 02 : Lexical analyser (scanner) written with FLEX, C++ mode
   Author : Anshul

   Build & run (slide 42):
       flex --c++ scanner.l
       g++ -o scanner lex.yy.cc -lfl
       ./scanner < input.txt          (or: ./scanner input.txt)

   Output: one token per line, "TOKEN_NAME: lexeme" (format of slide 39).
   Lexical errors go to stderr with their line number.
   ===================================================================== */

%{
#include <iostream>
#include <fstream>
#include <string>

static int errorCount = 0;
static int commentStartLine = 0;   /* line where the current block comment began */

/* Print one token:  NAME: lexeme */
static void emit(const char* name, const char* lexeme) {
    std::cout << name << ": " << lexeme << std::endl;
}

/* Report a lexical error and keep scanning */
static void lexError(int line, const std::string& msg) {
    std::cerr << "LEXICAL ERROR (line " << line << "): " << msg << std::endl;
    ++errorCount;
}
%}

%option c++
%option noyywrap
%option yylineno

/* Exclusive start condition: while inside a block comment
   only the <COMMENT> rules are active. */
%x COMMENT

/* ---------------- Definitions (named regular expressions) ---------------- */
DIGIT       [0-9]
LETTER      [A-Za-z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+
STRING      \"(\\.|[^"\\\n])*\"
WS          [ \t\r]+

%%
    /* ======================================================================
       RULES  (regex -> action)
       Flex picks the LONGEST match; on a tie, the rule written FIRST wins.
       => keywords are listed before {ID};  ">=" is one token, not ">" "=".
       ====================================================================== */

    /* ---------- Comments and white space (skipped) ---------- */
"//".*                  { /* line comment: ignore until end of line */ }
"/*"                    { commentStartLine = lineno(); BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { /* newline inside comment (line counter still updated) */ }
<COMMENT>.              { /* ignore comment content */ }
<COMMENT><<EOF>>        { lexError(commentStartLine, "unterminated block comment");
                          BEGIN(INITIAL); return 0; }
{WS}                    { /* spaces, tabs */ }
\n                      { /* new line */ }

    /* ---------- Keywords (must come before {ID}) ---------- */
"int"                   { emit("INT_TOKEN", yytext); }
"if"                    { emit("IF_TOKEN", yytext); }
"else"                  { emit("ELSE_TOKEN", yytext); }
"while"                 { emit("WHILE_TOKEN", yytext); }
"for"                   { emit("FOR_TOKEN", yytext); }
"prints"                { emit("PRINTS_TOKEN", yytext); }
"print"                 { emit("PRINT_TOKEN", yytext); }

    /* ---------- Literals and identifiers ---------- */
{DIGIT}+{ID}            { lexError(lineno(), std::string("invalid identifier '") + yytext
                                             + "' (cannot start with a digit)"); }
{INTEGER}               { emit("NUMBER_TOKEN", yytext); }
{ID}                    { emit("VAR_TOKEN", yytext); }
{STRING}                { emit("STRING_TOKEN", yytext); }
\"[^"\n]*               { lexError(lineno(), "unterminated string"); }

    /* ---------- Compound operators (2 characters) ---------- */
"++"                    { emit("INCREMENT_TOKEN", yytext); }
"--"                    { emit("DECREMENT_TOKEN", yytext); }
"+="                    { emit("PLUS_ASSIGN_TOKEN", yytext); }
"-="                    { emit("MINUS_ASSIGN_TOKEN", yytext); }
"&&"                    { emit("AND_TOKEN", yytext); }
"||"                    { emit("OR_TOKEN", yytext); }

    /* ---------- Comparison operators ---------- */
"=="|"!="|">="|"<="|">"|"<"   { emit("COMPARISON_TOKEN", yytext); }

    /* ---------- Single-character operators ---------- */
"="                     { emit("ASSIGN_TOKEN", yytext); }
"!"                     { emit("NOT_TOKEN", yytext); }
"+"                     { emit("PLUS_TOKEN", yytext); }
"-"                     { emit("MINUS_TOKEN", yytext); }
"*"                     { emit("MULT_TOKEN", yytext); }
"/"                     { emit("DIV_TOKEN", yytext); }

    /* ---------- Punctuation (names from slide 39) ---------- */
"("                     { emit("L1_TOKEN", yytext); }
")"                     { emit("R1_TOKEN", yytext); }
"{"                     { emit("L2_TOKEN", yytext); }
"}"                     { emit("R2_TOKEN", yytext); }
";"                     { emit("SEMICOLON_TOKEN", yytext); }
","                     { emit("COMMA_TOKEN", yytext); }

    /* ---------- Anything else: lexical error (must stay LAST) ---------- */
.                       { lexError(lineno(), std::string("unexpected character '")
                                             + yytext + "'"); }

%%

int main(int argc, char* argv[]) {
    std::ifstream file;
    std::istream* in = &std::cin;               /* default: ./scanner < input.txt */

    if (argc > 1) {                             /* optional: ./scanner input.txt */
        file.open(argv[1]);
        if (!file) {
            std::cerr << "Cannot open file " << argv[1] << std::endl;
            return 1;
        }
        in = &file;
    }

    yyFlexLexer lexer(in, &std::cout);
    lexer.yylex();                              /* actions don't return: scans everything */

    if (errorCount > 0) {
        std::cerr << errorCount << " lexical error(s) found." << std::endl;
        return 1;
    }
    return 0;
}
