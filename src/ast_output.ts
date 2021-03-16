import { ASTChildren, ASTNode } from "./ast_node";

export function astDump(ast: ASTChildren[] | ASTChildren, prefix: string = ""): string {
    if (!ast) {
        return "";
    }

    let output: string = ``;

    if (Array.isArray(ast)) {
        ast.forEach((element: ASTChildren) => {
            output += astDump(element, prefix);
        });
    } else {
        let source: string = "";
        let sourceArray: string = "";
        let children: string = "";

        if (typeof ast == 'string' || typeof ast == 'number') {
            source = ast;
        } else if (Array.isArray(ast.source) || (typeof ast.source == 'object')) {
            sourceArray = astDump(ast.source, `${prefix}-`);
            source = "-";
        } else {
            source = ast.source
                .replace(/ /g, "\\b")
                .replace(/\t/g, "\\t")
                .replace(/\n/g, "\\n")
                .replace(/\r/g, "\\r");
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
