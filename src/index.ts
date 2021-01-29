import { IParserOptions, normalize } from "./config";
import { ERRORS } from "./errors";
import ASTY = require("asty");
import { parser_token_4gl, parser_token_advpl } from "./parser";

const LANGUAGES = [
  {
    name: "4gl-token",
    extensions: [
      ".4gl", 
      ".per"
    ],
    parser: (text: string, options: any) => {
      return parser_token_4gl(text);
    },
  },
  {
    name: "advpL-token",
    parser: (text: string, options: any) => {
      return parser_token_advpl(text);
    },
    extensions: [
      ".prw",
      ".prx",
      ".aph",
      ".ppx",
      ".ppp",
      ".tlpp",
      ".ch"
    ],
  },
];

export function parser(content: string, options: IParserOptions): ASTY.ASTYNode {
  let parserList: any[] = [];

  options = normalize(options);

  parserList = LANGUAGES.filter((language) => {
    return language.name == (options.parser as string)
    || language.extensions.includes(options.fileext as string);
  });

  if (!parserList || parserList.length == 0) {
    throw new Error(`${ERRORS.E002} [${options.parser}]`);
  } else if (parserList.length > 1) {
    throw new Error(`${ERRORS.E003} [${options.parser}]`);
  }

  return parserList[0].parser(content, options);
}
