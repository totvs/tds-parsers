// Gramática eleborada com base na documentação disponibilizada em
// https://www.oninit.com/manual/informix/english/docs/4gl/7609.pdf
// e na pasta "docs" encontra-se uma cópia

{
const TokenKind = {
  program: "program",
  main: "main",
  statment: "statment",
  keyword: "keyword",
  whitespace: "whitespace",
  comment: "comment",
  operator: "operator",
  string: "string",
  number: "number",
  constant: "constant",
  id: "id",
  builtInVar: "builtInVar",
  globals: "globals",

// block: "block",
// bracket: "bracket",
// close_operator: "close_operator",
// statment: "statment",
// double_operator: "double_operator",
// expression: "expression",
// function: "function",
// identifier: "identifier",
// list: "list",
// modular: "modular",
// number: "number",
// unknown: "unknown",
// variable: "variable",
// notSpecified: "notSpecified"
}

var ast = [];

function addNode(node) {
  if (node) {
    ast.push(node);
  }

  return ast;
}

function createNode(kind, value, ws) {
  if (value) {
    const _location = location();
    const offset = {
      start: _location.start.offset,
      end: _location.end.offset,
    }

    let obj = {
      kind: kind,
      offset: offset,
      line: _location.start.line,
      column: _location.start.column,
      value: value,
      whitespace: ws
    }

    return obj;
  }

  return value;
}

function createNodeProgram(value) {
  return createNode(TokenKind.program, value);
}

function createNodeGlobals(value) {
  return createNode(TokenKind.globals, value);
}

function createNodeMain(value) {
  return createNode(TokenKind.main, value);
}

function createNodeFunction(value) {
  return createNode(TokenKind.function, value);
}

function createNodeWSpace(value) {
  return createNode(TokenKind.whitespace, value);
}

function createNodeStatment(value) {
  return createNode(TokenKind.statment, value);
}

function createNodeComment(value) {
  return createNode(TokenKind.comment, value);
}

function createNodeKeyword(value, ws) {
  return createNode(TokenKind.keyword, value, ws);
}

function createNodeOperator(value, ws) {
  return createNode(TokenKind.operator, value, ws);
}

function createNodeId(value) {
  return createNode(TokenKind.id, value);
}

function createNodeConstant(value) {
  return createNode(TokenKind.constant, value);
}

function createNodeString(value) {
  return createNode(TokenKind.string, value);
}

function createNodeNumber(value) {
  return createNode(TokenKind.number, value);
}

function createNodeBuiltInVar(value) {
  return createNode(TokenKind.builtInVar, value);
}

}

// /////////////////////////////////////////////// 
// Terminals
// /////////////////////////////////////////////// 

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';

string
  = s:$(double_quoted_string / single_quoted_string) {
      return createNodeString(s);
    }

double_quoted_string = $(D_QUOTE (!D_QUOTE .)* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE .)* S_QUOTE)

number
  = n:$([-+]? DIGIT+ (DOT DIGIT+)?) {
      return createNodeNumber(parseFloat(n, 10));
    }

DIGIT = [0-9]

TILDE = o:"~" WS { return createNodeOperator(o)}

ESCAPED
  = o:"\\\"" { return '"'}
 / "\\'" { return "'"}
 / "\\\\" { return "\\"}
 / "\\b" { return "\b"}
 / "\\t" { return "\t"}
 / "\\n" { return "\n"}
 / "\\f" { return "\f"}
 / "\\r" { return "\r"}

WS
  = s:$[ \t;]+ { return createNodeWSpace(s)}
 / s:_NL+

_NL = s:$("\n" / "\r" / "\r\n") { return createNodeWSpace(s)}

NLS
  = _NL / WS

// /////////////////////////////////////////////// 
// Tokens
// /////////////////////////////////////////////// 
tokens
  = BLACK 
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
 / C_BRACES
 / C_BRACKET
 / C_PARENTHESIS
 / O_BRACES
 / O_BRACKET
 / O_PARENTHESIS
 / string
 / number
 /// constant
  /// datetime
  /// operator

// /////////////////////////////////////////////// 
// Data types
// /////////////////////////////////////////////// 
attributeClause
  = ATTRIBUTE O_PARENTHESIS 
      (
        color
       / intensityList?
     )
    C_PARENTHESIS   

bindingClause
  = programArray (WITHOUT DEFAULTS)? FROM screenArray DOT ASTERISK

openWindowAttributeClause
  = ATTRIBUTE O_PARENTHESIS color? intensityList? C_PARENTHESIS   

color
  = BLACK 
 / BLUE 
 / CYAN 
 / GREEN 
 / MAGENTA 
 / RED 
 / WHITE 
 / YELLOW

intensityList
  = l:intensity_list+ p:intensity+ { return l.concat(p)}
 / p:intensity_list+ { return p}
 / p:intensity { return [p]}

intensity_list
  = e:(intensity WS? COMMA) { return e}

intensity
  = BOLD
 / DIM
 / INVISIBLE
 / NORMAL
 / REVERSE 
 / BLINK 
 / UNDERLINE

glExpression
  = timeExpression
  / characterExpression
  / numberExpression
  / integerExpression
  / booleanExpression
  / O_PARENTHESIS glExpression C_PARENTHESIS

dataTypeDeclaration
  = LIKE tableQualifier? table DOT column

glDataType
  = glSimpleDataType
   / arrayDataType
   / recordDataType
   / TEXT
   / BYTE

glSimpleDataType
  = (INTEGER/ INT)
 / (CHARACTER/ CHAR) (O_PARENTHESIS size C_PARENTHESIS)?
 / VARCHAR (O_PARENTHESIS maximumSize (COMMA reservedSize)? C_PARENTHESIS)?
 / SMALLINT
 / (DECIMAL/ DEC/ NUMERIC) (O_PARENTHESIS precision (COMMA scale)? C_PARENTHESIS)?
 / MONEY (O_PARENTHESIS precision (COMMA scale)? C_PARENTHESIS)?
 / (FLOAT/ DOUBLE PRECISION) (O_PARENTHESIS precision C_PARENTHESIS)?
 / SMALL FLOAT/ REAL
 / DATE
 / DATETIME datetimeQualifier
 / INTERVAL intervalQualifier

arrayDataType
  = ARRAY O_BRACKET sizeList C_BRACKET OF 
    (glSimpleDataType/ recordDataType/ BYTE/ TEXT) 

sizeList
  = l:size_list+ p:size+ { return l.concat(p)}
 / p:size_list+ { return p}
 / p:size { return [p]}

size_list
  = e:(size WS? COMMA) { return e}

