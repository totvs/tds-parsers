import { astDump, astSerialize } from './ast_output';
import { locEnd } from './parser';

export interface ILocation {
  offset: number;
  line: number;
  column: number;
}

export interface ILocationToken {
  start: ILocation;
  end: ILocation;
}

export enum EASTType {
  argumentList = 'argumentList',
  begin = 'begin',
  beginBlock = 'beginBlock',
  block = 'block',
  blockComment = 'blockComment',
  bodyBlock = 'bodyBlock',
  boolean = 'boolean',
  builtInVar = 'builtInVar',
  codeBlock = 'codeBlock',
  comment = 'comment',
  constant = 'constant',
  continueLine = 'continueLine',
  directive = 'directive',
  directiveBlock = 'directiveBlock',
  endBlock = 'endBlock',
  endLine = 'endLine',
  identifier = 'identifier',
  keyword = 'keyword',
  newLine = 'newLine',
  notSpecified = 'notSpecified',
  number = 'number',
  operator = 'operator',
  operatorAssign = 'operatorAssign',
  operatorBraces = 'operatorBraces',
  operatorBracket = 'operatorBracket',
  operatorLogical = 'operatorLogical',
  operatorMath = 'operatorMath',
  operatorParenthesis = 'operatorParenthesis',
  operatorSeparator = 'operatorSeparator',
  program = 'program',
  sequence = 'sequence',
  singleComment = 'singleComment',
  statement = 'statement',
  string = 'string',
  token = 'token',
  whiteSpace = 'whiteSpace',
}

export type ASTChild = ASTNode;

export class ASTNode {
  private _type: EASTType;
  private _source: string;
  private _location: ILocationToken;
  private _children: ASTChild[];
  private _attributes: {};

  constructor(type: EASTType, source: string, startLoc: ILocation) {
    this._type = type;
    this._location = {
      start: startLoc,
      end: { line: -Infinity, column: -Infinity, offset: -Infinity },
    };
    this._source = source;
    this._children = [];
    this._attributes = {};

    this.endLocation = locEnd(this);
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
    if (endLocation.offset < 0) {
      endLocation.offset = this._location.start.offset;
    }

    this._location = { ...this._location, end: endLocation };
  }

  public get children(): ASTChild[] {
    return this._children;
  }

  public add(children: ASTNode): this {
    this._children.push(children);
    this.endLocation = locEnd(this);

    return this;
  }

  public get block(): any[] {
    return [
      this._children[0], //begin block
      this._children[1], //content
      this._children[2],
    ]; //end block
  }

  public dump(maxLevel: number = Infinity) {
    return ASTUtil.dump(this, maxLevel);
  }

  public getByType(target: EASTType) {
    return ASTUtil.getByType(this, target);
  }

  public serialize() {
    return ASTUtil.serialize(this);
  }

  public get attributes(): {} {
    return this._attributes;
  }

  public getAttribute(key: string): string {
    return this._attributes[key];
  }

  public setAttribute(...args: any[]): this {
    if (args.length === 1 && typeof args[0] === 'object') {
      Object.keys(args[0]).forEach((key) => {
        if (args[0][key] !== undefined) this._attributes[key] = args[0][key];
        else delete this._attributes[key];
      });
    } else if (args.length === 2) {
      if (args[1] !== undefined) this._attributes[args[0]] = args[1];
      else delete this._attributes[args[0]];
    } else {
      throw new Error('set: invalid number of arguments');
    }

    return this;
  }
}

function astByType(ast: any, target: EASTType): ASTNode[] {
  const output: ASTNode[] = [];

  if (!ast || typeof ast === 'string') {
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
      }
    }
  }

  return output;
}

export const ASTUtil: any = {
  create: (type: EASTType, source: string, locStart: any): ASTNode => {
    return new ASTNode(type, source, locStart);
  },
  dump: (ast: ASTNode, maxLevel: number): string => {
    return astDump(ast, '', maxLevel);
  },
  serialize: (ast: ASTNode): string => {
    return astSerialize(ast);
  },
  getByType: (ast: ASTNode, target: EASTType): ASTNode[] => {
    return astByType(ast, target);
  },
};
