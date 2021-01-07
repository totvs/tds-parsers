/**
 * Copyright 2014 - TOTVS S/A - All Rights Reserved
 *
 * Grammar for advpl source-file. 
 *
 * @author Eriky Raggeoto Kashivagui
 * @version 3.0
 *
 */
parser grammar PerGrammar;

 options{
 	tokenVocab = PerLexer;
 }

 @parser::header {  
package br.com.totvs.tds.sdk.fourgl.per.parser;

import java.util.*;
}

//start 
 //  : NEWLINE* (
 //  		(protheusDoc4GL  (NEWLINE* | EOF) ) |
 //  		(databaseDeclaration | screenDeclaration |  tablesDeclaration  | attributesDeclaration | instructionsDeclaration | endBlock | (.)*? ) NEWLINE+
 //    )* EOF
 //  ;

 /* 
 * Alteração na definição principal para correção do Bug: TDSKEPPLER-1450 
 */
 start
 :
 	NEWLINE*
 	(
 		(
 			protheusDoc4GL
 			| databaseDeclaration
 			| screenDeclaration
 			| tablesDeclaration
 			| attributesDeclaration
 			| instructionsDeclaration
 			| endBlock 
 			
 		)*
 		(
 			.
 		)*? NEWLINE+
 	)* EOF
 ;

 endBlock
 :
 	END
 ;

 databaseDeclaration
 :
 	DATABASE NEWLINE* IDENTIFICATION
 ;

 screenDeclaration
 :
 	SCREEN
 ;

 tablesDeclaration
 :
 	TABLES NEWLINE+ IDENTIFICATION
 	(
 		NEWLINE* COMMA NEWLINE* IDENTIFICATION
 	)*
 ;

 attributesDeclaration
 locals [ Map<Token, Token> attributes ]
 @init { $attributes = new HashMap<Token, Token>();  }
 :
 	ATTRIBUTES
 	(
 		NEWLINE+ attributeId = IDENTIFICATION EQUAL attributeValue =
 		IDENTIFICATION_TABLES ~( SEMICOLON )* SEMICOLON
 		{  $attributes.put($attributeId, $attributeValue); }

 	)*
 ;

 variableType
 :
 	SMALLINT
 	| INTEGER
 	| DECIMAL
 	| CHAR
 	| DATE
 	| DATETIME
 	(
 		NEWLINE* variableDate NEWLINE* TO NEWLINE* variableDate
 	)?
 ;

 variableDate
 :
 	YEAR
 	| MONTH
 	| DAY
 	| HOUR
 	| MINUTE
 	| SECOND
 	|
 	(
 		FRACTION
 		(
 			LPAREN INTEGER_NUMBERS RPAREN
 		)?
 	)
 ;

 instructionsDeclaration
 locals [ Map<Token, String> declaredVariables ]
 @init { $declaredVariables = new LinkedHashMap<Token, String>();  }
 :
 	INSTRUCTIONS
 	(
 		NEWLINE*
 		(
 			DELIMITERS a = STRING_LITERAL
 			| SCREEN RECORD b = IDENTIFICATION anything
 		)
 		{ 	String variableType = null;
  			if( $a != null ){  variableType = "DELIMITERS"; $declaredVariables.put( $a, variableType );
  			} else if ( $b != null ) { variableType = "SCREEN RECORD"; $declaredVariables.put( $b, variableType );  }
  			 
  		}

 	)*
 ;