size 
  = number

recordDataType
  = RECORD
    (
      (memberList dataTypeDeclaration)+ END RECORD
     / LIKE tableQualifier? table DOT ASTERISK
   )

namedValue
  = (record DOT)* variable (O_BRACKET integerExpressionList C_BRACKET)?
  / record DOT ASTERISK

integerExpressionList
  = l:integer_expression_list+ p:integer_expression+ { return l.concat(p)}
 / p:integer_expression_list+ { return p}
 / p:integer_expression { return [p]}

integer_expression_list
  = e:(size WS? COMMA) { return e}

integer_expression
  = integerExpression

memberList
  = l:member_list+ p:member+ { return l.concat(p)}
 / p:member_list+ { return p}
 / p:member { return [p]}

member_list
  = e:(member WS? COMMA) { return e}

member
  = ID

functionCall
  = functionName O_PARENTHESIS glExpressionList C_PARENTHESIS

glExpressionList
  = gl_expression (WS? COMMA gl_expression)*

gl_expression
  = glExpression

booleanExpression
  = NOT? (
      booleanComparation
   / functionCall
   / TRUE
   / FALSE
 )/ (AND/ OR) booleanExpression

booleanComparation
  = stringComparation
  / setMembershipTest
  / nullTest
  / relationalComparation

relationalComparation
  =  (
    EQUAL
  / LESS
  / GREATER
  / LESS EQUAL
  / GREATER EQUAL
  / LESS GREATER
  / EXCLAMATION EQUAL) glExpression
  

stringComparation
  = characterExpression NOT? (MATCHES/ LIKE) criterion (ESCAPE D_QUOTE char D_QUOTE)

criterion
  = $(D_QUOTE (!D_QUOTE .)+ D_QUOTE)

nullTest
  = blobVariable IS (NOT)? NULL
  //= (glExpression/ blobVariable) IS (NOT)? NULL
  
setMembershipTest
  =  (NOT)? IN O_PARENTHESIS glExpression C_PARENTHESIS
//  = glExpression (NOT)? IN O_PARENTHESIS glExpression C_PARENTHESIS

integerExpression
  = (
    (PLUS / MINUS)?
    (
      literalInteger
     / functionCall
     / namedValue
     / booleanExpression
   )
    (PLUS / MINUS / ASTERISK / SLASH / MOD / ASTERISK ASTERISK)?
 )+
 / (dateValue MINUS dateValue)

literalInteger
  = (PLUS / MINUS)? DIGIT+ 

numberExpression
  = (
    (PLUS / MINUS)?
    (
      literalNumber
     / functionCall
     / namedValue
     / booleanExpression
   ) (
      PLUS
     / MINUS
     / ASTERISK
     / SLASH
     / MOD integerExpression
     / ASTERISK ASTERISK integerExpression
   )?
 )+

literalNumber
  = (PLUS/ MINUS) 
  (
    DIGIT+ DOT
   / DOT DIGIT+
 ) (
    ('e'i) (PLUS/ MINUS)? DIGIT+
 )?

characterExpression
  = (
    string
   / functionCall
   / namedValue
 ) (
    O_BRACKET integerExpression (COMMA integerExpression)? C_BRACKET
 )?
  CLIPPED? (USING D_QUOTE formatString D_QUOTE)?

timeExpression
  = intervalValue 
 / datetimeValue
 / dateValue

dateValue
  = (
    D_QUOTE numericDate D_QUOTE
   / functionCall 
   / namedValue
   / TODAY
   )
    (USING D_QUOTE formatString D_QUOTE)?

datetimeValue
  = (
    D_QUOTE numericDateTime D_QUOTE
   / datetimeLiteral
   / functionCall 
   / namedValue
   / CURRENT (datetimeQualifier)?
   / EXTEND O_PARENTHESIS 
      (
        (datetimeValue/ dateValue)
        (COMMA datetimeQualifier)?        
     ) C_PARENTHESIS
   )
  
intervalValue
  = (PLUS/ MINUS) 
    (
      (D_QUOTE numericDate D_QUOTE)
    / intervalLiteral
    / functionCall
    / namedValue
//    / integerExpression UNITS keyword
   )

numericDate
  = mo (separator dd separator)? (yy / yyyy)

mo = [1] [012] / [0-9]?[0-9]

dd = [0-9]?[0-9]

yy = [0-9][0-9]

yyyy = [0-9][0-9][0-9][0-9]

separator = SLASH 

datetimeQualifier
  = (YEAR / MONTH / DAY / HOUR / MINUTE / SECOND / FRACTION)
    TO (YEAR / MONTH / DAY / HOUR / MINUTE / SECOND / FRACTION O_PARENTHESIS scale C_PARENTHESIS)

datetimeLiteral
  = DATETIME O_PARENTHESIS numericDateTime C_PARENTHESIS datetimeQualifier

numericDateTime
  = yyyy (MINUS mo (MINUS dd (hh (COLON mm (COLON ss (DOT ffff)?)?)?)?)?)

hh = [12][0-9]

mm = [0-5][0-9]

ss = [0-5][0-9]

ffff = [0-9][0-9][0-9][0-9]

intervalQualifier
  = (
    ((DAY / HOUR / MINUTE / SECOND) (O_PARENTHESIS precision C_PARENTHESIS)? / FRACTION)
    TO (DAY / HOUR / MINUTE / SECOND / FRACTION (O_PARENTHESIS scale C_PARENTHESIS)?)
 ) / (
    (YEAR / MONTH) (O_PARENTHESIS precision C_PARENTHESIS)? TO (YEAR / MONTH)
 )

intervalLiteral
  = INTERVAL O_PARENTHESIS numericTimeInterval C_PARENTHESIS intervalQualifier

numericTimeInterval
  = dd (hh (COLON mm (COLON ss (DOT ffff)?)?)?)
  / yyyy MINUS mo

fieldClause
  = ((tableReference / screenRecord / screenArray (O_BRACKET line C_BRACKET)? / FORMONLY)?
  DOT (field / ASTERISK/ thruNotation)) (COMMA fieldClause)*

tableQualifier
  = databaseRef COLON (owner DOT / D_QUOTE owner DOT D_QUOTE)

thruNotation
  = first (THROUGH / THRU) same.last

databaseRef
  = $(ID (AT_SIGN ID)?)
  / string

// --------------------------------------------------------------
formatString = string

table = ID

column = ID 

precision = INTEGER

scale = INTEGER

maximumSize = INTEGER

reservedSize = INTEGER

record = ID

variable = ID 

array = ID

char = [a-zA-Z]

