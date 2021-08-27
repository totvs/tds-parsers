// Gramática eleborada com base na documentação disponibilizada em
// https://www.oninit.com/manual/informix/english/docs/4gl/7609.pdf
// e na pasta "docs" há uma cópia
{

const ast = options.util.makeAST(location, options);

const astBlock = (_begin, _body, _end) => {
  const begin = ast("beginBlock").add(_begin);
  const body = ast("bodyBlock").add(_body || []);
  const end = ast("endBlock").add(_end);
  
  return ast("block").add(begin).add(body).add(end);
};

}

start_program
	= p1:blocks?  { return ast("program").add(p1 || []) }

blocks
  = l:block+ p:blocks { return l.concat(p); }
  / p:block+ { return p; }
  / p:block { return [p]; }

start_token
	= p1:onlyTokens?  { return ast("token").add(p1 || []) }

onlyTokens
  = l:tokens+ p:onlyTokens { return l.concat(p); }
  / p:tokens+ { return p; }
  / p:tokens { return [p]; }

block
  = comment
  / moduleBlock
  / globalBlock
  / mainBlock
  / functionBlock
  / WS_NL

codeBlock
  = comment
//  / whileBlock
  / recordBlock
  / forBlock
  / forEachBlock
  / ifBlock
  / WS_NL

globalBlock
  = s:GLOBALS t:(WS_NL string endLine) { return [s, t] }
  / b:(GLOBALS endLine)
      t:tokensBlock*
    e:(END WS_NL GLOBALS endLine)
    { return astBlock(b, t, e) }

moduleBlock
  = s:DEFINE t:defineToken { return [s, ...t] }
    / s:DATABASE t:(WS_NL identifer endLine) { return [s, ...t] }

defineToken
  = (!(MAIN / FUNCTION / END) tokens)+
  
mainBlock
  = b:(MAIN endLine)
      t:tokensBlock*
    e:(END WS_NL MAIN endLine)  
    { return astBlock(b, t, e) }

functionBlock
  = b:(FUNCTION WS_NL identifer WS_NL? argumentList endLine)
      t:tokensBlock*
    e:(END WS_NL FUNCTION endLine)
    { return astBlock(b, t, e) }

forBlock
  = b:(FOR) 
      t:tokensBlock*
    e:(END WS_NL FOR endLine)
    { return astBlock(b, t, e) }

forEachBlock
  = b:(FOREACH) 
      t:tokensBlock*
    e:(END WS_NL FOREACH endLine)
    { return astBlock(b, t, e) }

recordBlock
  = b:(RECORD) 
      t:tokensBlock*
    e:(END WS_NL RECORD (endLine / WS? COMMA))
    { return astBlock(b, t, e).setAttribute('recordBlock', true) }

ifBlock
  = b:(IF) 
      t:tokensBlock*
    e:(END WS_NL IF endLine)
    { return astBlock(b, t, e) }

argumentList
  = o:(O_PARENTHESIS WS_NL?)
      a:arguments?
  c:C_PARENTHESIS 
  { return ast("argumentList").add([o, a || [], c]) }  

arguments
  = l:arg_list+ p:arg_value { return l.concat(p); }
  / p:arg_list+ { return p; }
  / p:arg_value { return [p]; }

arg_list = WS_NL? identifer WS_NL? COMMA WS_NL? 

arg_value = WS_NL? identifer WS_NL?

tokensBlock
  = codeBlock
  / !(END) tokens

tokens
  = WS_NL
  / comment
  / statements
  / keywords
  / builtInVar
  / operators
  / string
  / number
  / identifer 

