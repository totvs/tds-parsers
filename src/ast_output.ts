import { ASTNode } from "./ast_node";

export function astDump(ast: ASTNode | ASTNode[], prefix: string = ""): string {
    if (!ast) {
        return "";
    }

    let output: string = `${prefix}`;

    if (Array.isArray(ast)) {
        ast.forEach((element: ASTNode) => {
            output += astDump(element, prefix);
        });
    } else {
        output += `${ast.type}: ${ast.source } [${ast.location.line}:${ast.location.column}]\n`;

        if (ast.children && ast.children.length > 0) {
            output += astDump(ast.children, prefix + "| ");
        };
    }
    return output;
};

export function astSerialize(ast: ASTNode): string {

    return JSON.stringify(ast);
};
