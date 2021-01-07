lexer grammar PerLexer;

@lexer::header {
package br.com.totvs.tds.sdk.fourgl.per.parser;
}


NEWLINE
:
	'\n'
;

ATTRIBUTES
:
	A T T R I B U T E S
;

DATABASE
:
	D A T A B A S E
;

END
:
	E N D
;

INSTRUCTIONS
:
	I N S T R U C T I O N S
;

SCREEN
:
	S C R E E N
;

TABLES
:
	T A B L E S
;

UPDATE
:
	U P D A T E
;

CHAR
:
	C H A R
;

DATE
:
	D A T E
;

DAY
:
	D A Y
;

DATETIME
:
	D A T E T I M E
;

DECIMAL
:
	D E C I M A L
;

DEC
:
	D E C
;

DOUBLE
:
	D O U B L E
;

DYNAMIC
:
	D Y N A M I C
;

FLOAT
:
	F L O A T
;

FRACTION
:
	F R A C T I O N
;

HOUR
:
	H O U R
;

INT
:
	I N T
;

INTEGER
:
	I N T E G E R
;

INTERVAL
:
	I N T E R V A L
;

LIKE
:
	L I K E
;

LONG
:
	L O N G
;

MINUTE
:
	M I N U T E
;

MONEY
:
	M O N E Y
;

MONTH
:
	M O N T H
;

RECORD
:
	R E C O R D
;

SECOND
:
	S E C O N D
;

SHORT
:
	S H O R T
;

SMALLFLOAT
:
	S M A L L F L O A T
;

SMALLINT
:
	S M A L L I N T
;

SERIAL
:
	S E R I A L
;

STRING
:
	S T R I N G
;

TO
:
	T O
;

TYPE
:
	T Y P E
;

TYPEDEF
:
	T Y P E D E F
;

UNSIGNED
:
	U N S I G N E D
;

VARCHAR
:
	V A R C H A R
;

YEAR
:
	Y E A R
;

//fragment ASTERISK : '*';
//fragment TAB : '\t';
//fragment FF : '\f';
//fragment DIVISION : '/';
//GREATER : '>';
//LESSER : '<';
//fragment SLASH : '/' ;
//fragment BACKSLASH : '/';
//fragment SPACE_CODE : ' ';
//INIT_BRACKETS_ARRAY : '[';
//END_BRACKETS_ARRAY : ']';
//INIT_BRACKETS_STRUCTURE : '{';
//END_BRACKETS_STRUCTURE : '}'; 
//fragment SIMPLE_QUOTES : '\'';
//fragment DOUBLE_QUOTES : '\"';

DELIMITERS
:
	D E L I M I T E R S
;

ACCENTED_CHARACTERS
:
	[\u007F-\u00FF]
;

EQUAL
:
	'='
;

LPAREN
:
	'('
;

RPAREN
:
	')'
;

LBRACK
:
	'['
;

RBRACK
:
	']'
;

COMMA
:
	','
;

DOT
:
	'.'
;

COLON
:
	':'
;

PIPE
:
	'|'
;

SEMICOLON
:
	';'
;

AT_SIGN
:
	'@'
;

POUND_SIGN
:
	'#'
;

SYMBOLS
:
	'\''
	| '"'
	| '!'
	| '$'
	| '%'
	| '¨'
	| '&'
	| '*'
	| '-'
	| '–'
	| '_'
	| '+'
	| '§'
	| '´'
	| '`'
	| '~'
	| '^'
	| '\\'
	| '<'
	| '>'
	| '/'
	| '?'
	| '‡'
	| '…'
	| '„'
	| ''
	| '€'
	| 'ƒ'
	| '‘'
	| '†'
;

MULTILINE_COMMENT_START
:
	'{' -> pushMode ( MULTILINE_COMMENT )
;

COMMENT_CODE
:
	(
		'#'
		| '--' ~'#'
	) ~( '\n' | '\r' )+ -> skip
;

WHITESPACE
:
	(
		[\u0003-\u0008] //alguns fontes possuem esses caracteres que são aceitos pelo parser do servidor
		| ' '
		| '\t'
		| '\f'
		| '\r'
	)+ -> skip
