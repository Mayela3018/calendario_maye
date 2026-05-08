import 'package:flutter/material.dart';
import 'colores.dart';

// ════════════════════════════════════════════
//  NOTIFIER — guarda si estamos en modo oscuro
//  Semana 8: patrón similar a Provider/ChangeNotifier
// ════════════════════════════════════════════
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  bool get esModoOscuro => value == ThemeMode.dark;

  void toggleTema() {
    value = esModoOscuro ? ThemeMode.light : ThemeMode.dark;
  }
}

// ════════════════════════════════════════════
//  TEMA OSCURO
// ════════════════════════════════════════════
final temaOscuro = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kFondoOsc,
  colorScheme: const ColorScheme.dark(
    primary: kRosa,
    secondary: kRosaClaro,
    surface: kSuperficieOsc,
  ),
  cardColor: kSuperficieOsc,
  dividerColor: kRosa,
  extensions: const [_ColoresExtra(
    fondo: kFondoOsc,
    superficie: kSuperficieOsc,
    superficie2: kSuperficie2Osc,
    texto: Color(0xFFF5EEF8),
    textoSec: Color(0xFFC9B8D4),
  )],
);

// ════════════════════════════════════════════
//  TEMA CLARO
// ════════════════════════════════════════════
final temaClaro = ThemeData.light().copyWith(
  scaffoldBackgroundColor: kFondoCla,
  colorScheme: const ColorScheme.light(
    primary: kRosa,
    secondary: kMorado,
    surface: kSuperficieCla,
  ),
  cardColor: kSuperficieCla,
  dividerColor: kRosa,
  extensions: const [_ColoresExtra(
    fondo: kFondoCla,
    superficie: kSuperficieCla,
    superficie2: kSuperficie2Cla,
    texto: Color(0xFF2A1A2E),
    textoSec: Color(0xFF7A3F7E),
  )],
);

// ════════════════════════════════════════════
//  EXTENSIÓN para acceder a colores según tema
//  Uso: Theme.of(context).ext.texto
// ════════════════════════════════════════════
class _ColoresExtra extends ThemeExtension<_ColoresExtra> {
  final Color fondo;
  final Color superficie;
  final Color superficie2;
  final Color texto;
  final Color textoSec;

  const _ColoresExtra({
    required this.fondo,
    required this.superficie,
    required this.superficie2,
    required this.texto,
    required this.textoSec,
  });

  @override
  ThemeExtension<_ColoresExtra> copyWith({
    Color? fondo, Color? superficie, Color? superficie2,
    Color? texto, Color? textoSec,
  }) => _ColoresExtra(
    fondo: fondo ?? this.fondo,
    superficie: superficie ?? this.superficie,
    superficie2: superficie2 ?? this.superficie2,
    texto: texto ?? this.texto,
    textoSec: textoSec ?? this.textoSec,
  );

  @override
  ThemeExtension<_ColoresExtra> lerp(ThemeExtension<_ColoresExtra>? other, double t) {
    if (other is! _ColoresExtra) return this;
    return _ColoresExtra(
      fondo: Color.lerp(fondo, other.fondo, t)!,
      superficie: Color.lerp(superficie, other.superficie, t)!,
      superficie2: Color.lerp(superficie2, other.superficie2, t)!,
      texto: Color.lerp(texto, other.texto, t)!,
      textoSec: Color.lerp(textoSec, other.textoSec, t)!,
    );
  }
}

// Helper para acceder fácil desde cualquier widget
extension ThemeExt on BuildContext {
  _ColoresExtra get ext => Theme.of(this).extension<_ColoresExtra>()!;
}