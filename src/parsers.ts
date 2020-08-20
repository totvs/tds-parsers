import path = require("path");

const parser_4gl = require("./4gl.js");

export function parser(text: string, options: any): any {
  try {
    return parser_4gl.parse(text, options);
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
