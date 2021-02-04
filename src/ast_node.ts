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
    private _attributes: {};

    constructor(type: EASTType, source: string, location: ILocation) {
        this._type = type;
        this._location = location;
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

    public get beginBlock(): ASTNode | undefined {
        if (this.type == EASTType.block) {
            return this.children[0];
        }

        return undefined;
    }

    public get bodyBlock(): ASTNode | undefined {
        if (this.type == EASTType.block) {
            return this.children[1];
        }

        return undefined;
    }

    public get endBlock(): ASTNode | undefined {
        if (this.type == EASTType.block) {
            return this.children[2];
        }

        return undefined;
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