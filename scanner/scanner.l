/*
 * scanner.l - lexer for our pseudo C++ language (TP01, task 2)
 *
 *   flex --c++ scanner.l
 *   g++ -o scanner lex.yy.cc -lfl
 *   ./scanner < input.txt
 *
 * prints one token per line like on slide 39 -> "NAME: text"
 */

%{
#include <iostream>
#include <fstream>
#include <string>

int nbErrors = 0;
int commentLine = 0;   // to know where an unclosed /* started

void show(const char* tok, const char* txt) {
    std::cout << tok << ": " << txt << std::endl;
}

void error(int line, std::string msg) {
    std::cerr << "LEXICAL ERROR (line " << line << "): " << msg << std::endl;
    nbErrors++;
}
%}

%option c++
%option noyywrap
%option yylineno

%x COMMENT

DIGIT   [0-9]
LETTER  [A-Za-z]
ID      {LETTER}({LETTER}|{DIGIT}|_)*
NUMBER  {DIGIT}+
STRING  \"(\\.|[^"\\\n])*\"

%%

 /* comments + spaces are skipped */
"//".*              { }
"/*"                { commentLine = lineno(); BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT>\n         { }
<COMMENT>.          { }
<COMMENT><<EOF>>    { error(commentLine, "comment not closed"); return 0; }
[ \t\r\n]+          { }

 /* keywords - have to be before ID otherwise "if" would be a VAR */
"int"       { show("INT_TOKEN", yytext); }
"if"        { show("IF_TOKEN", yytext); }
"else"      { show("ELSE_TOKEN", yytext); }
"while"     { show("WHILE_TOKEN", yytext); }
"for"       { show("FOR_TOKEN", yytext); }
"print"     { show("PRINT_TOKEN", yytext); }
"prints"    { show("PRINTS_TOKEN", yytext); }

{DIGIT}+{ID}    { error(lineno(), std::string("bad identifier ") + yytext); }
{NUMBER}        { show("NUMBER_TOKEN", yytext); }
{ID}            { show("VAR_TOKEN", yytext); }
{STRING}        { show("STRING_TOKEN", yytext); }
\"[^"\n]*       { error(lineno(), "string not closed"); }

 /* 2 char operators, flex takes the longest match so >= is not > then = */
"++"    { show("INCREMENT_TOKEN", yytext); }
"--"    { show("DECREMENT_TOKEN", yytext); }
"+="    { show("PLUS_ASSIGN_TOKEN", yytext); }
"-="    { show("MINUS_ASSIGN_TOKEN", yytext); }
"&&"    { show("AND_TOKEN", yytext); }
"||"    { show("OR_TOKEN", yytext); }

"=="|"!="|">="|"<="|">"|"<"    { show("COMPARISON_TOKEN", yytext); }

"="     { show("ASSIGN_TOKEN", yytext); }
"!"     { show("NOT_TOKEN", yytext); }
"+"     { show("PLUS_TOKEN", yytext); }
"-"     { show("MINUS_TOKEN", yytext); }
"*"     { show("MULT_TOKEN", yytext); }
"/"     { show("DIV_TOKEN", yytext); }

 /* same names as slide 39 */
"("     { show("L1_TOKEN", yytext); }
")"     { show("R1_TOKEN", yytext); }
"{"     { show("L2_TOKEN", yytext); }
"}"     { show("R2_TOKEN", yytext); }
";"     { show("SEMICOLON_TOKEN", yytext); }
","     { show("COMMA_TOKEN", yytext); }

 /* anything else */
.       { error(lineno(), std::string("unknown character ") + yytext); }

%%

int main(int argc, char** argv) {
    std::ifstream f;
    std::istream* in = &std::cin;

    // can also do ./scanner file.txt
    if (argc > 1) {
        f.open(argv[1]);
        if (!f) {
            std::cerr << "can't open " << argv[1] << std::endl;
            return 1;
        }
        in = &f;
    }

    yyFlexLexer lexer(in, &std::cout);
    lexer.yylex();

    if (nbErrors > 0) {
        std::cerr << nbErrors << " error(s)" << std::endl;
        return 1;
    }
    return 0;
}