blobVariable = ID

tableReference = ID

screenRecord = ID

screenArray = ID

programArray = ID

field = ID

server = ID

owner = ID

first = ID

same = ID

last = ID

line = INTEGER

lines = INTEGER

functionName = ID

preparedStatment = ID

labelName = COLON ID

preparedStatmentName = ID

cursorName = ID

window = ID

form = ID

topLine = integer_expression

leftOffset = integer_expression

height = integer_expression

width = integer_expression

filename = string

response = variable

optionName = ID

// //////////////////////////////////////////////////////
// Start
// //////////////////////////////////////////////////////
start_program 
  = l:statments* { return createNodeProgram(ast)}

start_token 
  = l:line_token* { return ast}

line_token
  = t:comment { return addNode(t)}
  / t:tokens { return addNode(t)}
  / t:WS { return addNode(t)}
  / o:$(!WS .)+ { return createNode(TokenKind.notSpecified, o)}

statments
  = l:statment+ s:statment { return l.concat(s)}
  / l:statment+ { return l}
  / s:statment { return [s]}

statment
  = s:(
    WS
  / definitionDeclarationStatements
  / flowStatements
  / compilerDirectives
  / storageStatements
  / screenStatements
  / comment
  // / reportStatements
 ) { return createNodeStatment(s)}

sqlDynamicManagementStatements
    = execute
    / prepare
    / free

definitionDeclarationStatements
  = define
  / function
  / main 
  // / report //<< revisar >>

comment
  = singleCommentLine 
  / c:$(O_BRACES (!C_BRACES .)* C_BRACES) { return createNodeComment(c)}

singleCommentLine
  = c:$('#' (!_NL .)* _NL) { return createNodeComment(c)}
  / c:$('-' '-' '#' (!_NL .)* _NL) { return createNodeComment(c)}

screenStatements
  = clear
  / displayForm
  / openWindow
  / closeForm
  / error
  / options
  / closeWindow
  / input
  / prompt
  / construct
  / inputArray
  / scroll
  / currentWindow
  / menu
  / sleep
  / display
  / message
  / displayArray
  / openForm

// reportStatements << revisar >>
//   = need
//   / print
//   / pause
//   / skip

flowStatements
  = call 
  / finishReport
  / outputToReport
  / case
  / for
  / return
  / continue
  / foreach
  / run
  / goto
  / startReport
  / if
  / while
  / exit
  / label

compilerDirectives 
  = database
  / globals
  / defer
  / whenever

storageStatements
  = initialize
  / locate
  / let
  / validate

// //////////////////////////////////////////////////////
// Statments
// //////////////////////////////////////////////////////
execute
  = EXECUTE preparedStatment (USING namedValue)?

prepare 
  = PREPARE preparedStatmentName FROM (string / namedValue)

free
  = FREE (namedValue / preparedStatmentName / cursorName)

define
   = DEFINE defineType (WS? COMMA defineType)*

defineType
  = namedValue WS? ( glDataType / dataTypeDeclaration)

variableList
  = namedValue (WS? COMMA namedValue WS?)

main
  = f:(MAIN 
      define*
      databaseRef?
      (
        statments
        / EXIT PROGRAM
        / defer
     )? 
      (END MAIN)
    ) { return createNodeMain(f)}

function
  = f:((FUNCTION functionName O_PARENTHESIS argumentList? C_PARENTHESIS)
      define*
      (
        statments?
        / return
     ) 
      (END FUNCTION)
 ) { return createNodeFunction(f)}

argumentList
  = ID (WS? COMMA ID)*;

clear
  = CLEAR (
    FORM
    / WINDOW (window / SCREEN)
    / fieldList
 )

fieldList
  = l:field_list+ p:fieldClause+ { return l.concat(p)}
  / p:field_list+ { return p}
  / p:fieldClause { return [p]}

field_list
  = a:(fieldClause COMMA?) { return a}

displayForm
  = DISPLAY FORM form attributeClause?

openWindow
  = OPEN WINDOW window AT topLine COMMA leftOffset WITH
  (
    height ROWS COMMA width COLUMNS
    / FORM (filename / variable)
 ) openWindowAttributeClause

closeForm
  = CLOSE form

closeWindow
  = CLOSE window

continue
  = CONTINUE

error
  = ERROR strVarList attributeClause?

strVarList
  = l:strVar_list+ p:strVar+ { return l.concat(p)}
  / p:strVar_list+ { return p}
  / p:strVar { return [p]}

strVar_list 
  = a:(strVar WS? COMMA) { return a}

strVar
  = variable
  / string

options
  = OPTIONS optionsList

optionsList
  = l:option_list+ p:option+ { return l.concat(p)}
  / p:option_list+ { return p}
  / p:option { return [p]}

option_list
  = a:(option WS? COMMA) { return a}

option 
  = (
    (COMMENT / ERROR / FORM / MENU / MESSAGE / PROMPT) LINE (FIRST / LAST) (PLUS / MINUS)? number
 )
  / (
    (ACCEPT / DELETE / INSERT / NEXT / PREVIOUS) KEY key
 )
  / HELP FILE string
  / DISPLAY ATTRIBUTE attributeClause
  / INPUT ATTRIBUTE attributeClause
  / INPUT NO? WRAP
  / FIELD ORDER (UNCONSTRAINED / CONSTRAINT)
  / SQL INTERRUPT (ON / OFF)

input
  = INPUT bindingClause attributeClause? (HELP number)? 
      inputFormManagementBlock? END INPUT

keyList
  = l:key_list+ p:key+ { return l.concat(p)}
  / p:key_list+ { return p}
  / p:key { return [p]}

key_list
  = a:(key WS? COMMA) { return a}
  
key
  = (CONTROL MINUS [a-zA-Z])
    / $("f"i literalInteger) 

inputFormManagementBlock
 = (
   (BEFORE / AFTER) (
    FIELD fieldClause / INPUT 
   )
    / KEY keyList 
 ) (
    statment
    / NEXT FIELD (field / NEXT / PREVIOUS) 
    / (EXIT / CONTINUE) INPUT
 )+

inputArrayManagementBlock
 = (
   (BEFORE / AFTER) (
    FIELD fieldClause / INPUT / DELETE / INSERT / ROW  
   )
    / KEY keyList 
 ) (
    statment
    / NEXT FIELD (field / NEXT / PREVIOUS) 
    / (EXIT / CONTINUE) INPUT
 )+

prompt
  = PROMPT strVarList attributeClause? FOR CHAR? 
    response (HELP number)? attributeClause? 
    (ON KEY O_PARENTHESIS keyList C_PARENTHESIS statment)*
  END PROMPT 

