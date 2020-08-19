import { IParserOptions, normalize } from "./config";
import { ERRORS } from "./errors";
import * as call_parser from "./parsers";

const LANGUAGES = [
  {
    extensions: [".4gl"],
    name: "4GL",
    parsers: ["4gl"],
    vscodeLanguageIds: ["4gl"],
  },
];

const PARSERS = {
  "4gl": {
    parse: (text, options) => {
      return call_parser.parser(text, options);
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
      return lang.parsers;
    });
  }

  if (!parserList || parserList.length == 0) {
    throw new Error(ERRORS.E002);
  }

  const result = [];

  parserList.forEach((parser) => {
    result.push(PARSERS[parser].parse(content, options));
  });

  return result;
}
