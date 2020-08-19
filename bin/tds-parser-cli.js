#!/usr/bin/env node
/* eslint no-var: 0 */

const parser = require("../lib");
const fs = require("fs");
const path = require("path");
const { exit } = require("process");
var filename = process.argv[2];

if (!filename) {
  console.error("no filename specified");
  exit(1);
}

console.error("processing " + filename);
// var file = fs.readFileSync(filename, "utf8");

// let rangeStart = 0;
// let rangeEnd = Infinity;
// let cursorOffset = 0;

// const source = read(filepath);

// const mergedOptions = Object.assign(mergeDefaultOptions(options || {}), {
//   filepath,
//   rangeStart,
//   rangeEnd,
//   cursorOffset,
// });

// const output = prettyprint(input, {
//   ...mergedOptions,
//   astFormat: "4gl-source",
// });

// console.log(output);

// function prettyprint(src, options) {
//   let result = prettier.format(src, options);

//   return result.formatted || result;
// }

// function mergeDefaultOptions(parserConfig) {
//   return Object.assign(
//     {
//       plugins: [path.dirname(__dirname)],
//       printWidth: 80,
//     },
//     parserConfig
//   );
// }
