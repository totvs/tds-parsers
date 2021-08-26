import { ASTNode, EASTType } from './ast_node';
import { IParserOptions, normalize } from './config';
import { ERRORS } from './errors';
import {
  parser_program_4gl,
  parser_program_advpl,
  parser_token_4gl,
  parser_token_advpl,
} from './parser';

export { ASTNode, EASTType } from './ast_node';

const LANGUAGES = [
  {
    name: '4gl-token',
    extensions: ['.4gl', '.per'],
    parser: (text: string, options: any) => {
      return parser_token_4gl(text);
    },
  },
  {
    name: '4gl-program',
    extensions: ['.4gl', '.per'],
    parser: (text: string, options: any) => {
      return parser_program_4gl(text);
    },
  },
  {
    name: 'advpL-token',
    parser: (text: string, options: any) => {
      return parser_token_advpl(text);
    },
    extensions: ['.prw', '.prx', '.aph', '.ppx', '.ppp', '.tlpp', '.ch'],
  },
  {
    name: 'advpL-program',
    parser: (text: string, options: any) => {
      return parser_program_advpl(text);
    },
    extensions: ['.prw', '.prx', '.aph', '.ppx', '.ppp', '.tlpp', '.ch'],
  },
];

export function tds_parser(content: string, options: IParserOptions): ASTNode {
  let parserList: any[] = [];

  options = normalize(options);

  parserList = LANGUAGES.filter((language) => {
    return (
      language.name.endsWith(options.parserProcess as string) &&
      language.extensions.indexOf(options.fileext as string) > -1
    );
  });

  if (!parserList || parserList.length == 0) {
    throw new Error(`${ERRORS.E002} [${options.parserProcess}]`);
  } else if (parserList.length > 1) {
    throw new Error(`${ERRORS.E003} [${options.parserProcess}]`);
  }

  return parserList[0].parser(content, options);
}