// Devido ao mecanismo de funcionamento do PEGJS, a lista de palavras chaves
// e comandos devem ser informados em ordem descrescente
statements
= s:(
  WHILE
  / WHENEVER
  / VALIDATE
  / UPDATE
  / UNLOCK
  / UNLOAD
  / TABLES
  / START
  / SLEEP
  / SKIP
  / SET
  / SELECT
  / SCROLL
  / SCREEN
  / RUN
  / ROLLFORWARD
  / ROLLBACK
  / REVOKE
  / RETURN
  / REPORT
  / RENAME
  / RECOVER
  / PUT
  / PROMPT
  / PRIMARY
  / PREPARE
  / PAUSE
  / OUTPUT
  / ORDER
  / OPTIONS
  / OPEN
  / NEED
  / MESSAGE
  / MENU
  / MAIN
  / LOCK
  / LOCATE
  / LOAD
  / LET
  / LABEL
  / INSTRUCTIONS
  / INSERT
  / INPUT
  / INITIALIZE
  / IF
  / GRANT
  / GOTO
  / GLOBALS
  / FUNCTION
  / FREE
  / FORMAT
  / FOREACH
  / FOR
  / FLUSH
  / FINISH
  / FETCH
  / EXIT
  / EXECUTE
  / ERROR
  / END
  / DROP
  / DISPLAY
  / DELETE
  / DEFINE
  / DEFER
  / DECLARE
  / DATABASE
  / CREATE
  / CONTINUE
  / CONSTRUCT
  / COMMIT
  / CLOSE
  / CLEAR
  / CASE
  / CALL
  / BEGIN
  / ATTRIBUTES
  / ALTER
) &(WS_NL / operators) 

keywords
= s:(
  YELLOW
  / YEAR
  / WRAP
  / WORK
  / WORDWRAP
  / WITHOUT
  / WITH
  / WINDOW
  / WHITE
  / WHERE
  / WHEN
  / WEEKDAY
  / WARNING
  / WAITING
  / WAIT
  / VARCHAR
  / VALUES
  / USING
  / UPSHIFT
  / UP
  / UNITS
  / UNIQUE
  / UNION
  / UNDERLINE
  / UNCONSTRAINED
  / TYPE
  / TRAILER
  / TOP
  / TODAY
  / TO
  / TIME
  / THRU
  / THROUGH
  / THEN
  / TEXT
  / TEMP
  / TABLE
  / SUM
  / STRING
  / STOP
  / STEP
  / SQLWARNING
  / SQLERROR
  / SQL
  / SPACES
  / SPACE
  / SMALLINT
  / SMALLFLOAT
  / SMALL
  / SHOW
  / SHARE
  / SECOND
  / ROWS
  / ROW
  / RIGTH
  / REVERSE
  / RETURNING
  / RED
  / RECORD
  / REAL
  / READ
  / QUIT
  / PROGRAM
  / PRINT
  / PREVIOUS
  / PRECISION
  / PIPE
  / PAGENO
  / PAGE
  / OUTER
  / OTHERWISE
  / OR
  / OPTION
  / ON
  / OFF
  / OF
  / NVARCHAR
  / NUMERIC
  / NULL
  / NOTFOUND
  / NOT
  / NORMAL
  / NOENTRY
  / NO
  / NEXT
  / NCHAR
  / NAME
  / MONTH
  / MONEY
  / MODE
  / MOD
  / MINUTE
  / MIN
  / MEMORY
  / MDY
  / MAX
  / MATCHES
  / MARGIN
  / MAGENTA
  / LOG
  / LINES
  / LINE
  / LIKE
  / LENGTH
  / LEFT
  / LAST
  / KEY
  / ISOLATION
  / IS
  / INVISIBLE
  / INTO
  / INTERVAL
  / INTERRUPT
  / INTEGER
  / INT
  / INDEX
  / INCLUDE
  / IN
  / HOUR
  / HOLD
  / HIDE
  / HELP
  / HEADER
  / HAVING
  / GROUP
  / GREEN
  / GO
  / FROM
  / FRACTION
  / FOUND
  / FORMONLY
  / FORM
  / FLOAT
  / FIRST
  / FILE
  / FIELD
  / EXTERNAL
  / EXTEND
  / EXISTS
  / EXCLUSIVE
  / EVERY
  / ESCAPE
  / ELSE
  / ELIF
  / DYNAMIC
  / DOWNSHIFT
  / DOWN
  / DOUBLE
  / DISTINCT
  / DIRTY
  / DIM
  / DESCENDING
  / DESC
  / DELIMITERS
  / DELIMITER
  / DEFAULTS
  / DECIMAL
  / DEC
  / DAY
  / DATETIME
  / DATE
  / CYAN
  / CURSOR
  / CURRENT
  / COUNT
  / CONTROL
  / CONSTRAINT
  / COMMENTS
  / COMMENT
  / COMMAND
  / COLUMNS
  / COLUMN
  / CLIPPED
  / CHARACTER
  / CHAR
  / BYTE
  / BY
  / BOTTOM
  / BORDER
  / BOLD
  / BLUE
  / BLINK
  / BLACK
  / BIGINT
  / BETWEEN
  / BEFORE
  / AVG
  / AUTONEXT
  / ATTRIBUTE
  / AT
  / ASCII
  / ASCENDING
  / ASC
  / ARRAY
  / ANY
  / AND
  / ALL
  / AFTER
  / ACCEPT
) &(WS_NL / operators)

