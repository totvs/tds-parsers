const keywords = [
    'ALIAS',
'ANNOUNCE',
'AS',
'BEGIN',
'BEGINSQL'        ,
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
'WEBUSER'
]

keywords.forEach((keyword) => {
    console.log(`  / ${keyword.toUpperCase()}`);
});

console.log("\n\n\n\n\n");

keywords.forEach((keyword) => {
    let output = `${keyword.toUpperCase()}\n  = k:`;

    if (keyword.length > 4) {
        output = `${output}(\n  `

        for (let index = 4; index < keyword.length+1; index++) {
            const element = keyword.substr(0, index).toLowerCase();

            if (index == 4) {
                output = `${output} `
            } else {
                output = `${output}  /`
            }

            output = `${output} '${element}'i\n`
        }
        
        output = `${output}  )  { k.set('command', '${keyword.toLowerCase()}'); return ast('keyword', k) }\n`
    } else {
        const element = keyword.toLowerCase();
        output = `${output}'${element}'i { k.set('command', '${element}'); return ast('keyword', k) }\n`
    }

    console.log(`${output}\n`);
})
