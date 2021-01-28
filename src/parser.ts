import * as fs from "fs";
import * as path from "path";

import ASTY = require("asty");
import PEG = require("pegjs")
import PEGUtil = require("pegjs-util")

const grammarFile: any = {
    "4gl": path.resolve(__dirname, "..", "grammar", "4gl.pegjs"),
    "advpl": path.resolve(__dirname, "..", "grammar", "advpl.pegjs"),
}
const options: PEG.ParserBuildOptions =  {
    allowedStartRules: [ "start"],
    trace: false
}
const parsers: {} = { "4gl": undefined, "advpl": undefined };

function parser_token(parserId: string, text: string, options: any): ASTY.ASTYNode {
    const asty = new ASTY();
    if (!parsers[parserId]) {
        parsers[parserId] = PEG.generate(fs.readFileSync(grammarFile[parserId], "utf8"), options);
    }
    const result = PEGUtil.parse(parsers[parserId], text, {
        startRule: "start",
        makeAST: function (line: number, column: number, offset: number, args: any) {
            return asty.create.apply(asty, args).pos(line, column, offset)
        }
    });

    return result;
}

export const parser_token_4gl = (text: string, options: any) => { return parser_token("4gl", text, options) };
export const parser_token_advpl = (text: string, options: any) => { return parser_token("advpl", text, options) };
