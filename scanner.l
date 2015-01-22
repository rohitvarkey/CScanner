D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
int found=0,var_cnt=0,i;
struct holder
{
	char name[10];
	int val;
	}st[20];

%}

keyword "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"	
relop >|<|<=|>=|!=
ws [ \t]+
%%

^#([-a-zA-Z0-9.]|{relop}|{ws})* {fprintf(yyout,"\n%s\tPreprocessor Statement\t***",yytext);}
"/*"			{ ; }
{keyword}  {fprintf(yyout,"\n%s\tKeyword\t***",yytext);}
{L}({L}|{D})*		{  for(i=0;i<var_cnt;i++)
     						if(strcmp(st[i].name,yytext)==0)
      						break;   

    						if(i==var_cnt)  
     							strcpy(st[var_cnt++].name,yytext);
    						fprintf(yyout,"\n%s\t Variable\t%d",yytext,i);
    				}
					 

0[xX]{H}+{IS}?		{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
0{D}+{IS}?		{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
{D}+{IS}?		{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
L?'(\\.|[^\\'])+'	{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
{D}+{E}{FS}?		{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
{D}*"."{D}+({E})?{FS}?	{fprintf(yyout,"\n%s\tConstant\t***",yytext);}
{D}+"."{D}*({E})?{FS}?	{fprintf(yyout,"\n%s\tConstant\t***",yytext);}

L?\"(\\.|[^\\"])*\"	{fprintf(yyout,"\n%s\tString Literal\t***",yytext);}

"..."|">>="|"<<="|"+="|"-="|"*="|"/="		{fprintf(yyout,"\n%s\tOperator\t",yytext);}

"%="|"&="|"^="|"|="|">>"|"<<"|"++"|"--"|"->"|"&&"|"||"|"<="			{fprintf(yyout,"\n%s\tOperator\t",yytext);}

">="|"=="|"!="		{fprintf(yyout,"\n%sOperator\t",yytext);}
";"			{fprintf(yyout,"\n%sPunctuator\t",yytext);}
("{"|"<%")		{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
("}"|"%>")		{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
","			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
":"			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
"="			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
"("			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
")"			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
("["|"<:")		{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
("]"|":>")		{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
"."			{fprintf(yyout,"\n%s\tPunctuator\t",yytext);}
"&"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"!"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"~"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"-"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"+"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"*"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"/"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"%"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"<"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
">"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"^"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"|"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}
"?"			{fprintf(yyout,"\n%s\tOperator\t",yytext);}

[ \t\v\n\f]		{;}
.			{ /* ignore bad characters */ }

%%

int main()
{
 yyin=fopen("input.txt","r");
 yyout=fopen("out.txt","w");
 fprintf(yyout,"\n Symbol Table Format is:\n Lexeme\tToken\tAttribute Value\n");
 yylex();
 fprintf(yyout,"\n");
 fclose(yyout);
}
int yywrap()
{
 return(1);
}
