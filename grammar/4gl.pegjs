// Gramática eleborada com base na documentação disponibilizada em
// https://www.oninit.com/manual/informix/english/docs/4gl/7609.pdf
// e na pasta "docs" há uma cópia

{

//const unroll = options.util.makeUnroll(location, options);
const ast = options.util.makeAST(location, options);

}

start_program
	= t:token*
  { return ast("program", t) }

token 
  = blocks 
  / keywords 
  / comment
  / operators 
  / builtInVar
  / string
  / number
  / builtInVar
  / ID
  / WS/_NL
  / o:(!WS .)+ { return ast("notSpecified", o) }

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';

string
  = s:$(double_quoted_string / single_quoted_string) {
      return ast("string", s);
    }

double_quoted_string = $(D_QUOTE (!D_QUOTE .)* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE .)* S_QUOTE)

number
  = n:$([-+]? DIGIT+ (DOT DIGIT+)?) {
      return ast("number", n); 
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
  = s:$[ \t;]+ { return ast("whiteSpace", s) }

_NL = s:$("\n" / "\r" / "\r\n")+ { return ast("newLine", s) }

NLS
  = _NL / WS

blocks
  = k:(
    MAIN
    / FUNCTION
  ) { return ast("keyword", k).set("block", "begin" ) }
    / k0:END w:WS k1:(MAIN / FUNCTION)  { return [ 
      ast("keyword", k0), 
      ast(w), 
      ast("keyword", k1).set("block", "end"), 
    ] }

keywords
  = k:(
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
  ) w:(WS/_NL)
   { return [ ast("keyword", k), ast(w) ] }
 
operators
  = o:(
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
  ) { return ast("operator", o) }

builtInVar
  = v:(
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
  ) { return ast("builtInVar", v) }

comment
  = singleCommentLine 
  / c:$(O_BRACES (!C_BRACES .)* C_BRACES) { return ast("comment", c) }

singleCommentLine
  = c:$('#' (!_NL .)* _NL) { return ast("comment", c) }
  / c:$('-' '-' '#' (!_NL .)* _NL) { return ast("comment", c) }

ID = id:$([a-zA-Z_] [a-zA-Z_0-9]*) { return ast("identifier", id) }

AT_SIGN = "@";
INT_FLAG = "int_flag"i
NOT_FOUND = "notfound"i 
SQL_CODE = "sqlcode"i 
STATUS = "status"i 
QUIT_FLAG = "quit_flag"i 
SQL_CA_RECORD = "sqlcarecord"i 
SQL_ERR_M = "sqlerrm"i 
SQL_ERR_P = "sqlerrp"i 
SQL_ERR_D = "sqlerrd"i 
SQL_AWARN = "sqlawarn"i 

TRUE=c:"true"i { return ast("constante", c) }
FALSE=c:"false"i { return ast("constante", c) }

O_BRACES=o:"{" 
C_BRACES=o:"}" 
O_BRACKET=o:"[" 
C_BRACKET=o:"]" 
O_PARENTHESIS=o:"(" 
C_PARENTHESIS=o:")" 
COMMA=o:"," 
ASTERISK=o:"*" 
EQUAL=o:"="  
LESS=o:"<" 
GREATER=o:">" 
EXCLAMATION=o:"!" 
PLUS=o:"+" 
MINUS=o:"-" 
COLON=o:":" 
SLASH=o:"/" 

ACCEPT = "accept"i  
AFTER = "after"i  
ALL = "all"i  
AND = "and"i  
ANY = "any"i  
ARRAY = "array"i  
ASC = "asc"i  
ASCENDING = "ascending"i  
ASCII = "ascii"i  
AT = "year"i  
ATTRIBUTE = "attribute"i  
ATTRIBUTES = "attributes"i  
AUTONEXT = "autonext"i  
AVG = "avg"i  
BEFORE = "before"i  
BEGIN = "begin"i
BETWEEN = "between"i  
BIGINT = "bigint"i  
BLACK = "black"i  
BLINK = "blink"i  
BLUE = "blue"i  
BOLD = "bold"i  
BORDER = "border"i  
BOTTOM = "bottom"i  
BY = "by"i  
BYTE = "byte"i  
CALL = "call"i  
CASE = "case"i
CHAR = "char"i  
CHARACTER = "character"i  
CLEAR = "clear"i  
CLIPPED = "clipped"i  
CLOSE = "close"i  
COLUMN = "column"i  
COLUMNS = "columns"i  
COMMAND = "command"i  
COMMENT = "comment"i  
COMMENTS = "comments"i  
COMMIT = "commit"i  
CONSTRAINT = "constraint"i  
CONSTRUCT = "construct"i  
CONTINUE = "continue"i  
CONTROL = "control"i  
COUNT = "count"i  
CREATE = "create"i  
CURRENT = "current"i  
CURSOR = "cursor"i  
CYAN = "cyan"i  
DATABASE = "database"i  
DATE = "date"i  
DATETIME = "datetime"i  
DAY = "day"i  
DEC = "dec"i  
DECIMAL = "decimal"i  
DECLARE = "declare"i  
DEFAULTS = "defaults"i  
DEFER = "defer"i  
DEFINE = "define"i  
DELETE = "delete"i  
DELIMITER = "delimiter"i  
DELIMITERS = "delimiters"i  
DESC = "desc"i  
DESCENDING = "descending"i  
DIM = "dim"i  
DIRTY = "dirty"i  
DISPLAY = "display"i  
DISTINCT = "distinct"i  
DOUBLE = "double"i  
DOWN = "down"i  
DOWNSHIFT = "downshift"i  
DROP = "drop"i  
DYNAMIC = "dynamic"i  
ELIF = "elif"i  
ELSE = "else"i  
END = "end"i
ERROR = "error"i  
ESCAPE = "escape"i  
EVERY = "every"i  
EXCLUSIVE = "exclusive"i  
EXECUTE = "execute"i  
EXISTS = "exists"i  
EXIT = "exit"i  
EXTEND = "extend"i  
EXTERNAL = "external"i  
FETCH = "fetch"i  
FIELD = "field"i  
FILE = "file"i  
FINISH = "finish"i
FIRST = "first"i  
FLOAT = "float"i  
FLUSH = "flush"i  
FOR = "for"i 
FOREACH = "foreach"i
FORM = "form"i  
FORMAT = "format"i  
FORMONLY = "formonly"i  
FOUND = "found"i  
FRACTION = "fraction"i  
FREE = "free"i  
FROM = "from"i  
FUNCTION = "function"i
GLOBALS = "globals"i  
GO = "go"i  
GOTO = "goto"i  
GREEN = "green"i  
GROUP = "group"i  
HAVING = "having"i  
HEADER = "header"i  
HELP = "help"i  
HIDE = "hide"i  
HOLD = "hold"i  
HOUR = "hour"i  
IF = "if"i  
IN = "in"i  
INCLUDE = "include"i  
INDEX = "index"i  
INITIALIZE = "initialize"i  
INPUT = "input"i  
INSERT = "insert"i  
INSTRUCTIONS = "instructions"i  
INT = "int"i  
INTEGER = "integer"i  
INTERRUPT = "interrupt"i  
INTERVAL = "interval"i  
INTO = "into"i  
INVISIBLE = "invisible"i  
IS = "is"i  
ISOLATION = "isolation"i  
KEY = "key"i  
LABEL = "label"i  
LAST = "last"i  
LEFT = "left"i  
LENGTH = "length"i  
LET = "let"i  
LIKE = "like"i  
LINE = "line"i  
LINES = "lines"i  
LOAD = "load"i  
LOCATE = "locate"i  
LOCK = "lock"i  
LOG = "log"i  
MAGENTA = "magenta"i  
MAIN = "main"i
MARGIN = "margin"i  
MATCHES = "matches"i  
MAX = "max"i  
MDY = "mdy"i  
MEMORY = "memory"i  
MENU = "menu"i  
MESSAGE = "message"i  
MIN = "min"i  
MINUTE = "minute"i  
MOD = "mod"i  
MODE = "mode"i  
MONEY = "money"i  
MONTH = "month"i  
NAME = "name"i  
NCHAR = "nchar"i  
NEED = "need"i  
NEXT = "next"i  
NO = "no"i  
NOENTRY = "noentry"i  
NORMAL = "normal"i  
NOT = "not"i  
NOTFOUND = "notfound"i  
NULL = "null"i  
NUMERIC = "numeric"i  
NVARCHAR = "nvarchar"i  
OF = "of"i  
OFF = "off"i  
ON = "on"i  
OPEN = "open"i  
OPTION = "option"i  
OPTIONS = "options"i  
OR = "or"i  
ORDER = "order"i  
OTHERWISE = "otherwise"i  
OUTER = "outer"i  
OUTPUT = "output"i  
PAGE = "page"i  
PAGENO = "pageno"i  
PIPE = "pipe"i  
PRECISION = "precision"i  
PREPARE = "prepare"i  
PREVIOUS = "previous"i  
PRIMARY = "primary"i  
PRINT = "print"i  
PROGRAM = "program"i  
PROMPT = "prompt"i  
PUT = "put"i  
QUIT = "quit"i  
READ = "read"i  
REAL = "real"i  
RECORD = "record"i  
RED = "red"i  
REPORT = "report"i  
RETURN = "return"i  
RETURNING = "returning"i  
REVERSE = "reverse"i  
RIGTH = "rigth"i  
ROLLBACK = "rollback"i  
ROW = "row"i  
ROWS = "rows"i  
RUN = "run"i  
SCREEN = "screen"i  
SCROLL = "scroll"i  
SECOND = "second"i  
SELECT = "select"i  
SET = "set"i  
SHARE = "share"i  
SHOW = "show"i  
SKIP = "skip"i  
SLEEP = "sleep"i  
SMALL = "small"i  
SMALLFLOAT = "smallfloat"i  
SMALLINT = "smallint"i  
SPACE = "space"i  
SPACES = "spaces"i  
SQL = "sql"i  
SQLERROR = "sqlerror"i  
SQLWARNING = "sqlwarning"i  
START = "start"i  
STEP = "step"i  
STOP = "stop"i  
STRING = "string"i  
SUM = "sum"i  
TABLE = "table"i  
TABLES = "tables"i  
TEMP = "temp"i  
TEXT = "text"i  
THEN = "then"i  
THROUGH = "through"i  
THRU = "thru"i  
TIME = "time"i  
TO = "to"i  
TODAY = "today"i  
TOP = "top"i  
TRAILER = "trailer"i  
TYPE = "type"i  
UNCONSTRAINED = "unconstrained"i  
UNDERLINE = "underline"i  
UNION = "union"i  
UNIQUE = "unique"i  
UNITS = "units"i  
UNLOAD = "unload"i  
UNLOCK = "unlock"i  
UP = "up"i  
UPDATE = "update"i  
UPSHIFT = "upshift"i  
USING = "using"i  
VALIDATE = "validate"i  
VALUES = "values"i  
VARCHAR = "varchar"i  
WAIT = "wait"i  
WAITING = "waiting"i  
WARNING = "warning"i  
WEEKDAY = "weekday"i  
WHEN = "when"i  
WHENEVER = "whenever"i  
WHERE = "where"i  
WHILE = "while"i  
WHITE = "white"i  
WINDOW = "window"i  
WITH = "with"i  
WITHOUT = "without"i  
WORDWRAP = "wordwrap"i  
WORK = "work"i  
WRAP = "wrap"i  
YEAR = "year"i  
YELLOW = "yellow"i  
