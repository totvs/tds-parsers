import { astDump, astSerialize } from "./ast_output";

export interface ILocation {
    offset: number;
    line: number;
    column: number;
}

export enum EASTType {
    program = "program",
     block = "block",
    begin = "begin",
    comment = "comment",
    string = "string",
    number = "number",
    whiteSpace = "whiteSpace",
    newLine = "newLine",
    sequence = "sequence",
    identifier = "identifier",
    constant = "constant",
    builtInVar = "builtInVar",
    operator = "operator",
    keyword = "keyword",
    notSpecified = "notSpecified",
    undefined = "undefined",
}

export class ASTNode {
    private _type: EASTType;
    private _source: string;
    private _location: ILocation;
    private _children: ASTNode[];

    constructor(type: EASTType, source: string, location: ILocation) {
        this._type = type;
        this._location = location;
        this._source = source;
        this._children = [];
    }

    public get type(): EASTType {
        return this._type;
    }

    public get source(): string {
        return this._source;
    }

    public get location(): ILocation {
        return this._location;
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

    public serialize() {
        return ASTUtil.serialize(this);
    }

}

export const ASTUtil: any = {
    create: (type: EASTType, source: string, location: ILocation): ASTNode => {
        return new ASTNode(type, source, location)
    },
    dump: (ast: ASTNode): string => {
        return astDump(ast);
    },
    serialize: (ast: ASTNode): string => {
        return astSerialize(ast);
    },

}