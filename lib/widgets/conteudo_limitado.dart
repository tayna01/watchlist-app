import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ConteudoLimitado extends StatelessWidget {
  const ConteudoLimitado({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.larguraMaxima),
        child: child,
      ),
    );
  }
}