construct 
  = CONSTRUCT constructVariableClause attributeClause? (HELP number)? 
  (constructFormManagementBlock+ END CONSTRUCT)?

constructVariableClause 
  = (variableList ON columnList FROM fieldClause)
    / (BY NAME variable ON columnList)

columnList
  = l:col_list+ p:col_element+ { return l.concat(p)}
  / p:col_list+ { return p}
  / p:col_element { return [p]}

col_list 
  = a:(col_element WS? COMMA) { return a}

col_element
  = ID
  
constructFormManagementBlock
  = (
    BEFORE CONSTRUCT
    / AFTER CONSTRUCT
    / (BEFORE / AFTER) FIELD fieldList
    / (ON KEY O_PARENTHESIS keyList C_PARENTHESIS statment)
 )
  (
    statment
    / NEXT FIELD (NEXT / PREVIOUS) 
    / (CONTINUE / EXIT) CONSTRUCT
 )+

inputArray
  = INPUT ARRAY bindingClause attributeClause? (HELP number)? 
    inputFormManagementBlock?

scroll
  = SCROLL fieldClause (DOWN / UP) (BY lines)?

currentWindow 
  = CURRENT WINDOW IS (window / SCREEN)

menu
  = MENU (string / variable) menuControlBlock+ END MENU

menuControlBlock
  = (
    BEFORE MENU
    / commandBlock
 )
  (
    statment
    / NEXT OPTION optionName
    / (SHOW / HIDE) OPTION (ALL / optionNameList) 
    / (CONTINUE / EXIT) CONSTRUCT
 )+

optionNameList
  = l:optionName_list+ p:optionName+ { return l.concat(p)}
  / p:optionName_list+ { return p}
  / p:optionName { return [p]}

optionName_list
  = a:(optionName WS? COMMA) { return a}

commandBlock
  = COMMAND (KEY keyList)?  optionName (optionDescription)? (HELP number)?

optionDescription
  = string;

sleep
  = SLEEP number

display 
  =  DISPLAY (
      (displayValueList / COLUMN leftOffset)+
    / displayValueList AT line COMMA leftOffset attributeClause?
    / displayValueList TO fieldClause+ line COMMA leftOffset attributeClause?
    / BY NAME variableList  attributeClause
 )

displayValueList
  = strVar_list
//   l:displayValue_list+ p:displayValue+ { return l.concat(p)}
//   / p:displayValue_list+ { return p}
//   / p:displayValue { return [p]}

// displayValue_list
//   = a:(displayValue WS? COMMA) { return a}

//displayValue
//  = 
displayArray 
  = DISPLAY ARRAY recordArray TO screenArray DOT ASTERISK attributeClause?
    (ON KEY O_PARENTHESIS keyList C_PARENTHESIS (statment / EXIT DISPLAY))*

recordArray = ID

message 
  =  MESSAGE strVarList attributeClause?

openForm
  = OPEN FORM form FROM filename

call
  = CALL functionName O_PARENTHESIS glExpressionList? C_PARENTHESIS
    (RETURNING receivingVariableList)?

receivingVariableList
  = variableList

reportName = ID

finishReport
   = FINISH REPORT reportName

outputToReport
   = OUTPUT  TO  REPORT reportName O_PARENTHESIS glExpressionList C_PARENTHESIS

case
  = CASE (
      O_PARENTHESIS glExpression C_PARENTHESIS whenList
      / whenBooleanList
     )
      (OTHERWISE (statments / EXIT  CASE))?
  END CASE

whenList
  = l:when_list+ p:when+ { return l.concat(p)}
  / p:when_list+ { return p}
  / p:when { return [p]}

when_list 
  = a:(when &when) { return a}

when
  = WHEN glExpression (statments / EXIT  CASE)

whenBooleanList
  = l:whenB_list+ p:whenB+ { return l.concat(p)}
  / p:whenB_list+ { return p}
  / p:whenB { return [p]}

whenB_list 
  = a:(whenB &whenB) { return a}

whenB
  = WHEN booleanExpression (statments / EXIT  CASE)

counter = ID
start = integerExpression
finish = integerExpression
increment = integerExpression

leftExpression = glExpression
rightExpression = glExpression
incrementExpression = glExpression

for
  = FOR variable 
  (EQUAL start TO finish (STEP increment)? 
  / IN O_PARENTHESIS 
    (
      leftExpression TO rightExpression (STEP incrementExpression)? 
      / (glExpression (COMMA glExpression)*)
   ) 
    C_PARENTHESIS 
 )
      statments?
    END FOR

cursor = ID

foreach
  = FOREACH  cursor  (INTO  variableList)?  
      (statments / CONTINUE  FOREACH / EXIT  FOREACH)
    END FOREACH

return
  = RETURN (
      glExpressionList
      / O_PARENTHESIS glExpressionList C_PARENTHESIS
 )? 

run
  = RUN  (string / variable) (
      RETURNING  variable
      / WITHOUT  WAITING
   )?

goto
  = GOTO labelName

label
  = labelName COLON

startReport
  = START REPORT (
    TO (
      string
      // / PRINTER << revisar >>
      / PIPE (string / variable)
   )
 )?

if
  = (IF booleanExpression  THEN)
      statments?
      elifList?
      else?
    (END IF)

elifList
  = l:elif_list+ p:elif+ { return l.concat(p)}
  / p:elif_list+ { return p}
  / p:elif { return [p]}

elif_list
  = a:(elif &ELIF) { return a}

elif
  = ELIF booleanExpression THEN statments 

else
  = ELSE statments?

while
  = WHILE booleanExpression
      statments?
    END WHILE

exit
  = EXIT PROGRAM (
      integer_expression
      / O_PARENTHESIS integer_expression C_PARENTHESIS
   )?

database  
  = DATABASE databaseRef (WITHOUT NULL INPUT)?
  / DATABASE FORMONLY

globals
  = g:(GLOBALS define* END GLOBALS) { return createNodeGlobals(g)}
  / g:(GLOBALS string comment?) { return createNodeGlobals(g)}

defer
  = DEFER (INTERRUPT / QUIT)

whenever
  = WHENEVER 
  (
    NOT FOUND
    / SQLERROR
    / ANY? ERROR
    / WARNING
    / SQLWARNING
 )
  (
    CONTINUE
    / (GOTO / GO TO) labelName
    / STOP
    / CALL functionName
 )

initialize
  = INITIALIZE variableList 
  (
    LIKE columnList
    / TO NULL
 )

