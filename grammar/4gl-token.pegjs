{
  const TokenKind = {
    keyword: "keyword",
    whitespace: "whitespace",
    comment: "comment",
    identifier: "identifier",
    string: "string",
    number: "number",
    variable: "variable",
    operator: "operator",
    bracket: "bracket",
    builtInVar: "builtInVar",
  };

  var ast = [];

  function addNode(node) {
    if (node) {
      ast.push(node);
    }

    return ast;
  }

  function createNode(kind, value) {
    if (value) {
      const _location = location();
      const offset = {
        start: _location.start.offset,
        end: _location.end.offset,
      };

      let obj = {
        kind: kind,
        offset: offset,
        line: _location.start.line,
        column: _location.start.column,
        value: value,
      };

      return obj;
    }

    return value;
  }

  function createNodeKeyword(value) {
    return createNode(TokenKind.keyword, value);
  }

  function createNodeSpace(value) {
    return createNode(TokenKind.whitespace, value);
  }

  function createNodeComment(open, comment, close) {
    return createNode(TokenKind.comment, [open, comment, close]);
  }

  function createNodeVar(value) {
    return createNode(TokenKind.variable, value);
  }

  function createNodeBuiltInVar(value) {
    return createNode(TokenKind.builtInVar, value);
  }

  function createNodeExpression(value) {
    return createNode(TokenKind.expression, value);
  }

  function createNodeOperator(value) {
    return createNode(TokenKind.operator, value);
  }

  function createNodeBracket(value) {
    return createNode(TokenKind.bracket, value);
  }

  function createNodeNumber(value) {

    return createNode(TokenKind.number, value);
  }

  function createNodeString(value) {

    return createNode(TokenKind.string, value);
  }

  function createNodeIdentifier(id, dataType) {
    return createNode(TokenKind.identifier, [id, dataType]);
  }
}

start = l:line* { return ast; }

line
  = l:comment { return addNode(l); }
  / l:tokens { return addNode(l); }
  / l:WS_SPACE { return addNode(l); }

comment
  = o:"#" c:$(!NL .)* e:NL { return createNodeComment(o, c, e); }
  / o:"--" c:$(!NL .)* e:NL { return createNodeComment(o, c, e); }
  / o:"{" c:$(!"}" .)* e:"}" { return createNodeComment(o, c, e); }

tokens
  = $BYTE
  / $TEXT
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
  / WS_SPACE
  / YEAR
  / string_exp
  / number_exp
  / variable
  / ID
  / OPERATOR

variable
  = v:(ID DOT ID) { return createNodeVar(v); }
  / v:(ID DOT ASTERISK) { return createNodeVar(v); }
  / v:builtInVariables { return createNodeBuiltInVar(v); }

builtInVariables
  = "arg_val"i
  / "arr_count"i
  / "arr_curr"i
  / "errorlog"i
  / "fgl_keyval"i
  / "fgl_lastkey"i
  / "infield"i
  / "int_flag"i
  / "quit_flag"i
  / "num_args"i
  / "scr_line"i
  / "set_count"i
  / "showhelp"i
  / "sqlca"i
  / "sqlcode"i
  / "sqlerrd"i
  / "startlog"i

simpleDataType
  = numberType
  / timeType
  / characterType

numberType
  = BIGINT
  / INTEGER
  / INT
  / $SMALLINT
  / DECIMAL
  / DEC
  / NUMERIC
  / MONEY
  / DOUBLE WS_SPACE PRECISION
  / FLOAT
  / REAL
  / SMALLFLOAT

timeType
  = DATETIME
  / $DATE
  / $INTERVAL

characterType
  = CHARACTER
  / CHAR
  / NCHAR
  / VARCHAR
  / NVARCHAR

number_exp
  = t:$([-+]? DIGIT+ (DOT DIGIT+)?)   {
      return createNodeNumber(parseFloat(t, 10));
    }

string_exp
  = s:(double_quoted_string / single_quoted_string) {
      return createNodeString(s);
    }

double_quoted_string = (D_QUOTE $double_quoted_char* D_QUOTE)

single_quoted_string = (S_QUOTE $single_quoted_char* S_QUOTE)

double_quoted_char
  = ESCAPED
  / !D_QUOTE c:. { return c; }

single_quoted_char
  = ESCAPED
  / !S_QUOTE c:. { return c; }

