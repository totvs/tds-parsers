const parser_4gl = require("./4gl.js");

export function parser(text: string, options: any) {
  try {
    return parser_4gl.parse(text, options);
  } catch (error) {
    if (error.location) {
      console.error(
        `Sintax error: [${error.location.start.line}:${error.location.start.column}] ${error.message}`
      );
    } else {
      console.log(error);
    }

    throw error;
  }

  return [];
}
