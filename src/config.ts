import path = require("path");
import { ERRORS } from "./errors";

export interface IParserOptions {
  debug?: boolean;
  filepath?: string;
  parser?: string
}

export const defaultOptions: IParserOptions = {
  debug: false,
  filepath: "",
  parser: "",
};

export function normalize(options: IParserOptions): IParserOptions {
  const opts = { ...defaultOptions, ...options };

  if (
    opts.filepath === "" &&
    opts.parser === ""
  ) {
    throw new Error(ERRORS.E001);
  }

  if (opts.filepath !== "" && opts.parser == "") {
    opts.parser = path.extname(opts.filepath as string);
  }

  return opts;
}