// ======================================================================================

AFTER = k:"after"i { return createNodeKeyword(k); }

ALL = k:"all"i { return createNodeKeyword(k); }

AND = k:"and"i { return createNodeKeyword(k); }

ANY = k:"any"i { return createNodeKeyword(k); }

ARRAY = k:"array"i { return createNodeKeyword(k); }

ASC = k:"asc"i { return createNodeKeyword(k); }

ASCENDING = k:"ascending"i { return createNodeKeyword(k); }

ASCII = k:"ascii"i { return createNodeKeyword(k); }

ASTERISK = o:"*" { return createNodeOperator(o); }

AT = o:"@" { return createNodeOperator(o); }

ATTRIBUTE = k:"attribute"i { return createNodeKeyword(k); }

ATTRIBUTES = k:"attributes"i { return createNodeKeyword(k); }

AUTONEXT = k:"autonext"i { return createNodeKeyword(k); }

AVG = k:"avg"i { return createNodeKeyword(k); }

BEFORE = k:"before"i { return createNodeKeyword(k); }

BEGIN = k:"begin"i { return createNodeKeyword(k); }

BETWEEN = k:"between"i { return createNodeKeyword(k); }

BIGINT = k:"bigint"i { return createNodeKeyword(k); }

BORDER = k:"border"i { return createNodeKeyword(k); }

BOTTOM = k:"bottom"i { return createNodeKeyword(k); }

BY = k:"by"i { return createNodeKeyword(k); }

BYTE = k:"byte"i { return createNodeKeyword(k); }

CALL = k:"call"i { return createNodeKeyword(k); }

CASE = k:"case"i { return createNodeKeyword(k); }

CHAR = k:"CHAR"i { return createNodeKeyword(k); }

CHARACTER = k:"character"i { return createNodeKeyword(k); }

CLEAR = k:"clear"i { return createNodeKeyword(k); }

CLIPPED = k:"clipped"i { return createNodeKeyword(k); }

CLOSE = k:"close"i { return createNodeKeyword(k); }

COLON = o:":" { return createNodeOperator(o); }

COLUMN = k:"column"i { return createNodeKeyword(k); }

COLUMNS = k:"columns"i { return createNodeKeyword(k); }

COMMA = o:"," { return createNodeOperator(o); }

COMMAND = k:"command"i { return createNodeKeyword(k); }

COMMENTS = k:"comments"i { return createNodeKeyword(k); }

COMMIT = k:"commit"i { return createNodeKeyword(k); }

CONSTRAINT = k:"constraint"i { return createNodeKeyword(k); }

CONSTRUCT = k:"construct"i { return createNodeKeyword(k); }

CONTINUE = k:"continue"i { return createNodeKeyword(k); }

COUNT = k:"count"i { return createNodeKeyword(k); }

CREATE = k:"create"i { return createNodeKeyword(k); }

CURRENT = k:"current"i { return createNodeKeyword(k); }

CURSOR = k:"cursor"i { return createNodeKeyword(k); }

DATABASE = k:"database"i { return createNodeKeyword(k); }

DATE = k:"date"i { return createNodeKeyword(k); }

DATETIME = k:"datetime"i { return createNodeKeyword(k); }

DAY = k:"day"i { return createNodeKeyword(k); }

DEC = k:"dec"i { return createNodeKeyword(k); }

DECIMAL = k:"decimal"i { return createNodeKeyword(k); }

DECLARE = k:"declare"i { return createNodeKeyword(k); }

DEFAULTS = k:"defaults"i { return createNodeKeyword(k); }

DEFER = k:"defer"i { return createNodeKeyword(k); }

DEFINE = k:"define"i { return createNodeKeyword(k); }

DELETE = k:"delete"i { return createNodeKeyword(k); }

DELIMITER = k:"delimiter"i { return createNodeKeyword(k); }

DELIMITERS = k:"delimiters"i { return createNodeKeyword(k); }

DESC = k:"desc"i { return createNodeKeyword(k); }

DESCENDING = k:"descending"i { return createNodeKeyword(k); }

DIRTY = k:"dirty"i { return createNodeKeyword(k); }

DISPLAY = k:"display"i { return createNodeKeyword(k); }

DISTINCT = k:"distinct"i { return createNodeKeyword(k); }

DOT = o:"." { return createNodeOperator(o); }

