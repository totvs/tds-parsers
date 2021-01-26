import { IParserOptions, normalize } from "./config";
import { ERRORS } from "./errors";
import * as call_parser from "./parsers";
export {  } from "./interfaces";

const LANGUAGES = [
  {
    extensions: [".4gl"],
    name: "4GL",
    parsers: ["4gl-token"],
  },
];

const PARSERS = {
  // "4gl-source": {
  //   parse: (text, options) => {
  //     return call_parser.parser_program(text, options);
  //   },
  // },
  "4gl-token": {
    parse: (text, options) => {
      return call_parser.parser_token(text, options);
    },
  },
};

export function parser(content: string, options: IParserOptions): any[] {
  let parserList: any[] = [];

  options = normalize(options);

  parserList = LANGUAGES.filter((language) => {
    return language.parsers.includes(options.parser as string);
  }).map((lang) => {
    return lang.parsers.filter((parser) => {
      return parser == options.parser;
    });
  });

  if (!parserList || parserList.length == 0) {
    throw new Error(`${ERRORS.E002} [${options.parser}]`);
  } else if (parserList.length > 1) {
    throw new Error(`${ERRORS.E003} [${options.parser}]`);
  }

  const result: any[] = [];

  parserList.forEach((parser) => {
    result.push(PARSERS[parser].parse(content, options));
  });

  return result;
}
