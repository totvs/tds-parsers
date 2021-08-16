import path = require('path');
import { ERRORS } from './errors';

export type ParserProcess = 'token' | 'program';

export interface IParserOptions {
  debug?: boolean;
  filepath?: string;
  parserProcess?: ParserProcess;
  fileext?: string;
}

export const defaultOptions: IParserOptions = {
  debug: false,
  filepath: '',
  parserProcess: 'program',
  fileext: '',
};

export function normalize(options: IParserOptions): IParserOptions {
  const opts = { ...defaultOptions, ...options };

  if (
    opts.filepath === '' &&
    opts.parserProcess !== 'program' &&
    opts.parserProcess !== 'token'
  ) {
    throw new Error(ERRORS.E001);
  }

  if (opts.filepath !== '') {
    opts.fileext = path.extname(opts.filepath as string).toLowerCase();
  }

  return opts;
}
