"use strict";

const PRINT_WIDTH = 80;

const fs = require("fs");
const path = require("path");
const parser = require("../lib").parser;

function run_spec(dirname, options) {
  fs.readdirSync(dirname).forEach((filename) => {
    const filepath = dirname + "/" + filename;
    if (
      path.extname(filename) !== ".snap" &&
      fs.lstatSync(filepath).isFile() &&
      filename[0] !== "." &&
      !filename.endsWith(".log") &&
      filename !== "jsfmt.spec.js"
    ) {
      const source = read(filepath).replace(/\r\n/g, "\n");
      const parsePrefix = path.extname(filename).substr(1);

      describe(parsePrefix + ": Sintax", () => {
        const mergedOptions = Object.assign(
          mergeDefaultOptions(options || {}),
          {
            filepath: filepath,
            parser: parsePrefix,
          }
        );

        test(filename, () => {
          const output = parser(source, mergedOptions);

          expect(
            raw(
              source +
                "~".repeat(PRINT_WIDTH) +
                "\n" +
                JSON.stringify(output, undefined, 2)
            )
          ).toMatchSnapshot();
        });
      });

      describe(parsePrefix + ": Token", () => {
        const mergedOptions = Object.assign(
          mergeDefaultOptions(options || {}),
          {
            filepath: filepath,
            parser: parsePrefix + "-token",
          }
        );

        test(filename, () => {
          const output = parser(source, mergedOptions);

          expect(
            raw(
              source +
                "~".repeat(PRINT_WIDTH) +
                "\n" +
                JSON.stringify(output, undefined, 2)
            )
          ).toMatchSnapshot();
        });
      });
    }
  });
}

global.run_spec = run_spec;

function read(filename) {
  return fs.readFileSync(filename, "utf8");
}

function mergeDefaultOptions(parserConfig) {
  return Object.assign(
    {
      debug: false,
    },
    parserConfig
  );
}

/**
 * Wraps a string in a marker object that is used by `./raw-serializer.js` to
 * directly print that string in a snapshot without escaping all double quotes.
 * Backticks will still be escaped.
 */
function raw(string) {
  if (typeof string !== "string") {
    throw new Error("Raw snapshots have to be strings.");
  }
  return { [Symbol.for("raw")]: string };
}
