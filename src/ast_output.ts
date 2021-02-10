import { ASTNode } from "./ast_node";

export function astDump(ast: ASTNode | ASTNode[], prefix: string = ""): string {
    if (!ast) {
        return "";
    }

    let output: string = ``;

    if (Array.isArray(ast)) {
        ast.forEach((element: ASTNode) => {
            output += astDump(element, prefix);
        });
    } else {
        if (typeof ast == 'string' || typeof ast == 'number') {
            output += ast;
        } else if (Array.isArray(ast.source)) {
            output += astDump(ast.source, prefix);
        } else {
            let source = ast.source
                .replace(/\t/g, "\\t")
                .replace(/\n/g, "\\n")
                .replace(/\r/g, "\\r");
            if (source == ' ') {
                source = "\\b";
            }
            const attributes: string = JSON.stringify(ast.attributes());
            const location: string = `${ast.location.start.line}:${ast.location.start.column}-${ast.location.end.line}:${ast.location.end.column}`;
            output = `${prefix}${ast.type}: ${source} [${location}] {C:${ast.children.length}} {A:${attributes}}\n`;

            if (ast.children && ast.children.length > 0) {
                output += astDump(ast.children, `${prefix}| `);
            };
        }
    }
    return output;
};

export function astSerialize(ast: ASTNode): string {

    return JSON.stringify(ast);
};
