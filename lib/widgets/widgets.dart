import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../theme/app_theme.dart';
import '../theme/colores.dart';

// ════════════════════════════════════════════
//  CELDA DÍA — widget del grid del calendario
//  Semana 4: prefer const donde sea posible
// ════════════════════════════════════════════
class CeldaDia extends StatelessWidget {
  final DateTime dia;
  final DateTime hoy;
  final DateTime? seleccionado;
  final bool tieneEventos;
  final VoidCallback onTap;

  const CeldaDia({
    super.key,
    required this.dia,
    required this.hoy,
    required this.seleccionado,
    required this.tieneEventos,
    required this.onTap,
  });

  bool get _esHoy =>
      dia.year == hoy.year && dia.month == hoy.month && dia.day == hoy.day;

  bool get _esSel =>
      seleccionado != null &&
      dia.year == seleccionado!.year &&
      dia.month == seleccionado!.month &&
      dia.day == seleccionado!.day;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: _esSel
                ? const LinearGradient(
                    colors: [kMorado, kRosa],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _esSel
                ? null
                : _esHoy
                    ? kRosa.withOpacity(0.12)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: _esHoy && !_esSel
                ? Border.all(color: kRosa.withOpacity(0.6), width: 1.2)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${dia.day}',
                style: TextStyle(
                  color: _esSel
                      ? Colors.white
                      : _esHoy
                          ? kRosaClaro
                          : context.ext.texto.withOpacity(0.85),
                  fontSize: 14,
                  fontWeight:
                      _esHoy || _esSel ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
              if (tieneEventos)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _esSel ? Colors.white : kPastel,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  TARJETA EVENTO — item de la lista
// ════════════════════════════════════════════
class TarjetaEvento extends StatelessWidget {
  final Evento evento;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const TarjetaEvento({
    super.key,
    required this.evento,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${evento.titulo}-${evento.hora}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: evento.color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: evento.color.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: evento.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(evento.emoji, style: const TextStyle(fontSize: 17)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  evento.titulo,
                  style: TextStyle(
                    color: evento.completado
                        ? context.ext.textoSec
                        : context.ext.texto,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    decoration: evento.completado
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  evento.hora,
                  style: TextStyle(color: evento.color.withOpacity(0.8), fontSize: 11),
                ),
              ]),
            ),
            Icon(
              evento.completado
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: evento.completado
                  ? kRosaClaro
                  : context.ext.textoSec.withOpacity(0.3),
              size: 20,
            ),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  TARJETA NOTA — item del grid
// ════════════════════════════════════════════
class TarjetaNota extends StatelessWidget {
  final Nota nota;
  final VoidCallback onLongPress;

  const TarjetaNota({
    super.key,
    required this.nota,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.ext.superficie,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: nota.color.withOpacity(0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: nota.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${nota.fecha.day} ${meses[nota.fecha.month - 1]}',
              style: TextStyle(
                color: nota.color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nota.titulo,
            style: TextStyle(
              color: context.ext.texto,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              nota.contenido,
              style: TextStyle(
                color: context.ext.textoSec.withOpacity(0.7),
                fontSize: 12,
                height: 1.5,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  BOTÓN NAV — flecha izq/der del calendario
//  Semana 5: función con argumentos
// ════════════════════════════════════════════
class BtnNav extends StatelessWidget {
  final IconData icono;
  final VoidCallback onTap;

  const BtnNav({super.key, required this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.ext.superficie2,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: kRosa.withOpacity(0.25)),
        ),
        child: Icon(icono, color: kRosaClaro, size: 17),
      ),
    );
  }
}