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
	= p1:superTokens?  { return ast("program").add(p1 || []) }

start_token
	= p1:onlyTokens?  { return ast("token").add(p1 || []) }

onlyTokens
  = l:onlyToken+ p:onlyTokens+ { return l.concat(p); }
  / p:onlyToken+ { return p; }
  / p:onlyToken { return [p]; }

onlyToken
  = WS_NL
  / comment
  / keywords
  / builtInVar
  / operators
  / string
  / number
  / identifer

superTokens
  = l:arg_token+ p:superTokens+ { return l.concat(p); }
  / p:arg_token+ { return p; }
  / p:arg_token { return [p]; }

arg_token = superToken

superToken
  = WS_NL
  / comment
  / moduleBlock
  / globalBlock
  / mainBlock
  / functionBlock
  /// o:$(!WS .)+ { return ast("notSpecified", o) }

globalBlock
  = GLOBALS WS_NL string endLine 
  / b:(GLOBALS endLine)
      t:tokens*
    e:(END WS_NL GLOBALS endLine)
    { return astBlock(b, t, e) }

moduleBlock
  = DEFINE defineTokens*
  / DATABASE WS_NL identifer

mainBlock
  = b:(MAIN endLine)
      t:tokens*
    e:(END WS_NL MAIN endLine)  
    { return astBlock(b, t, e) }

functionBlock
  = b:(FUNCTION WS_NL identifer WS_NL? argumentList endLine)
      t:tokens*
    e:(END WS_NL FUNCTION endLine)
    { return astBlock(b, t, e) }

forBlock
  = b:(FOR) 
      t:tokens*
    e:(END WS_NL FOR endLine)
    { return astBlock(b, t, e) }

forEachBlock
  = b:(FOREACH) 
      t:tokens*
    e:(END WS_NL FOREACH endLine)
    { return astBlock(b, t, e) }

recordBlock
  = b:(RECORD) 
      t:tokens*
    e:(END WS_NL RECORD (endLine / WS? COMMA))
    { return astBlock(b, t, e) }

ifBlock
  = b:(IF) 
      t:tokens*
    e:(END WS_NL IF endLine)
    { return astBlock(b, t, e) }

argumentList
  = o:(O_PARENTHESIS WS_NL?)
      a:arguments?
  c:C_PARENTHESIS 
  { return ast("argumentList").add([o, a || [], c]) }  

arguments
  = l:arg_list+ p:arg_value+ { return l.concat(p); }
  / p:arg_list+ { return p; }
  / p:arg_value { return [p]; }

arg_list = WS_NL? identifer WS_NL? COMMA WS_NL? 

arg_value = WS_NL? identifer WS_NL?

defineTokens
  = tokens

tokens
  = WS_NL
  / forBlock
  / forEachBlock
  / ifBlock
  / recordBlock
  / comment
  / keywords
  / builtInVar
  / operators
  / string
  / number
  / !(END / THEN) identifer

