'use strict';

const PRINT_WIDTH = 80;

const fs = require('fs');
const path = require('path');
const tds_parser = require('../lib').tds_parser;
const PEGUtil = require('../lib/PEGUtil');

function run_spec(dirname, options) {
  fs.readdirSync(dirname).forEach((filename) => {
    const filepath = dirname + '/' + filename;
    if (
      path.extname(filename) !== '.snap' &&
      fs.lstatSync(filepath).isFile() &&
      filename[0] !== '.' &&
      !filename.endsWith('.log') &&
      filename !== 'jsfmt.spec.js'
    ) {
      const source = fs.readFileSync(filepath, 'utf8').replace(/\r\n/g, '\n');
      const parsePrefix = path.extname(filename).substr(1);

      ['token', 'program'].forEach((process) => {
        describe(`${parsePrefix}: ${process}`, () => {
          const mergedOptions = Object.assign(
            mergeDefaultOptions(options || {}),
            {
              parserProcess: process,
              filepath: filepath,
            }
          );

          test(filename, () => {
            const output = tds_parser(source, mergedOptions);
            let dump = ''; //output.ast.dump();

            expect(output).not.toBeNull();

            if (output && output.error) {
              dump = `${filename}\n${PEGUtil.errorMessage(output.error)}`;
              expect(dump).toBeNull();
            } else {
              dump = output.ast.dump();
              expect(raw(dump)).toMatchSnapshot();
            }
          });
        });
      });
    }
  });
}

global.run_spec = run_spec;

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
  if (typeof string !== 'string') {
    throw new Error('Raw snapshots have to be strings.');
  }
  return { [Symbol.for('raw')]: string };
}
