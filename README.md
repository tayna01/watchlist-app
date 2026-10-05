# watchlist-app

Watchlist de filmes em **Flutter Web**, com busca na API da **TMDB** e
armazenamento no **Cloud Firestore**. O app tem duas telas: **Busca**, onde os
filmes populares são carregados e podem ser pesquisados por título, e
**Minha Lista**, com as listas "Quero Ver" e "Já Vi" atualizadas em tempo real.

## Funcionalidades

- Listar os filmes populares da TMDB em uma grade de pôsteres
- Buscar filmes pelo título
- Abrir a tela de detalhes com pôster, nota, ano e sinopse
- Salvar um filme como "Quero Ver" ou "Já Vi"
- Mover um filme entre as listas e remover da lista
- Listas em tempo real via `StreamBuilder` do Firestore
- Tema escuro inspirado no IMDb, responsivo e com limite de largura para telas grandes

## Como rodar

Pré-requisitos: Flutter SDK, Chrome e um projeto no Firebase com o Firestore
habilitado.

```bash
flutter pub get
flutter run -d chrome
```

O token da TMDB é lido de uma variável de ambiente chamada `TMDB_TOKEN` e não
fica no código:

```bash
flutter run -d chrome --dart-define=TMDB_TOKEN=seu_token_aqui
```

## Testes e análise estática

```bash
dart format lib
flutter analyze
flutter test
```

## Tecnologias

| Tecnologia | Uso |
|---|---|
| Flutter 3.41 | Interface e build web |
| Firebase Core | Inicialização do app |
| Cloud Firestore | Persistência das listas |
| TMDB API | Busca de filmes, pôsteres, notas e sinopse |
| google_fonts | Tipografia (Poppins e Bebas Neue) |

## Estrutura do projeto

```
lib/
  main.dart              App, tema e navegação inferior
  theme/app_theme.dart   Paleta, tipografia e estilos globais
  models/filme.dart      Modelo do filme
  services/
    tmdb_service.dart    Chamadas à API da TMDB
    firestore_service.dart Gravação e leitura das listas
  screens/
    busca_screen.dart    Busca e grade de pôsteres
    minha_lista_screen.dart  Listas "Quero Ver" e "Já Vi"
    detalhes_screen.dart Detalhes, nota, ano e sinopse
  widgets/               Widgets reutilizáveis da interface
test/
  widget_test.dart       Testes do tema e dos widgets da interface
  filme_test.dart        Testes do modelo de dados
```

## Documentação

A identidade visual, a paleta, as fontes e as decisões de design estão
descritas em [DOCUMENTACAO.md](DOCUMENTACAO.md).
