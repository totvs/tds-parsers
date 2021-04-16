// Gramática eleborada com base na documentação disponibilizada em
// https://tdn.totvs.com/display/tec/AdvPL

{

const ast = options.util.makeAST(location, options);
const astBlock = (_begin, _body, _end) => {
  const begin = ast("beginBlock").add(_begin);
  const body = ast("bodyBlock").add(_body || [] );
  const end = ast("endBlock").add(_end);

  if (end.location.end.line == -Infinity) {
    end.location.end = body.location.end;
  } 
  
  return ast("block").add(begin).add(body).add(end);
};

}

start_program
	= p1:superTokens?  { return ast("program").add(p1 || []) }

superTokens
  = l:arg_token+ p:superTokens+ { return l.concat(p); }
  / p:arg_token+ { return p; }
  / p:arg_token { return [p]; }

arg_token = superToken

superToken
  = WS_CONTINUE
  / NL
  / comment
  / functionBlock
  / directives
  / tokens

functionBlock
  = b:(scope? WS_CONTINUE? FUNCTION WS_CONTINUE identifer WS_CONTINUE? argumentList endLine)
      t:tokens*
    { return astBlock(b, t, []) }

scope
  = PYME
  / PROJECT  
  / TEMPLATE
  / WEB
  / HTML 
  / USER 
  / WEBUSER 

forBlock
  = b:(FOR) 
      t:tokens*
    e:(NEXT endLine)
    { return astBlock(b, t, e) }

ifBlock
  = b:(IF) 
      t:tokens*
    e:(ENDIF endLine)
    { return astBlock(b, t, e) }

/*
codeBlock
  = b:(O_BRACES WS_CONTINUE? PIPE)
      a:(arguments? WS_CONTINUE? PIPE)    
      t:tokens*
    e:(C_BRACES endLine)
    { return astBlock(b, t, e).add(ast("arguments").add(a || [])) }
*/

argumentList
  = o:(O_PARENTHESIS WS_CONTINUE?)
      a:arguments?
  c:C_PARENTHESIS 
  { return ast("argumentList").add(o).add(a || []).add(c) }  

arguments
  = l:arg_list+ p:arg_value+ { return l.concat(p); }
  / p:arg_list+ { return p; }
  / p:arg_value { return [p]; }

arg_value = WS_CONTINUE? identifer WS_CONTINUE?

arg_list = WS_CONTINUE? identifer WS_CONTINUE? COMMA WS_CONTINUE? 

tokens
  = WS_CONTINUE
  / NL
  / comment
  / forBlock
  / ifBlock
  // / codeBlock
  / directives
  / keywords
  / logicalOperators
  / operators
  / string
  / number
  / boolean
  / !scope fileIdentifer
  / !scope identifer

directives
  = p:POUND 
    d:(COMMAND 
      / DEFINE
      / TRANSLATE
      / XCOMMAND
      / XTRANSLATE
    )
    t:tokens+ 
    e:endLine?
    { return ast("directive", p, d, t, e) }
  / d:(POUND INCLUDE WS string endLine) { return ast("directive", d) }
  / b:(POUND (IFDEF / IFNDEF) WS ID endLine) 
      t:tokens*
    e:(POUND ENDIF endLine) 
    { return ast("directiveBlock", b).add(t).add(e) }      

// não esquecer de remover 'scope' da lista de keywords
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
  ) &(WS_CONTINUE / operators)
  { return k;}

logicalOperators
  = o:(
    DOT 'and'i DOT 
    / DOT 'or'i DOT 
    / DOT 'not'i DOT 
    / EXCLAMATION 
  ) { return ast("operatorLogical", o); }

operators
  = (
    ASSIGN
    / C_BRACES
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
    / PIPE
  )

comment
  = c:$(singleComment NL) { return ast("comment", c) }
  / c:$(MINUS MINUS POUND? (!NL .)* NL) { return ast("comment", c) }
  / c:$(SLASH ASTERISK $(!(ASTERISK SLASH) .)* (ASTERISK SLASH)) { return ast("blockComment", c) }

endLine
  = w:WS? c:singleComment? n:NL
      { return ast("endLine", [w, c, n]) }

singleComment
  = c:$(SLASH SLASH $(!NL .)*) { return ast("singleComment", c) }

string
  = s:$(double_quoted_string / single_quoted_string) {
      return ast("string", s);
    }

double_quoted_string = $(D_QUOTE (!D_QUOTE (.))* D_QUOTE)

single_quoted_string = $(S_QUOTE (!S_QUOTE (.))* S_QUOTE)

number
  = n:$([-+]? DIGIT+ (DOT DIGIT+)?) 
  { return ast("number", n); }

boolean
  = b:$(DOT [TtFfYyNn] DOT) 
  { return ast("boolean", b); }

WS
  = s:$([ \t])+
  { return ast("whiteSpace", s) }

NL 
  = s:$("\n" / "\r" / "\r\n")+
  { return ast("newLine", s) }

WS_CONTINUE
  = WS
  / s:SEMI_COLON+ { return ast("continueLine", s) }