keywords
  = k:(
    ACCEPT
    / AFTER
    / ALL
    / AND
    / ANY
    / ARRAY
    / ASC
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
    / BLACK
    / BLINK
    / BLUE
    / BOLD
    / BORDER
    / BOTTOM
    / BY
    / BYTE
    / CALL
    / CASE
    / CHAR
    / CHARACTER
    / CLEAR
    / CLIPPED
    / CLOSE
    / COLUMN
    / COLUMNS
    / COMMAND
    / COMMENT
    / COMMENTS
    / COMMIT
    / CONSTRAINT
    / CONSTRUCT
    / CONTINUE
    / CONTROL
    / COUNT
    / CREATE
    / CURRENT
    / CURSOR
    / CYAN
    / DATE
    / DATETIME
    / DAY
    / DEC
    / DECIMAL
    / DECLARE
    / DEFAULTS
    / DEFER
    / DEFINE
    / DELETE
    / DELIMITER
    / DELIMITERS
    / DESC
    / DESCENDING
    / DIM
    / DIRTY
    / DISPLAY
    / DISTINCT
    / DOUBLE
    / DOWN
    / DOWNSHIFT
    / DROP
    / DYNAMIC
    / ELIF
    / ELSE
    / END
    / ERROR
    / ESCAPE
    / EVERY
    / EXCLUSIVE
    / EXECUTE
    / EXISTS
    / EXIT
    / EXTEND
    / EXTERNAL
    / FETCH
    / FIELD
    / FILE
    / FINISH
    / FIRST
    / FLOAT
    / FLUSH
    / FORM
    / FORMAT
    / FORMONLY
    / FOUND
    / FRACTION
    / FREE
    / FROM
    / FUNCTION
    / GO
    / GOTO
    / GREEN
    / GROUP
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
    / INT
    / INTEGER
    / INTERRUPT
    / INTERVAL
    / INTO
    / INVISIBLE
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
    / LOCATE
    / LOCK
    / LOG
    / MAGENTA
    / MAIN
    / MARGIN
    / MATCHES
    / MAX
    / MDY
    / MEMORY
    / MENU
    / MESSAGE
    / MIN
    / MINUTE
    / MOD
    / MODE
    / MONEY
    / MONTH
    / NAME
    / NCHAR
    / NEED
    / NEXT
    / NO
    / NOENTRY
    / NORMAL
    / NOT
    / NOTFOUND
    / NULL
    / NUMERIC
    / NVARCHAR
    / OF
    / OFF
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
    / PRECISION
    / PREPARE
    / PREVIOUS
    / PRIMARY
    / PRINT
    / PROGRAM
    / PROMPT
    / PUT
    / QUIT
    / READ
    / REAL
    / RED
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
    / SMALL
    / SMALLFLOAT
    / SMALLINT
    / SPACE
    / SPACES
    / SQL
    / SQLERROR
    / SQLWARNING
    / START
    / STEP
    / STOP
    / STRING
    / SUM
    / TABLE
    / TABLES
    / TEMP
    / TEXT
    / THEN
    / THROUGH
    / THRU
    / TIME
    / TO
    / TODAY
    / TOP
    / TRAILER
    / TYPE
    / UNCONSTRAINED  
    / UNDERLINE
    / UNION
    / UNIQUE
    / UNITS
    / UNLOAD
    / UNLOCK
    / UP
    / UPDATE
    / UPSHIFT
    / USING
    / VALIDATE
    / VALUES
    / VARCHAR
    / WAIT
    / WAITING
    / WARNING
    / WEEKDAY
    / WHEN
    / WHENEVER
    / WHERE
    / WHILE
    / WHITE
    / WINDOW
    / WITH
    / WITHOUT
    / WORDWRAP
    / WORK
    / WRAP
    / YEAR
    / YELLOW  
  ) &(WS_NL / operators)
  { return k;}

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
  = s:$([; \t]+)
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

