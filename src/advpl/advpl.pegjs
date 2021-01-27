// Gramática eleborada com base na análise de arquivos de configuração
// tmLan
{

const unroll = options.util.makeUnroll(location, options);
const ast    = options.util.makeAST   (location, options);

}

start
	= t:token* 
	{ return ast("program").set("value", t) }

token 
	= comments
  / WS? keywords WS
  / operators
  / separators
  / string
  / number
  / ID
  / WS
  / NL
  / o:$(!WS .)+ { return ast("notSpecified").set("code", o) }

keywords
	= k:(
    "define"i
    / "endif"i
    / "else"i
    / "ifdef"i
    / "ifndef"i
    / "include"i
    / "xcommand"i
    / "xtranslate"i
    / "activate"i
    / "alias"i
    / "and"i
    / "beginsql"i
    / "between"i
    / "case"i
    / "centered"i
    / "class"i
    / "constructor"i
    / "data"i
    / "define"i
    / "dialog"i
    / "do"i
    / "else"i
    / "elseif"i
    / "end"i
    / "endcase"i
    / "endclass"i
    / "enddo"i
    / "endfunction"i
    / "endif"i
    / "endsql"i
    / "exit"i
    / "for"i
    / "from"i
    / "function"i
    / "get"i
    / "if"i
    / "loop"i
    / "main"i
    / "method"i
    / "next"i
    / "nil"i
    / "of"i
    / "or"i
    / "otherwise"i
    / "pixel"i
    / "return"i
    / "select"i
    / "to"i
    / "user"i
    / "var"i
    / "while"i
    / "where"i
    / "local"i
    / "static"i
    / "private"i
    / "public"i
    / "default"i
    / "as"i
    / "array"i
    / "block"i
    / "codeblock"i
    / "character"i
    / "char"i
    / "date"i
    / "logical"i
    / "numeric"i
    / "object"i
	) { return ast("keyword").set("value", k) }

comments
	= c:(
		$('//' (!NL .)* NL)
		/ $(('/*' (!('*/')) .)* ('*/'))
	) { return ast("comment").set("value", c) }

string
	= s:$(
    double_quoted_string 
    / single_quoted_string
  ) { return ast("string").set("value", s) }

double_quoted_string 
	= $(D_QUOTE (!D_QUOTE .)* D_QUOTE)

single_quoted_string 
	= $(S_QUOTE (!S_QUOTE .)* S_QUOTE)

number
	= n:(
		$(DIGIT+ [lL])
		/ $([-+]? DIGIT+ (DOT DIGIT+)? ([eE][+-]?[0-9]+)?)
		/ $('0' [xX] [0-9a-fA-F]+)
		/ $('0' [oO] [0-7]+)
		/ $('0' [bB] [01]+)
	) { return ast("number").set("value", n) }

objectVariable 
	= o1:$((':' ':')? ID) o2:$(':' ID)* 
	{ return ast("objectVariable").add(unroll(o1, o2)) }

D_QUOTE = '\"';
S_QUOTE = '\'';
DOT = '\.';
DIGIT = [0-9]

ID = 
	id:($([a-zA-Z_] [a-zA-Z_0-9]*)) 
	{ return ast("identifier").set("value", id) }

operators
	= o: (
		"\.t\."i
		/ "\.f\."i
		/ "true"i
		/ "false"i
		/ "\.and\."i
		/ "\.or\."i
		/ ":="
		/ "*="
		/ "<"
		/ "!"
		/ "("
		/ ")"
		/ "="
		/ "#"
		/ "%="
		/ "+="
		/ "-="
		/ "=="
		/ "!="
		/ "<="
		/ ">="
		/ "<>"             
		/ "<"
		/ ">"
		/ "++"
		/ "--"
		/ "%"
		/ "*"
		/ "/ "
		/ "+"
		/ "-"
  / "{"
  / "}"
  / "["
  / "]"
  / "("
  / ")"
	)  { ast("operator").set("value", o) }

separators
	= s:[,;]
	{ ast("separator").set("value", s) }

WS
	= ws:$([ \t])+ 
	{ return ast("whiteSpace").set("value", ws) }

NL
	= nl:$("\n" / "\r" / "\r\n")+
	{ return ast("newLine").set("value", nl) }
