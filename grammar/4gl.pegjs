// Gramática eleborada com base na documentação disponibilizada em
// https://www.oninit.com/manual/informix/english/docs/4gl/7609.pdf
// e na pasta "docs" há uma cópia

{

//const unroll = options.util.makeUnroll(location, options);
const ast    = options.util.makeAST   (location, options);

}

start
	= t:token*
	{ return ast("program").set("value", t) }

token 
  = comment
  / NLS? keywords NLS
  / operators 
  / string
  / number
  / (!keywords ID)
  / NLS
  / o:(!WS .)+ { return ast("notSpecified").set("value", o) }

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';

string
  = s:$(double_quoted_string / single_quoted_string) {
      return ast("string").set("value", s);
    }

double_quoted_string = $(D_QUOTE (!D_QUOTE .)* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE .)* S_QUOTE)

number
  = n:$([-+]? DIGIT+ (DOT DIGIT+)?) {
      return ast("number").set("value", n); 
    }

DIGIT = [0-9]

ESCAPED
 = "\\\"" { return '"'}
 / "\\'" { return "'"}
 / "\\\\" { return "\\"}
 / "\\b" { return "\b"}
 / "\\t" { return "\t"}
 / "\\n" { return "\n"}
 / "\\f" { return "\f"}
 / "\\r" { return "\r"}

WS
  = s:$[ \t;]+ { return ast("whiteSpace").set("value", s) }

_NL = s:$("\n" / "\r" / "\r\n")+ { return ast("newLine").set("value", s) }

NLS
  = _NL / WS

keywords
  = (
    BLACK 
    / BLUE 
    / CYAN 
    / GREEN 
    / MAGENTA 
    / RED 
    / WHITE 
    / YELLOW
    / BYTE
    / TEXT
    / AFTER
    / ALL
    / AND
    / ANY
    / ARRAY
    / ASC
    / ACCEPT
    / ASCENDING
    / ASCII
    / AT
    / ATTRIBUTE
    / ATTRIBUTES
    / AUTONEXT
    / AVG
    / BEFORE
    / BEGIN
    / BETWEEN
    / BIGINT
    / BORDER
    / BOTTOM
    / BY
    / CALL
    / CASE
    / CLEAR
    / CLIPPED
    / CLOSE
    / COLUMN
    / COLUMNS
    / COMMA
    / COMMAND
    / COMMENT
    / COMMENTS
    / COMMIT
    / CONSTRAINT
    / CONSTRUCT
    / CONTINUE
    / COUNT
    / CREATE
    / CURRENT
    / CURSOR
    / DATABASE
    / DAY
    / DECLARE
    / DEFAULTS
    / DEFER
    / DEFINE
    / DELETE
    / DELIMITER
    / DELIMITERS
    / DESC
    / DESCENDING
    / DIRTY
    / DISPLAY
    / DISTINCT
    / DOWNSHIFT
    / DOT
    / DROP
    / DYNAMIC
    / ELSE
    / END
    / ERROR
    / EVERY
    / EXCLUSIVE
    / EXECUTE
    / EXISTS
    / EXIT
    / EXTEND
    / EXTERNAL
    / FALSE
    / FETCH
    / FIELD
    / FILE
    / FINISH
    / FIRST
    / FLUSH
    / FOR
    / FOR
    / FOREACH
    / FORM
    / FORMAT
    / FRACTION
    / FREE
    / FROM
    / FUNCTION
    / GROUP
    / GLOBALS
    / HAVING
    / HEADER
    / HELP
    / HIDE
    / HOLD
    / HOUR
    / IF
    / IN
    / INCLUDE
    / INDEX
    / INITIALIZE
    / INPUT
    / INSERT
    / INSTRUCTIONS
    / INTERRUPT
    / INTERVAL
    / INTO
    / IS
    / ISOLATION
    / KEY
    / LABEL
    / LAST
    / LEFT
    / LENGTH
    / LET
    / LIKE
    / LINE
    / LINES
    / LOAD
    / LOCK
    / LOG
    / MAIN
    / MARGIN
    / MATCHES
    / MAX
    / MDY
    / MENU
    / MESSAGE
    / MIN
    / MINUTE
    / MOD
    / MODE
    / MONTH
    / NAME
    / NEED
    / NEXT
    / NO
    / NOENTRY
    / NOT
    / NOTFOUND
    / NULL
    / ON
    / OPEN
    / OPTION
    / OPTIONS
    / OR
    / ORDER
    / OTHERWISE
    / OUTER
    / OUTPUT
    / PAGE
    / PAGENO
    / PIPE
    / PREPARE
    / PREVIOUS
    / PRIMARY
    / PRINT
    / PROGRAM
    / PROMPT
    / PROMPT
    / PUT
    / QUIT
    / READ
    / RECORD
    / REPORT
    / RETURN
    / RETURNING
    / REVERSE
    / RIGTH
    / ROLLBACK
    / ROW
    / ROWS
    / RUN
    / SCREEN
    / SCROLL
    / SECOND
    / SELECT
    / SET
    / SHARE
    / SHOW
    / SKIP
    / SLEEP
    / SPACE
    / SPACES
    / SQL
    / START
    / STEP
    / STOP
    / SUM
    / TABLE
    / TABLES
    / TEMP
    / THEN
    / THEN
    / TIME
    / TO
    / TODAY
    / TOP
    / TRAILER
    / TRUE
    / TYPE
    / UNCONSTRAINED
    / UNION
    / UNIQUE
    / UNITS
    / UNLOAD
    / UNLOAD
    / UNLOCK
    / UPDATE
    / UPSHIFT
    / USING
    / VALUES
    / WAIT
    / WAITING
    / WEEKDAY
    / WHEN
    / WHENEVER
    / WHERE
    / WHILE
    / WINDOW
    / WITH
    / WITHOUT
    / WORDWRAP
    / WORK
    / YEAR
  )
 
