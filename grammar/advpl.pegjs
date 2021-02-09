// Gramática eleborada com base na análise de arquivos de configuração
// tmLan
{

const ast    = options.util.makeAST   (location, options);

}

start_program
	= p1:superToken? p2:superToken*  { return ast("program").add(p1, p2) }

superToken
  = comment
  / functionBlock
  / WS_NL_CONTINUE+
  / o:$(!WS .)+ { return ast("notSpecified", o) }

functionBlock
  = b:((scope WS_NL_CONTINUE)? FUNCTION WS_NL_CONTINUE ID WS_NL_CONTINUE? argumentList WS_NL_CONTINUE)
      t:tokens*
    &(functionBlock)?
    { return ast("block").add(b, t) }

scope
  = PYME
  / PROJECT  
  / TEMPLATE
  / WEB
  / HTML 
  / USER 
  / WEBUSER 

argumentList
  = o:O_PARENTHESIS WS_NL_CONTINUE?
      ids:(ID (WS_NL_CONTINUE? COMMA WS_NL_CONTINUE? ID WS_NL_CONTINUE?)*)?
  c:C_PARENTHESIS 
  { return ast("argumentList").add(o, ids || [], c) }  

tokens 
	= WS_NL_CONTINUE
  / keywords
  / operators
  / string
  / number
  / ID
  / o:$(!WS .)+ { return ast("notSpecified", o) }

keywords
	= k:(
    ALIAS
    / ANNOUNCE
    / AS
    / BEGIN
    / BEGINSQL
    / BREAK
    / CASE
    / CATCH
    / COLUMN
    / DATE
    / DECLARE
    / DO
    / ELSE
    / ELSEIF
    / ENDCASE
    / ENDDO
    / ENDIF
    / ENDSQL
    / EXIT
    / EXTERNAL
    / FIELD
    / FOR
    / FUNCTION
    / IF
    / IIF
    / IN
    / LOCAL
    / LOGICAL
    / LOOP
    / MAIN
    / MEMVAR
    / METHOD
    / NEXT
    / NIL
    / NUMERIC
    / OTHERWISE
    / PRIVATE
    / PROCEDURE
    / PUBLIC
    / RECOVER
    / RETURN
    / SEQUENCE
    / STATIC
    / STEP
    / THROW
    / TO
    / TRY
    / USING
    / WHILE
    / WITH
    / _FIELD
    / PYME
    / PROJECT
    / TEMPLATE
    / WEB
    / HTML
    / USER
    / WEBUSER
	) &(WS_NL_CONTINUE / operators)
  { return k }

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
  )

comment
  = c:$(SLASH SLASH (!NL .)* NL) { return ast("comment", c) }
  / c:$(SLASH ASTERISK $(!(ASTERISK SLASH) .)* ASTERISK SLASH) { return ast("comment", c) }

sqlExpression
  = s:$(PERCENT 'NOPARSER'i PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'NOTDEL'i PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'EXP:'i (!PERCENT .)+ PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'ORDER:'i (!PERCENT .)+ PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'TABLE:'i (!PERCENT .)+ PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'TEMP-TABLE:'i (!PERCENT .)+ PERCENT) { ast('sqlExpression', s) }
  / s:$(PERCENT 'XFILIAL:'i (!PERCENT .)+ PERCENT) { ast('sqlExpression', s) }

string
  = s:$(double_quoted_string / single_quoted_string) 
  { return ast("string", s); }

double_quoted_string = $(D_QUOTE (!D_QUOTE .)* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE .)* S_QUOTE)

number
	= n:$(DIGIT+ [lL]) { return ast("number", n).set("subtype", "long") }
  / n:$([-+]? DIGIT+ (DOT DIGIT+)? ([eE][+-]?[0-9]+)?) { return ast("number", n).set("subtype", "complex") }
  / n:$('0' [xX] [0-9a-fA-F]+) { return ast("number", n).set("subtype", "hex") }
  / n:$('0' [oO] [0-7]+) { return ast("number", n).set("subtype", "octal") }
  / n:$('0' [bB] [01]+) { return ast("number", n).set("subtype", "binary") }

WS
  = s:$[ \t]
  { return ast("whiteSpace", s) }

NL 
  = s:$("\n" / "\r" / "\r\n")
  { return ast("newLine", s) }

WS_NL_CONTINUE
  = (WS / NL / SEMICOLON)

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';
DIGIT = [0-9]
SEMICOLON = ';'

ID
  = SINGLE_ID 
  / OBJECT_ID 

