const keywords = [
  'ALIAS',
  'ANNOUNCE',
  'AS',
  'BEGIN',
  'BEGINSQL',
  'BREAK',
  'CASE',
  'CATCH',
  'COLUMN',
  'DATE',
  'DECLARE',
  'DO',
  'ELSE',
  'ELSEIF',
  'ENDCASE',
  'ENDDO',
  'ENDIF',
  'ENDSQL',
  'EXIT',
  'EXTERNAL',
  'FIELD',
  'FOR',
  'FUNCTION',
  'IF',
  'IIF',
  'IN',
  'LOCAL',
  'LOGICAL',
  'LOOP',
  'MAIN',
  'MEMVAR',
  'METHOD',
  'NEXT',
  'NIL',
  'NUMERIC',
  'OTHERWISE',
  'PRIVATE',
  'PROCEDURE',
  'PUBLIC',
  'RECOVER',
  'RETURN',
  'SEQUENCE',
  'STATIC',
  'STEP',
  'THROW',
  'TO',
  'TRY',
  'USING',
  'WHILE',
  'WITH',
  '_FIELD',
  'PYME',
  'PROJECT',
  'TEMPLATE',
  'WEB',
  'HTML',
  'USER',
  'WEBUSER',
];

keywords
  .sort((a, b) => {
    return b <= a;
  })
  .forEach((keyword) => {
    console.log(`  / ${keyword.toUpperCase()}`);
  });

console.log('\n\n\n\n\n');

keywords.forEach((keyword) => {
  let output = `${keyword.toUpperCase()}\n  = k:`;

  if (keyword.length > 4) {
    output = `${output}(\n  `;

    for (let index = keyword.length; index > 3; index--) {
      const element = keyword.substr(0, index).toLowerCase();

      if (index != keyword.length) {
        output = `${output}  /`;
      }

      output = `${output} '${element}'i\n`;
    }

    output = `${output}  )  { return ast('keyword', k).setAttribute('command', '${keyword.toLowerCase()}') }\n`;
  } else {
    const element = keyword.toLowerCase();
    output = `${output}'${element}'i { return ast('keyword', k) }\n`;
  }

  console.log(`${output}\n`);
});
