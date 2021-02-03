import PEGUtil = require("pegjs-util")
import { parse as parser_4gl } from "./4gl";
import { parse as parser_advpl } from "./advpl";
import { ASTNode, ASTUtil } from "./ast_node";

function parser_token(parser: any, text: string): { ast: ASTNode, error?: any } {
    const result = PEGUtil.parse({ parse: parser }, text, {
        startRule: "start_program",
        makeAST: function (line: number, column: number, offset: number, _args: any[]) {
            const args: any[] = [];

            args.push(_args[0]);
            if (_args.length > 1) {
                args.push(_args[1]);
            } else {
                args.push("");
            }

            const node: ASTNode = ASTUtil.create(...args, { line, column, offset });

            return node;
        }
    });

    return result;
}

export const parser_token_4gl = (text: string) => { return parser_token(parser_4gl, text) };
export const parser_token_advpl = (text: string) => { return parser_token(parser_advpl, text) };
