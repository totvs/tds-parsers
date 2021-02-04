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
        if (typeof ast == 'string') {
            output += ast;
        } else if (Array.isArray(ast.source)) {
            ast.source.forEach((element: ASTNode) => {
                output += astDump(element, prefix);
            });
        } else {
            const source = ast.source
                .replace(/ /g, "\\b")
                .replace(/\t/g, "\\t")
                .replace(/\n/g, "\\n")
                .replace(/\r/g, "\\r");

            const attributes: string = ast.attributes.length > 0? JSON.stringify(ast.attributes): "";

            output += `${ast.type}: ${source} [${ast.location.line}:${ast.location.column}] {${attributes}\n`;

            if (ast.children && ast.children.length > 0) {
                output += astDump(ast.children, prefix + "| ");
            };
        }
    }
    return output;
};

export function astSerialize(ast: ASTNode): string {

    return JSON.stringify(ast);
};
