import { IParserOptions, normalize } from "./config";
import { ERRORS } from "./errors";
import * as call_parser from "./parsers";

const LANGUAGES = [
  {
    extensions: [".4gl"],
    name: "4GL",
    parsers: ["4gl", "4gl-token"],
    vscodeLanguageIds: ["4gl"],
  },
];

const PARSERS = {
  "4gl": {
    parse: (text, options) => {
      return call_parser.parser(text, options);
    },
  },
  "4gl-token": {
    parse: (text, options) => {
      return call_parser.parser_token(text, options);
    },
  },
};

export function parser(content: string, options: IParserOptions): any[] {
  let parserList: any[] = undefined;

  options = normalize(options);

  if (options.vscodeLanguageId !== "") {
    parserList = LANGUAGES.filter((language) => {
      return language.vscodeLanguageIds.includes(options.vscodeLanguageId);
    }).map((lang) => {
      return lang.parsers;
    });
  } else if (options.parser !== "") {
    parserList = LANGUAGES.filter((language) => {
      return language.parsers.includes(options.parser);
    }).map((lang) => {
      return lang.parsers.filter((parser) => {
        return parser == options.parser;
      });
    });
  }

  if (!parserList || parserList.length == 0) {
    throw new Error(ERRORS.E002);
  } else if (parserList.length > 1) {
    throw new Error(ERRORS.E003);
  }

  const result = [];

  parserList.forEach((parser) => {
    result.push(PARSERS[parser].parse(content, options));
  });

  return result;
}