DOUBLE = k:"double"i { return createNodeKeyword(k); }

DOWNSHIFT = k:"downshift"i { return createNodeKeyword(k); }

DROP = k:"drop"i { return createNodeKeyword(k); }

DYNAMIC = k:"dynamic"i { return createNodeKeyword(k); }

ELSE = k:"else"i { return createNodeKeyword(k); }

END = k:"end"i { return createNodeKeyword(k); }

ERROR = k:"error"i { return createNodeKeyword(k); }

EVERY = k:"every"i { return createNodeKeyword(k); }

EXCLUSIVE = k:"exclusive"i { return createNodeKeyword(k); }

EXECUTE = k:"execute"i { return createNodeKeyword(k); }

EXISTS = k:"exists"i { return createNodeKeyword(k); }

EXIT = k:"exit"i { return createNodeKeyword(k); }

EXTEND = k:"extend"i { return createNodeKeyword(k); }

EXTERNAL = k:"external"i { return createNodeKeyword(k); }

FALSE = k:"false"i { return createNodeKeyword(k); }

FETCH = k:"fetch"i { return createNodeKeyword(k); }

FIELD = k:"field"i { return createNodeKeyword(k); }

FILE = k:"file"i { return createNodeKeyword(k); }

FINISH = k:"finish"i { return createNodeKeyword(k); }

FIRST = k:"first"i { return createNodeKeyword(k); }

FLOAT = k:"float"i { return createNodeKeyword(k); }

FLUSH = k:"flush"i { return createNodeKeyword(k); }

FOR = k:"for"i { return createNodeKeyword(k); }

FOREACH = k:"foreach"i { return createNodeKeyword(k); }

FORM = k:"form"i { return createNodeKeyword(k); }

FORMAT = k:"format"i { return createNodeKeyword(k); }

FRACTION = k:"fraction"i { return createNodeKeyword(k); }

FREE = k:"free"i { return createNodeKeyword(k); }

FROM = k:"from"i { return createNodeKeyword(k); }

FUNCTION = k:"function"i { return createNodeKeyword(k); }

GLOBALS = k:"globals"i { return createNodeKeyword(k); }

GROUP = k:"group"i { return createNodeKeyword(k); }

HAVING = k:"having"i { return createNodeKeyword(k); }

HEADER = k:"header"i { return createNodeKeyword(k); }

HELP = k:"help"i { return createNodeKeyword(k); }

HIDE = k:"hide"i { return createNodeKeyword(k); }

HOLD = k:"hold"i { return createNodeKeyword(k); }

HOUR = k:"hour"i { return createNodeKeyword(k); }

IF = k:"if"i { return createNodeKeyword(k); }

IN = k:"in"i { return createNodeKeyword(k); }

INCLUDE = k:"include"i { return createNodeKeyword(k); }

INDEX = k:"index"i { return createNodeKeyword(k); }

INITIALIZE = k:"initialize"i { return createNodeKeyword(k); }

INPUT = k:"input"i { return createNodeKeyword(k); }

INSERT = k:"insert"i { return createNodeKeyword(k); }

INSTRUCTIONS = k:"instructions"i { return createNodeKeyword(k); }

INT = k:"int"i { return createNodeKeyword(k); }

INTEGER = k:"integer"i { return createNodeKeyword(k); }

INTERRUPT = k:"interrupt"i { return createNodeKeyword(k); }

INTERVAL = k:"interval"i { return createNodeKeyword(k); }

INTO = k:"into"i { return createNodeKeyword(k); }

IS = k:"is"i { return createNodeKeyword(k); }

ISOLATION = k:"isolation"i { return createNodeKeyword(k); }

KEY = k:"key"i { return createNodeKeyword(k); }

LABEL = k:"label"i { return createNodeKeyword(k); }

LAST = k:"last"i { return createNodeKeyword(k); }

LEFT = k:"left"i { return createNodeKeyword(k); }

LENGTH = k:"length"i { return createNodeKeyword(k); }

LET = k:"let"i { return createNodeKeyword(k); }

LIKE = k:"like"i { return createNodeKeyword(k); }

LINE = k:"line"i { return createNodeKeyword(k); }

LINES = k:"lines"i { return createNodeKeyword(k); }

LOAD = k:"load"i { return createNodeKeyword(k); }

LOCK = k:"lock"i { return createNodeKeyword(k); }