;

INTEGER_NUMBERS
:
	'0' .. '9'+
;

IDENTIFICATION
:
	(
		'a' .. 'z'
		| 'A' .. 'Z'
		| '0' .. '9'
		| '_'
	)+
;

IDENTIFICATION_TABLES
:
	(
		'a' .. 'z'
		| 'A' .. 'Z'
		| '0' .. '9'
		| DOT
		| '_'
		| '*'
	)+
;

STRING_LITERAL
:
	'"'
	(
		~( '"' | '\n' )
	)*
	(
		'"'
		| '\n'
	)
	| '\''
	(
		~( '\'' | '\n' )
	)*
	(
		'\''
		| '\n'
	)
;

PROTHEUS_DOC_START
:
	'/*/{Protheus.doc}' -> mode ( PDOC )
;

PROTHEUS_DOC_START_4GL
:
	'{/{Protheus.doc}' -> mode ( PDOC )
;

//////////////////////////////////////////////////////////////////////////////////////
// Alteracoes realizadas nas regras do Pdoc devem ser replicadas para as gramaticas
// AdvPL, 4GL e PER
//////////////////////////////////////////////////////////////////////////////////////
mode PDOC;

PROTHEUS_DOC_END
:
	'/*/' -> popMode
;

PROTHEUS_DOC_END_4GL
:
	'/}' -> popMode
;

LBRACE
:
	'{'
;

RBRACE
:
	'}'
;


PDOC_ID
:
	(
		LETTER
		| DIGIT
		| '_'
		| ':'
		| '.'
	)+
;

PDOC_WS
:
	(
		' '
		| '\t'
		| '\r'
		| '\f'
	) -> channel (HIDDEN)
;

PDOC_COMMA
:
	COMMA
;

PDOC_SPECIAL_CHARS
:
	SYMBOLS
	| ACCENTED_CHARACTERS
	| LPAREN
	| RPAREN
	| LBRACK
	| RBRACK
	| LBRACE
	| RBRACE
	| COLON
	| PIPE
	| DOT
	| POUND_SIGN
	| ';'
;

AT_ACCESSLEVEL
:
	AT_SIGN A C C E S S L E V E L
;

AT_AUTHOR
:
	AT_SIGN A U T H O R
;

AT_BUILD
:
	AT_SIGN B U I L D
;

AT_CHILDREN
:
	AT_SIGN C H I L D R E N
;

AT_COUNTRY
:
	AT_SIGN C O U N T R Y
;

AT_DATABASE
:
	AT_SIGN D A T A B A S E
;

AT_DESCRIPTION
:
	AT_SIGN D E S C R I P T I O N
;

AT_DEPRECATED
:
	AT_SIGN D E P R E C A T E D
;

AT_EXAMPLE
:
	AT_SIGN E X A M P L E
;

AT_SAMPLE
:
	AT_SIGN S A M P L E
;

AT_LANGUAGE
:
	AT_SIGN L A N G U A G E
;

AT_LINK
:
	AT_SIGN L I N K
;

AT_OBS
:
	AT_SIGN O B S
;

AT_PARAM
:
	AT_SIGN P A R A M
;

AT_PARENTS
:
	AT_SIGN P A R E N T S
;

AT_PROTECTED
:
	AT_SIGN P R O T E C T E D
;

AT_TYPE
:
	AT_SIGN T Y P E
;

AT_PROPTYPE
:
	AT_SIGN P R O P T Y P E
;

AT_DEFVALUE
:
	AT_SIGN D E F V A L U E
;

AT_READONLY
:
	AT_SIGN R E A D O N L Y
;

AT_SOURCE
:
	AT_SIGN S O U R C E
;

AT_HISTORY
:
	AT_SIGN H I S T O R Y
;

AT_RETURN
:
	AT_SIGN R E T U R N
;

AT_SYSTEMOPER
:
	AT_SIGN S Y S T E M O P E R
;

AT_SEE
:
	AT_SIGN S E E
;