locate
  = LOCATE variableList IN 
  (
    MEMORY
    / FILE (filename / variable)?
 )

destination = receivingVariableList
source = receivingVariableList

let
  = LET 
    (
      receivingVariableList EQUAL (glExpressionList / NULL)
      / destination DOT ASTERISK EQUAL source DOT ASTERISK
   )

validate
  = VALIDATE variableList LIKE columnList

ID = (!tokens $([a-zA-Z_] [a-zA-Z_0-9]*))

MO=('0'..'1')? DIGIT;
DD=('0'..'3')? DIGIT;
YYYY=DIGIT{4}
HH=('0'..'2')? DIGIT;
MM=('0'..'5')? DIGIT;
SS=('0'..'5')? DIGIT;
FFFF=DIGIT{4}

AT_SIGN="@";
INT_FLAG=v:$("int_flag" WS) { return createNodeBuiltInVar(v) }
NOT_FOUND=v:$("notfound"i WS?) { return createNodeBuiltInVar(v) }
SQL_CODE=v:$("sqlcode"i WS?) { return createNodeBuiltInVar(v) }
STATUS=v:$("status"i WS?) { return createNodeBuiltInVar(v) }
QUIT_FLAG=v:$("quit_flag"i WS?) { return createNodeBuiltInVar(v) }
SQL_CA_RECORD=v:$("sqlcarecord"i WS?) { return createNodeBuiltInVar(v) }
SQL_ERR_M=v:$("sqlerrm"i WS?) { return createNodeBuiltInVar(v) }
SQL_ERR_P=v:$("sqlerrp"i WS?) { return createNodeBuiltInVar(v) }
SQL_ERR_D=v:$("sqlerrd"i WS?) { return createNodeBuiltInVar(v) }
SQL_AWARN=v:$("sqlawarn"i WS?) { return createNodeBuiltInVar(v) }

TRUE=c:$("true"i WS?) { return createNodeConstant(c) }
FALSE=c:$("false"i WS?) { return createNodeConstant(c) }

O_BRACES=o:$("{" WS?) { return createNodeOperator(o) }
C_BRACES=o:$("}" WS?) { return createNodeOperator(o) }
O_BRACKET=o:$("[" WS?) { return createNodeOperator(o) }
C_BRACKET=o:$("]" WS?) { return createNodeOperator(o) }
O_PARENTHESIS=o:$("(" WS?) { return createNodeOperator(o) }
C_PARENTHESIS=o:$(")" WS?) { return createNodeOperator(o) }
COMMA=o:$("," WS?) { return createNodeOperator(o) }
ASTERISK=o:$("*" WS?) { return createNodeOperator(o) }
EQUAL=o:$("="  WS?) { return createNodeOperator(o) }
LESS=o:$("<" WS?) { return createNodeOperator(o) }
GREATER=o:$(">" WS?) { return createNodeOperator(o) }
EXCLAMATION=o:$("!" WS?) { return createNodeOperator(o) }
PLUS=o:$("+" WS?) { return createNodeOperator(o) }
MINUS=o:$("-" WS?) { return createNodeOperator(o) }
COLON=o:$(":" WS?) { return createNodeOperator(o) }
SLASH=o:$("/" WS?) { return createNodeOperator(o) }

