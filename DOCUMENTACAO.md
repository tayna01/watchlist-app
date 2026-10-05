# watchlist-app

Aplicativo Flutter Web de watchlist de filmes. Busca filmes na API da TMDB e
salva em duas listas no Cloud Firestore: "Quero Ver" e "Já Vi".

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

---

# Estilização e identidade visual

Esta seção descreve todo o trabalho de redesign feito no app, que antes usava o
Material padrão (tema roxo claro gerado por `ColorScheme.fromSeed`, `ListTile`
simples e textos soltos no centro das telas).

A referência visual foi o site do IMDb: fundo quase preto, superfícies em cinza
escuro e um único amarelo de destaque. O objetivo foi dar aparência de produto
pronto, sem mexer em nenhuma lógica, serviço, modelo de dados, query do
Firestore ou chamada da TMDB.

## 1. Paleta de cores

Todas as cores estão centralizadas em `AppColors`, dentro de
`lib/theme/app_theme.dart`. Nenhuma cor aparece "escrita à mão" nas telas.

| Hexadecimal | Nome no código | Onde é usada |
|---|---|---|
| `#121212` | `AppColors.fundo` | Fundo do app (`scaffoldBackgroundColor`), cor de fundo dos botões amarelos e do texto sobre o amarelo. Também é a superfície mais escura do `ColorScheme`. |
| `#1F1F1F` | `AppColors.superficie` | Fundo das AppBars, da NavigationBar, dos cards, do `CardTheme`, dos campos de texto, do diálogo e do `PopupMenu`. |
| `#2A2A2A` | `AppColors.elevada` | Superfícies "por cima": chip com a contagem de filmes, placeholder do pôster, trilho dos indicadores de progresso, SnackBar e estado desabilitado dos botões. |
| `#F5C518` | `AppColors.destaque` | Amarelo IMDb. `primary` do `ColorScheme`. Usado nos botões principais, no ícone e no texto ativos da NavigationBar, no indicador e no rótulo da TabBar, no selo de nota, no rótulo "Sinopse" e no estado de foco do teclado. |
| `#FFFFFF` | `AppColors.textoPrimario` | Títulos e textos principais, `onSurface` do `ColorScheme`. |
| `#B3B3B3` | `AppColors.textoSecundario` | Subtítulos, sinopse, metadados, placeholders, ícones inativos e estado vazio. |
| `#303030` | `AppColors.borda` | Contorno de 1 px dos cards, borda dos campos de texto e divisores. Dá separação sem clarear, deixando o visual "chapado". |
| `#3FAE6A` | `AppColors.sucesso` | Verde discreto de apoio: aba "Já Vi", etiqueta "Já vi", "Marcar como Já Vi", ícone `check_rounded` e SnackBar de salvar ou mover. |
| `#E0524B` | `AppColors.perigo` | Vermelho discreto de apoio: "Remover da lista", estado de erro e SnackBar de remoção. |
| `#EDEDED` | (no `app_theme.dart`, só no botão) | Fundo do botão claro "Já Vi" na tela de detalhes. |

Justificativa: fundo e superfícies em cinza quase preto dão o contraste de
"cinema" sem ser 100% preto, e o amarelo serve como único ponto de atenção, o
que faz o usuário saber na hora onde pode clicar.

## 2. Fontes e ícones

**Fontes (duas famílias, via pacote `google_fonts`):**

- **Poppins** para todo o texto do app: corpo, botões, campos, legendas.
  Escolhida por ser geométrica, arredondada e muito legível em tela pequena,
  além de ter todos os pesos (400, 500, 600, 700) que o Material usa.
- **Bebas Neue** só em `display`, `headline` e no `titleTextStyle` da AppBar.
  Escolhida por ser uma fonte condensada, em caixa alta, que lembra cartaz de
  cinema e a marca do IMDb. Como é condensada, ela só funciona bem em tamanho
  grande, por isso fica restrita aos títulos.

As duas famílias estão declaradas em `AppTheme.dark`: o `TextTheme` é gerado a
partir de `GoogleFonts.poppinsTextTheme(...)` e os estilos de título são
substituídos por `GoogleFonts.bebasNeue(...)`. Como o `google_fonts` baixa as
fontes do Google Fonts em runtime, não foi necessário declarar `fonts:` no
`pubspec.yaml` nem versionar arquivos `.ttf` no repositório.

