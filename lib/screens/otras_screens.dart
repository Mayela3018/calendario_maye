import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../theme/app_theme.dart';
import '../theme/colores.dart';
import '../widgets/widgets.dart';
import '../dialogs/dialogs.dart';

// ════════════════════════════════════════════
//  PANTALLA TAREAS
// ════════════════════════════════════════════
class TareasScreen extends StatelessWidget {
  final Map<String, List<Evento>> eventos;
  final Function(String, int) onToggle;

  const TareasScreen({
    super.key,
    required this.eventos,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;

    // Aplana todos los eventos en una lista
    final todos = <Map<String, dynamic>>[];
    for (final e in eventos.entries) {
      for (int i = 0; i < e.value.length; i++) {
        todos.add({'key': e.key, 'idx': i, 'ev': e.value[i]});
      }
    }

    final pendientes = todos.where((e) => !(e['ev'] as Evento).completado).toList();
    final completadas = todos.where((e) => (e['ev'] as Evento).completado).toList();

    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
          child: ShaderMask(
            shaderCallback: (b) =>
                const LinearGradient(colors: [kRosaClaro, kPastel]).createShader(b),
            child: const Text(
              'Mis Tareas',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          child: todos.isEmpty
              ? Center(
                  child: Text('Sin tareas aún', style: TextStyle(color: ext.textoSec)),
                )
              // Semana 6: ListView con secciones
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    if (pendientes.isNotEmpty) ...[
                      _seccion('Pendientes', pendientes.length, kRosa, ext),
                      ...pendientes.map((e) => _itemTarea(e, ext)),
                      const SizedBox(height: 14),
                    ],
                    if (completadas.isNotEmpty) ...[
                      _seccion('Completadas', completadas.length, kPastel, ext),
                      ...completadas.map((e) => _itemTarea(e, ext)),
                    ],
                  ],
                ),
        ),
      ]),
    );
  }

  // Semana 5: función con múltiples argumentos
  Widget _seccion(String titulo, int n, Color color, dynamic ext) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Row(children: [
      Text(titulo, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('$n', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ),
    ]),
  );

  Widget _itemTarea(Map<String, dynamic> data, dynamic ext) {
    final ev = data['ev'] as Evento;
    return GestureDetector(
      onTap: () => onToggle(data['key'] as String, data['idx'] as int),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ext.superficie,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ev.completado ? kPastel.withOpacity(0.15) : kRosa.withOpacity(0.1),
          ),
        ),
        child: Row(children: [
          Icon(
            ev.completado ? Icons.check_circle : Icons.radio_button_unchecked,
            color: ev.completado ? kRosaClaro : kRosa.withOpacity(0.4),
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(ev.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ev.titulo,
              style: TextStyle(
                color: ev.completado ? ext.textoSec : ext.texto,
                fontSize: 14,
                decoration: ev.completado ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(ev.hora, style: TextStyle(color: ev.color.withOpacity(0.8), fontSize: 12)),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  PANTALLA NOTAS
// ════════════════════════════════════════════
class NotasScreen extends StatelessWidget {
  final List<Nota> notas;
  final Function(Nota) onAgregada;
  final Function(int) onEliminada;

  const NotasScreen({
    super.key,
    required this.notas,
    required this.onAgregada,
    required this.onEliminada,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (b) =>
                    const LinearGradient(colors: [kRosaClaro, kPastel]).createShader(b),
                child: const Text(
                  'Mis Notas',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DialogNota(onGuardar: onAgregada),
                ),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [kMorado, kRosa]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: notas.isEmpty
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sticky_note_2_outlined, color: kRosa.withOpacity(0.3), size: 44),
                    const SizedBox(height: 10),
                    Text('Agrega tu primera nota', style: TextStyle(color: ext.textoSec, fontSize: 14)),
                  ],
                ))
              // Semana 6: GridView con builder
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: notas.length,
                  itemBuilder: (ctx, i) => TarjetaNota(
                    nota: notas[i],
                    onLongPress: () => showDialog(
                      context: ctx,
                      builder: (_) => AlertDialog(
                        backgroundColor: ext.superficie,
                        title: Text('¿Eliminar nota?', style: TextStyle(color: ext.texto)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Cancelar', style: TextStyle(color: ext.textoSec)),
                          ),
                          TextButton(
                            onPressed: () { onEliminada(i); Navigator.pop(ctx); },
                            child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ]),
    );
  }
}