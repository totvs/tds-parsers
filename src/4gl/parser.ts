import * as fs from "fs";
import * as path from "path";

import ASTY = require("asty");
import PEG = require("pegjs")
import PEGUtil = require("pegjs-util")

const grammarFile: string = path.join(".", "src", "4gl", "4gl.pegjs");
const options: PEG.ParserBuildOptions =  {
    allowedStartRules: [ "start"],
    trace: false
}
const parser: PEG.Parser = PEG.generate(fs.readFileSync(grammarFile, "utf8"), options);

export function parser_token(text: string, options: any): ASTY.ASTYNode {
    const asty = new ASTY();
    const result = PEGUtil.parse(parser, text, {
        startRule: "start",
        makeAST: function (line: number, column: number, offset: number, args: any) {
            return asty.create.apply(asty, args).pos(line, column, offset)
        }
    });

    return result;
}