SINGLE_ID
  = id:$([a-zA-Z_] [a-zA-Z_0-9]*)
	  { return ast("identifier", id) }

OBJECT_ID
  = o1:$((COLON COLON)? SINGLE_ID) o2:$(COLON SINGLE_ID)*
	  { return ast("objectVariable").add(o1, o2) }

TRUE=c:"\.t\."i { return ast("constant", c) }
FALSE=c:"\.f\."i { return ast("constant", c) }

POUND = o:"#" { return ast("operator", o) }
AT_SIGN = o:"@" { return ast("operator", o) }
EXCLAMATION=o:"!" { return ast("operator", o) }
COLON=o:":" { return ast("operator", o) }

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
PERCENT=o:"%" { return ast("operator", o) }

ALIAS
  = k:(
    'alia'i
  / 'alias'i
  )  { k.set('command', 'alias'); return ast('keyword', k) }


ANNOUNCE
  = k:(
    'anno'i
  / 'annou'i
  / 'announ'i
  / 'announc'i
  / 'announce'i
  )  { k.set('command', 'announce'); return ast('keyword', k) }


AS
  = k:'as'i { k.set('command', 'as'); return ast('keyword', k) }


BEGIN
  = k:(
    'begi'i
  / 'begin'i
  )  { k.set('command', 'begin'); return ast('keyword', k) }


BEGINSQL
  = k:(
    'begi'i
  / 'begin'i
  / 'begins'i
  / 'beginsq'i
  / 'beginsql'i
  )  { k.set('command', 'beginsql'); return ast('keyword', k) }


BREAK
  = k:(
    'brea'i
  / 'break'i
  )  { k.set('command', 'break'); return ast('keyword', k) }


CASE
  = k:'case'i { k.set('command', 'case'); return ast('keyword', k) }


CATCH
  = k:(
    'catc'i
  / 'catch'i
  )  { k.set('command', 'catch'); return ast('keyword', k) }


COLUMN
  = k:(
    'colu'i
  / 'colum'i
  / 'column'i
  )  { k.set('command', 'column'); return ast('keyword', k) }


DATE
  = k:'date'i { k.set('command', 'date'); return ast('keyword', k) }


DECLARE
  = k:(
    'decl'i
  / 'decla'i
  / 'declar'i
  / 'declare'i
  )  { k.set('command', 'declare'); return ast('keyword', k) }


DO
  = k:'do'i { k.set('command', 'do'); return ast('keyword', k) }


ELSE
  = k:'else'i { k.set('command', 'else'); return ast('keyword', k) }


ELSEIF
  = k:(
    'else'i
  / 'elsei'i
  / 'elseif'i
  )  { k.set('command', 'elseif'); return ast('keyword', k) }


ENDCASE
  = k:(
    'endc'i
  / 'endca'i
  / 'endcas'i
  / 'endcase'i
  )  { k.set('command', 'endcase'); return ast('keyword', k) }


ENDDO
  = k:(
    'endd'i
  / 'enddo'i
  )  { k.set('command', 'enddo'); return ast('keyword', k) }


ENDIF
  = k:(
    'endi'i
  / 'endif'i
  )  { k.set('command', 'endif'); return ast('keyword', k) }


ENDSQL
  = k:(
    'ends'i
  / 'endsq'i
  / 'endsql'i
  )  { k.set('command', 'endsql'); return ast('keyword', k) }


EXIT
  = k:'exit'i { k.set('command', 'exit'); return ast('keyword', k) }


EXTERNAL
  = k:(
    'exte'i
  / 'exter'i
  / 'extern'i
  / 'externa'i
  / 'external'i
  )  { k.set('command', 'external'); return ast('keyword', k) }


FIELD
  = k:(
    'fiel'i
  / 'field'i
  )  { k.set('command', 'field'); return ast('keyword', k) }


FOR
  = k:'for'i { k.set('command', 'for'); return ast('keyword', k) }


FUNCTION
  = k:(
    'func'i
  / 'funct'i
  / 'functi'i
  / 'functio'i
  / 'function'i
  )  { k.set('command', 'function'); return ast('keyword', k) }


IF
  = k:'if'i { k.set('command', 'if'); return ast('keyword', k) }


IIF
  = k:'iif'i { k.set('command', 'iif'); return ast('keyword', k) }


IN
  = k:'in'i { k.set('command', 'in'); return ast('keyword', k) }


LOCAL
  = k:(
    'loca'i
  / 'local'i
  )  { k.set('command', 'local'); return ast('keyword', k) }


