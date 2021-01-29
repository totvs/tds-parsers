import ASTY = require("asty");
import PEGUtil = require("pegjs-util")
import { parse as parser_4gl } from "./4gl";
import { parse as parser_advpl } from "./advpl";

function parser_token(parser: any, text: string): ASTY.ASTYNode {
    const asty = new ASTY();
    const result = PEGUtil.parse({ parse: parser }, text, {
        startRule: "start_program",
        makeAST: function (line: number, column: number, offset: number, _args: any[]) {
            const args: any[] = [];

            args.push(_args[0]);
            if (_args.length > 1) {
                // if (Array.isArray(_args[1])) {
                //     args.push({});
                //     const unroll = PEGUtil.makeUnroll(location, _args[1]);
                //     args.push(unroll);
                // } else {
                    args.push({ value: _args[1] });
//                }
            }

            return asty.create.apply(asty, args).pos(line, column, offset)
        }
    });

    return result;
}

export const parser_token_4gl = (text: string) => { return parser_token(parser_4gl, text) };
export const parser_token_advpl = (text: string) => { return parser_token(parser_advpl, text) };