DIGIT = [0-9]

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';
SEMI_COLON = ';';

identifer
  = i:$(COLON COLON ID) { return ast("identifier", i) }
  / i:ID { return ast("identifier", i) }

fileIdentifer
  = i:$(ID DOT ID) { return ast("identifier", i) }

ID = $(
      ([a-zA-Z_] [a-zA-Z_0-9]*) 
      (COLON ([a-zA-Z_] [a-zA-Z_0-9]*))*
    )

POUND = o:"#" { return ast("operator", o) }
AT_SIGN = o:"@" { return ast("operator", o) }
EXCLAMATION = o:"!" { return ast("operator", o) }
COLON = o:":" { return ast("operator", o) }
PIPE = o:"|" { return ast("operator", o) }

O_BRACES=o:"{" { return ast("operatorBraces", o) }
C_BRACES=o:"}" { return ast("operatorBraces", o) }
O_BRACKET=o:"[" { return ast("operatorBracket", o) }
C_BRACKET=o:"]" { return ast("operatorBracket", o) }
O_PARENTHESIS=o:"(" { return ast("operatorParenthesis", o) }
C_PARENTHESIS=o:")" { return ast("operatorParenthesis", o) }

COMMA=o:"," { return ast("operatorSeparator", o) }

ASSIGN=o:":=" { return ast("operatorAssign", o) }

ASTERISK=o:"*" { return ast("operatorMath", o) }
EQUAL=o:"="  { return ast("operatorMath", o) }
LESS=o:"<" { return ast("operatorMath", o) }
GREATER=o:">" { return ast("operatorMath", o) }
PLUS=o:"+" { return ast("operatorMath", o) }
MINUS=o:"-" { return ast("operatorMath", o) }
SLASH=o:"/" { return ast("operatorMath", o) }

COMMAND     = d:'command'i { return ast("keyword", d)}
DEFINE      = d:'define 'i { return ast("keyword", d)}
INCLUDE     = d:'include'i { return ast("keyword", d)}
TRANSLATE   = d:'translate'i { return ast("keyword", d)}
XCOMMAND    = d:'xcommand'i { return ast("keyword", d)}
XTRANSLATE  = d:'xtranslate'i { return ast("keyword", d)}
IFDEF = d:'ifdef'i { return ast("keyword", d)}
IFNDEF= d:'ifndef'i { return ast("keyword", d)}

//para gerar a lista de tokens das palavras chaves, execute:
// 
ALIAS
  = k:(
   'alias'i
  / 'alia'i
  )  { return ast('keyword', k).setAttribute('command', 'alias') }


ANNOUNCE
  = k:(
   'announce'i
  / 'announc'i
  / 'announ'i
  / 'annou'i
  / 'anno'i
  )  { return ast('keyword', k).setAttribute('command', 'announce') }


AS
  = k:'as'i { return ast('keyword', k) }


BEGIN
  = k:(
   'begin'i
  / 'begi'i
  )  { return ast('keyword', k).setAttribute('command', 'begin') }


BEGINSQL
  = k:(
   'beginsql'i
  / 'beginsq'i
  / 'begins'i
  / 'begin'i
  / 'begi'i
  )  { return ast('keyword', k).setAttribute('command', 'beginsql') }


BREAK
  = k:(
   'break'i
  / 'brea'i
  )  { return ast('keyword', k).setAttribute('command', 'break') }


CASE
  = k:'case'i { return ast('keyword', k) }


CATCH
  = k:(
   'catch'i
  / 'catc'i
  )  { return ast('keyword', k).setAttribute('command', 'catch') }


COLUMN
  = k:(
   'column'i
  / 'colum'i
  / 'colu'i
  )  { return ast('keyword', k).setAttribute('command', 'column') }


DATE
  = k:'date'i { return ast('keyword', k) }


DECLARE
  = k:(
   'declare'i
  / 'declar'i
  / 'decla'i
  / 'decl'i
  )  { return ast('keyword', k).setAttribute('command', 'declare') }


DO
  = k:'do'i { return ast('keyword', k) }


ELSE
  = k:'else'i { return ast('keyword', k) }


ELSEIF
  = k:(
   'elseif'i
  / 'elsei'i
  / 'else'i
  )  { return ast('keyword', k).setAttribute('command', 'elseif') }


ENDCASE
  = k:(
   'endcase'i
  / 'endcas'i
  / 'endca'i
  / 'endc'i
  )  { return ast('keyword', k).setAttribute('command', 'endcase') }


ENDDO
  = k:(
   'enddo'i
  / 'endd'i
  )  { return ast('keyword', k).setAttribute('command', 'enddo') }


ENDIF
  = k:(
   'endif'i
  / 'endi'i
  )  { return ast('keyword', k).setAttribute('command', 'endif') }


ENDSQL
  = k:(
   'endsql'i
  / 'endsq'i
  / 'ends'i
  )  { return ast('keyword', k).setAttribute('command', 'endsql') }


EXIT
  = k:'exit'i { return ast('keyword', k) }