ACCEPT = k:"accept"i { return ast("keyword", k) }
AFTER = k:"after"i  { return ast("keyword", k) }
ALL = k:"all"i  { return ast("keyword", k) }
AND = k:"and"i  { return ast("keyword", k) }
ANY = k:"any"i  { return ast("keyword", k) }
ARRAY = k:"array"i  { return ast("keyword", k) }
ASC = k:"asc"i  { return ast("keyword", k) }
ASCENDING = k:"ascending"i  { return ast("keyword", k) }
ASCII = k:"ascii"i  { return ast("keyword", k) }
AT = k:"year"i  { return ast("keyword", k) }
ATTRIBUTE = k:"attribute"i  { return ast("keyword", k) }
ATTRIBUTES = k:"attributes"i  { return ast("keyword", k) }
AUTONEXT = k:"autonext"i  { return ast("keyword", k) }
AVG = k:"avg"i  { return ast("keyword", k) }
BEFORE = k:"before"i  { return ast("keyword", k) }
BEGIN = k:"begin"i{ return ast("keyword", k) }
BETWEEN = k:"between"i  { return ast("keyword", k) }
BIGINT = k:"bigint"i  { return ast("keyword", k) }
BLACK = k:"black"i  { return ast("keyword", k) }
BLINK = k:"blink"i  { return ast("keyword", k) }
BLUE = k:"blue"i  { return ast("keyword", k) }
BOLD = k:"bold"i  { return ast("keyword", k) }
BORDER = k:"border"i  { return ast("keyword", k) }
BOTTOM = k:"bottom"i  { return ast("keyword", k) }
BY = k:"by"i  { return ast("keyword", k) }
BYTE = k:"byte"i  { return ast("keyword", k) }
CALL = k:"call"i  { return ast("keyword", k) }
CASE = k:"case"i{ return ast("keyword", k) }
CHAR = k:"char"i  { return ast("keyword", k) }
CHARACTER = k:"character"i  { return ast("keyword", k) }
CLEAR = k:"clear"i  { return ast("keyword", k) }
CLIPPED = k:"clipped"i  { return ast("keyword", k) }
CLOSE = k:"close"i  { return ast("keyword", k) }
COLUMN = k:"column"i  { return ast("keyword", k) }
COLUMNS = k:"columns"i  { return ast("keyword", k) }
COMMAND = k:"command"i  { return ast("keyword", k) }
COMMENT = k:"comment"i  { return ast("keyword", k) }
COMMENTS = k:"comments"i  { return ast("keyword", k) }
COMMIT = k:"commit"i  { return ast("keyword", k) }
CONSTRAINT = k:"constraint"i  { return ast("keyword", k) }
CONSTRUCT = k:"construct"i  { return ast("keyword", k) }
CONTINUE = k:"continue"i  { return ast("keyword", k) }
CONTROL = k:"control"i  { return ast("keyword", k) }
COUNT = k:"count"i  { return ast("keyword", k) }
CREATE = k:"create"i  { return ast("keyword", k) }
CURRENT = k:"current"i  { return ast("keyword", k) }
CURSOR = k:"cursor"i  { return ast("keyword", k) }
CYAN = k:"cyan"i  { return ast("keyword", k) }
DATABASE = k:"database"i  { return ast("keyword", k) }
DATE = k:"date"i  { return ast("keyword", k) }
DATETIME = k:"datetime"i  { return ast("keyword", k) }
DAY = k:"day"i  { return ast("keyword", k) }
DEC = k:"dec"i  { return ast("keyword", k) }
DECIMAL = k:"decimal"i  { return ast("keyword", k) }
DECLARE = k:"declare"i  { return ast("keyword", k) }
DEFAULTS = k:"defaults"i  { return ast("keyword", k) }
DEFER = k:"defer"i  { return ast("keyword", k) }
DEFINE = k:"define"i  { return ast("keyword", k) }
DELETE = k:"delete"i  { return ast("keyword", k) }
DELIMITER = k:"delimiter"i  { return ast("keyword", k) }
DELIMITERS = k:"delimiters"i  { return ast("keyword", k) }
DESC = k:"desc"i  { return ast("keyword", k) }
DESCENDING = k:"descending"i  { return ast("keyword", k) }
DIM = k:"dim"i  { return ast("keyword", k) }
DIRTY = k:"dirty"i  { return ast("keyword", k) }
DISPLAY = k:"display"i  { return ast("keyword", k) }
DISTINCT = k:"distinct"i  { return ast("keyword", k) }
DOUBLE = k:"double"i  { return ast("keyword", k) }
DOWN = k:"down"i  { return ast("keyword", k) }
DOWNSHIFT = k:"downshift"i  { return ast("keyword", k) }
DROP = k:"drop"i  { return ast("keyword", k) }
DYNAMIC = k:"dynamic"i  { return ast("keyword", k) }
ELIF = k:"elif"i  { return ast("keyword", k) }
ELSE = k:"else"i  { return ast("keyword", k) }
END = k:"end"i{ return ast("keyword", k) }
ERROR = k:"error"i  { return ast("keyword", k) }
ESCAPE = k:"escape"i  { return ast("keyword", k) }
EVERY = k:"every"i  { return ast("keyword", k) }
EXCLUSIVE = k:"exclusive"i  { return ast("keyword", k) }
EXECUTE = k:"execute"i  { return ast("keyword", k) }
EXISTS = k:"exists"i  { return ast("keyword", k) }
EXIT = k:"exit"i  { return ast("keyword", k) }
EXTEND = k:"extend"i  { return ast("keyword", k) }
EXTERNAL = k:"external"i  { return ast("keyword", k) }
FETCH = k:"fetch"i  { return ast("keyword", k) }
FIELD = k:"field"i  { return ast("keyword", k) }
FILE = k:"file"i  { return ast("keyword", k) }
FINISH = k:"finish"i{ return ast("keyword", k) }
FIRST = k:"first"i  { return ast("keyword", k) }
FLOAT = k:"float"i  { return ast("keyword", k) }
FLUSH = k:"flush"i  { return ast("keyword", k) }
FOR = k:"for"i { return ast("keyword", k) }
FOREACH = k:"foreach"i{ return ast("keyword", k) }
FORM = k:"form"i  { return ast("keyword", k) }
FORMAT = k:"format"i  { return ast("keyword", k) }
FORMONLY = k:"formonly"i  { return ast("keyword", k) }
FOUND = k:"found"i  { return ast("keyword", k) }
FRACTION = k:"fraction"i  { return ast("keyword", k) }
FREE = k:"free"i  { return ast("keyword", k) }
FROM = k:"from"i  { return ast("keyword", k) }
FUNCTION = k:"function"i{ return ast("keyword", k) }
GLOBALS = k:"globals"i  { return ast("keyword", k) }
GO = k:"go"i  { return ast("keyword", k) }
GOTO = k:"goto"i  { return ast("keyword", k) }
GREEN = k:"green"i  { return ast("keyword", k) }
GROUP = k:"group"i  { return ast("keyword", k) }
HAVING = k:"having"i  { return ast("keyword", k) }
HEADER = k:"header"i  { return ast("keyword", k) }
HELP = k:"help"i  { return ast("keyword", k) }
HIDE = k:"hide"i  { return ast("keyword", k) }
HOLD = k:"hold"i  { return ast("keyword", k) }
HOUR = k:"hour"i  { return ast("keyword", k) }
IF = k:"if"i  { return ast("keyword", k) }
IN = k:"in"i  { return ast("keyword", k) }
INCLUDE = k:"include"i  { return ast("keyword", k) }
INDEX = k:"index"i  { return ast("keyword", k) }
INITIALIZE = k:"initialize"i  { return ast("keyword", k) }
INPUT = k:"input"i  { return ast("keyword", k) }
INSERT = k:"insert"i  { return ast("keyword", k) }
INSTRUCTIONS = k:"instructions"i{ return ast("keyword", k) }  
INT = k:"int"i  { return ast("keyword", k) }
INTEGER = k:"integer"i  { return ast("keyword", k) }
INTERRUPT = k:"interrupt"i  { return ast("keyword", k) }
INTERVAL = k:"interval"i  { return ast("keyword", k) }
INTO = k:"into"i  { return ast("keyword", k) }
INVISIBLE = k:"invisible"i  { return ast("keyword", k) }
IS = k:"is"i  { return ast("keyword", k) }
ISOLATION = k:"isolation"i  { return ast("keyword", k) }
KEY = k:"key"i  { return ast("keyword", k) }
LABEL = k:"label"i  { return ast("keyword", k) }
LAST = k:"last"i  { return ast("keyword", k) }
LEFT = k:"left"i  { return ast("keyword", k) }
LENGTH = k:"length"i  { return ast("keyword", k) }
LET = k:"let"i  { return ast("keyword", k) }
LIKE = k:"like"i  { return ast("keyword", k) }
LINE = k:"line"i  { return ast("keyword", k) }
LINES = k:"lines"i  { return ast("keyword", k) }
LOAD = k:"load"i  { return ast("keyword", k) }
LOCATE = k:"locate"i  { return ast("keyword", k) }
LOCK = k:"lock"i  { return ast("keyword", k) }
LOG = k:"log"i  { return ast("keyword", k) }
MAGENTA = k:"magenta"i  { return ast("keyword", k) }
MAIN = k:"main"i{ return ast("keyword", k) }
MARGIN = k:"margin"i  { return ast("keyword", k) }
MATCHES = k:"matches"i  { return ast("keyword", k) }
MAX = k:"max"i  { return ast("keyword", k) }
MDY = k:"mdy"i  { return ast("keyword", k) }
MEMORY = k:"memory"i  { return ast("keyword", k) }
MENU = k:"menu"i  { return ast("keyword", k) }
MESSAGE = k:"message"i  { return ast("keyword", k) }
MIN = k:"min"i  { return ast("keyword", k) }
MINUTE = k:"minute"i  { return ast("keyword", k) }
MOD = k:"mod"i  { return ast("keyword", k) }
MODE = k:"mode"i  { return ast("keyword", k) }
MONEY = k:"money"i  { return ast("keyword", k) }
MONTH = k:"month"i  { return ast("keyword", k) }
NAME = k:"name"i  { return ast("keyword", k) }
NCHAR = k:"nchar"i  { return ast("keyword", k) }
NEED = k:"need"i  { return ast("keyword", k) }
NEXT = k:"next"i  { return ast("keyword", k) }
NO = k:"no"i  { return ast("keyword", k) }
NOENTRY = k:"noentry"i  { return ast("keyword", k) }
NORMAL = k:"normal"i  { return ast("keyword", k) }
NOT = k:"not"i  { return ast("keyword", k) }
NOTFOUND = k:"notfound"i  { return ast("keyword", k) }
NULL = k:"null"i  { return ast("keyword", k) }
NUMERIC = k:"numeric"i  { return ast("keyword", k) }
NVARCHAR = k:"nvarchar"i  { return ast("keyword", k) }
OF = k:"of"i  { return ast("keyword", k) }
OFF = k:"off"i  { return ast("keyword", k) }
ON = k:"on"i  { return ast("keyword", k) }
OPEN = k:"open"i  { return ast("keyword", k) }
OPTION = k:"option"i  { return ast("keyword", k) }
OPTIONS = k:"options"i  { return ast("keyword", k) }
OR = k:"or"i  { return ast("keyword", k) }
ORDER = k:"order"i  { return ast("keyword", k) }
OTHERWISE = k:"otherwise"i  { return ast("keyword", k) }
OUTER = k:"outer"i  { return ast("keyword", k) }
OUTPUT = k:"output"i  { return ast("keyword", k) }
PAGE = k:"page"i  { return ast("keyword", k) }
PAGENO = k:"pageno"i  { return ast("keyword", k) }
PIPE = k:"pipe"i  { return ast("keyword", k) }
PRECISION = k:"precision"i  { return ast("keyword", k) }
PREPARE = k:"prepare"i  { return ast("keyword", k) }
PREVIOUS = k:"previous"i  { return ast("keyword", k) }
PRIMARY = k:"primary"i  { return ast("keyword", k) }
PRINT = k:"print"i  { return ast("keyword", k) }
PROGRAM = k:"program"i  { return ast("keyword", k) }
PROMPT = k:"prompt"i  { return ast("keyword", k) }
PUT = k:"put"i  { return ast("keyword", k) }
QUIT = k:"quit"i  { return ast("keyword", k) }
READ = k:"read"i  { return ast("keyword", k) }
REAL = k:"real"i  { return ast("keyword", k) }
RECORD = k:"record"i  { return ast("keyword", k) }
RED = k:"red"i  { return ast("keyword", k) }
REPORT = k:"report"i  { return ast("keyword", k) }
RETURN = k:"return"i  { return ast("keyword", k) }
RETURNING = k:"returning"i  { return ast("keyword", k) }
REVERSE = k:"reverse"i  { return ast("keyword", k) }
RIGTH = k:"rigth"i  { return ast("keyword", k) }
ROLLBACK = k:"rollback"i  { return ast("keyword", k) }
ROW = k:"row"i  { return ast("keyword", k) }
ROWS = k:"rows"i  { return ast("keyword", k) }
RUN = k:"run"i  { return ast("keyword", k) }
SCREEN = k:"screen"i  { return ast("keyword", k) }
SCROLL = k:"scroll"i  { return ast("keyword", k) }
SECOND = k:"second"i  { return ast("keyword", k) }
SELECT = k:"select"i  { return ast("keyword", k) }
SET = k:"set"i  { return ast("keyword", k) }
SHARE = k:"share"i  { return ast("keyword", k) }
SHOW = k:"show"i  { return ast("keyword", k) }
SKIP = k:"skip"i  { return ast("keyword", k) }
SLEEP = k:"sleep"i  { return ast("keyword", k) }
SMALL = k:"small"i  { return ast("keyword", k) }
SMALLFLOAT = k:"smallfloat"i  { return ast("keyword", k) }
SMALLINT = k:"smallint"i  { return ast("keyword", k) }
SPACE = k:"space"i  { return ast("keyword", k) }
SPACES = k:"spaces"i  { return ast("keyword", k) }
SQL = k:"sql"i  { return ast("keyword", k) }
SQLERROR = k:"sqlerror"i  { return ast("keyword", k) }
SQLWARNING = k:"sqlwarning"i  { return ast("keyword", k) }
START = k:"start"i  { return ast("keyword", k) }
STEP = k:"step"i  { return ast("keyword", k) }
STOP = k:"stop"i  { return ast("keyword", k) }
STRING = k:"string"i  { return ast("keyword", k) }
SUM = k:"sum"i  { return ast("keyword", k) }
TABLE = k:"table"i  { return ast("keyword", k) }
TABLES = k:"tables"i  { return ast("keyword", k) }
TEMP = k:"temp"i  { return ast("keyword", k) }
TEXT = k:"text"i  { return ast("keyword", k) }
THEN = k:"then"i  { return ast("keyword", k) }
THROUGH = k:"through"i  { return ast("keyword", k) }
THRU = k:"thru"i  { return ast("keyword", k) }
TIME = k:"time"i  { return ast("keyword", k) }
TO = k:"to"i  { return ast("keyword", k) }
TODAY = k:"today"i  { return ast("keyword", k) }
TOP = k:"top"i  { return ast("keyword", k) }
TRAILER = k:"trailer"i  { return ast("keyword", k) }
TYPE = k:"type"i  { return ast("keyword", k) }
UNCONSTRAINED = k:"unconstrained"i { return ast("keyword", k) }  
UNDERLINE = k:"underline"i  { return ast("keyword", k) }
UNION = k:"union"i  { return ast("keyword", k) }
UNIQUE = k:"unique"i  { return ast("keyword", k) }
UNITS = k:"units"i  { return ast("keyword", k) }
UNLOAD = k:"unload"i  { return ast("keyword", k) }
UNLOCK = k:"unlock"i  { return ast("keyword", k) }
UP = k:"up"i  { return ast("keyword", k) }
UPDATE = k:"update"i  { return ast("keyword", k) }
UPSHIFT = k:"upshift"i  { return ast("keyword", k) }
USING = k:"using"i  { return ast("keyword", k) }
VALIDATE = k:"validate"i  { return ast("keyword", k) }
VALUES = k:"values"i  { return ast("keyword", k) }
VARCHAR = k:"varchar"i  { return ast("keyword", k) }
WAIT = k:"wait"i  { return ast("keyword", k) }
WAITING = k:"waiting"i  { return ast("keyword", k) }
WARNING = k:"warning"i  { return ast("keyword", k) }
WEEKDAY = k:"weekday"i  { return ast("keyword", k) }
WHEN = k:"when"i  { return ast("keyword", k) }
WHENEVER = k:"whenever"i  { return ast("keyword", k) }
WHERE = k:"where"i  { return ast("keyword", k) }
WHILE = k:"while"i  { return ast("keyword", k) }
WHITE = k:"white"i  { return ast("keyword", k) }
WINDOW = k:"window"i  { return ast("keyword", k) }
WITH = k:"with"i  { return ast("keyword", k) }
WITHOUT = k:"without"i  { return ast("keyword", k) }
WORDWRAP = k:"wordwrap"i  { return ast("keyword", k) }
WORK = k:"work"i  { return ast("keyword", k) }
WRAP = k:"wrap"i  { return ast("keyword", k) }
YEAR = k:"year"i  { return ast("keyword", k) }
YELLOW = k:"yellow"i  { return ast("keyword", k) }