AT_SINCE
:
	AT_SIGN S I N C E
;

AT_TABLE
:
	AT_SIGN T A B L E
;

AT_TODO
:
	AT_SIGN T O D O
;

AT_VERSION
:
	AT_SIGN V E R S I O N
;

REFERENCE
:
	AT_SIGN
;

AT_PROJECT
:
	AT_SIGN P R O J E C T
;

AT_OWNER
:
	AT_SIGN O W N E R
;

AT_MENU
:
	AT_SIGN M E N U
;

AT_ISSUE
:
	AT_SIGN I S S U E
;

//Obrigatório ficar após as marcações esperadas 
AT_UNKNOWN
:
	AT_SIGN PDOC_ID
;

PDOC_NEWLINE
:
	NEWLINE
;

mode MULTILINE_COMMENT;

MULTILINE_COMMENT_END
:
	'}' -> popMode
;

MULTILINE_COMMENT_ID
:
	ID
;

MULTILINE_COMMENT_WS
:
	(
		' '
		| '\t'
		| '\r'
		| '\f'
	) -> channel (HIDDEN)
;

MULTILINE_COMMENT_NUMBER
:
	NUMBER
;

MULTILINE_COMMENT_NEWLINE
:
	NEWLINE
;

MULTILINE_COMMENT_BRACKETS
:
	RBRACE
	| LBRACE
	| RBRACK
	| LBRACK
	| RPAREN
	| LPAREN
;

MULTILINE_COMMENT_PUNCTUATION
:
	COMMA
	| DOT
	| COLON
	| PIPE
;

MULTILINE_COMMENT_SPECIAL_CHARS
:
	SYMBOLS
	| SEMICOLON
	| AT_SIGN
	| ACCENTED_CHARACTERS
	| POUND_SIGN
;

//////////////////////////////////////////////////////////////////////////////////////
// Alteracoes realizadas nas regras do Pdoc devem ser replicadas para as gramaticas
// AdvPL, 4GL e PER
//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
// Alteracoes realizadas nas regras gerais podem ser replicadas para as gramaticas
// AdvPL, 4GL e PER
//////////////////////////////////////////////////////////////////////////////////////

//
// Basic Lexer that has all the alphabet letters.
//

/**
 * Fragments tokens
*/
fragment
A
:
	'A'
	| 'a'
;

fragment
B
:
	'B'
	| 'b'
;

fragment
C
:
	'C'
	| 'c'
;

fragment
D
:
	'D'
	| 'd'
;

fragment
E
:
	'E'
	| 'e'
;

fragment
F
:
	'F'
	| 'f'
;

fragment
G
:
	'G'
	| 'g'
;

fragment
H
:
	'H'
	| 'h'
;

fragment
I
:
	'I'
	| 'i'
;

fragment
J
:
	'J'
	| 'j'
;

fragment
K
:
	'K'
	| 'k'
;

fragment
L
:
	'L'
	| 'l'
;

fragment
M
:
	'M'
	| 'm'
;

fragment
N
:
	'N'
	| 'n'
;

fragment
O
:
	'O'
	| 'o'
;

fragment
P
:
	'P'
	| 'p'
;

fragment
Q
:
	'Q'
	| 'q'
;

fragment
R
:
	'R'
	| 'r'
;

fragment
S
:
	'S'
	| 's'
;

fragment
T
:
	'T'
	| 't'
;

fragment
U
:
	'U'
	| 'u'
;

fragment
V
:
	'V'
	| 'v'
;

fragment
W
:
	'W'
	| 'w'
;

fragment
X
:
	'X'
	| 'x'
;

fragment
Y
:
	'Y'
	| 'y'
;

fragment
Z
:
	'Z'
	| 'z'
;

fragment
LETTER
:
	'A' .. 'Z'
	| 'a' .. 'z'
;

fragment
DIGIT
:
	'0' .. '9'
;

ID
:
	(
		LETTER
		| '_'
	)
	(
		LETTER
		| DIGIT
		| '_'
	)*
;

NUMBER
:
	DIGIT+
	(
		DOT DIGIT+
	)?
;
