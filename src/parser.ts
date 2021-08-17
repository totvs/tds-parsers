import PEGUtil = require('./PEGUtil');
import { parse as parser_4gl } from './4gl';
import { parse as parser_advpl } from './advpl';
import { ASTChild, ASTNode, ASTUtil, EASTType, ILocation } from './ast_node';

export function locEnd(ast: ASTChild | ASTChild[]): ILocation {
  let location: ILocation = {
    line: -Infinity,
    column: -Infinity,
    offset: -Infinity,
  };

  if (!ast) {
    return location;
  }

  if (Array.isArray(ast)) {
    for (let index = 0; index < ast.length; index++) {
      const element = ast[index];
      const loc = locEnd(element);
      if (location.offset < loc.offset) {
        location = loc;
      }
    }
  } else if (typeof ast === 'string') {
    //ignore
  } else if (ast.children.length > 0) {
    location = locEnd(ast.children);
  } else if (Array.isArray(ast.source)) {
    location = locEnd(ast.source);
  } else if (ast.location.start.offset > ast.location.end.offset) {
    const start: ILocation = ast.location.start;
    location = {
      line: start.line,
      column: start.column + ast.source.length - 1,
      offset: start.offset + ast.source.length - 1,
    };
  } else {
    location = ast.location.end;
  }

  return location;
}

function parser_process(
  parser: any,
  text: string,
  startRule: string
): { ast: ASTNode | null; error?: any } {
  const result = PEGUtil.parse(
    { parse: parser, SyntaxError: SyntaxError },
    text,
    {
      startRule: startRule,
      makeAST: function (
        line: number,
        column: number,
        offset: number,
        _args: any[]
      ) {
        const args: any[] = [];

        if (!Object.values(EASTType).includes(_args[0])) {
          console.error('Invalid EASType: ' + _args[0]);
          throw new Error('Invalid EASType: ' + _args[0]);
        }

        args.push(_args[0]);
        if (_args.length > 1) {
          if (Array.isArray(_args[1])) {
            args.push(
              _args[1].filter(
                (element) => element != null && element != undefined
              )
            );
          } else {
            args.push(_args[1]);
          }
        } else {
          args.push('');
        }

        const node: ASTNode = ASTUtil.create(...args, { line, column, offset });

        return node;
      },
    }
  );

  return result;
}

export const parser_token_4gl = (text: string): any => {
  return parser_process(parser_4gl, text, 'start_token');
};

export const parser_program_4gl = (text: string): any => {
  return parser_process(parser_4gl, text, 'start_program');
};

export const parser_token_advpl = (text: string) => {
  return parser_process(parser_advpl, text, 'start_token');
};

export const parser_program_advpl = (text: string) => {
  return parser_process(parser_advpl, text, 'start_program');
};
