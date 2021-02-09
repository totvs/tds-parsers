import { astDump, astSerialize } from "./ast_output";

export interface ILocation {
    offset: number;
    line: number;
    column: number;
}

export interface ILocationToken {
    start: ILocation,
    end: ILocation
}

export enum EASTType {
    program = "program",
    block = "block",
    argumentList = "argumentList",
    begin = "begin",
    string = "string",
    number = "number",
    whiteSpace = "whiteSpace",
    endLine = "endLine",
    newLine = "newLine",
    sequence = "sequence",
    identifier = "identifier",
    constant = "constant",
    builtInVar = "builtInVar",
    operator = "operator",
    operatorBraces = "operatorBraces",
    operatorBracket = "operatorBracket",
    operatorParenthesis = "operatorParenthesis",
    operatorSeparator = "operatorSeparator",
    operatorMath = "operatorMath",
    keyword = "keyword",
    comment = "comment",
    blockcomment = "blockcomment",
    singleLineComment = "singleLineComment",
    notSpecified = "notSpecified",

}

export class ASTNode {
    private _type: EASTType;
    private _source: string;
    private _location: ILocationToken;
    private _children: ASTNode[];
    private _attributes: {};

    constructor(type: EASTType, source: string, startLoc: ILocation) {
        this._type = type;
        this._location = { start: startLoc, end: { line: -Infinity, column: -Infinity, offset: -Infinity} };
        this._source = source;
        this._children = [];
        this._attributes = {}
    }

    public get type(): EASTType {
        return this._type;
    }

    public get source(): string {
        return this._source;
    }

    public get location(): ILocationToken {
        return this._location;
    }

    public set endLocation(endLocation: ILocation) {
        this._location = { ...this._location, end: endLocation };
    }

    public get children(): ASTNode[] {
        return this._children;
    }

    public add(...children: ASTNode[]): this {
        children.forEach((child: ASTNode) => {
            this._children.push(child);
        });

        return this;
    }

    public dump() {
        return ASTUtil.dump(this);
    }

    public getByType(target: EASTType) {
        return ASTUtil.getByType(this, target);
    }

    public serialize() {
        return ASTUtil.serialize(this);
    }

    public attributes(): {} {
        return this._attributes;
    }

    public get(key: string): any {
        return this._attributes[key];
    }

    public set(...args: any[]) {
        if (args.length === 1
            && typeof args[0] === "object") {
            Object.keys(args[0]).forEach((key) => {
                if (args[0][key] !== undefined)
                    this._attributes[key] = args[0][key]
                else
                    delete this._attributes[key]
            })
        }
        else if (args.length === 2) {
            if (args[1] !== undefined)
                this._attributes[args[0]] = args[1]
            else
                delete this._attributes[args[0]]
        }
        else {
            throw new Error("set: invalid number of arguments");
        }

        return this;
    }

    public get children_0(): ASTNode {

        return this.children[0];
    }

    public get children_1(): ASTNode {

        return this.children[1];
    }

    public get children_2(): ASTNode {

        return this.children[2];
    }

    public get children_3(): ASTNode {

        return this.children[3];
    }

}

function astByType(ast: any, target: EASTType): ASTNode[] {
    const output: ASTNode[] = [];

    if (!ast || typeof ast === "string") {
        return output;
    }

    if (Array.isArray(ast)) {
        ast.forEach((element: ASTNode) => {
            output.push(...astByType(element, target));
        });
    } else {
        if (Array.isArray(ast.source)) {
            output.push(...astByType(ast.source, target));
        } else {
            if (ast.type === EASTType.notSpecified) {
                output.push(ast);
            }

            if (ast.children && ast.children.length > 0) {
                output.push(...astByType(ast.children, target));
            };
        }
    }

    return output;
}


export const ASTUtil: any = {
    create: (type: EASTType, source: string, locStart: any): ASTNode => {
        return new ASTNode(type, source, locStart)
    },
    dump: (ast: ASTNode): string => {
        return astDump(ast);
    },
    serialize: (ast: ASTNode): string => {
        return astSerialize(ast);
    },
    getByType: (ast: ASTNode, target: EASTType): ASTNode[] => {
        return astByType(ast, target);
    },

}