operators
  = (
    C_BRACES
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
    / AT_SIGN
    / DOUBLE_PIPE
  )

builtInVar
  = (
    INT_FLAG
    / NOT_FOUND 
    / SQL_CODE 
    / STATUS 
    / QUIT_FLAG 
    / SQL_CA_RECORD 
    / SQL_ERR_M 
    / SQL_ERR_P 
    / SQL_ERR_D 
    / SQL_AWARN 
  )

comment
  = c:$(singleComment NL) { return ast("comment", c) }
  / c:$(POUND POUND (!NL .)* NL) { return ast("comment", c) }
  / c:$(MINUS MINUS POUND? (!NL .)* NL) { return ast("comment", c) }
  / c:$(O_BRACES $(!C_BRACES .)* C_BRACES) { return ast("blockComment", c) }

endLine
  = w:WS* c:singleComment? n:NL
      { return ast("endLine", [w, c, n]) }

singleComment
  = c:$(POUND $(!NL .)*) { return ast("singleComment", c) }

string
  = s:$(double_quoted_string / single_quoted_string) {
      return ast("string", s);
    }

double_quoted_string = $(D_QUOTE (!D_QUOTE (ESCAPED / .))* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE (ESCAPED / .))* S_QUOTE)

number
  = n:$([-+]? DIGIT+ (DOT DIGIT+)?) 
  { return ast("number", n); }

ESCAPED
 = '\\"' { return '\\"'}
 / "\\'" { return "\\'"}

WS
  = s:$((" " / "\t")+)
  { return ast("whiteSpace", s) }

NL 
  = s:$("\n" / "\r" / "\r\n")+
  { return ast("newLine", s) }

WS_NL
  = (WS / NL)+

DIGIT = [0-9]

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';

identifer
  = i:$(ID DOT ASTERISK) { return ast("identifier", i) }
  / i:$(DOT ID) { return ast("identifier", i) }
  / i:ID { return ast("identifier", i) }

ID = $(
      ([a-zA-Z_] [a-zA-Z_0-9]*) 
      (DOT ([a-zA-Z_] [a-zA-Z_0-9]*))*
    )

TRUE=c:"true"i { return ast("constant", c) }
FALSE=c:"false"i { return ast("constant", c) }

INT_FLAG = v:"int_flag"i { return ast("builtInVar", v) }
NOT_FOUND = v:"notfound"i { return ast("builtInVar", v) } 
SQL_CODE = v:"sqlcode"i { return ast("builtInVar", v) } 
STATUS = v:"status"i { return ast("builtInVar", v) } 
QUIT_FLAG = v:"quit_flag"i { return ast("builtInVar", v) } 
SQL_CA_RECORD = v:"sqlcarecord"i { return ast("builtInVar", v) } 
SQL_ERR_M = v:"sqlerrm"i { return ast("builtInVar", v) } 
SQL_ERR_P = v:"sqlerrp"i { return ast("builtInVar", v) } 
SQL_ERR_D = v:"sqlerrd"i { return ast("builtInVar", v) } 
SQL_AWARN = v:"sqlawarn"i { return ast("builtInVar", v) } 

POUND = o:"#" { return ast("operator", o) }
AT_SIGN = o:"@" { return ast("operator", o) }
EXCLAMATION = o:"!" { return ast("operator", o) }
COLON = o:":" { return ast("operator", o) }
DOUBLE_PIPE = o:"||" { return ast("operator", o) }

O_BRACES=o:"{" { return ast("operatorBraces", o) }
C_BRACES=o:"}" { return ast("operatorBraces", o) }
O_BRACKET=o:"[" { return ast("operatorBracket", o) }
C_BRACKET=o:"]" { return ast("operatorBracket", o) }
O_PARENTHESIS=o:"(" { return ast("operatorParenthesis", o) }
C_PARENTHESIS=o:")" { return ast("operatorParenthesis", o) }

COMMA=o:"," { return ast("operatorSeparator", o) }

ASTERISK=o:"*" { return ast("operatorMath", o) }
EQUAL=o:"="  { return ast("operatorMath", o) }
LESS=o:"<" { return ast("operatorMath", o) }
GREATER=o:">" { return ast("operatorMath", o) }
PLUS=o:"+" { return ast("operatorMath", o) }
MINUS=o:"-" { return ast("operatorMath", o) }
SLASH=o:"/" { return ast("operatorMath", o) }

