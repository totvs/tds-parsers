import path = require("path");

const parser_4gl = require("./4gl.js");

function process(parser: any, text: string, options: any): any {
  try {
    return parser.parse(text, options);
  } catch (error) {
    if (error.location) {
      const file = path.basename(options.filepath);
      let msg: string;

      msg = `${error.name}: ${file}[${error.location.start.line}:${error.location.start.column}] ${error.message}`;
      console.error(msg);
    } else {
      console.log(error);
    }

    throw error;
  }
}

export function parser_program(text: string, options: any): any {
  return process(parser_4gl, text, { ...options, startRule: "start_program" });
}

export function parser_token(text: string, options: any): any {
  return process(parser_4gl, text, {
    ...options,
    startRule: "start_token",
  });
}