LOG = k:"log"i { return createNodeKeyword(k); }

MAIN = k:"main"i { return createNodeKeyword(k); }

MARGIN = k:"margin"i { return createNodeKeyword(k); }

MATCHES = k:"matches"i { return createNodeKeyword(k); }

MAX = k:"max"i { return createNodeKeyword(k); }

MDY = k:"mdy"i { return createNodeKeyword(k); }

MENU = k:"menu"i { return createNodeKeyword(k); }

MESSAGE = k:"message"i { return createNodeKeyword(k); }

MIN = k:"min"i { return createNodeKeyword(k); }

MINUTE = k:"minute"i { return createNodeKeyword(k); }

MOD = k:"mod"i { return createNodeKeyword(k); }

MODE = k:"mode"i { return createNodeKeyword(k); }

MONEY = k:"money"i { return createNodeKeyword(k); }

MONTH = k:"month"i { return createNodeKeyword(k); }

NAME = k:"name"i { return createNodeKeyword(k); }

NCHAR = k:"nchar"i { return createNodeKeyword(k); }

NEED = k:"need"i { return createNodeKeyword(k); }

NEXT = k:"next"i { return createNodeKeyword(k); }

NO = k:"no"i { return createNodeKeyword(k); }

NOENTRY = k:"noentry"i { return createNodeKeyword(k); }

NOT = k:"not"i { return createNodeKeyword(k); }

NOTFOUND = k:"notfound"i { return createNodeKeyword(k); }

NULL = k:"null"i { return createNodeKeyword(k); }

NUMERIC = k:"numeric"i { return createNodeKeyword(k); }

NVARCHAR = k:"nvarchar"i { return createNodeKeyword(k); }

OF = k:"of"i { return createNodeKeyword(k); }

ON = k:"on"i { return createNodeKeyword(k); }

OPEN = k:"open"i { return createNodeKeyword(k); }

OPTION = k:"option"i { return createNodeKeyword(k); }

OPTIONS = k:"options"i { return createNodeKeyword(k); }

OR = k:"or"i { return createNodeKeyword(k); }

ORDER = k:"order"i { return createNodeKeyword(k); }

OTHERWISE = k:"otherwise"i { return createNodeKeyword(k); }

OUTER = k:"outer"i { return createNodeKeyword(k); }

OUTPUT = k:"output"i { return createNodeKeyword(k); }

PAGE = k:"page"i { return createNodeKeyword(k); }

PAGENO = k:"pageno"i { return createNodeKeyword(k); }

PIPE = k:"pipe"i { return createNodeKeyword(k); }

PRECISION = k:"precision"i { return createNodeKeyword(k); }

PREPARE = k:"prepare"i { return createNodeKeyword(k); }

PREVIOUS = k:"previous"i { return createNodeKeyword(k); }

PRIMARY = k:"primary"i { return createNodeKeyword(k); }

PRINT = k:"print"i { return createNodeKeyword(k); }

PROGRAM = k:"program"i { return createNodeKeyword(k); }

PROMPT = k:"prompt"i { return createNodeKeyword(k); }

PUT = k:"put"i { return createNodeKeyword(k); }

QUIT = k:"quit"i { return createNodeKeyword(k); }

READ = k:"read"i { return createNodeKeyword(k); }

REAL = k:"real"i { return createNodeKeyword(k); }

RECORD = k:"record"i { return createNodeKeyword(k); }

REPORT = k:"report"i { return createNodeKeyword(k); }

RETURN = k:"return"i { return createNodeKeyword(k); }

RETURNING = k:"returning"i { return createNodeKeyword(k); }

REVERSE = k:"reverse"i { return createNodeKeyword(k); }

RIGTH = k:"rigth"i { return createNodeKeyword(k); }

ROLLBACK = k:"rollback"i { return createNodeKeyword(k); }

ROW = k:"row"i { return createNodeKeyword(k); }

ROWS = k:"rows"i { return createNodeKeyword(k); }

RUN = k:"run"i { return createNodeKeyword(k); }

SCREEN = k:"screen"i { return createNodeKeyword(k); }

SCROLL = k:"scroll"i { return createNodeKeyword(k); }

SECOND = k:"second"i { return createNodeKeyword(k); }

SELECT = k:"select"i { return createNodeKeyword(k); }

SET = k:"set"i { return createNodeKeyword(k); }