EXTERNAL
  = k:(
   'external'i
  / 'externa'i
  / 'extern'i
  / 'exter'i
  / 'exte'i
  )  { return ast('keyword', k).setAttribute('command', 'external') }


FIELD
  = k:(
   'field'i
  / 'fiel'i
  )  { return ast('keyword', k).setAttribute('command', 'field') }


FOR
  = k:'for'i { return ast('keyword', k) }


FUNCTION
  = k:(
   'function'i
  / 'functio'i
  / 'functi'i
  / 'funct'i
  / 'func'i
  )  { return ast('keyword', k).setAttribute('command', 'function') }


IF
  = k:'if'i { return ast('keyword', k) }


IIF
  = k:'iif'i { return ast('keyword', k) }


IN
  = k:'in'i { return ast('keyword', k) }


LOCAL
  = k:(
   'local'i
  / 'loca'i
  )  { return ast('keyword', k).setAttribute('command', 'local') }


LOGICAL
  = k:(
   'logical'i
  / 'logica'i
  / 'logic'i
  / 'logi'i
  )  { return ast('keyword', k).setAttribute('command', 'logical') }


LOOP
  = k:'loop'i { return ast('keyword', k) }


MAIN
  = k:'main'i { return ast('keyword', k) }


MEMVAR
  = k:(
   'memvar'i
  / 'memva'i
  / 'memv'i
  )  { return ast('keyword', k).setAttribute('command', 'memvar') }


METHOD
  = k:(
   'method'i
  / 'metho'i
  / 'meth'i
  )  { return ast('keyword', k).setAttribute('command', 'method') }


NEXT
  = k:'next'i { return ast('keyword', k) }


NIL
  = k:'nil'i { return ast('keyword', k) }


NUMERIC
  = k:(
   'numeric'i
  / 'numeri'i
  / 'numer'i
  / 'nume'i
  )  { return ast('keyword', k).setAttribute('command', 'numeric') }


OTHERWISE
  = k:(
   'otherwise'i
  / 'otherwis'i
  / 'otherwi'i
  / 'otherw'i
  / 'other'i
  / 'othe'i
  )  { return ast('keyword', k).setAttribute('command', 'otherwise') }


PRIVATE
  = k:(
   'private'i
  / 'privat'i
  / 'priva'i
  / 'priv'i
  )  { return ast('keyword', k).setAttribute('command', 'private') }


PROCEDURE
  = k:(
   'procedure'i
  / 'procedur'i
  / 'procedu'i
  / 'proced'i
  / 'proce'i
  / 'proc'i
  )  { return ast('keyword', k).setAttribute('command', 'procedure') }


PUBLIC
  = k:(
   'public'i
  / 'publi'i
  / 'publ'i
  )  { return ast('keyword', k).setAttribute('command', 'public') }


RECOVER
  = k:(
   'recover'i
  / 'recove'i
  / 'recov'i
  / 'reco'i
  )  { return ast('keyword', k).setAttribute('command', 'recover') }


RETURN
  = k:(
   'return'i
  / 'retur'i
  / 'retu'i
  )  { return ast('keyword', k).setAttribute('command', 'return') }


SEQUENCE
  = k:(
   'sequence'i
  / 'sequenc'i
  / 'sequen'i
  / 'seque'i
  / 'sequ'i
  )  { return ast('keyword', k).setAttribute('command', 'sequence') }


STATIC
  = k:(
   'static'i
  / 'stati'i
  / 'stat'i
  )  { return ast('keyword', k).setAttribute('command', 'static') }


STEP
  = k:'step'i { return ast('keyword', k) }


THROW
  = k:(
   'throw'i
  / 'thro'i
  )  { return ast('keyword', k).setAttribute('command', 'throw') }


TO
  = k:'to'i { return ast('keyword', k) }


TRY
  = k:'try'i { return ast('keyword', k) }


USING
  = k:(
   'using'i
  / 'usin'i
  )  { return ast('keyword', k).setAttribute('command', 'using') }


WHILE
  = k:(
   'while'i
  / 'whil'i
  )  { return ast('keyword', k).setAttribute('command', 'while') }


WITH
  = k:'with'i { return ast('keyword', k) }


_FIELD
  = k:(
   '_field'i
  / '_fiel'i
  / '_fie'i
  )  { return ast('keyword', k).setAttribute('command', '_field') }


PYME
  = k:'pyme'i { return ast('keyword', k) }


PROJECT
  = k:(
   'project'i
  / 'projec'i
  / 'proje'i
  / 'proj'i
  )  { return ast('keyword', k).setAttribute('command', 'project') }


TEMPLATE
  = k:(
   'template'i
  / 'templat'i
  / 'templa'i
  / 'templ'i
  / 'temp'i
  )  { return ast('keyword', k).setAttribute('command', 'template') }


WEB
  = k:'web'i { return ast('keyword', k) }


HTML
  = k:'html'i { return ast('keyword', k) }


USER
  = k:'user'i { return ast('keyword', k) }


WEBUSER
  = k:(
   'webuser'i
  / 'webuse'i
  / 'webus'i
  / 'webu'i
  )  { return ast('keyword', k).setAttribute('command', 'webuser') }