operators
  = C_BRACES
  / C_BRACKET
  / C_PARENTHESIS
  / O_BRACES
  / O_BRACKET
  / O_PARENTHESIS
  / COMMA
  / ASTERISK
  / EQUAL
  / LESS
  / GREATER
  / EXCLAMATION
  / PLUS
  / MINUS
  / COLON
  / SLASH

numericDate
  = mo (separator dd separator)? (yy / yyyy)

mo = [1] [012] / [0-9]?[0-9]

dd = [0-9]?[0-9]

yy = [0-9][0-9]

yyyy = [0-9][0-9][0-9][0-9]

separator = SLASH 

comment
  = singleCommentLine 
  / c:$(O_BRACES (!C_BRACES .)* C_BRACES) { return ast("comment").set("value", c) }

singleCommentLine
  = c:$('#' (!_NL .)* _NL) { return ast("comment").set("value", c) }
  / c:$('-' '-' '#' (!_NL .)* _NL) { return ast("comment").set("value", s) }

ID = id:$([a-zA-Z_] [a-zA-Z_0-9]*) { return ast("identifier").set("value", id) }

MO=('0'..'1')? DIGIT;
DD=('0'..'3')? DIGIT;
YYYY=DIGIT{4}
HH=('0'..'2')? DIGIT;
MM=('0'..'5')? DIGIT;
SS=('0'..'5')? DIGIT;
FFFF=DIGIT{4}

AT_SIGN="@";
INT_FLAG=v:"int_flag"i{ return ast("builtInVar").set("value", c) }
NOT_FOUND=v:"notfound"i { return ast("builtInVar").set("value", c) }
SQL_CODE=v:"sqlcode"i { return ast("builtInVar").set("value", c) }
STATUS=v:"status"i { return ast("builtInVar").set("value", c) }
QUIT_FLAG=v:"quit_flag"i { return ast("builtInVar").set("value", c) }
SQL_CA_RECORD=v:"sqlcarecord"i { return ast("builtInVar").set("value", c) }
SQL_ERR_M=v:"sqlerrm"i { return ast("builtInVar").set("value", c) }
SQL_ERR_P=v:"sqlerrp"i { return ast("builtInVar").set("value", c) }
SQL_ERR_D=v:"sqlerrd"i { return ast("builtInVar").set("value", c) }
SQL_AWARN=v:"sqlawarn"i { return ast("builtInVar").set("value", c) }

TRUE=c:"true"i { return ast("constante").set("value", c) }
FALSE=c:"false"i { return ast("constante").set("value", c) }

