{
  const keywordList = [
    "AFTER",
    "ALL",
    "AND",
    "ANY",
    "ASC",
    "ASCII",
    "ASCENDING",
    "AT",
    "ATTRIBUTE",
    "ATTRIBUTES",
    "AUTONEXT",
    "AVG",
    "BEFORE",
    "BEGIN",
    "BETWEEN",
    "BORDER",
    "BOTTOM",
    "BY",
    "CASE",
    "CLEAR",
    "CLIPPED",
    "CLOSE",
    "COLUMN",
    "COLUMNS",
    "COMMAND",
    "COMMENTS",
    "COMMIT",
    "CONSTRAINT",
    "CONSTRUCT",
    "CONTINUE",
    "COUNT",
    "CREATE",
    "CURRENT",
    "CURSOR",
    "DATABASE",
    "DECLARE",
    "DEFAULTS",
    "DEFER",
    "DELETE",
    "DELIMITERS",
    "DELIMITER",
    "DESC",
    "DESCENDING",
    "DIRTY",
    "DISTINCT",
    "DOWNSHIFT",
    "DROP",
    "ELSE",
    "ERROR",
    "EVERY",
    "EXCLUSIVE",
    "EXECUTE",
    "EXIT",
    "EXISTS",
    "EXTEND",
    "EXTERNAL",
    "FALSE",
    "FETCH",
    "FIELD",
    "FILE",
    "FINISH",
    "FIRST",
    "FLUSH",
    "FOR",
    "FOREACH",
    "FORM",
    "FORMAT",
    "FREE",
    "FROM",
    "GROUP",
    "HAVING",
    "HEADER",
    "HELP",
    "HIDE",
    "HOLD",
    "IF",
    "IN",
    "INCLUDE",
    "INDEX",
    "INITIALIZE",
    "INPUT",
    "INSERT",
    "INSTRUCTIONS",
    "INTERRUPT",
    "INTERVAL",
    "INTO",
    "IS",
    "ISOLATION",
    "KEY",
    "LABEL",
    "LAST",
    "LEFT",
    "LENGTH",
    "LINE",
    "LINES",
    "LOAD",
    "LOCK",
    "LOG",
    "MAIN",
    "MARGIN",
    "MATCHES",
    "MAX",
    "MDY",
    "MENU",
    "MESSAGE",
    "MIN",
    "MOD",
    "MODE",
    "NAME",
    "NEED",
    "NEXT",
    "NO",
    "NOENTRY",
    "NOT",
    "NOTFOUND",
    "NULL",
    "ON",
    "OPEN",
    "OPTION",
    "OPTIONS",
    "OR",
    "ORDER",
    "OTHERWISE",
    "OUTER",
    "OUTPUT",
    "PAGE",
    "PAGENO",
    "PIPE",
    "PREPARE",
    "PREVIOUS",
    "PRIMARY",
    "PRINT",
    "PROGRAM",
    "PROMPT",
    "PUT",
    "QUIT",
    "READ",
    "REPORT",
    "RETURN",
    "REVERSE",
    "RIGTH",
    "ROLLBACK",
    "ROW",
    "ROWS",
    "RUN",
    "SCREEN",
    "SCROLL",
    "SELECT",
    "SET",
    "SHARE",
    "SHOW",
    "SKIP",
    "SLEEP",
    "SPACE",
    "SPACES",
    "SQL",
    "START",
    "STEP",
    "STOP",
    "SUM",
    "TABLE",
    "TABLES",
    "TEMP",
    "THEN",
    "TIME",
    "TODAY",
    "TOP",
    "TRAILER",
    "TRUE",
    "TYPE",
    "UNCONSTRAINED",
    "UNION",
    "UNIQUE",
    "UNITS",
    "UNLOAD",
    "UNLOCK",
    "UNLOAD",
    "UPDATE",
    "UPSHIFT",
    "USING",
    "VALUES",
    "WAIT",
    "WAITING",
    "WEEKDAY",
    "WHEN",
    "WHENEVER",
    "WHERE",
    "WHILE",
    "WINDOW",
    "WITH",
    "WITHOUT",
    "WORDWRAP",
    "WORK",
  ];

  const TokenKind = {
    keyword: "keyword",
    whitespace: "whitespace",
    comment: "comment",
    identifier: "identifier",
    globals: "globals",
    modular: "modular",
    main: "main",
    function: "function",
    command: "command",
    string: "string",
    number: "number",
    variable: "variable",
    expression: "expression",
    operator: "operator",
    bracket: "bracket",
    builtInVar: "builtInVar",
    block: "block",
    list: "list",
    unknown: "unknown",
  };

  const ConstType = {
    integer: "integer",
    string: "string",
  };

  var program = { kind: "program", value: [], offset: undefined };

  function addNode(node) {
    if (node) {
      program.value.push(node);
    }
    
    return program;
  }

  function createNode(kind, value) {
    if (value) {
      const _location = location();
      const offset = {
        start: _location.start.offset,
        end: _location.end.offset,
      };
      
      let obj = { kind: kind, offset: offset, line: _location.start.line, column: _location.start.column,value: value };
      
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

  function createNodeModular(value) {

    return createNode(TokenKind.modular, value);
  }

  function createNodeSession(session) {

    return createNode(TokenKind.session, session);
  }

  function createNodeGlobal(value) {

    return createNode(TokenKind.globals, value);
  }

  function createNodeVar(value) {

    return createNode(TokenKind.variable, value);
  }

  function createNodeBuiltInVar(value) {

    return createNode(TokenKind.builtInVar, value);
  }

  function createNodeMain(value) {

    return createNode(TokenKind.main, value);
  }

  function createNodeFunction(value) {

    return createNode(TokenKind.function, value);
  }

  function createNodeBlock(value) {

    return createNode(TokenKind.block, value);
  }

  function createNodeCommand(value) {
    return createNode(TokenKind.command, value);
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

  function createNodeNumber(dataType, value) {
    const info = { type: dataType, value: value };

    return createNode(TokenKind.number, info);
  }

  function createNodeString(value) {
    const info = { type: ConstType.string, value: value };

    return createNode(TokenKind.string, info);
  }

  function createNodeList(list) {

    return createNode(TokenKind.list, list);
  }


  function createNodeIdentifier(id, dataType) {

    return createNode(TokenKind.identifier, [id, dataType]);
  }

}

start = l:line* { return program }

line
  = l:session { return addNode(l); }
  / l:comment { return addNode(l); }
  / l:SPACE { return addNode(l); }

session
  = s:modular  { return s; }
  / s:globals  { return s; }
  / s:function { return s; }

comment
  = o:"#" c:$(!NL .)* e:NL { return createNodeComment(o, c, e); }
  / o:"--" c:$(!NL .)* e:NL { return createNodeComment(o, c, e); }
  / o:"{" c:$(!"}" .)* e:"}" { return createNodeComment(o, c, e); }

modular = d:define+ { return createNodeModular(d); }

globals
  = g:((GLOBALS SPACE) 
        (block?) 
      (END SPACE GLOBALS SPACE)) { return createNodeGlobal(g); }
  / g:(GLOBALS SPACE string_exp comment? SPACE) { return createNodeGlobal(g); }

function
  = f:((MAIN SPACE) 
        (block?) 
      (END SPACE MAIN SPACE)) { return createNodeMain(f); }
  / f:((FUNCTION SPACE ID SPACE? O_PARENTHESIS SPACE? parameterList SPACE? C_PARENTHESIS)
         (block?)
       (END SPACE FUNCTION SPACE)) { return createNodeFunction(f); }

block = b:blockCommand { return createNodeBlock(b); }

blockCommand
  = l:commands+ c:command { return l.concat(c); }
  / l:commands+ { return l; }
  / c:commands { return [c]; }

commands
  = c:(SPACE) { return c; }
  / c:(SPACE? comment) { return c; }
  / c:(SPACE? command SPACE? comment? NL?) { return createNodeCommand(c); }

command = c:(define / display / call / let / prompt) { return c; }

define = DEFINE SPACE ID SPACE dataType 

display = DISPLAY SPACE expressions

call
  = CALL
    SPACE
    ID
    SPACE?
    argumentList
    returning?

returning
    = SPACE RETURNING SPACE receivingVariables

let = LET SPACE receivingVariables SPACE? EQUAL SPACE? expressions

prompt = PROMPT SPACE string_exp SPACE FOR SPACE ID

expressions
  = l:exp_list+ e:expression { return l.concat(e); }
  / l:exp_list+ { return l; }
  / e:expression { return [e]; }

exp_list
  = e:(SPACE? e:expression SPACE? o:OPERATOR SPACE?) { return createNodeExpression(e); }

expression
  = string_exp
  / integer_exp
  / variable

argumentList
  = o:O_PARENTHESIS SPACE? a:arguments? SPACE? c:C_PARENTHESIS { return [o, a?createNodeList(a):[] , c]; }

arguments
  = l:arg_list+ p:arg_value+ { return l.concat(p); }
  / p:arg_list+ { return p; }
  / p:arg_value { return [p]; }

arg_value = SPACE? e:expressions SPACE? { return e; }

arg_list = SPACE? e:expressions SPACE? COMMA SPACE? { return e; }

parameterList
  = l:parmList? { return l?createNodeList(l):[]; }

parmList
  = l:param_list+ p:param_id+ { return l.concat(p); }
  / p:param_list+ { return p; }
  / p:param_id { return [p]; }

param_list = v:param_id COMMA SPACE? { return v; }

param_id = SPACE? v:ID SPACE? { return v; }

receivingVariables
  = l:var_list+ v:variable+ { return l.concat(v); }
  / l:var_list+ { return l; }
  / v:variable { return [v]; }

var_list = SPACE? variable SPACE? COMMA SPACE?

variable
  = v:(ID DOT ID) { return createNodeVar(v); }
  / v:(ID DOT ASTERISK) { return createNodeVar(v); }
  / v:(ID O_BRACKET expressions C_BRACKET) { return createNodeVar(v); }
  / v:ID { return createNodeVar(v); }
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

dataType
  = simpleDataType     
  / structuredDataType 
  / largeDataType      

simpleDataType
  = numberType    
  / timeType      
  / characterType 

numberType
  = (BIGINT / INTEGER / INT)
  / $SMALLINT
  / ((DECIMAL / DEC / NUMERIC / MONEY) (O_PARENTHESIS scale C_PARENTHESIS)?)
  / ((DOUBLE SPACE PRECISION / FLOAT) (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / (REAL / SMALLFLOAT)

timeType
  = (DATETIME SPACE datetimeQualifier)
  / $DATE
  / $INTERVAL

characterType
  = ((CHARACTER / CHAR) (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / (NCHAR (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / ((VARCHAR / NVARCHAR) (O_PARENTHESIS integer_exp C_PARENTHESIS?))

largeDataType
  = $BYTE
  / $TEXT

structuredDataType
  = (
    ARRAY SPACE?
      O_BRACKET SPACE?
      sizeArray SPACE?
      C_BRACKET SPACE
      OF SPACE
      (simpleDataType / recordDataType / largeDataType)
  )
  / (DYNAMIC SPACE ARRAY)
  / recordDataType

sizeArray = integer_exp (COMMA integer_exp)*

recordDataType
  = (RECORD SPACE LIKE tableQualifier columnQualifier)
  / RECORD SPACE member END SPACE RECORD

datetimeQualifier = datetimeQualifierWord SPACE TO SPACE datetimeQualifierWord

datetimeQualifierWord
  = YEAR
  / MONTH
  / DAY
  / HOUR
  / MINUTE
  / SECOND
  / FRACTION (O_PARENTHESIS scale C_PARENTHESIS)?

scale = integer_exp (COMMA integer_exp)?

member
  = LIKE tableQualifier columnQualifier
  / l:identifierList { return createNodeList(l)}

identifierList
  = l:identifier_list+ i:identifier+ { return l.concat(i); }
  / l:identifier_list+ { return l; }
  / i:identifier { return [i]; }

identifier_list = i:identifier SPACE? COMMA SPACE? { return i; }

identifier = ID SPACE simpleDataType SPACE?

tableQualifier
  = s:(
    (ID (AT ID)? COLON)?
      o:(ID DOT / D_QUOTE ID DOT D_QUOTE / S_QUOTE ID DOT S_QUOTE)
  )?

columnQualifier = ID DOT (ID / ASTERISK)

integer_exp
  = t:$([-+]? DIGIT+) { return createNodeNumber(ConstType.integer, parseInt(t, 10)) }

string_exp
  = s:(double_quoted_string / single_quoted_string) { return createNodeString(s); }

double_quoted_string = (D_QUOTE $double_quoted_char* D_QUOTE)

single_quoted_string = (S_QUOTE $single_quoted_char* S_QUOTE)

double_quoted_char
  = ESCAPED
  / !D_QUOTE c:. { return c; }

single_quoted_char
  = ESCAPED
  / !S_QUOTE c:. { return c; }

// ======================================================================================

ID = id:$([a-zA-Z_] [a-zA-Z0-9_]*) { return id; }

DEFINE = k:"define"i { return createNodeKeyword(k); }

CALL = k:"call"i { return createNodeKeyword(k); }

DISPLAY = k:"display"i { return createNodeKeyword(k); }

END = k:"end"i { return createNodeKeyword(k); }

FUNCTION = k:"function"i { return createNodeKeyword(k); }

GLOBALS = k:"globals"i { return createNodeKeyword(k); }

LET = k:"let"i { return createNodeKeyword(k); }

PROMPT = k:"prompt"i { return createNodeKeyword(k); }

MAIN = k:"main"i { return createNodeKeyword(k); }

STRING = k:"string"i { return createNodeKeyword(k); }

RETURNING = k:"returning"i { return createNodeKeyword(k); }

OPERATOR = o:[~!@%^&*-+|/{}\:;<>?#_] { return createNodeOperator(o); }

EQUAL = o:"=" { return createNodeOperator(o); }

O_PARENTHESIS = o:"(" { return createNodeBracket(o); }

C_PARENTHESIS = o:")" { return createNodeBracket(o); }

O_BRACKET = o:"[" { return createNodeBracket(o); }

C_BRACKET = o:"]" { return createNodeBracket(o); }

AT = o:"@" { return createNodeOperator(o); }

DOT = o:"." { return createNodeOperator(o); }

COLON = o:":" { return createNodeOperator(o); }

COMMA = o:"," { return createNodeOperator(o); }

ASTERISK = o:"*" { return createNodeOperator(o); }

BIGINT = k:"bigint"i { return createNodeKeyword(k); }

BYTE = k:"byte"i { return createNodeKeyword(k); }

CHAR = k:"CHAR"i { return createNodeKeyword(k); }

CHARACTER = k:"character"i { return createNodeKeyword(k); }

DATE = k:"date"i { return createNodeKeyword(k); }

DATETIME = k:"datetime"i { return createNodeKeyword(k); }

DEC = k:"dec"i { return createNodeKeyword(k); }

DECIMAL = k:"decimal"i { return createNodeKeyword(k); }

DOUBLE = k:("double"i) { return createNodeKeyword(k); }

PRECISION = k:("precision"i) { return createNodeKeyword(k); }

DYNAMIC = k:("dynamic"i) { return createNodeKeyword(k); }

ARRAY = k:("array"i) { return createNodeKeyword(k); }

FLOAT = k:"float"i { return createNodeKeyword(k); }

INT = k:"int"i { return createNodeKeyword(k); }

INTEGER = k:"integer"i { return createNodeKeyword(k); }

INTERVAL = k:"interval"i { return createNodeKeyword(k); }

LIKE = k:"like"i { return createNodeKeyword(k); }

MONEY = k:"money"i { return createNodeKeyword(k); }

NCHAR = k:"nchar"i { return createNodeKeyword(k); }

NUMERIC = k:"numeric"i { return createNodeKeyword(k); }

NVARCHAR = k:"nvarchar"i { return createNodeKeyword(k); }

OF = k:"of"i { return createNodeKeyword(k); }

FOR = k:"for"i { return createNodeKeyword(k); }

REAL = k:"real"i { return createNodeKeyword(k); }

RECORD = k:"record"i { return createNodeKeyword(k); }

SMALLFLOAT = k:"smallfloat"i { return createNodeKeyword(k); }

SMALLINT = k:"smallint"i { return createNodeKeyword(k); }

TEXT = k:"text"i { return createNodeKeyword(k); }

TO = k:"to"i { return createNodeKeyword(k); }

VARCHAR = k:"varchar"i { return createNodeKeyword(k); }

YEAR = k:"year"i { return createNodeKeyword(k); }

MONTH = k:"month"i { return createNodeKeyword(k); }

DAY = k:"day"i { return createNodeKeyword(k); }

HOUR = k:"hour"i { return createNodeKeyword(k); }

MINUTE = k:"minute"i { return createNodeKeyword(k); }

SECOND = k:"second"i { return createNodeKeyword(k); }

FRACTION = k:"fraction"i { return createNodeKeyword(k); }

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

SPACE
  = s:$[ \t\n\r]+ { return createNodeSpace(s); }
  / s:NL+

NL = s:("\n" / "\r\n") { return createNodeSpace(s); }

NLS
  = NL
  / SPACE

EOF = !.
