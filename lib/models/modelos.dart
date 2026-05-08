import 'package:flutter/material.dart';

// ════════════════════════════════════════════
//  MODELO EVENTO
//  Semana 2: Clase con propiedades y constructor
// ════════════════════════════════════════════
class Evento {
  String titulo;
  String hora;
  Color color;
  String emoji;
  bool completado;

  Evento({
    required this.titulo,
    required this.hora,
    required this.color,
    required this.emoji,
    this.completado = false,
  });
}

// ════════════════════════════════════════════
//  MODELO NOTA
// ════════════════════════════════════════════
class Nota {
  String titulo;
  String contenido;
  DateTime fecha;
  Color color;

  Nota({
    required this.titulo,
    required this.contenido,
    required this.fecha,
    required this.color,
  });
}