**Ícones:** todos em Material Icons na variante `_rounded`
(`Icons.search_rounded`, `Icons.theaters_rounded`, `Icons.star_rounded`,
`Icons.movie_rounded`, entre outros), para manter um traço arredondado
coerente com os cantos de 8 a 12 px do resto do app.

**Cantos arredondados** ficam em `AppRadius`: `card` 12 px, `campo` e `botao`
10 px, `selo` 8 px. Assim o mesmo raio é reutilizado em cards, campos, botões,
diálogos e SnackBars.

## 3. Arquivos criados

| Arquivo | Responsabilidade |
|---|---|
| `lib/theme/app_theme.dart` | `AppColors`, `AppRadius`, `AppLayout` e `AppTheme.dark` com `ColorScheme`, `TextTheme`, AppBar, NavigationBar, TabBar, botões, campos, cards, SnackBar, diálogo, popup, progresso, divisores e scrollbar. |
| `lib/widgets/app_brand.dart` | `AppBrandBar`: AppBar com o claquete, o nome "Watch List App" e o subtítulo da tela; aceita `bottom` para as abas. |
| `lib/widgets/app_snack.dart` | `AppSnack.mostrar`: SnackBar flutuante padronizado com ícone colorido. |
| `lib/widgets/poster_filme.dart` | `PosterFilme`: pôster da TMDB com fade no carregamento e placeholder no erro. |
| `lib/widgets/nota_selo.dart` | `NotaSelo`: selo amarelo com estrela e nota. |
| `lib/widgets/filme_cartao.dart` | `FilmeCartao`: card de pôster da grade de busca. |
| `lib/widgets/item_lista.dart` | `ItemLista`: card horizontal da Minha Lista com menu de ações. |
| `lib/widgets/estado_vazio.dart` | `EstadoVazio`: ícone grande, título e mensagem (vazio, sem resultado e erro). |
| `lib/widgets/conteudo_limitado.dart` | `ConteudoLimitado`: centraliza e limita o conteúdo em 1100 px. |

## 4. Arquivos alterados

| Arquivo | O que mudou |
|---|---|
| `pubspec.yaml` | Adicionada a dependência `google_fonts`. |
| `lib/main.dart` | Aplicado `theme: AppTheme.dark`; `BottomNavigationBar` trocada por `NavigationBar`; título do app e da aba do navegador ajustados para "Watch List App"; `debugShowCheckedModeBanner: false`. |
| `lib/screens/busca_screen.dart` | Corpo da tela: campo com lupa, botão "Buscar" com ícone, título de seção com contador, grade de pôsteres responsiva, estado de carregamento e estado sem resultado estilizados. |
| `lib/screens/minha_lista_screen.dart` | Cards horizontais estilizados com `ItemLista`, `EstadoVazio` para lista vazia e para erro, SnackBars flutuantes com ícone, lista com espaçamento e largura limitada. |
| `lib/screens/detalhes_screen.dart` | Pôster grande com sombra, título em destaque, selo de nota, metadados, sinopse legível, dois botões claros e layout lado a lado ou empilhado. |
| `lib/models/filme.dart` | Adicionado o campo `releaseDate`, lido do `release_date` da TMDB e salvo no Firestore, com o getter `ano` que extrai os 4 primeiros dígitos da data. É a única alteração de modelo, feita para exibir o ano na tela de detalhes. |
| `lib/widgets/item_lista.dart` | O texto dos itens do menu passou a ficar dentro de um `Flexible`, para o rótulo quebrar em duas linhas em vez de estourar a largura do menu. |
| `pubspec.yaml` | Removidos os comentários padrão do Flutter gerado automaticamente. |
| `README.md` | Reescrito com descrição, funcionalidades, como rodar, tecnologias e estrutura do projeto. |
| `test/widget_test.dart` | Substituído o teste padrão do contador por 12 testes do tema e dos widgets. |
| `test/filme_test.dart` | Novo arquivo com 4 testes do modelo, incluindo a extração do ano. |