LOGICAL
  = k:(
    'logi'i
  / 'logic'i
  / 'logica'i
  / 'logical'i
  )  { k.set('command', 'logical'); return ast('keyword', k) }


LOOP
  = k:'loop'i { k.set('command', 'loop'); return ast('keyword', k) }


MAIN
  = k:'main'i { k.set('command', 'main'); return ast('keyword', k) }


MEMVAR
  = k:(
    'memv'i
  / 'memva'i
  / 'memvar'i
  )  { k.set('command', 'memvar'); return ast('keyword', k) }


METHOD
  = k:(
    'meth'i
  / 'metho'i
  / 'method'i
  )  { k.set('command', 'method'); return ast('keyword', k) }


NEXT
  = k:'next'i { k.set('command', 'next'); return ast('keyword', k) }


NIL
  = k:'nil'i { k.set('command', 'nil'); return ast('keyword', k) }


NUMERIC
  = k:(
    'nume'i
  / 'numer'i
  / 'numeri'i
  / 'numeric'i
  )  { k.set('command', 'numeric'); return ast('keyword', k) }


OTHERWISE
  = k:(
    'othe'i
  / 'other'i
  / 'otherw'i
  / 'otherwi'i
  / 'otherwis'i
  / 'otherwise'i
  )  { k.set('command', 'otherwise'); return ast('keyword', k) }


PRIVATE
  = k:(
    'priv'i
  / 'priva'i
  / 'privat'i
  / 'private'i
  )  { k.set('command', 'private'); return ast('keyword', k) }


PROCEDURE
  = k:(
    'proc'i
  / 'proce'i
  / 'proced'i
  / 'procedu'i
  / 'procedur'i
  / 'procedure'i
  )  { k.set('command', 'procedure'); return ast('keyword', k) }


PUBLIC
  = k:(
    'publ'i
  / 'publi'i
  / 'public'i
  )  { k.set('command', 'public'); return ast('keyword', k) }


RECOVER
  = k:(
    'reco'i
  / 'recov'i
  / 'recove'i
  / 'recover'i
  )  { k.set('command', 'recover'); return ast('keyword', k) }


RETURN
  = k:(
    'retu'i
  / 'retur'i
  / 'return'i
  )  { k.set('command', 'return'); return ast('keyword', k) }


SEQUENCE
  = k:(
    'sequ'i
  / 'seque'i
  / 'sequen'i
  / 'sequenc'i
  / 'sequence'i
  )  { k.set('command', 'sequence'); return ast('keyword', k) }


STATIC
  = k:(
    'stat'i
  / 'stati'i
  / 'static'i
  )  { k.set('command', 'static'); return ast('keyword', k) }


STEP
  = k:'step'i { k.set('command', 'step'); return ast('keyword', k) }


THROW
  = k:(
    'thro'i
  / 'throw'i
  )  { k.set('command', 'throw'); return ast('keyword', k) }


TO
  = k:'to'i { k.set('command', 'to'); return ast('keyword', k) }


TRY
  = k:'try'i { k.set('command', 'try'); return ast('keyword', k) }


USING
  = k:(
    'usin'i
  / 'using'i
  )  { k.set('command', 'using'); return ast('keyword', k) }


WHILE
  = k:(
    'whil'i
  / 'while'i
  )  { k.set('command', 'while'); return ast('keyword', k) }


WITH
  = k:'with'i { k.set('command', 'with'); return ast('keyword', k) }


_FIELD
  = k:(
    '_fie'i
  / '_fiel'i
  / '_field'i
  )  { k.set('command', '_field'); return ast('keyword', k) }


PYME
  = k:'pyme'i { k.set('command', 'pyme'); return ast('keyword', k) }


PROJECT
  = k:(
    'proj'i
  / 'proje'i
  / 'projec'i
  / 'project'i
  )  { k.set('command', 'project'); return ast('keyword', k) }


TEMPLATE
  = k:(
    'temp'i
  / 'templ'i
  / 'templa'i
  / 'templat'i
  / 'template'i
  )  { k.set('command', 'template'); return ast('keyword', k) }


WEB
  = k:'web'i { k.set('command', 'web'); return ast('keyword', k) }


HTML
  = k:'html'i { k.set('command', 'html'); return ast('keyword', k) }


USER
  = k:'user'i { k.set('command', 'user'); return ast('keyword', k) }


WEBUSER
  = k:(
    'webu'i
  / 'webus'i
  / 'webuse'i
  / 'webuser'i
  )  { k.set('command', 'webuser'); return ast('keyword', k) }


