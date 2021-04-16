# TOTVS Developer Studio: Analisador sintático

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

## Instalação

Para uso local:

```
npm install @totvs/tds-parsers
```

Para uso global:

```
npm install @totvs/tds-parsers -g
```

## Uso embarcado (API)

Se você deseja executar o **TDS-Parsers** via programa:

Importe o pacote

```ts
import { parser } from '@totvs/tds-parsers';
import { IParserOptions } from '@totvs/tds-parsers/typings/config';
import { ASTNode } from '@totvs/tds-parsers/typings/ast_node';
```

## `parser(source: string, parserInfo: IParserInfo): { ast: ASTNode~, error: Error }`

`parser` executa a análise sintática do conteúdo em `source`, retornando a arvore sintátîca abstrata (_AST_, em ingles). `parserInfo.parser` deve ser informado de acordo com a linguagem a ser formatada. Os valores válidos são: `advpl` ou `4gl`. As demais informações são opcionais.

```ts
try {
    const parserInfo: any = {
      debug: false, //adiciona informações de depuração do analisador
      filepath: "c:\\myProject\\file1.prw", //localização do arquivo
      parser: "advpl", //analisador a ser aplicado
      fileext: "prw", //extensão do arquivo a ser considerado
    };

    const result: any = parser(source, parserInfo);
    if (result.error) {
      throw result.error;
    }

    // processamento da AST aqui

  } catch (error) {
    if (error.location) {
      console.error(
        `Sintax error: [${error.location.start.line}:${error.location.start.column}] ${error.message}`
      );
    } else {
      console.error(error);
    }
    throw error;
  }
}
```

## Mantenedor

<table>
  <tr>
    <td align="center"><a href="https://twitter.com/TOTVSDevelopers"><img src="https://avatars2.githubusercontent.com/u/20243897?v=4?s=100" width="100px;" alt=""/><br /><sub><b>TOTVS S.A.</b></sub></a><br /><a href="#maintenance-totvs" title="Maintenance">🚧</a> <a href="#plugin-totvs" title="Plugin/utility libraries">🔌</a> <a href="#projectManagement-totvs" title="Project Management">📆</a></td>
    </tr>
</table>

## Colaboradores

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/brodao"><img src="https://avatars0.githubusercontent.com/u/949914?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Alan Cândido</b></sub></a><br /><a href="https://github.com/totvs/@totvs/prettier-plugin-4gl/commits?author=brodao" title="Code">💻</a> <a href="https://github.com/totvs/@totvs/prettier-plugin-4gl/commits?author=brodao" title="Documentation">📖</a> <a href="https://github.com/totvs/@totvs/prettier-plugin-4gl/commits?author=brodao" title="Tests">⚠️</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
