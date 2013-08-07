%{
#include <cstdio>
#include <cstdlib>
#include <iostream>
using namespace std;

#include "beamer.tab.h"

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);
%}

%union {
	char *sval;
}

%token HTML_START
%token HTML_END
%token HEAD_START
%token HEAD_END
%token TITLE_START
%token TITLE_END
%token AUTHOR_START
%token AUTHOR_END
%token BODY_START;
%token BODY_END;
%token DIV_START;
%token DIV_END;
%token H1_START;
%token H1_END;
%token QUOTE_START;
%token QUOTE_END;
%token OL_START;
%token OL_END;
%token LI_START;
%token LI_END;
%token IMG_START;
%token IMG_ALT_START;
%token IMG_END;


%token <sval> STRING



%%


beamer:
	start head body end
	;

start:
	HTML_START { cout << "\\documentclass{beamer}\n\\usepackage{graphics}\n\\begin{document}" << endl; }
	;

head:
	HEAD_START title author HEAD_END
	;
title:
	TITLE_START STRING TITLE_END { cout << "\\title{" << $2 << "}" << endl; }
	;
author:
	AUTHOR_START STRING AUTHOR_END { cout << "\\author{" << $2 << "}" << endl; }
	;

body:
	BODY_START title_page frames BODY_END
	;
title_page:
	{ cout << "\\begin{frame}\n\\titlepage\n\\end{frame}" << endl; }
	;
frames:
	start_frame content end_frame
	| start_frame content end_frame frames
	;
start_frame:
	DIV_START H1_START STRING H1_END { cout << "\\begin{frame}{" << $3 << "}" << endl; }
	;
end_frame:
	DIV_END { cout << "\\end{frame}" << endl; }
	;
content:
	text
	| text content 
	| quote
	| quote content
	| list
	| list content
	| img
	| img content
	;
text:
	STRING { cout << $1 << endl; }
	;
quote:
	QUOTE_START STRING QUOTE_END { cout << "\\begin{block}{Cytat}\n" << $2 << "\\end{block}" << endl; }
	;
list:
	start_list content_list end_list
	;
start_list:
	OL_START { cout << "\\begin{itemize}" << endl; }
	;
end_list:
	OL_END { cout << "\\end{itemize}" << endl; }
	;
content_list:
	list_element
	| list_element content_list
	;
list_element:
	LI_START STRING LI_END { cout << "\\item " << $2 << endl; }
	;
img:
	IMG_START STRING IMG_ALT_START STRING IMG_END { cout << "\\begin{figure}[p]\n\\centering\n\\includegraphics{" << $2 << "}\n\\caption{" << $4 << "}\n\\end{figure}" << endl; }
	;

end:
	HTML_END { cout << "\\end{document}" << endl; }
	;



%%


main()
{
	yyin = stdin;

	do {
		yyparse();
	} while (!feof(yyin));
}

void yyerror(const char *s) {
	cout << "error: " << s << endl;
	exit(-1);
}