**Não foram alterados:** `lib/services/firestore_service.dart`,
`lib/services/tmdb_service.dart`, `lib/firebase_options.dart`. As queries
(`where('status', isEqualTo: status)`), os métodos de gravação, atualização e
remoção e as chamadas à TMDB continuam exatamente iguais.

## 5. Testes automatizados

O arquivo `test/widget_test.dart` que existia era o teste padrão do contador
do Flutter e **já falhava** antes do redesign, porque procurava `Icons.add` e o
texto `"0"`, que não existem neste app. Foi substituído por testes que
verificam justamente as partes visuais difíceis de conferir na tela:

| Teste | O que garante |
|---|---|
| Tema | Cor de fundo, cor primária, cor de superfície, cores dos textos, fonte do corpo e do título, SnackBar flutuante, cor da NavigationBar e indicador da TabBar |
| `AppBrandBar` | Nome do app, subtítulo da tela e ícone de claquete |
| `PosterFilme` | Placeholder quando o filme não tem pôster e quando a URL da imagem falha |
| `NotaSelo` | Nota com uma casa decimal e string vazia quando a nota é nula |
| `EstadoVazio` | Ícone, título e mensagem |
| `FilmeCartao` | Título, nota e disparo do `onTap` |
| `ItemLista` | Título, nota, etiqueta da lista e disparo das ações mover e remover pelo menu |
| `AppSnack` | Mensagem exibida e margem flutuante do SnackBar |

O arquivo `test/filme_test.dart` cobre o modelo: leitura do `release_date` da
TMDB, ano nulo quando a data falta ou é inválida, montagem da URL do pôster e
leitura do ano e do status vindos do Firestore.

Resultado: `16 testes passando` (`00:01 +16: All tests passed!`).

Esses testes também resolveram uma pendência prática: o `errorBuilder` do
pôster e o estado de erro da lista eram difíceis de ver no navegador, porque
dependem de falha de rede. Agora são verificados de forma determinística, sem
precisar desligar a internet.

## 6. Passo a passo e comandos executados

```bash
# 1. Dependência e fontes
flutter pub add google_fonts

# 2. Tema global em lib/theme/app_theme.dart + ligação no MaterialApp

# 3. AppBar com identidade e NavigationBar

# 4. Busca: widgets reutilizáveis e grade de pôsteres

# 5. Minha Lista: cards, estados vazio e erro, SnackBars

# 6. Detalhes: pôster, título, nota, sinopse e botões

# 7. Responsividade (limite de 1100 px) e acabamentos

# Validação a cada etapa
dart format lib
flutter analyze
flutter run -d chrome
flutter build web --release

# Validação dos testes
flutter test
```

Resultado final da validação: `dart format` sem mudanças pendentes,
`flutter analyze` com "No issues found", `flutter test` com os 16 testes
passando e `flutter build web --release` compilado com sucesso em cerca de 82
segundos.

## 7. Problemas encontrados e soluções

1. **`indicatorWeight` não existe em `TabBarThemeData`.** O parâmetro pertence
   ao widget `TabBar`. Solução: o tema cuida da cor do indicador e o peso foi
   passado direto no `TabBar` da Minha Lista (`indicatorWeight: 3`).
2. **`ColorScheme.fromSeed` não deixa escolher as duas superfícies.** Ele gera
   as cores a partir de uma cor semente e não atende a exigência de ter
   `#1F1F1F` em cards e `#2A2A2A` em superfícies elevadas. Solução: usar
   `ColorScheme.dark(...)` com todos os campos preenchidos à mão, incluindo
   `surfaceContainerLow`, `surfaceContainer` e `surfaceContainerHigh`.
3. **`Icons.swap_hor_rounded` não existe** na biblioteca Material Icons. Ao
   procurar depois de compilar, o analisador acusou o erro. Solução: usar
   `Icons.swap_horiz_rounded`.
4. **`loadingBuilder` do `Image.network` não devolve um número.** Ele entrega um
   `ImageChunkEvent`, e a primeira versão do código tentou usar o valor como
   se fosse um número. Solução: calcular a fração com
   `cumulativeBytesLoaded / expectedTotalBytes` e usar isso na opacidade.