ACCEPT=k:"accept"i w:WS? { return createNodeKeyword(k,w) }
AFTER=k:"after"i w:WS? { return createNodeKeyword(k,w) }
ALL=k:"all"i w:WS? { return createNodeKeyword(k,w) }
AND=k:"and"i w:WS? { return createNodeKeyword(k,w) }
ANY=k:"any"i w:WS? { return createNodeKeyword(k,w) }
ARRAY=k:"array"i w:WS? { return createNodeKeyword(k,w) }
ASC=k:"asc"i w:WS? { return createNodeKeyword(k,w) }
ASCENDING=k:"ascending"i w:WS? { return createNodeKeyword(k,w) }
ASCII=k:"ascii"i w:WS? { return createNodeKeyword(k,w) }
AT=k:"year"i w:WS? { return createNodeKeyword(k,w) }
ATTRIBUTE=k:"attribute"i w:WS? { return createNodeKeyword(k,w) }
ATTRIBUTES=k:"attributes"i w:WS? { return createNodeKeyword(k,w) }
AUTONEXT=k:"autonext"i w:WS? { return createNodeKeyword(k,w) }
AVG=k:"avg"i w:WS? { return createNodeKeyword(k,w) }
BEFORE=k:"before"i w:WS? { return createNodeKeyword(k,w) }
BEGIN=k:"begin"i w:WS? { return createNodeKeyword(k,w) }
BETWEEN=k:"between"i w:WS? { return createNodeKeyword(k,w) }
BIGINT=k:"bigint"i w:WS? { return createNodeKeyword(k,w) }
BLACK=k:"black"i w:WS? { return createNodeKeyword(k,w) }
BLINK=k:"blink"i w:WS? { return createNodeKeyword(k,w) }
BLUE=k:"blue"i w:WS? { return createNodeKeyword(k,w) }
BOLD=k:"bold"i w:WS? { return createNodeKeyword(k,w) }
BORDER=k:"border"i w:WS? { return createNodeKeyword(k,w) }
BOTTOM=k:"bottom"i w:WS? { return createNodeKeyword(k,w) }
BY=k:"by"i w:WS? { return createNodeKeyword(k,w) }
BYTE=k:"byte"i w:WS? { return createNodeKeyword(k,w) }
CALL=k:"call"i w:WS? { return createNodeKeyword(k,w) }
CASE=k:"case"i w:WS? { return createNodeKeyword(k,w) }
CHAR=k:"char"i w:WS? { return createNodeKeyword(k,w) }
CHARACTER=k:"character"i w:WS? { return createNodeKeyword(k,w) }
CLEAR=k:"clear"i w:WS? { return createNodeKeyword(k,w) }
CLIPPED=k:"clipped"i w:WS? { return createNodeKeyword(k,w) }
CLOSE=k:"close"i w:WS? { return createNodeKeyword(k,w) }
COLUMN=k:"column"i w:WS? { return createNodeKeyword(k,w) }
COLUMNS=k:"columns"i w:WS? { return createNodeKeyword(k,w) }
COMMAND=k:"command"i w:WS? { return createNodeKeyword(k,w) }
COMMENT=k:"comment"i w:WS? { return createNodeKeyword(k,w) }
COMMENTS=k:"comments"i w:WS? { return createNodeKeyword(k,w) }
COMMIT=k:"commit"i w:WS? { return createNodeKeyword(k,w) }
CONSTRAINT=k:"constraint"i w:WS? { return createNodeKeyword(k,w) }
CONSTRUCT=k:"construct"i w:WS? { return createNodeKeyword(k,w) }
CONTINUE=k:"continue"i w:WS? { return createNodeKeyword(k,w) }
CONTROL=k:"control"i w:WS? { return createNodeKeyword(k,w) }
COUNT=k:"count"i w:WS? { return createNodeKeyword(k,w) }
CREATE=k:"create"i w:WS? { return createNodeKeyword(k,w) }
CURRENT=k:"current"i w:WS? { return createNodeKeyword(k,w) }
CURSOR=k:"cursor"i w:WS? { return createNodeKeyword(k,w) }
CYAN=k:"cyan"i w:WS? { return createNodeKeyword(k,w) }
DATABASE=k:"database"i w:WS? { return createNodeKeyword(k,w) }
DATE=k:"date"i w:WS? { return createNodeKeyword(k,w) }
DATETIME=k:"datetime"i w:WS? { return createNodeKeyword(k,w) }
DAY=k:"day"i w:WS? { return createNodeKeyword(k,w) }
DEC=k:"dec"i w:WS? { return createNodeKeyword(k,w) }
DECIMAL=k:"decimal"i w:WS? { return createNodeKeyword(k,w) }
DECLARE=k:"declare"i w:WS? { return createNodeKeyword(k,w) }
DEFAULTS=k:"defaults"i w:WS? { return createNodeKeyword(k,w) }
DEFER=k:"defer"i w:WS? { return createNodeKeyword(k,w) }
DEFINE=k:"define"i w:WS? { return createNodeKeyword(k,w) }
DELETE=k:"delete"i w:WS? { return createNodeKeyword(k,w) }
DELIMITER=k:"delimiter"i w:WS? { return createNodeKeyword(k,w) }
DELIMITERS=k:"delimiters"i w:WS? { return createNodeKeyword(k,w) }
DESC=k:"desc"i w:WS? { return createNodeKeyword(k,w) }
DESCENDING=k:"descending"i w:WS? { return createNodeKeyword(k,w) }
DIM=k:"dim"i w:WS? { return createNodeKeyword(k,w) }
DIRTY=k:"dirty"i w:WS? { return createNodeKeyword(k,w) }
DISPLAY=k:"display"i w:WS? { return createNodeKeyword(k,w) }
DISTINCT=k:"distinct"i w:WS? { return createNodeKeyword(k,w) }
DOUBLE=k:"double"i w:WS? { return createNodeKeyword(k,w) }
DOWN=k:"down"i w:WS? { return createNodeKeyword(k,w) }
DOWNSHIFT=k:"downshift"i w:WS? { return createNodeKeyword(k,w) }
DROP=k:"drop"i w:WS? { return createNodeKeyword(k,w) }
DYNAMIC=k:"dynamic"i w:WS? { return createNodeKeyword(k,w) }
ELIF=k:"elif"i w:WS? { return createNodeKeyword(k,w) }
ELSE=k:"else"i w:WS? { return createNodeKeyword(k,w) }
END=k:"end"i w:WS? { return createNodeKeyword(k,w) }
ERROR=k:"error"i w:WS? { return createNodeKeyword(k,w) }
ESCAPE=k:"escape"i w:WS? { return createNodeKeyword(k,w) }
EVERY=k:"every"i w:WS? { return createNodeKeyword(k,w) }
EXCLUSIVE=k:"exclusive"i w:WS? { return createNodeKeyword(k,w) }
EXECUTE=k:"execute"i w:WS? { return createNodeKeyword(k,w) }
EXISTS=k:"exists"i w:WS? { return createNodeKeyword(k,w) }
EXIT=k:"exit"i w:WS? { return createNodeKeyword(k,w) }
EXTEND=k:"extend"i w:WS? { return createNodeKeyword(k,w) }
EXTERNAL=k:"external"i w:WS? { return createNodeKeyword(k,w) }
FETCH=k:"fetch"i w:WS? { return createNodeKeyword(k,w) }
FIELD=k:"field"i w:WS? { return createNodeKeyword(k,w) }
FILE=k:"file"i w:WS? { return createNodeKeyword(k,w) }
FINISH=k:"finish"i w:WS? { return createNodeKeyword(k,w) }
FIRST=k:"first"i w:WS? { return createNodeKeyword(k,w) }
FLOAT=k:"float"i w:WS? { return createNodeKeyword(k,w) }
FLUSH=k:"flush"i w:WS? { return createNodeKeyword(k,w) }
FOR=k:"for"i w:WS? { return createNodeKeyword(k,w) }
FOREACH=k:"foreach"i w:WS? { return createNodeKeyword(k,w) }
FORM=k:"form"i w:WS? { return createNodeKeyword(k,w) }
FORMAT=k:"format"i w:WS? { return createNodeKeyword(k,w) }
FORMONLY=k:"formonly"i w:WS? { return createNodeKeyword(k,w) }
FOUND=k:"found"i w:WS? { return createNodeKeyword(k,w) }
FRACTION=k:"fraction"i w:WS? { return createNodeKeyword(k,w) }
FREE=k:"free"i w:WS? { return createNodeKeyword(k,w) }
FROM=k:"from"i w:WS? { return createNodeKeyword(k,w) }
FUNCTION=k:"function"i w:WS? { return createNodeKeyword(k,w) }
GLOBALS=k:"globals"i w:WS? { return createNodeKeyword(k,w) }
GO=k:"go"i w:WS? { return createNodeKeyword(k,w) }
GOTO=k:"goto"i w:WS? { return createNodeKeyword(k,w) }
GREEN=k:"green"i w:WS? { return createNodeKeyword(k,w) }
GROUP=k:"group"i w:WS? { return createNodeKeyword(k,w) }
HAVING=k:"having"i w:WS? { return createNodeKeyword(k,w) }
HEADER=k:"header"i w:WS? { return createNodeKeyword(k,w) }
HELP=k:"help"i w:WS? { return createNodeKeyword(k,w) }
HIDE=k:"hide"i w:WS? { return createNodeKeyword(k,w) }
HOLD=k:"hold"i w:WS? { return createNodeKeyword(k,w) }
HOUR=k:"hour"i w:WS? { return createNodeKeyword(k,w) }
IF=k:"if"i w:WS? { return createNodeKeyword(k,w) }
IN=k:"in"i w:WS? { return createNodeKeyword(k,w) }
INCLUDE=k:"include"i w:WS? { return createNodeKeyword(k,w) }
INDEX=k:"index"i w:WS? { return createNodeKeyword(k,w) }
INITIALIZE=k:"initialize"i w:WS? { return createNodeKeyword(k,w) }
INPUT=k:"input"i w:WS? { return createNodeKeyword(k,w) }
INSERT=k:"insert"i w:WS? { return createNodeKeyword(k,w) }
INSTRUCTIONS=k:"instructions"i w:WS? { return createNodeKeyword(k,w) }
INT=k:"int"i w:WS? { return createNodeKeyword(k,w) }
INTEGER=k:"integer"i w:WS? { return createNodeKeyword(k,w) }
INTERRUPT=k:"interrupt"i w:WS? { return createNodeKeyword(k,w) }
INTERVAL=k:"interval"i w:WS? { return createNodeKeyword(k,w) }
INTO=k:"into"i w:WS? { return createNodeKeyword(k,w) }
INVISIBLE=k:"invisible"i w:WS? { return createNodeKeyword(k,w) }
IS=k:"is"i w:WS? { return createNodeKeyword(k,w) }
ISOLATION=k:"isolation"i w:WS? { return createNodeKeyword(k,w) }
KEY=k:"key"i w:WS? { return createNodeKeyword(k,w) }
LABEL=k:"label"i w:WS? { return createNodeKeyword(k,w) }
LAST=k:"last"i w:WS? { return createNodeKeyword(k,w) }
LEFT=k:"left"i w:WS? { return createNodeKeyword(k,w) }
LENGTH=k:"length"i w:WS? { return createNodeKeyword(k,w) }
LET=k:"let"i w:WS? { return createNodeKeyword(k,w) }
LIKE=k:"like"i w:WS? { return createNodeKeyword(k,w) }
LINE=k:"line"i w:WS? { return createNodeKeyword(k,w) }
LINES=k:"lines"i w:WS? { return createNodeKeyword(k,w) }
LOAD=k:"load"i w:WS? { return createNodeKeyword(k,w) }
LOCATE=k:"locate"i w:WS? { return createNodeKeyword(k,w) }
LOCK=k:"lock"i w:WS? { return createNodeKeyword(k,w) }
LOG=k:"log"i w:WS? { return createNodeKeyword(k,w) }
MAGENTA=k:"magenta"i w:WS? { return createNodeKeyword(k,w) }
MAIN=k:"main"i w:WS? { return createNodeKeyword(k,w) }
MARGIN=k:"margin"i w:WS? { return createNodeKeyword(k,w) }
MATCHES=k:"matches"i w:WS? { return createNodeKeyword(k,w) }
MAX=k:"max"i w:WS? { return createNodeKeyword(k,w) }
MDY=k:"mdy"i w:WS? { return createNodeKeyword(k,w) }
MEMORY=k:"memory"i w:WS? { return createNodeKeyword(k,w) }
MENU=k:"menu"i w:WS? { return createNodeKeyword(k,w) }
MESSAGE=k:"message"i w:WS? { return createNodeKeyword(k,w) }
MIN=k:"min"i w:WS? { return createNodeKeyword(k,w) }
MINUTE=k:"minute"i w:WS? { return createNodeKeyword(k,w) }
MOD=k:"mod"i w:WS? { return createNodeKeyword(k,w) }
MODE=k:"mode"i w:WS? { return createNodeKeyword(k,w) }
MONEY=k:"money"i w:WS? { return createNodeKeyword(k,w) }
MONTH=k:"month"i w:WS? { return createNodeKeyword(k,w) }
NAME=k:"name"i w:WS? { return createNodeKeyword(k,w) }
NCHAR=k:"nchar"i w:WS? { return createNodeKeyword(k,w) }
NEED=k:"need"i w:WS? { return createNodeKeyword(k,w) }
NEXT=k:"next"i w:WS? { return createNodeKeyword(k,w) }
NO=k:"no"i w:WS? { return createNodeKeyword(k,w) }
NOENTRY=k:"noentry"i w:WS? { return createNodeKeyword(k,w) }
NORMAL=k:"normal"i w:WS? { return createNodeKeyword(k,w) }
NOT=k:"not"i w:WS? { return createNodeKeyword(k,w) }
NOTFOUND=k:"notfound"i w:WS? { return createNodeKeyword(k,w) }
NULL=k:"null"i w:WS? { return createNodeKeyword(k,w) }
NUMERIC=k:"numeric"i w:WS? { return createNodeKeyword(k,w) }
NVARCHAR=k:"nvarchar"i w:WS? { return createNodeKeyword(k,w) }
OF=k:"of"i w:WS? { return createNodeKeyword(k,w) }
OFF=k:"off"i w:WS? { return createNodeKeyword(k,w) }
ON=k:"on"i w:WS? { return createNodeKeyword(k,w) }
OPEN=k:"open"i w:WS? { return createNodeKeyword(k,w) }
OPTION=k:"option"i w:WS? { return createNodeKeyword(k,w) }
OPTIONS=k:"options"i w:WS? { return createNodeKeyword(k,w) }
OR=k:"or"i w:WS? { return createNodeKeyword(k,w) }
ORDER=k:"order"i w:WS? { return createNodeKeyword(k,w) }
OTHERWISE=k:"otherwise"i w:WS? { return createNodeKeyword(k,w) }
OUTER=k:"outer"i w:WS? { return createNodeKeyword(k,w) }
OUTPUT=k:"output"i w:WS? { return createNodeKeyword(k,w) }
PAGE=k:"page"i w:WS? { return createNodeKeyword(k,w) }
PAGENO=k:"pageno"i w:WS? { return createNodeKeyword(k,w) }
PIPE=k:"pipe"i w:WS? { return createNodeKeyword(k,w) }
PRECISION=k:"precision"i w:WS? { return createNodeKeyword(k,w) }
PREPARE=k:"prepare"i w:WS? { return createNodeKeyword(k,w) }
PREVIOUS=k:"previous"i w:WS? { return createNodeKeyword(k,w) }
PRIMARY=k:"primary"i w:WS? { return createNodeKeyword(k,w) }
PRINT=k:"print"i w:WS? { return createNodeKeyword(k,w) }
PROGRAM=k:"program"i w:WS? { return createNodeKeyword(k,w) }
PROMPT=k:"prompt"i w:WS? { return createNodeKeyword(k,w) }
PUT=k:"put"i w:WS? { return createNodeKeyword(k,w) }
QUIT=k:"quit"i w:WS? { return createNodeKeyword(k,w) }
READ=k:"read"i w:WS? { return createNodeKeyword(k,w) }
REAL=k:"real"i w:WS? { return createNodeKeyword(k,w) }
RECORD=k:"record"i w:WS? { return createNodeKeyword(k,w) }
RED=k:"red"i w:WS? { return createNodeKeyword(k,w) }
REPORT=k:"report"i w:WS? { return createNodeKeyword(k,w) }
RETURN=k:"return"i w:WS? { return createNodeKeyword(k,w) }
RETURNING=k:"returning"i w:WS? { return createNodeKeyword(k,w) }
REVERSE=k:"reverse"i w:WS? { return createNodeKeyword(k,w) }
RIGTH=k:"rigth"i w:WS? { return createNodeKeyword(k,w) }
ROLLBACK=k:"rollback"i w:WS? { return createNodeKeyword(k,w) }
ROW=k:"row"i w:WS? { return createNodeKeyword(k,w) }
ROWS=k:"rows"i w:WS? { return createNodeKeyword(k,w) }
RUN=k:"run"i w:WS? { return createNodeKeyword(k,w) }
SCREEN=k:"screen"i w:WS? { return createNodeKeyword(k,w) }
SCROLL=k:"scroll"i w:WS? { return createNodeKeyword(k,w) }
SECOND=k:"second"i w:WS? { return createNodeKeyword(k,w) }
SELECT=k:"select"i w:WS? { return createNodeKeyword(k,w) }
SET=k:"set"i w:WS? { return createNodeKeyword(k,w) }
SHARE=k:"share"i w:WS? { return createNodeKeyword(k,w) }
SHOW=k:"show"i w:WS? { return createNodeKeyword(k,w) }
SKIP=k:"skip"i w:WS? { return createNodeKeyword(k,w) }
SLEEP=k:"sleep"i w:WS? { return createNodeKeyword(k,w) }
SMALL=k:"small"i w:WS? { return createNodeKeyword(k,w) }
SMALLFLOAT=k:"smallfloat"i w:WS? { return createNodeKeyword(k,w) }
SMALLINT=k:"smallint"i w:WS? { return createNodeKeyword(k,w) }
SPACE=k:"space"i w:WS? { return createNodeKeyword(k,w) }
SPACES=k:"spaces"i w:WS? { return createNodeKeyword(k,w) }
SQL=k:"sql"i w:WS? { return createNodeKeyword(k,w) }
SQLERROR=k:"sqlerror"i w:WS? { return createNodeKeyword(k,w) }
SQLWARNING=k:"sqlwarning"i w:WS? { return createNodeKeyword(k,w) }
START=k:"start"i w:WS? { return createNodeKeyword(k,w) }
STEP=k:"step"i w:WS? { return createNodeKeyword(k,w) }
STOP=k:"stop"i w:WS? { return createNodeKeyword(k,w) }
STRING=k:"string"i w:WS? { return createNodeKeyword(k,w) }
SUM=k:"sum"i w:WS? { return createNodeKeyword(k,w) }
TABLE=k:"table"i w:WS? { return createNodeKeyword(k,w) }
TABLES=k:"tables"i w:WS? { return createNodeKeyword(k,w) }
TEMP=k:"temp"i w:WS? { return createNodeKeyword(k,w) }
TEXT=k:"text"i w:WS? { return createNodeKeyword(k,w) }
THEN=k:"then"i w:WS? { return createNodeKeyword(k,w) }
THROUGH=k:"through"i w:WS? { return createNodeKeyword(k,w) }
THRU=k:"thru"i w:WS? { return createNodeKeyword(k,w) }
TIME=k:"time"i w:WS? { return createNodeKeyword(k,w) }
TO=k:"to"i w:WS? { return createNodeKeyword(k,w) }
TODAY=k:"today"i w:WS? { return createNodeKeyword(k,w) }
TOP=k:"top"i w:WS? { return createNodeKeyword(k,w) }
TRAILER=k:"trailer"i w:WS? { return createNodeKeyword(k,w) }
TYPE=k:"type"i w:WS? { return createNodeKeyword(k,w) }
UNCONSTRAINED=k:"unconstrained"i w:WS? { return createNodeKeyword(k,w) }
UNDERLINE=k:"underline"i w:WS? { return createNodeKeyword(k,w) }
UNION=k:"union"i w:WS? { return createNodeKeyword(k,w) }
UNIQUE=k:"unique"i w:WS? { return createNodeKeyword(k,w) }
UNITS=k:"units"i w:WS? { return createNodeKeyword(k,w) }
UNLOAD=k:"unload"i w:WS? { return createNodeKeyword(k,w) }
UNLOCK=k:"unlock"i w:WS? { return createNodeKeyword(k,w) }
UP=k:"up"i w:WS? { return createNodeKeyword(k,w) }
UPDATE=k:"update"i w:WS? { return createNodeKeyword(k,w) }
UPSHIFT=k:"upshift"i w:WS? { return createNodeKeyword(k,w) }
USING=k:"using"i w:WS? { return createNodeKeyword(k,w) }
VALIDATE=k:"validate"i w:WS? { return createNodeKeyword(k,w) }
VALUES=k:"values"i w:WS? { return createNodeKeyword(k,w) }
VARCHAR=k:"varchar"i w:WS? { return createNodeKeyword(k,w) }
WAIT=k:"wait"i w:WS? { return createNodeKeyword(k,w) }
WAITING=k:"waiting"i w:WS? { return createNodeKeyword(k,w) }
WARNING=k:"warning"i w:WS? { return createNodeKeyword(k,w) }
WEEKDAY=k:"weekday"i w:WS? { return createNodeKeyword(k,w) }
WHEN=k:"when"i w:WS? { return createNodeKeyword(k,w) }
WHENEVER=k:"whenever"i w:WS? { return createNodeKeyword(k,w) }
WHERE=k:"where"i w:WS? { return createNodeKeyword(k,w) }
WHILE=k:"while"i w:WS? { return createNodeKeyword(k,w) }
WHITE=k:"white"i w:WS? { return createNodeKeyword(k,w) }
WINDOW=k:"window"i w:WS? { return createNodeKeyword(k,w) }
WITH=k:"with"i w:WS? { return createNodeKeyword(k,w) }
WITHOUT=k:"without"i w:WS? { return createNodeKeyword(k,w) }
WORDWRAP=k:"wordwrap"i w:WS? { return createNodeKeyword(k,w) }
WORK=k:"work"i w:WS? { return createNodeKeyword(k,w) }
WRAP=k:"wrap"i w:WS? { return createNodeKeyword(k,w) }
YEAR=k:"year"i w:WS? { return createNodeKeyword(k,w) }
YELLOW=k:"yellow"i w:WS? { return createNodeKeyword(k,w) }
