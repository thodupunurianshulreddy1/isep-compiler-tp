%{
#include 
#include 
#include 
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          ({LETTER}|_)({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+
STRING      \"(\\.|[^"\\])*\"
WS          [ \t\r\n]+

%%

{WS}            {  }


"int"           { std::cout << "TYPE_TOKEN: " << yytext << std::endl; }
"if"            { std::cout << "IF_TOKEN: " << yytext << std::endl; }
"while"         { std::cout << "WHILE_TOKEN: " << yytext << std::endl; }
"print"         { std::cout << "PRINT_TOKEN: " << yytext << std::endl; }


"=="            { std::cout << "EQUAL_TOKEN: " << yytext << std::endl; }
"!="            { std::cout << "NOT_EQUAL_TOKEN: " << yytext << std::endl; }
">="            { std::cout << "GREATER_EQUAL_TOKEN: " << yytext << std::endl; }
"<="            { std::cout << "LESS_EQUAL_TOKEN: " << yytext << std::endl; }
">"             { std::cout << "GREATER_TOKEN: " << yytext << std::endl; }
"<"             { std::cout << "LESS_TOKEN: " << yytext << std::endl; }


"="             { std::cout << "ASSIGN_TOKEN: " << yytext << std::endl; }
"+"             { std::cout << "PLUS_TOKEN: " << yytext << std::endl; }
"-"             { std::cout << "MINUS_TOKEN: " << yytext << std::endl; }
"*"             { std::cout << "MULTIPLY_TOKEN: " << yytext << std::endl; }
"/"             { std::cout << "DIVIDE_TOKEN: " << yytext << std::endl; }

   
"("             { std::cout << "L_PAREN_TOKEN: " << yytext << std::endl; }
")"             { std::cout << "R_PAREN_TOKEN: " << yytext << std::endl; }
"{"             { std::cout << "L_BRACE_TOKEN: " << yytext << std::endl; }
"}"             { std::cout << "R_BRACE_TOKEN: " << yytext << std::endl; }
";"             { std::cout << "SEMICOLON_TOKEN: " << yytext << std::endl; }
","             { std::cout << "COMMA_TOKEN: " << yytext << std::endl; }

   
{NUMBER}        { std::cout << "NUMBER_TOKEN: " << yytext << std::endl; }
{STRING}        { std::cout << "STRING_TOKEN: " << yytext << std::endl; }
{ID}            { std::cout << "VAR_TOKEN: " << yytext << std::endl; }

.               { std::cerr << "UNKNOWN_TOKEN: " << yytext << std::endl; }

%%

int main(void) {
    yyFlexLexer lexer;
    lexer.yylex();
    return 0;
}