ACCEPT = k:"accept"i { return ast('keyword', k) }
AFTER = k:"after"i { return ast('keyword', k) }
ALL = k:"all"i { return ast('keyword', k) }
ALTER = s:"alter"i { return ast('statement', s) }
AND = k:"and"i { return ast('keyword', k) }
ANY = k:"any"i { return ast('keyword', k) }
ARRAY = k:"array"i { return ast('keyword', k) }
ASC = k:"asc"i { return ast('keyword', k) }
ASCENDING = k:"ascending"i { return ast('keyword', k) }
ASCII = k:"ascii"i { return ast('keyword', k) }
AT = k:"at"i { return ast('keyword', k) }
ATTRIBUTE = k:"attribute"i { return ast('keyword', k) }
ATTRIBUTES = s:"attributes"i { return ast('statement', s) }
AUTONEXT = k:"autonext"i { return ast('keyword', k) }
AVG = k:"avg"i { return ast('keyword', k) }
BEFORE = k:"before"i { return ast('keyword', k) }
BEGIN = s:"begin"i { return ast('statement', s) }
BETWEEN = k:"between"i { return ast('keyword', k) }
BIGINT = k:"bigint"i { return ast('keyword', k) }
BLACK = k:"black"i { return ast('keyword', k) }
BLINK = k:"blink"i { return ast('keyword', k) }
BLUE = k:"blue"i { return ast('keyword', k) }
BOLD = k:"bold"i { return ast('keyword', k) }
BORDER = k:"border"i { return ast('keyword', k) }
BOTTOM = k:"bottom"i { return ast('keyword', k) }
BY = k:"by"i { return ast('keyword', k) }
BYTE = k:"byte"i { return ast('keyword', k) }
CALL = s:"call"i { return ast('statement', s) }
CASE = s:"case"i { return ast('statement', s) }
CHAR = k:"char"i { return ast('keyword', k) }
CHARACTER = k:"character"i { return ast('keyword', k) }
CLEAR = s:"clear"i { return ast('statement', s) }
CLIPPED = k:"clipped"i { return ast('keyword', k) }
CLOSE = s:"close"i { return ast('statement', s) }
COLUMN = k:"column"i { return ast('keyword', k) }
COLUMNS = k:"columns"i { return ast('keyword', k) }
COMMAND = k:"command"i { return ast('keyword', k) }
COMMENT = k:"comment"i { return ast('keyword', k) }
COMMENTS = k:"comments"i { return ast('keyword', k) }
COMMIT = s:"commit"i { return ast('statement', s) }
CONSTRAINT = k:"constraint"i { return ast('keyword', k) }
CONSTRUCT = s:"construct"i { return ast('statement', s) }
CONTINUE = s:"continue"i { return ast('statement', s) }
CONTROL = k:"control"i { return ast('keyword', k) }
COUNT = k:"count"i { return ast('keyword', k) }
CREATE = s:"create"i { return ast('statement', s) }
CURRENT = k:"current"i { return ast('keyword', k) }
CURSOR = k:"cursor"i { return ast('keyword', k) }
CYAN = k:"cyan"i { return ast('keyword', k) }
DATABASE = s:"database"i { return ast('statement', s) }
DATE = k:"date"i { return ast('keyword', k) }
DATETIME = k:"datetime"i { return ast('keyword', k) }
DAY = k:"day"i { return ast('keyword', k) }
DEC = k:"dec"i { return ast('keyword', k) }
DECIMAL = k:"decimal"i { return ast('keyword', k) }
DECLARE = s:"declare"i { return ast('statement', s) }
DEFAULTS = k:"defaults"i { return ast('keyword', k) }
DEFER = s:"defer"i { return ast('statement', s) }
DEFINE = s:"define"i { return ast('statement', s) }
DELETE = s:"delete"i { return ast('statement', s) }
DELIMITER = k:"delimiter"i { return ast('keyword', k) }
DELIMITERS = k:"delimiters"i { return ast('keyword', k) }
DESC = k:"desc"i { return ast('keyword', k) }
DESCENDING = k:"descending"i { return ast('keyword', k) }
DIM = k:"dim"i { return ast('keyword', k) }
DIRTY = k:"dirty"i { return ast('keyword', k) }
DISPLAY = s:"display"i { return ast('statement', s) }
DISTINCT = k:"distinct"i { return ast('keyword', k) }
DOUBLE = k:"double"i { return ast('keyword', k) }
DOWN = k:"down"i { return ast('keyword', k) }
DOWNSHIFT = k:"downshift"i { return ast('keyword', k) }
DROP = s:"drop"i { return ast('statement', s) }
DYNAMIC = k:"dynamic"i { return ast('keyword', k) }
ELIF = k:"elif"i { return ast('keyword', k) }
ELSE = k:"else"i { return ast('keyword', k) }
END = s:"end"i { return ast('statement', s) }
ERROR = s:"error"i { return ast('statement', s) }
ESCAPE = k:"escape"i { return ast('keyword', k) }
EVERY = k:"every"i { return ast('keyword', k) }
EXCLUSIVE = k:"exclusive"i { return ast('keyword', k) }
EXECUTE = s:"execute"i { return ast('statement', s) }
EXISTS = k:"exists"i { return ast('keyword', k) }
EXIT = s:"exit"i { return ast('statement', s) }
EXTEND = k:"extend"i { return ast('keyword', k) }
EXTERNAL = k:"external"i { return ast('keyword', k) }
FETCH = s:"fetch"i { return ast('statement', s) }
FIELD = k:"field"i { return ast('keyword', k) }
FILE = k:"file"i { return ast('keyword', k) }
FINISH = s:"finish"i { return ast('statement', s) }
FIRST = k:"first"i { return ast('keyword', k) }
FLOAT = k:"float"i { return ast('keyword', k) }
FLUSH = s:"flush"i { return ast('statement', s) }
FOR = s:"for"i { return ast('statement', s) }
FOREACH = s:"foreach"i { return ast('statement', s) }
FORM = k:"form"i { return ast('keyword', k) }
FORMAT = s:"format"i { return ast('statement', s) }
FORMONLY = k:"formonly"i { return ast('keyword', k) }
FOUND = k:"found"i { return ast('keyword', k) }
FRACTION = k:"fraction"i { return ast('keyword', k) }
FREE = s:"free"i { return ast('statement', s) }
FROM = k:"from"i { return ast('keyword', k) }
FUNCTION = s:"function"i { return ast('statement', s) }
GLOBALS = s:"globals"i { return ast('statement', s) }
GO = k:"go"i { return ast('keyword', k) }
GOTO = s:"goto"i { return ast('statement', s) }
GRANT = s:"grant"i { return ast('statement', s) }
GREEN = k:"green"i { return ast('keyword', k) }
GROUP = k:"group"i { return ast('keyword', k) }
HAVING = k:"having"i { return ast('keyword', k) }
HEADER = k:"header"i { return ast('keyword', k) }
HELP = k:"help"i { return ast('keyword', k) }
HIDE = k:"hide"i { return ast('keyword', k) }
HOLD = k:"hold"i { return ast('keyword', k) }
HOUR = k:"hour"i { return ast('keyword', k) }
IF = s:"if"i { return ast('statement', s) }
IN = k:"in"i { return ast('keyword', k) }
INCLUDE = k:"include"i { return ast('keyword', k) }
INDEX = k:"index"i { return ast('keyword', k) }
INITIALIZE = s:"initialize"i { return ast('statement', s) }
INPUT = s:"input"i { return ast('statement', s) }
INSERT = s:"insert"i { return ast('statement', s) }
INSTRUCTIONS = s:"instructions"i { return ast('statement', s) }
INT = k:"int"i { return ast('keyword', k) }
INTEGER = k:"integer"i { return ast('keyword', k) }
INTERRUPT = k:"interrupt"i { return ast('keyword', k) }
INTERVAL = k:"interval"i { return ast('keyword', k) }
INTO = k:"into"i { return ast('keyword', k) }
INVISIBLE = k:"invisible"i { return ast('keyword', k) }
IS = k:"is"i { return ast('keyword', k) }
ISOLATION = k:"isolation"i { return ast('keyword', k) }
KEY = k:"key"i { return ast('keyword', k) }
LABEL = s:"label"i { return ast('statement', s) }
LAST = k:"last"i { return ast('keyword', k) }
LEFT = k:"left"i { return ast('keyword', k) }
LENGTH = k:"length"i { return ast('keyword', k) }
LET = s:"let"i { return ast('statement', s) }
LIKE = k:"like"i { return ast('keyword', k) }
LINE = k:"line"i { return ast('keyword', k) }
LINES = k:"lines"i { return ast('keyword', k) }
LOAD = s:"load"i { return ast('statement', s) }
LOCATE = s:"locate"i { return ast('statement', s) }
LOCK = s:"lock"i { return ast('statement', s) }
LOG = k:"log"i { return ast('keyword', k) }
MAGENTA = k:"magenta"i { return ast('keyword', k) }
MAIN = s:"main"i { return ast('statement', s) }
MARGIN = k:"margin"i { return ast('keyword', k) }
MATCHES = k:"matches"i { return ast('keyword', k) }
MAX = k:"max"i { return ast('keyword', k) }
MDY = k:"mdy"i { return ast('keyword', k) }
MEMORY = k:"memory"i { return ast('keyword', k) }
MENU = s:"menu"i { return ast('statement', s) }
MESSAGE = s:"message"i { return ast('statement', s) }
MIN = k:"min"i { return ast('keyword', k) }
MINUTE = k:"minute"i { return ast('keyword', k) }
MOD = k:"mod"i { return ast('keyword', k) }
MODE = k:"mode"i { return ast('keyword', k) }
MONEY = k:"money"i { return ast('keyword', k) }
MONTH = k:"month"i { return ast('keyword', k) }
NAME = k:"name"i { return ast('keyword', k) }
NCHAR = k:"nchar"i { return ast('keyword', k) }
NEED = s:"need"i { return ast('statement', s) }
NEXT = k:"next"i { return ast('keyword', k) }
NO = k:"no"i { return ast('keyword', k) }
NOENTRY = k:"noentry"i { return ast('keyword', k) }
NORMAL = k:"normal"i { return ast('keyword', k) }
NOT = k:"not"i { return ast('keyword', k) }
NOTFOUND = k:"notfound"i { return ast('keyword', k) }
NULL = k:"null"i { return ast('keyword', k) }
NUMERIC = k:"numeric"i { return ast('keyword', k) }
NVARCHAR = k:"nvarchar"i { return ast('keyword', k) }
OF = k:"of"i { return ast('keyword', k) }
OFF = k:"off"i { return ast('keyword', k) }
ON = k:"on"i { return ast('keyword', k) }
OPEN = s:"open"i { return ast('statement', s) }
OPTION = k:"option"i { return ast('keyword', k) }
OPTIONS = s:"options"i { return ast('statement', s) }
OR = k:"or"i { return ast('keyword', k) }
ORDER = s:"order"i { return ast('statement', s) }
OTHERWISE = k:"otherwise"i { return ast('keyword', k) }
OUTER = k:"outer"i { return ast('keyword', k) }
OUTPUT = s:"output"i { return ast('statement', s) }
PAGE = k:"page"i { return ast('keyword', k) }
PAGENO = k:"pageno"i { return ast('keyword', k) }
PAUSE = s:"pause"i { return ast('statement', s) }
PIPE = k:"pipe"i { return ast('keyword', k) }
PRECISION = k:"precision"i { return ast('keyword', k) }
PREPARE = s:"prepare"i { return ast('statement', s) }
PREVIOUS = k:"previous"i { return ast('keyword', k) }
PRIMARY = s:"primary"i { return ast('statement', s) }
PRINT = k:"print"i { return ast('keyword', k) }
PROGRAM = k:"program"i { return ast('keyword', k) }
PROMPT = s:"prompt"i { return ast('statement', s) }
PUT = s:"put"i { return ast('statement', s) }
QUIT = k:"quit"i { return ast('keyword', k) }
READ = k:"read"i { return ast('keyword', k) }
REAL = k:"real"i { return ast('keyword', k) }
RECORD = k:"record"i { return ast('keyword', k) }
RECOVER = s:"recover"i { return ast('statement', s) }
RED = k:"red"i { return ast('keyword', k) }
RENAME = s:"rename"i { return ast('statement', s) }
REPORT = s:"report"i { return ast('statement', s) }
RETURN = s:"return"i { return ast('statement', s) }
RETURNING = k:"returning"i { return ast('keyword', k) }
REVERSE = k:"reverse"i { return ast('keyword', k) }
REVOKE = s:"revoke"i { return ast('statement', s) }
RIGTH = k:"rigth"i { return ast('keyword', k) }
ROLLBACK = s:"rollback"i { return ast('statement', s) }
ROLLFORWARD = s:"rollforward"i { return ast('statement', s) }
ROW = k:"row"i { return ast('keyword', k) }
ROWS = k:"rows"i { return ast('keyword', k) }
RUN = s:"run"i { return ast('statement', s) }
SCREEN = s:"screen"i { return ast('statement', s) }
SCROLL = s:"scroll"i { return ast('statement', s) }
SECOND = k:"second"i { return ast('keyword', k) }
SELECT = s:"select"i { return ast('statement', s) }
SET = s:"set"i { return ast('statement', s) }
SHARE = k:"share"i { return ast('keyword', k) }
SHOW = k:"show"i { return ast('keyword', k) }
SKIP = s:"skip"i { return ast('statement', s) }
SLEEP = s:"sleep"i { return ast('statement', s) }
SMALL = k:"small"i { return ast('keyword', k) }
SMALLFLOAT = k:"smallfloat"i { return ast('keyword', k) }
SMALLINT = k:"smallint"i { return ast('keyword', k) }
SPACE = k:"space"i { return ast('keyword', k) }
SPACES = k:"spaces"i { return ast('keyword', k) }
SQL = k:"sql"i { return ast('keyword', k) }
SQLERROR = k:"sqlerror"i { return ast('keyword', k) }
SQLWARNING = k:"sqlwarning"i { return ast('keyword', k) }
START = s:"start"i { return ast('statement', s) }
STEP = k:"step"i { return ast('keyword', k) }
STOP = k:"stop"i { return ast('keyword', k) }
STRING = k:"string"i { return ast('keyword', k) }
SUM = k:"sum"i { return ast('keyword', k) }
TABLE = k:"table"i { return ast('keyword', k) }
TABLES = s:"tables"i { return ast('statement', s) }
TEMP = k:"temp"i { return ast('keyword', k) }
TEXT = k:"text"i { return ast('keyword', k) }
THEN = k:"then"i { return ast('keyword', k) }
THROUGH = k:"through"i { return ast('keyword', k) }
THRU = k:"thru"i { return ast('keyword', k) }
TIME = k:"time"i { return ast('keyword', k) }
TO = k:"to"i { return ast('keyword', k) }
TODAY = k:"today"i { return ast('keyword', k) }
TOP = k:"top"i { return ast('keyword', k) }
TRAILER = k:"trailer"i { return ast('keyword', k) }
TYPE = k:"type"i { return ast('keyword', k) }
UNCONSTRAINED = k:"unconstrained"i { return ast('keyword', k) }
UNDERLINE = k:"underline"i { return ast('keyword', k) }
UNION = k:"union"i { return ast('keyword', k) }
UNIQUE = k:"unique"i { return ast('keyword', k) }
UNITS = k:"units"i { return ast('keyword', k) }
UNLOAD = s:"unload"i { return ast('statement', s) }
UNLOCK = s:"unlock"i { return ast('statement', s) }
UP = k:"up"i { return ast('keyword', k) }
UPDATE = s:"update"i { return ast('statement', s) }
UPSHIFT = k:"upshift"i { return ast('keyword', k) }
USING = k:"using"i { return ast('keyword', k) }
VALIDATE = s:"validate"i { return ast('statement', s) }
VALUES = k:"values"i { return ast('keyword', k) }
VARCHAR = k:"varchar"i { return ast('keyword', k) }
WAIT = k:"wait"i { return ast('keyword', k) }
WAITING = k:"waiting"i { return ast('keyword', k) }
WARNING = k:"warning"i { return ast('keyword', k) }
WEEKDAY = k:"weekday"i { return ast('keyword', k) }
WHEN = k:"when"i { return ast('keyword', k) }
WHENEVER = s:"whenever"i { return ast('statement', s) }
WHERE = k:"where"i { return ast('keyword', k) }
WHILE = s:"while"i { return ast('statement', s) }
WHITE = k:"white"i { return ast('keyword', k) }
WINDOW = k:"window"i { return ast('keyword', k) }
WITH = k:"with"i { return ast('keyword', k) }
WITHOUT = k:"without"i { return ast('keyword', k) }
WORDWRAP = k:"wordwrap"i { return ast('keyword', k) }
WORK = k:"work"i { return ast('keyword', k) }
WRAP = k:"wrap"i { return ast('keyword', k) }
YEAR = k:"year"i { return ast('keyword', k) }
YELLOW = k:"yellow"i { return ast('keyword', k) }