// commentBlock
// :
// 	(
// 		MULTILINE_COMMENT_START
// 		| MULTILINE_COMMENT_START
// 	) ~( MULTILINE_COMMENT_END )+ MULTILINE_COMMENT_END
// ;

 anything
 :
 	~( NEWLINE )+
 ;

 protheusDoc4GL
 :
 	PROTHEUS_DOC_START_4GL PDOC_ID? PDOC_NEWLINE+
 	(
 		proDocBaseDescription
 	)?
 	(
 		proDocElementsOrErrors
 	)* PROTHEUS_DOC_END_4GL
 ;

 //////////////////////////////////////////////////////////////////////////////////////
 // Alteracoes realizadas nas regras do Pdoc devem ser replicadas para as gramaticas
 // AdvPL, 4GL e PER
 //////////////////////////////////////////////////////////////////////////////////////

 //////////////////////////////////////////////////////
 // PROTHEUSDOC

 proDocElementsOrErrors
 :
 	(
 		proDocElements PDOC_NEWLINE*
 	) # expectedStatement
 	| multiLineValue # unexpectedStatement
 ;

 proDocElements
 :
 	(
 		proDocAuthor
 		| proDocAccessLevel
 		| proDocBuild
 		| proDocChildren
 		| proDocCountry
 		| proDocDatabase
 		| proDocParam
 		| proDocDescription
 		| proDocDeprecated
 		| proDocExample
 		| proDocLanguage
 		| proDocLink
 		| proDocObs
 		| proDocParents
 		| proDocProtected
 		| proDocReturn
 		| proDocSystemOper
 		| proDocSee
 		| proDocSince
 		| proDocTable
 		| proDocTodo
 		| proDocVersion
 		| proDocType
 		| proDocPropType
 		| proDocDefValue
 		| proDocReadOnly
 		| proDocSource
 		| proDocHistory
 		| proDocProject
 		| proDocOwner
 		| proDocMenu
 		| proDocIssue
 		| proDocUnknown //obrigatório ser o último
 	)
 ;

 proDocBaseDescription
 :
 	multiLineValue
 ;

 proDocAuthor
 :
 	AT_AUTHOR expPdocValue?
 ;

 proDocAccessLevel
 :
 	AT_ACCESSLEVEL expPdocValue?
 ;

 proDocBuild
 :
 	AT_BUILD expPdocValue?
 ;

 proDocChildren
 :
 	AT_CHILDREN multiLineValue?
 ;

 proDocCountry
 :
 	AT_COUNTRY expPdocValue?
 ;

 proDocDatabase
 :
 	AT_DATABASE expPdocValue?
 ;

 proDocParam
 :
 	AT_PARAM multiLineValue?
 ;

 proDocDescription
 :
 	AT_DESCRIPTION multiLineValue?
 ;

 proDocDeprecated
 :
 	AT_DEPRECATED expPdocValue?
 ;

 proDocExample
 :
 	(
 		AT_EXAMPLE
 		| AT_SAMPLE
 	) multiLineValue?
 ;

 proDocLanguage
 :
 	AT_LANGUAGE expPdocValue?
 ;

 proDocLink
 :
 	AT_LINK expPdocValue?
 ;

 proDocObs
 :
 	AT_OBS multiLineValue?
 ;

 proDocParents
 :
 	AT_PARENTS multiLineValue?
 ;

 proDocProtected
 :
 	AT_PROTECTED expPdocValue?
 ;

 proDocReturn
 :
 	AT_RETURN PDOC_ID? expPdocValue?
 ;

 proDocSystemOper
 :
 	AT_SYSTEMOPER expPdocValue?
 ;

 proDocSee
 :
 	AT_SEE multiLineValue?
 ;

 proDocSince
 :
 	AT_SINCE expPdocValue?
 ;

 proDocTable
 :
 	AT_TABLE
 	(
 		(
 			PDOC_ID
 			(
 				PDOC_NEWLINE? PDOC_COMMA PDOC_NEWLINE? PDOC_ID
 			)*
 		)
 		| expPdocValue
 	)?
 ;

 proDocTodo
 :
 	AT_TODO multiLineValue?
 ;

 proDocVersion
 :
 	AT_VERSION expPdocValue?
 ;

 proDocType
 :
 	AT_TYPE expPdocValue?
 ;

 proDocPropType
 :
 	AT_PROPTYPE expPdocValue?
 ;

 proDocDefValue
 :
 	AT_DEFVALUE expPdocValue?
 ;

 proDocReadOnly
 :
 	AT_READONLY expPdocValue?
 ;

 proDocSource
 :
 	AT_SOURCE expPdocValue?
 ;

 proDocHistory
 :
 	AT_HISTORY expPdocValue?
 ;

 proDocProject
 :
 	AT_PROJECT expPdocValue?
 ;

proDocOwner
 :
 	AT_OWNER expPdocValue?
 ;

proDocMenu
 :
 	AT_MENU expPdocValue?
 ;

proDocIssue
 :
 	AT_ISSUE expPdocValue?
 ;
 
proDocUnknown
 :
 	AT_UNKNOWN expPdocValue?
 ;

 expPdocValue
 :
 	~( PDOC_NEWLINE )+
 ;

 //Caso encontre o inicio de uma propriedade, ele deve para imediatamente a regra, para o inï¿½cio da prï¿½xima
 //Ou ainda se encontrar o final do Pdoc, deve ocorrer a mesma aï¿½ï¿½o

 multiLineValue
 :
 	~( AT_ACCESSLEVEL | AT_AUTHOR | AT_BUILD | AT_CHILDREN | AT_COUNTRY |
 	AT_DATABASE | AT_DESCRIPTION | AT_DEPRECATED | AT_EXAMPLE | AT_HISTORY |
 	AT_SAMPLE | AT_LANGUAGE | AT_LINK | AT_OBS | AT_PARAM | AT_PARENTS |
 	AT_PROTECTED | AT_TYPE | AT_PROPTYPE | AT_DEFVALUE | AT_READONLY | AT_SOURCE
 	| AT_RETURN | AT_SYSTEMOPER | AT_SEE | AT_SINCE | AT_TABLE | AT_TODO |
 	AT_VERSION | PROTHEUS_DOC_END | PROTHEUS_DOC_END_4GL )+
 ;

 //////////////////////////////////////////////////////////////////////////////////////
 // Alteracoes realizadas nas regras do Pdoc devem ser replicadas para as gramaticas
 // AdvPL, 4GL e PER
 //////////////////////////////////////////////////////////////////////////////////////
