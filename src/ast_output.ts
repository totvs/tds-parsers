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
        let source: string = "";
        let sourceArray: string = "";
        let children: string = "";

        if (typeof ast == 'string' || typeof ast == 'number') {
            source = ast;
        } else if (Array.isArray(ast.source)) {
            sourceArray = astDump(ast.source, `${prefix}-`);
            source = "-";
        } else {
            source = ast.source
                .replace(/\t/g, "\\t")
                .replace(/\n/g, "\\n")
                .replace(/\r/g, "\\r");
            if (source == ' ') {
                source = "\\b";
            }
        }

        if (ast.children && ast.children.length > 0) {
            children = astDump(ast.children, `${prefix}| `.replace('-', ' '));
        };

        const attributes: string = JSON.stringify(ast.attributes());
        const location: string = `${ast.location.start.line}:${ast.location.start.column}-${ast.location.end.line}:${ast.location.end.column}`;

        output = `${prefix}${ast.type}: ${source} [${location}] {C:${ast.children.length}} {A:${attributes}}\n`;
        output = `${output}${sourceArray}${children}`;
    }

    return output;
};

export function astSerialize(ast: ASTNode): string {

    return JSON.stringify(ast);
};
