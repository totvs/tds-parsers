('use strict');

const fs = require('fs');
const path = require('path');
const tds_parser = require('../lib').tds_parser;
const PEGUtil = require('../lib/PEGUtil');
const raw = require('jest-snapshot-serializer-raw').wrap;

global.run_spec = (dirname, processes, options) => {
  if (!Array.isArray(processes)) {
    processes = ['token', 'program'];
  }

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

      describe(`${parsePrefix}: ${filename}`, () => {
        processes.forEach((process) => {
          const mergedOptions = Object.assign(
            mergeDefaultOptions(options || {}),
            {
              parserProcess: process,
              filepath: filepath,
            }
          );

          test(process, () => {
            const output = tds_parser(source, mergedOptions);
            let dump = ''; //output.ast.dump();

            expect(output).not.toBeNull();
            //expect(output).not.toThrow();

            if (output.error) {
              dump = `${filename}\n${PEGUtil.errorMessage(output.error)}`;
            } else {
              dump = output.ast.dump();
            }

            expect(
              raw(createSnapshot(source, dump, mergedOptions))
            ).toMatchSnapshot();
          });
        });
      });
    }
  });
};

global.run_spec = run_spec;

function mergeDefaultOptions(parserConfig) {
  return Object.assign(
    {
      debug: false,
    },
    parserConfig
  );
}

function createSnapshot(input, output, options) {
  const separatorWidth = 80;

  return []
    .concat(
      '\n',
      printSeparator(separatorWidth, 'options'),
      printOptions(options),
      printSeparator(separatorWidth, 'input'),
      input,
      printSeparator(separatorWidth, 'output'),
      output,
      printSeparator(separatorWidth)
    )
    .join('\n');
}

function printSeparator(width, description) {
  description = description || '';
  const leftLength = Math.floor((width - description.length) / 2);
  const rightLength = width - leftLength - description.length;
  return '='.repeat(leftLength) + description + '='.repeat(rightLength);
}

function printOptions(options) {
  const keys = Object.keys(options).sort();
  return keys.map((key) => `${key}: ${stringify(options[key])}`).join('\n');
  function stringify(value) {
    return value === Infinity
      ? 'Infinity'
      : Array.isArray(value)
      ? `[${value.map((v) => JSON.stringify(v)).join(', ')}]`
      : JSON.stringify(value);
  }
}