SHARE = k:"share"i { return createNodeKeyword(k); }

SHOW = k:"show"i { return createNodeKeyword(k); }

SKIP = k:"skip"i { return createNodeKeyword(k); }

SLEEP = k:"sleep"i { return createNodeKeyword(k); }

SMALLFLOAT = k:"smallfloat"i { return createNodeKeyword(k); }

SMALLINT = k:"smallint"i { return createNodeKeyword(k); }

SPACE = k:"space"i { return createNodeKeyword(k); }

SPACES = k:"spaces"i { return createNodeKeyword(k); }

SQL = k:"sql"i { return createNodeKeyword(k); }

START = k:"start"i { return createNodeKeyword(k); }

STEP = k:"step"i { return createNodeKeyword(k); }

STOP = k:"stop"i { return createNodeKeyword(k); }

STRING = k:"string"i { return createNodeKeyword(k); }

SUM = k:"sum"i { return createNodeKeyword(k); }

TABLE = k:"table"i { return createNodeKeyword(k); }

TABLES = k:"tables"i { return createNodeKeyword(k); }

TEMP = k:"temp"i { return createNodeKeyword(k); }

TEXT = k:"text"i { return createNodeKeyword(k); }

THEN = k:"then"i { return createNodeKeyword(k); }

TIME = k:"time"i { return createNodeKeyword(k); }

TO = k:"to"i { return createNodeKeyword(k); }

TODAY = k:"today"i { return createNodeKeyword(k); }

TOP = k:"top"i { return createNodeKeyword(k); }

TRAILER = k:"trailer"i { return createNodeKeyword(k); }

TRUE = k:"true"i { return createNodeKeyword(k); }

TYPE = k:"type"i { return createNodeKeyword(k); }

UNCONSTRAINED = k:"unconstrained"i { return createNodeKeyword(k); }

UNION = k:"union"i { return createNodeKeyword(k); }

UNIQUE = k:"unique"i { return createNodeKeyword(k); }

UNITS = k:"units"i { return createNodeKeyword(k); }

UNLOAD = k:"unload"i { return createNodeKeyword(k); }

UNLOCK = k:"unlock"i { return createNodeKeyword(k); }

UPDATE = k:"update"i { return createNodeKeyword(k); }

UPSHIFT = k:"upshift"i { return createNodeKeyword(k); }

USING = k:"using"i { return createNodeKeyword(k); }

VALUES = k:"values"i { return createNodeKeyword(k); }

VARCHAR = k:"varchar"i { return createNodeKeyword(k); }

WAIT = k:"wait"i { return createNodeKeyword(k); }

WAITING = k:"waiting"i { return createNodeKeyword(k); }

WEEKDAY = k:"weekday"i { return createNodeKeyword(k); }

WHEN = k:"when"i { return createNodeKeyword(k); }

WHENEVER = k:"whenever"i { return createNodeKeyword(k); }

WHERE = k:"where"i { return createNodeKeyword(k); }

WHILE = k:"while"i { return createNodeKeyword(k); }

WINDOW = k:"window"i { return createNodeKeyword(k); }

WITH = k:"with"i { return createNodeKeyword(k); }

WITHOUT = k:"without"i { return createNodeKeyword(k); }

WORDWRAP = k:"wordwrap"i { return createNodeKeyword(k); }

WORK = k:"work"i { return createNodeKeyword(k); }

YEAR = k:"year"i { return createNodeKeyword(k); }

ID = id:$([a-zA-Z_] [a-zA-Z0-9_]*) { return id; }

OPERATOR = o:[\[\]\(\)~!@%^&*-+|/{}\:;<>?#_=] { return createNodeOperator(o); }

D_QUOTE = "\""

S_QUOTE = "'"

ESCAPED
  = "\\\"" { return '"'; }
  / "\\'" { return "'"; }
  / "\\\\" { return "\\"; }
  / "\\b" { return "\b"; }
  / "\\t" { return "\t"; }
  / "\\n" { return "\n"; }
  / "\\f" { return "\f"; }
  / "\\r" { return "\r"; }

DIGIT = [0-9]

WS_SPACE
  = s:$[ \t\n\r]+ { return createNodeSpace(s); }
  / s:NL+

NL = s:("\n" / "\r\n") { return createNodeSpace(s); }

NLS
  = NL
  / WS_SPACE

EOF = !.
