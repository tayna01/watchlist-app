import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:watchlist_flutter_firestore/models/filme.dart';
import 'package:watchlist_flutter_firestore/theme/app_theme.dart';
import 'package:watchlist_flutter_firestore/widgets/app_brand.dart';
import 'package:watchlist_flutter_firestore/widgets/app_snack.dart';
import 'package:watchlist_flutter_firestore/widgets/estado_vazio.dart';
import 'package:watchlist_flutter_firestore/widgets/filme_cartao.dart';
import 'package:watchlist_flutter_firestore/widgets/item_lista.dart';
import 'package:watchlist_flutter_firestore/widgets/nota_selo.dart';
import 'package:watchlist_flutter_firestore/widgets/poster_filme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Filme filmeDeTeste({double? nota = 7.8}) {
    return Filme(
      id: 1,
      title: 'Matrix',
      overview: 'Um hacker descobre a verdade.',
      voteAverage: nota,
    );
  }

  Widget hospedar(Widget child) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
    );
  }

  group('Tema', () {
    testWidgets('aplica a paleta e a tipografia do app', (tester) async {
      late ThemeData tema;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) {
              tema = Theme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(tema.scaffoldBackgroundColor, AppColors.fundo);
      expect(tema.colorScheme.primary, AppColors.destaque);
      expect(tema.colorScheme.surface, AppColors.superficie);
      expect(tema.textTheme.bodyLarge?.color, AppColors.textoPrimario);
      expect(tema.textTheme.bodyMedium?.color, AppColors.textoSecundario);
      expect(tema.textTheme.bodyLarge?.fontFamily, isNotNull);
      expect(tema.textTheme.headlineLarge?.fontFamily, isNotNull);
      expect(tema.snackBarTheme.behavior, SnackBarBehavior.floating);
      expect(tema.navigationBarTheme.backgroundColor, AppColors.superficie);
      expect(tema.tabBarTheme.indicatorColor, AppColors.destaque);
    });
  });

  group('AppBrandBar', () {
    testWidgets('mostra o nome do app e o subtitulo da tela', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(appBar: const AppBrandBar(subtitulo: 'BUSCA')),
        ),
      );

      expect(find.text('Watch List App'), findsOneWidget);
      expect(find.text('BUSCA'), findsOneWidget);
      expect(find.byIcon(Icons.theaters_rounded), findsOneWidget);
    });
  });

  group('PosterFilme', () {
    testWidgets('mostra o placeholder quando o filme nao tem poster', (
      tester,
    ) async {
      await tester.pumpWidget(hospedar(const PosterFilme(url: null)));

      expect(find.byIcon(Icons.movie_rounded), findsOneWidget);
    });

    testWidgets('mostra o placeholder quando a imagem falha', (tester) async {
      await tester.pumpWidget(
        hospedar(const PosterFilme(url: 'https://exemplo.invalido/poster.jpg')),
      );
      await tester.pump();

      expect(find.byIcon(Icons.movie_rounded), findsOneWidget);
    });
  });

  group('NotaSelo', () {
    testWidgets('mostra a nota com uma casa decimal', (tester) async {
      await tester.pumpWidget(hospedar(const NotaSelo(nota: 7.86)));

      expect(find.text('7.9'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('nao mostra nada quando a nota e nula', (tester) async {
      await tester.pumpWidget(hospedar(const NotaSelo(nota: null)));

      expect(find.byType(Icon), findsNothing);
    });
  });

  group('EstadoVazio', () {
    testWidgets('mostra icone, titulo e mensagem', (tester) async {
      await tester.pumpWidget(
        hospedar(
          const EstadoVazio(
            icone: Icons.search_off_rounded,
            titulo: 'Nenhum resultado',
            mensagem: 'Tente outro título.',
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
      expect(find.text('Nenhum resultado'), findsOneWidget);
      expect(find.text('Tente outro título.'), findsOneWidget);
    });
  });

  group('FilmeCartao', () {
    testWidgets('mostra o titulo, a nota e chama o onTap', (tester) async {
      var tocar = false;
      final filme = filmeDeTeste();

      await tester.pumpWidget(
        hospedar(
          SizedBox(
            width: 200,
            height: 350,
            child: FilmeCartao(filme: filme, onTap: () => tocar = true),
          ),
        ),
      );

      expect(find.text('Matrix'), findsOneWidget);
      expect(find.text('7.8'), findsOneWidget);

      await tester.tap(find.byType(FilmeCartao));
      expect(tocar, isTrue);
    });
  });

  group('ItemLista', () {
    testWidgets('mostra o titulo, a nota e a etiqueta da lista', (
      tester,
    ) async {
      await tester.pumpWidget(
        hospedar(
          ItemLista(
            filme: filmeDeTeste(),
            status: 'ja_vi',
            onMover: () {},
            onRemover: () {},
          ),
        ),
      );

      expect(find.text('Matrix'), findsOneWidget);
      expect(find.text('7.8'), findsOneWidget);
      expect(find.text('Já vi'), findsOneWidget);
    });

    testWidgets('o menu dispara a acao de remover', (tester) async {
      var removeu = false;

      await tester.pumpWidget(
        hospedar(
          ItemLista(
            filme: filmeDeTeste(),
            status: 'quero_ver',
            onMover: () {},
            onRemover: () => removeu = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover da lista'));
      await tester.pumpAndSettle();

      expect(removeu, isTrue);
    });

    testWidgets('o menu dispara a acao de mover', (tester) async {
      var moveu = false;

      await tester.pumpWidget(
        hospedar(
          ItemLista(
            filme: filmeDeTeste(),
            status: 'quero_ver',
            onMover: () => moveu = true,
            onRemover: () {},
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Marcar como Já Vi'));
      await tester.pumpAndSettle();

      expect(moveu, isTrue);
    });
  });

  group('AppSnack', () {
    testWidgets('mostra um SnackBar flutuante com a mensagem', (tester) async {
      await tester.pumpWidget(
        hospedar(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => AppSnack.mostrar(context, 'Salvo com sucesso'),
                child: const Text('salvar'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('salvar'));
      await tester.pump();

      expect(find.text('Salvo com sucesso'), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.margin, const EdgeInsets.all(16));
    });
  });
}