O_BRACES=o:"{" { return ast("operator").set("value", o) }
C_BRACES=o:"}" { return ast("operator").set("value", o) }
O_BRACKET=o:"[" { return ast("operator").set("value", o) }
C_BRACKET=o:"]" { return ast("operator").set("value", o) }
O_PARENTHESIS=o:"(" { return ast("operator").set("value", o) }
C_PARENTHESIS=o:")" { return ast("operator").set("value", o) }
COMMA=o:"," { return ast("operator").set("value", o) }
ASTERISK=o:"*" { return ast("operator").set("value", o) }
EQUAL=o:"="  { return ast("operator").set("value", o) }
LESS=o:"<" { return ast("operator").set("value", o) }
GREATER=o:">" { return ast("operator").set("value", o) }
EXCLAMATION=o:"!" { return ast("operator").set("value", o) }
PLUS=o:"+" { return ast("operator").set("value", o) }
MINUS=o:"-" { return ast("operator").set("value", o) }
COLON=o:":" { return ast("operator").set("value", o) }
SLASH=o:"/" { return ast("operator").set("value", o) }

ACCEPT=k:"accept"i  { return ast("keyword").set("value", k) }
AFTER=k:"after"i  { return ast("keyword").set("value", k) }
ALL=k:"all"i  { return ast("keyword").set("value", k) }
AND=k:"and"i  { return ast("keyword").set("value", k) }
ANY=k:"any"i  { return ast("keyword").set("value", k) }
ARRAY=k:"array"i  { return ast("keyword").set("value", k) }
ASC=k:"asc"i  { return ast("keyword").set("value", k) }
ASCENDING=k:"ascending"i  { return ast("keyword").set("value", k) }
ASCII=k:"ascii"i  { return ast("keyword").set("value", k) }
AT=k:"year"i  { return ast("keyword").set("value", k) }
ATTRIBUTE=k:"attribute"i  { return ast("keyword").set("value", k) }
ATTRIBUTES=k:"attributes"i  { return ast("keyword").set("value", k) }
AUTONEXT=k:"autonext"i  { return ast("keyword").set("value", k) }
AVG=k:"avg"i  { return ast("keyword").set("value", k) }
BEFORE=k:"before"i  { return ast("keyword").set("value", k) }
BEGIN=k:"begin"i ? { return  ast("keyword").set("value", k) }
BETWEEN=k:"between"i  { return ast("keyword").set("value", k) }
BIGINT=k:"bigint"i  { return ast("keyword").set("value", k) }
BLACK=k:"black"i  { return ast("keyword").set("value", k) }
BLINK=k:"blink"i  { return ast("keyword").set("value", k) }
BLUE=k:"blue"i  { return ast("keyword").set("value", k) }
BOLD=k:"bold"i  { return ast("keyword").set("value", k) }
BORDER=k:"border"i  { return ast("keyword").set("value", k) }
BOTTOM=k:"bottom"i  { return ast("keyword").set("value", k) }
BY=k:"by"i  { return ast("keyword").set("value", k) }
BYTE=k:"byte"i  { return ast("keyword").set("value", k) }
CALL=k:"call"i  { return ast("keyword").set("value", k) }
CASE=k:"case"i ? { return  ast("keyword").set("value", k) }
CHAR=k:"char"i  { return ast("keyword").set("value", k) }
CHARACTER=k:"character"i  { return ast("keyword").set("value", k) }
CLEAR=k:"clear"i  { return ast("keyword").set("value", k) }
CLIPPED=k:"clipped"i  { return ast("keyword").set("value", k) }
CLOSE=k:"close"i  { return ast("keyword").set("value", k) }
COLUMN=k:"column"i  { return ast("keyword").set("value", k) }
COLUMNS=k:"columns"i  { return ast("keyword").set("value", k) }
COMMAND=k:"command"i  { return ast("keyword").set("value", k) }
COMMENT=k:"comment"i  { return ast("keyword").set("value", k) }
COMMENTS=k:"comments"i  { return ast("keyword").set("value", k) }
COMMIT=k:"commit"i  { return ast("keyword").set("value", k) }
CONSTRAINT=k:"constraint"i  { return ast("keyword").set("value", k) }
CONSTRUCT=k:"construct"i  { return ast("keyword").set("value", k) }
CONTINUE=k:"continue"i  { return ast("keyword").set("value", k) }
CONTROL=k:"control"i  { return ast("keyword").set("value", k) }
COUNT=k:"count"i  { return ast("keyword").set("value", k) }
CREATE=k:"create"i  { return ast("keyword").set("value", k) }
CURRENT=k:"current"i  { return ast("keyword").set("value", k) }
CURSOR=k:"cursor"i  { return ast("keyword").set("value", k) }
CYAN=k:"cyan"i  { return ast("keyword").set("value", k) }
DATABASE=k:"database"i  { return ast("keyword").set("value", k) }
DATE=k:"date"i  { return ast("keyword").set("value", k) }
DATETIME=k:"datetime"i  { return ast("keyword").set("value", k) }
DAY=k:"day"i  { return ast("keyword").set("value", k) }
DEC=k:"dec"i  { return ast("keyword").set("value", k) }
DECIMAL=k:"decimal"i  { return ast("keyword").set("value", k) }
DECLARE=k:"declare"i  { return ast("keyword").set("value", k) }
DEFAULTS=k:"defaults"i  { return ast("keyword").set("value", k) }
DEFER=k:"defer"i  { return ast("keyword").set("value", k) }
DEFINE=k:"define"i  { return ast("keyword").set("value", k) }
DELETE=k:"delete"i  { return ast("keyword").set("value", k) }
DELIMITER=k:"delimiter"i  { return ast("keyword").set("value", k) }
DELIMITERS=k:"delimiters"i  { return ast("keyword").set("value", k) }
DESC=k:"desc"i  { return ast("keyword").set("value", k) }
DESCENDING=k:"descending"i  { return ast("keyword").set("value", k) }
DIM=k:"dim"i  { return ast("keyword").set("value", k) }
DIRTY=k:"dirty"i  { return ast("keyword").set("value", k) }
DISPLAY=k:"display"i  { return ast("keyword").set("value", k) }
DISTINCT=k:"distinct"i  { return ast("keyword").set("value", k) }
DOUBLE=k:"double"i  { return ast("keyword").set("value", k) }
DOWN=k:"down"i  { return ast("keyword").set("value", k) }
DOWNSHIFT=k:"downshift"i  { return ast("keyword").set("value", k) }
DROP=k:"drop"i  { return ast("keyword").set("value", k) }
DYNAMIC=k:"dynamic"i  { return ast("keyword").set("value", k) }
ELIF=k:"elif"i  { return ast("keyword").set("value", k) }
ELSE=k:"else"i  { return ast("keyword").set("value", k) }
END=k:"end"i ? { return  ast("keyword").set("value", k) }
ERROR=k:"error"i  { return ast("keyword").set("value", k) }
ESCAPE=k:"escape"i  { return ast("keyword").set("value", k) }
EVERY=k:"every"i  { return ast("keyword").set("value", k) }
EXCLUSIVE=k:"exclusive"i  { return ast("keyword").set("value", k) }
EXECUTE=k:"execute"i  { return ast("keyword").set("value", k) }
EXISTS=k:"exists"i  { return ast("keyword").set("value", k) }
EXIT=k:"exit"i  { return ast("keyword").set("value", k) }
EXTEND=k:"extend"i  { return ast("keyword").set("value", k) }
EXTERNAL=k:"external"i  { return ast("keyword").set("value", k) }
FETCH=k:"fetch"i  { return ast("keyword").set("value", k) }
FIELD=k:"field"i  { return ast("keyword").set("value", k) }
FILE=k:"file"i  { return ast("keyword").set("value", k) }
FINISH=k:"finish"i ? { return  ast("keyword").set("value", k) }
FIRST=k:"first"i  { return ast("keyword").set("value", k) }
FLOAT=k:"float"i  { return ast("keyword").set("value", k) }
FLUSH=k:"flush"i  { return ast("keyword").set("value", k) }
FOR=k:"for"i ? { return  ast("keyword").set("value", k) }
FOREACH=k:"foreach"i ? { return  ast("keyword").set("value", k) }
FORM=k:"form"i  { return ast("keyword").set("value", k) }
FORMAT=k:"format"i  { return ast("keyword").set("value", k) }
FORMONLY=k:"formonly"i  { return ast("keyword").set("value", k) }
FOUND=k:"found"i  { return ast("keyword").set("value", k) }
FRACTION=k:"fraction"i  { return ast("keyword").set("value", k) }
FREE=k:"free"i  { return ast("keyword").set("value", k) }
FROM=k:"from"i  { return ast("keyword").set("value", k) }
FUNCTION=k:"function"i ? { return  ast("keyword").set("value", k) }
GLOBALS=k:"globals"i  { return ast("keyword").set("value", k) }
GO=k:"go"i  { return ast("keyword").set("value", k) }
GOTO=k:"goto"i  { return ast("keyword").set("value", k) }
GREEN=k:"green"i  { return ast("keyword").set("value", k) }
GROUP=k:"group"i  { return ast("keyword").set("value", k) }
HAVING=k:"having"i  { return ast("keyword").set("value", k) }
HEADER=k:"header"i  { return ast("keyword").set("value", k) }
HELP=k:"help"i  { return ast("keyword").set("value", k) }
HIDE=k:"hide"i  { return ast("keyword").set("value", k) }
HOLD=k:"hold"i  { return ast("keyword").set("value", k) }
HOUR=k:"hour"i  { return ast("keyword").set("value", k) }
IF=k:"if"i  { return ast("keyword").set("value", k) }
IN=k:"in"i  { return ast("keyword").set("value", k) }
INCLUDE=k:"include"i  { return ast("keyword").set("value", k) }
INDEX=k:"index"i  { return ast("keyword").set("value", k) }
INITIALIZE=k:"initialize"i  { return ast("keyword").set("value", k) }
INPUT=k:"input"i  { return ast("keyword").set("value", k) }
INSERT=k:"insert"i  { return ast("keyword").set("value", k) }
INSTRUCTIONS=k:"instructions"i  { return ast("keyword").set("value", k) }
INT=k:"int"i  { return ast("keyword").set("value", k) }
INTEGER=k:"integer"i  { return ast("keyword").set("value", k) }
INTERRUPT=k:"interrupt"i  { return ast("keyword").set("value", k) }
INTERVAL=k:"interval"i  { return ast("keyword").set("value", k) }
INTO=k:"into"i  { return ast("keyword").set("value", k) }
INVISIBLE=k:"invisible"i  { return ast("keyword").set("value", k) }
IS=k:"is"i  { return ast("keyword").set("value", k) }
ISOLATION=k:"isolation"i  { return ast("keyword").set("value", k) }
KEY=k:"key"i  { return ast("keyword").set("value", k) }
LABEL=k:"label"i  { return ast("keyword").set("value", k) }
LAST=k:"last"i  { return ast("keyword").set("value", k) }
LEFT=k:"left"i  { return ast("keyword").set("value", k) }
LENGTH=k:"length"i  { return ast("keyword").set("value", k) }
LET=k:"let"i  { return ast("keyword").set("value", k) }
LIKE=k:"like"i  { return ast("keyword").set("value", k) }
LINE=k:"line"i  { return ast("keyword").set("value", k) }
LINES=k:"lines"i  { return ast("keyword").set("value", k) }
LOAD=k:"load"i  { return ast("keyword").set("value", k) }
LOCATE=k:"locate"i  { return ast("keyword").set("value", k) }
LOCK=k:"lock"i  { return ast("keyword").set("value", k) }
LOG=k:"log"i  { return ast("keyword").set("value", k) }
MAGENTA=k:"magenta"i  { return ast("keyword").set("value", k) }
MAIN=k:"main"i ? { return  ast("keyword").set("value", k) }
MARGIN=k:"margin"i  { return ast("keyword").set("value", k) }
MATCHES=k:"matches"i  { return ast("keyword").set("value", k) }
MAX=k:"max"i  { return ast("keyword").set("value", k) }
MDY=k:"mdy"i  { return ast("keyword").set("value", k) }
MEMORY=k:"memory"i  { return ast("keyword").set("value", k) }
MENU=k:"menu"i  { return ast("keyword").set("value", k) }
MESSAGE=k:"message"i  { return ast("keyword").set("value", k) }
MIN=k:"min"i  { return ast("keyword").set("value", k) }
MINUTE=k:"minute"i  { return ast("keyword").set("value", k) }
MOD=k:"mod"i  { return ast("keyword").set("value", k) }
MODE=k:"mode"i  { return ast("keyword").set("value", k) }
MONEY=k:"money"i  { return ast("keyword").set("value", k) }
MONTH=k:"month"i  { return ast("keyword").set("value", k) }
NAME=k:"name"i  { return ast("keyword").set("value", k) }
NCHAR=k:"nchar"i  { return ast("keyword").set("value", k) }
NEED=k:"need"i  { return ast("keyword").set("value", k) }
NEXT=k:"next"i  { return ast("keyword").set("value", k) }
NO=k:"no"i  { return ast("keyword").set("value", k) }
NOENTRY=k:"noentry"i  { return ast("keyword").set("value", k) }
NORMAL=k:"normal"i  { return ast("keyword").set("value", k) }
NOT=k:"not"i  { return ast("keyword").set("value", k) }
NOTFOUND=k:"notfound"i  { return ast("keyword").set("value", k) }
NULL=k:"null"i  { return ast("keyword").set("value", k) }
NUMERIC=k:"numeric"i  { return ast("keyword").set("value", k) }
NVARCHAR=k:"nvarchar"i  { return ast("keyword").set("value", k) }
OF=k:"of"i  { return ast("keyword").set("value", k) }
OFF=k:"off"i  { return ast("keyword").set("value", k) }
ON=k:"on"i  { return ast("keyword").set("value", k) }
OPEN=k:"open"i  { return ast("keyword").set("value", k) }
OPTION=k:"option"i  { return ast("keyword").set("value", k) }
OPTIONS=k:"options"i  { return ast("keyword").set("value", k) }
OR=k:"or"i  { return ast("keyword").set("value", k) }
ORDER=k:"order"i  { return ast("keyword").set("value", k) }
OTHERWISE=k:"otherwise"i  { return ast("keyword").set("value", k) }
OUTER=k:"outer"i  { return ast("keyword").set("value", k) }
OUTPUT=k:"output"i  { return ast("keyword").set("value", k) }
PAGE=k:"page"i  { return ast("keyword").set("value", k) }
PAGENO=k:"pageno"i  { return ast("keyword").set("value", k) }
PIPE=k:"pipe"i  { return ast("keyword").set("value", k) }
PRECISION=k:"precision"i  { return ast("keyword").set("value", k) }
PREPARE=k:"prepare"i  { return ast("keyword").set("value", k) }
PREVIOUS=k:"previous"i  { return ast("keyword").set("value", k) }
PRIMARY=k:"primary"i  { return ast("keyword").set("value", k) }
PRINT=k:"print"i  { return ast("keyword").set("value", k) }
PROGRAM=k:"program"i  { return ast("keyword").set("value", k) }
PROMPT=k:"prompt"i  { return ast("keyword").set("value", k) }
PUT=k:"put"i  { return ast("keyword").set("value", k) }
QUIT=k:"quit"i  { return ast("keyword").set("value", k) }
READ=k:"read"i  { return ast("keyword").set("value", k) }
REAL=k:"real"i  { return ast("keyword").set("value", k) }
RECORD=k:"record"i  { return ast("keyword").set("value", k) }
RED=k:"red"i  { return ast("keyword").set("value", k) }
REPORT=k:"report"i  { return ast("keyword").set("value", k) }
RETURN=k:"return"i  { return ast("keyword").set("value", k) }
RETURNING=k:"returning"i  { return ast("keyword").set("value", k) }
REVERSE=k:"reverse"i  { return ast("keyword").set("value", k) }
RIGTH=k:"rigth"i  { return ast("keyword").set("value", k) }
ROLLBACK=k:"rollback"i  { return ast("keyword").set("value", k) }
ROW=k:"row"i  { return ast("keyword").set("value", k) }
ROWS=k:"rows"i  { return ast("keyword").set("value", k) }
RUN=k:"run"i  { return ast("keyword").set("value", k) }
SCREEN=k:"screen"i  { return ast("keyword").set("value", k) }
SCROLL=k:"scroll"i  { return ast("keyword").set("value", k) }
SECOND=k:"second"i  { return ast("keyword").set("value", k) }
SELECT=k:"select"i  { return ast("keyword").set("value", k) }
SET=k:"set"i  { return ast("keyword").set("value", k) }
SHARE=k:"share"i  { return ast("keyword").set("value", k) }
SHOW=k:"show"i  { return ast("keyword").set("value", k) }
SKIP=k:"skip"i  { return ast("keyword").set("value", k) }
SLEEP=k:"sleep"i  { return ast("keyword").set("value", k) }
SMALL=k:"small"i  { return ast("keyword").set("value", k) }
SMALLFLOAT=k:"smallfloat"i  { return ast("keyword").set("value", k) }
SMALLINT=k:"smallint"i  { return ast("keyword").set("value", k) }
SPACE=k:"space"i  { return ast("keyword").set("value", k) }
SPACES=k:"spaces"i  { return ast("keyword").set("value", k) }
SQL=k:"sql"i  { return ast("keyword").set("value", k) }
SQLERROR=k:"sqlerror"i  { return ast("keyword").set("value", k) }
SQLWARNING=k:"sqlwarning"i  { return ast("keyword").set("value", k) }
START=k:"start"i  { return ast("keyword").set("value", k) }
STEP=k:"step"i  { return ast("keyword").set("value", k) }
STOP=k:"stop"i  { return ast("keyword").set("value", k) }
STRING=k:"string"i  { return ast("keyword").set("value", k) }
SUM=k:"sum"i  { return ast("keyword").set("value", k) }
TABLE=k:"table"i  { return ast("keyword").set("value", k) }
TABLES=k:"tables"i  { return ast("keyword").set("value", k) }
TEMP=k:"temp"i  { return ast("keyword").set("value", k) }
TEXT=k:"text"i  { return ast("keyword").set("value", k) }
THEN=k:"then"i  { return ast("keyword").set("value", k) }
THROUGH=k:"through"i  { return ast("keyword").set("value", k) }
THRU=k:"thru"i  { return ast("keyword").set("value", k) }
TIME=k:"time"i  { return ast("keyword").set("value", k) }
TO=k:"to"i  { return ast("keyword").set("value", k) }
TODAY=k:"today"i  { return ast("keyword").set("value", k) }
TOP=k:"top"i  { return ast("keyword").set("value", k) }
TRAILER=k:"trailer"i  { return ast("keyword").set("value", k) }
TYPE=k:"type"i  { return ast("keyword").set("value", k) }
UNCONSTRAINED=k:"unconstrained"i  { return ast("keyword").set("value", k) }
UNDERLINE=k:"underline"i  { return ast("keyword").set("value", k) }
UNION=k:"union"i  { return ast("keyword").set("value", k) }
UNIQUE=k:"unique"i  { return ast("keyword").set("value", k) }
UNITS=k:"units"i  { return ast("keyword").set("value", k) }
UNLOAD=k:"unload"i  { return ast("keyword").set("value", k) }
UNLOCK=k:"unlock"i  { return ast("keyword").set("value", k) }
UP=k:"up"i  { return ast("keyword").set("value", k) }
UPDATE=k:"update"i  { return ast("keyword").set("value", k) }
UPSHIFT=k:"upshift"i  { return ast("keyword").set("value", k) }
USING=k:"using"i  { return ast("keyword").set("value", k) }
VALIDATE=k:"validate"i  { return ast("keyword").set("value", k) }
VALUES=k:"values"i  { return ast("keyword").set("value", k) }
VARCHAR=k:"varchar"i  { return ast("keyword").set("value", k) }
WAIT=k:"wait"i  { return ast("keyword").set("value", k) }
WAITING=k:"waiting"i  { return ast("keyword").set("value", k) }
WARNING=k:"warning"i  { return ast("keyword").set("value", k) }
WEEKDAY=k:"weekday"i  { return ast("keyword").set("value", k) }
WHEN=k:"when"i  { return ast("keyword").set("value", k) }
WHENEVER=k:"whenever"i  { return ast("keyword").set("value", k) }
WHERE=k:"where"i  { return ast("keyword").set("value", k) }
WHILE=k:"while"i  { return ast("keyword").set("value", k) }
WHITE=k:"white"i  { return ast("keyword").set("value", k) }
WINDOW=k:"window"i  { return ast("keyword").set("value", k) }
WITH=k:"with"i  { return ast("keyword").set("value", k) }
WITHOUT=k:"without"i  { return ast("keyword").set("value", k) }
WORDWRAP=k:"wordwrap"i  { return ast("keyword").set("value", k) }
WORK=k:"work"i  { return ast("keyword").set("value", k) }
WRAP=k:"wrap"i  { return ast("keyword").set("value", k) }
YEAR=k:"year"i  { return ast("keyword").set("value", k) }
YELLOW=k:"yellow"i  { return ast("keyword").set("value", k) }