5. **Arquivos editados por comando do PowerShell ficaram invisíveis para o
   analisador.** Depois de usar `Set-Content` para renomear uma variável, o
   `flutter analyze` passou a acusar `Target of URI doesn't exist:
   'detalhes_screen.dart'` mesmo com o arquivo existindo, abrindo e sendo
   lido normalmente. O diagnóstico foi usar arquivos de teste: um arquivo novo
   criado pela ferramenta de edição resolvia o import, o arquivo editado pelo
   PowerShell não. Solução: regra de trabalho, nunca editar arquivo com comando
   de terminal, sempre pelas ferramentas de edição, e recriar o arquivo
   afetado.
6. **O modelo de dados não tinha o ano do filme.** `Filme` só tinha `id`,
   `title`, `overview`, `posterPath` e `voteAverage`, e a TMDB devolve o ano em
   `release_date`. Durante o redesign o ano ficou de fora para não alterar o
   modelo nem as chamadas da API, e no lugar dele aparecia o id do filme. Com a
   autorização posterior, o campo `releaseDate` foi incluído no modelo, lido do
   `fromTmdbJson`, salvo pelo `toMap` e lido de volta pelo `fromFirestoreMap`,
   para que o ano não se perca ao salvar no Firestore. A extração do ano ficou
   no getter `ano`, que devolve `null` quando a data está ausente ou incompleta,
   e assim a tela não quebra.
7. **`test/widget_test.dart` era o teste padrão do contador do Flutter** e já
   estava quebrado antes do redesign, porque procura `Icons.add` e o texto "0",
   que não existem neste app. Como não dá para rodar `flutter test` com um
   arquivo quebrado, ele foi substituído por testes dos widgets e do tema, e
   criado o `test/filme_test.dart` para o modelo.
8. **Os itens do menu de ações estouravam a largura.** O primeiro teste do
   `ItemLista` reprovou com `A RenderFlex overflowed by 14 pixels on the right`,
   porque o ícone e o texto "Marcar como Quero Ver" não cabiam nos 256 px do
   `PopupMenu`. Solução: envolver o texto em `Flexible`, deixando o rótulo
   quebrar em duas linhas. Erro esse não aparecia na tela com o card centralizado
   e só foi encontrado porque o teste cobre o menu de verdade.
9. **`behavior` do `SnackBar` chega como `null` no teste.** O atributo vem do
   `SnackBarTheme` e não é copiado para o widget. Solução: o teste passa a
   conferir a margem, que é definida diretamente no `AppSnack`, e a checagem do
   comportamento flutuante continua no teste do tema.
10. **Arredondamento de nota no teste.** `7.85.toStringAsFixed(1)` devolve
   `"7.8"` por causa da representação binária do número, então o teste que
   esperava `"7.9"` reprovou. Solução: usar `7.86` como entrada, que arredonda
   de forma previsível.

## 8. Decisões de design para a apresentação

O app adota um tema escuro inspirado no IMDb para que o foco esteja no
conteúdo, que são os pôsteres, e não em decorações: o fundo é quase preto, os
cards são cinza escuro com contorno de 1 px e apenas um vermelho e um verde bem
discretos dão significado às ações. O amarelo `#F5C518` foi escolhido como
única cor de destaque e aparece sempre no mesmo lugar: botões principais, aba
ativa da navegação, indicador das abas, selo de nota e rótulo de seção. Assim o
usuário aprende a leitura do app em poucos segundos. As fontes também
trabalham nessa direção: Poppins garante leitura confortável em textos
pequenos e Bebas Neue, por ser condensada e em caixa alta, dá cara de cartaz de
cinema nos títulos. Todos os cantos entre 8 e 12 px, o espaçamento em múltiplos
de 4 e as sombras suaves mantêm o conjunto coerente. Para o navegador, o
conteúdo foi limitado a 1100 px e centralizado, e a grade de pôsteres recalcula
o número de colunas conforme a largura da janela, de 2 a 5, evitando cartões
esticados em telas grandes. Por fim, os elementos que se repetem foram
transformados em widgets reutilizáveis (`PosterFilme`, `NotaSelo`,
`FilmeCartao`, `ItemLista`, `EstadoVazio`, `AppSnack`, `AppBrandBar`), o que
evita duplicação e facilita manter o visual padrão em todo o app.
