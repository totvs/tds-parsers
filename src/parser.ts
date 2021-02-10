import PEGUtil = require("pegjs-util")
import { parse as parser_4gl } from "./4gl";
import { parse as parser_advpl } from "./advpl";
import { ASTNode, ASTUtil, ILocation, ILocationToken } from "./ast_node";

function locStart(ast) {
    let offset = 0;

    if (Array.isArray(ast)) {
        if (ast.length > 0) {
            for (let index = 0; index < ast.length; index++) {
                const element = ast[index];
                offset = locStart(element);
                if (offset !== 0) {
                    break;
                }
            }
        }
    } else if (!ast.offset) {
        offset = locStart(ast.value);
    } else if (ast.kind) {
        offset = ast.offset.start;
    }

    return offset;
}

function locEnd(ast: ASTNode | ASTNode[]): ILocation {
    let location: ILocation = { line: -Infinity, column: -Infinity, offset: -Infinity };

    if (Array.isArray(ast)) {
        for (let index = 0; index < ast.length; index++) {
            const element = ast[index];
            location = locEnd(element);
            if (location.offset !== -Infinity) {
                break;
            }
        }
    } else if (typeof ast ==="string") {
        //ignore
    } else if (ast.children.length > 0) {
        location = locEnd(ast.children);
    } else if (Array.isArray(ast.source)) {
        location = locEnd(ast.source);
    } else if (ast.location.start.offset > ast.location.end.offset) {
        const start: ILocation = ast.location.start;
        location = { line: start.line, column: start.column + ast.source.length - 1,  offset: start.offset + ast.source.length - 1};
    }

    return location;
}

function parser_token(parser: any, text: string): { ast: ASTNode, error?: any } {
    const result = PEGUtil.parse({ parse: parser }, text, {
        startRule: "start_program",
        makeAST: function (line: number, column: number, offset: number, _args: any[]) {
            const args: any[] = [];

            args.push(_args[0]);
            if (_args.length > 1) {
                if (Array.isArray(_args[1])) {
                    args.push(_args[1].filter((element) => element != undefined));
                } else {
                    args.push(_args[1]);
                }
            } else {
                args.push("");
            }

            const node: ASTNode = ASTUtil.create(...args, { line, column, offset });
            node.endLocation = locEnd(node);

            return node;
        }
    });

    return result;
}

export const parser_token_4gl = (text: string) => { return parser_token(parser_4gl, text.endsWith("\n") ? text : text + "\n") };
export const parser_token_advpl = (text: string) => { return parser_token(parser_advpl, text.endsWith("\n") ? text : text + "\n") };
