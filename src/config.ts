import path = require("path");
import { ERRORS } from "./errors";

export interface IParserOptions {
  debug?: boolean;
  filepath?: string;
  parser?: string;
  fileext?: string;
}

export const defaultOptions: IParserOptions = {
  debug: false,
  filepath: "",
  parser: "",
  fileext: ""
};

export function normalize(options: IParserOptions): IParserOptions {
  const opts = { ...defaultOptions, ...options };

  if ((opts.filepath === "") && (opts.parser === "")) {
    throw new Error(ERRORS.E001);
  }

  if (opts.filepath !== "") {
    opts.fileext = path.extname(opts.filepath as string).toLowerCase();
  }

  return opts;
}
