import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../theme/app_theme.dart';
import '../theme/colores.dart';

// ════════════════════════════════════════════
//  DIALOG NUEVO EVENTO
//  Semana 7: TextFormField con validación
//  Semana 2: StatefulWidget con clase propia
// ════════════════════════════════════════════
class DialogEvento extends StatefulWidget {
  final DateTime fecha;
  final Function(Evento) onGuardar;

  const DialogEvento({
    super.key,
    required this.fecha,
    required this.onGuardar,
  });

  @override
  State<DialogEvento> createState() => _DialogEventoState();
}

class _DialogEventoState extends State<DialogEvento> {
  final _titCtrl = TextEditingController();
  final _horaCtrl = TextEditingController(text: '9:00 AM');
  Color _color = kRosa;
  String _emoji = '📌';

  final _colores = kColoresTarea;
  final _emojis = ['📌','🎯','💼','🎨','🚀','📚','🏋️','🍽️','🎉','💡','🌸','⭐'];

  @override
  void dispose() {
    _titCtrl.dispose();
    _horaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Container(
      decoration: BoxDecoration(
        color: ext.superficie,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 34,
              height: 4,
              decoration: BoxDecoration(
                color: kRosa.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [kRosaClaro, kPastel],
            ).createShader(b),
            child: const Text(
              'Nuevo Evento',
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          _campo(context, 'Título del evento', _titCtrl, Icons.title_outlined),
          const SizedBox(height: 10),
          _campo(context, 'Hora (ej: 10:00 AM)', _horaCtrl, Icons.access_time_outlined),
          const SizedBox(height: 14),
          Text('Elige un emoji', style: TextStyle(color: ext.textoSec, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _emojis.map((e) => GestureDetector(
              onTap: () => setState(() => _emoji = e),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: _emoji == e ? kRosa.withOpacity(0.2) : ext.superficie2,
                  borderRadius: BorderRadius.circular(9),
                  border: _emoji == e ? Border.all(color: kRosaClaro) : null,
                ),
                child: Center(child: Text(e, style: const TextStyle(fontSize: 19))),
              ),
            )).toList(),
          ),
          const SizedBox(height: 14),
          Text('Color', style: TextStyle(color: ext.textoSec, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: _colores.map((c) => GestureDetector(
              onTap: () => setState(() => _color = c),
              child: Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: _color == c ? Border.all(color: Colors.white, width: 2) : null,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                if (_titCtrl.text.trim().isEmpty) return;
                widget.onGuardar(Evento(
                  titulo: _titCtrl.text.trim(),
                  hora: _horaCtrl.text.trim(),
                  color: _color,
                  emoji: _emoji,
                ));
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kMorado, kRosa, kRosaClaro]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Guardar evento',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Semana 5: función con argumentos
  Widget _campo(BuildContext context, String hint, TextEditingController c, IconData ic) {
    final ext = context.ext;
    return TextField(
      controller: c,
      style: TextStyle(color: ext.texto),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ext.textoSec.withOpacity(0.45)),
        prefixIcon: Icon(ic, color: kRosaClaro, size: 19),
        filled: true,
        fillColor: ext.superficie2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRosaClaro),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  DIALOG NUEVA NOTA
//  Semana 7: múltiples TextFormField
// ════════════════════════════════════════════
class DialogNota extends StatefulWidget {
  final Function(Nota) onGuardar;
  const DialogNota({super.key, required this.onGuardar});

  @override
  State<DialogNota> createState() => _DialogNotaState();
}

class _DialogNotaState extends State<DialogNota> {
  final _titCtrl = TextEditingController();
  final _contCtrl = TextEditingController();
  Color _color = kRosa;
  final _colores = kColoresTarea;

  @override
  void dispose() {
    _titCtrl.dispose();
    _contCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return Container(
      decoration: BoxDecoration(
        color: ext.superficie,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 34, height: 4,
              decoration: BoxDecoration(
                color: kRosa.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [kRosaClaro, kPastel],
            ).createShader(b),
            child: const Text(
              'Nueva Nota',
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          // Semana 7: TextField / TextFormField
          TextField(
            controller: _titCtrl,
            style: TextStyle(color: ext.texto),
            decoration: InputDecoration(
              hintText: 'Título de la nota',
              hintStyle: TextStyle(color: ext.textoSec.withOpacity(0.45)),
              prefixIcon: const Icon(Icons.title_outlined, color: kRosaClaro, size: 19),
              filled: true, fillColor: ext.superficie2,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRosaClaro)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contCtrl,
            style: TextStyle(color: ext.texto, fontSize: 14),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Escribe lo que quieras recordar...',
              hintStyle: TextStyle(color: ext.textoSec.withOpacity(0.45)),
              filled: true, fillColor: ext.superficie2,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRosaClaro)),
            ),
          ),
          const SizedBox(height: 14),
          Text('Color de la nota', style: TextStyle(color: ext.textoSec, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: _colores.map((c) => GestureDetector(
              onTap: () => setState(() => _color = c),
              child: Container(
                width: 28, height: 28,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: c, shape: BoxShape.circle,
                  border: _color == c ? Border.all(color: Colors.white, width: 2) : null,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                if (_titCtrl.text.trim().isEmpty) return;
                widget.onGuardar(Nota(
                  titulo: _titCtrl.text.trim(),
                  contenido: _contCtrl.text.trim(),
                  fecha: DateTime.now(),
                  color: _color,
                ));
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kMorado, kRosa, kRosaClaro]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Guardar nota',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}