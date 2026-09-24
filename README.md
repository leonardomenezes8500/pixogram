![pixogram](assets/logo.png)

figlet, mas no estilo pixel-art bloco-único do logo do [mini.nvim](https://github.com/nvim-mini/mini.nvim): grade 4x7, sem antialiasing, sem artefato de fonte — todo glifo é reto e uniforme.

> Isso é praticamente uma cópia da técnica (e da fonte) que [Evgeni Chasnovski](https://github.com/echasnovski) criou pro `mini.nvim` — ver [Créditos](#créditos). `pixogram` só generaliza pra qualquer texto, em `sh` POSIX em vez de Lua+Neovim.

```
$ pixogram "hello world"
█ █ ███ █   █   ███     █ █ ███ ███ █   ██
█ █ █   █   █   █ █     █ █ █ █ █ █ █   █ █
███ ██  █   █   █ █     ███ █ █ ██  █   █ █
█ █ █   █   █   █ █     ███ █ █ █ █ █   █ █
█ █ ███ ███ ███ ███     █ █ ███ █ █ ███ ██
```

```
$ pixogram -o logo.png "track:#bfe3ff" "ec:#dcd2a0"
```

## Uso

```
pixogram [-o FILE] [-b BG] [-s SCALE] TEXT[:COLOR] ...
```

- Sem `-o`: imprime block-art ASCII no stdout (bom pra colar em comentário de código — não precisa de cor).
- `-o FILE`: gera um PNG (precisa do `magick`, do ImageMagick).
- `-b COLOR`: cor de fundo, hex (padrão `#00182A`).
- `-s SCALE`: fator de upscale por célula da grade no PNG (padrão `15`, o mesmo que o mini.nvim usa pro README deles — `15 * 7 = 105px` de altura).
- Cada argumento de texto pode levar sua própria `:COR` pro modo PNG (padrão `#D9D8AA`). Vários argumentos só são concatenados — sem espaço entre eles — porque cada glifo já carrega sua própria coluna em branco à direita.
- Só existem `a-z`, `0-9` e espaço. Qualquer outro caractere vira uma célula em branco.
- **Letra estilizada (2 cores numa letra só):** pra uma letra individual, `LETRA:COR1,COR2` pinta parte do próprio glifo numa cor e o resto noutra — é o mesmo tratamento que o mini.nvim dá pro "n" do logo deles. Só funciona pra um caractere por vez, e só existe pra letras com um estilo definido no script (hoje: `o`, `n`). Não é automático nem "inteligente" — é uma tabelinha `style[]` opcional que você adiciona à mão quando quiser esse efeito numa letra nova.

  ```
  pixogram -o logo.png "pix:#B3DAF9" "o:#B3DAF9,#D9D8AA" "gram:#D9D8AA"
  ```

## Instalação

```
make install               # instala em ~/.local/bin/pixogram
make install PREFIX=/usr   # ou em outro prefixo
make uninstall
```

Só precisa de `sh` POSIX (testado com `dash`), `awk` e, pro modo `-o`, `magick` (ImageMagick 7).

## Créditos

Todo o crédito da fonte e da técnica é de **[Evgeni Chasnovski](https://github.com/echasnovski)** ([@echasnovski](https://github.com/echasnovski)), autor do [mini.nvim](https://github.com/nvim-mini/mini.nvim). A grade de pixels de cada letra foi transcrita pixel a pixel dos arquivos [`logo-2/font/*.gif`](https://github.com/nvim-mini/assets/tree/main/logo-2/font) do repositório [nvim-mini/assets](https://github.com/nvim-mini/assets) (MIT License), que é o gerador real por trás do logo do mini.nvim (`logo-2/generate.lua`). As cores padrão (`#00182A` fundo, `#D9D8AA` letra) também vêm de lá.

`pixogram` não teria existido sem esse trabalho — é essencialmente uma reimplementação da mesma ideia em `sh` POSIX + `awk`, pra gerar texto qualquer em vez de só os módulos do mini.nvim. Ver [LICENSE](LICENSE) pro aviso de copyright completo.
