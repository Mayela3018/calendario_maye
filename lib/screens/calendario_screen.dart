import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../theme/app_theme.dart';
import '../theme/colores.dart';
import '../widgets/widgets.dart';
import '../dialogs/dialogs.dart';

// ════════════════════════════════════════════
//  PANTALLA CALENDARIO
// ════════════════════════════════════════════
class CalendarioScreen extends StatefulWidget {
  final Map<String, List<Evento>> eventos;
  final Function(String, Evento) onAgregado;
  final Function(String, int) onEliminado;
  final Function(String, int) onToggle;

  const CalendarioScreen({
    super.key,
    required this.eventos,
    required this.onAgregado,
    required this.onEliminado,
    required this.onToggle,
  });

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final DateTime _hoy = DateTime.now();
  late DateTime _mes;
  DateTime? _sel;

  // Semana 5: función con argumentos — retorna clave del Map
  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

  String get _nomMes => [
    'Enero','Febrero','Marzo','Abril','Mayo','Junio',
    'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'
  ][_mes.month - 1];

  @override
  void initState() {
    super.initState();
    _mes = DateTime(_hoy.year, _hoy.month);
    _sel = _hoy;
  }

  List<DateTime?> get _dias {
    final p = DateTime(_mes.year, _mes.month, 1);
    final u = DateTime(_mes.year, _mes.month + 1, 0);
    final off = p.weekday == 7 ? 6 : p.weekday - 1;
    return [
      ...List<DateTime?>.filled(off, null),
      ...List.generate(u.day, (i) => DateTime(_mes.year, _mes.month, i + 1)),
    ];
  }

  List<Evento> get _eventosDelDia =>
      _sel == null ? [] : (widget.eventos[_key(_sel!)] ?? []);

  void _abrirAgregar() {
    if (_sel == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DialogEvento(
        fecha: _sel!,
        onGuardar: (e) {
          widget.onAgregado(_key(_sel!), e);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.ext;
    return SafeArea(
      child: Column(children: [
        _buildHeader(ext),
        _buildNavMes(ext),
        const SizedBox(height: 10),
        _buildLabelsDias(ext),
        const SizedBox(height: 6),
        _buildGrid(),
        const SizedBox(height: 10),
        Expanded(child: _buildListaEventos(ext)),
      ]),
    );
  }

  Widget _buildHeader(ext) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          shaderCallback: (b) =>
              const LinearGradient(colors: [kRosaClaro, kPastel]).createShader(b),
          child: const Text(
            'Mi Calendario',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        GestureDetector(
          onTap: _abrirAgregar,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kMorado, kRosa],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    ),
  );

  Widget _buildNavMes(ext) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BtnNav(
          icono: Icons.chevron_left,
          onTap: () => setState(() => _mes = DateTime(_mes.year, _mes.month - 1)),
        ),
        Text(
          '$_nomMes ${_mes.year}',
          style: TextStyle(color: ext.texto, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        BtnNav(
          icono: Icons.chevron_right,
          onTap: () => setState(() => _mes = DateTime(_mes.year, _mes.month + 1)),
        ),
      ],
    ),
  );

  Widget _buildLabelsDias(ext) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: ['Lu','Ma','Mi','Ju','Vi','Sá','Do'].map((d) => Expanded(
        child: Center(
          child: Text(d, style: TextStyle(
            color: (d == 'Sá' || d == 'Do')
                ? kPastel.withOpacity(0.7)
                : ext.textoSec.withOpacity(0.45),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          )),
        ),
      )).toList(),
    ),
  );

  Widget _buildGrid() {
    final dias = _dias;
    final filas = (dias.length / 7).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: List.generate(filas, (f) => Row(
          children: List.generate(7, (c) {
            final idx = f * 7 + c;
            if (idx >= dias.length || dias[idx] == null) {
              return const Expanded(child: SizedBox(height: 46));
            }
            final dia = dias[idx]!;
            // Semana 6: construye celdas dinámicamente (similar a ListView builder)
            return CeldaDia(
              dia: dia,
              hoy: _hoy,
              seleccionado: _sel,
              tieneEventos: (widget.eventos[_key(dia)] ?? []).isNotEmpty,
              onTap: () => setState(() => _sel = dia),
            );
          }),
        )),
      ),
    );
  }

  Widget _buildListaEventos(ext) {
    final evs = _eventosDelDia;
    final k = _sel != null ? _key(_sel!) : '';
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      decoration: BoxDecoration(
        color: ext.superficie,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kRosa.withOpacity(0.12)),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _sel != null
                    ? '${_sel!.day} de $_nomMes'
                    : 'Selecciona un día',
                style: TextStyle(color: ext.texto, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Row(children: [
                if (evs.isNotEmpty) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: kRosaClaro.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${evs.length}',
                    style: const TextStyle(color: kRosaClaro, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _abrirAgregar,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kRosa.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: kRosaClaro, size: 16),
                  ),
                ),
              ]),
            ],
          ),
        ),
        Divider(height: 1, color: kRosa.withOpacity(0.1)),
        Expanded(
          child: evs.isEmpty
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_available_outlined, color: kRosa.withOpacity(0.3), size: 34),
                    const SizedBox(height: 8),
                    Text(
                      _sel != null ? 'Sin eventos — ¡agrega uno!' : 'Toca un día',
                      style: TextStyle(color: ext.textoSec.withOpacity(0.4), fontSize: 13),
                    ),
                  ],
                ))
              // Semana 6: ListView.separated
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: evs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => TarjetaEvento(
                    evento: evs[i],
                    onTap: () => widget.onToggle(k, i),
                    onDismiss: () => widget.onEliminado(k, i),
                  ),
                ),
        ),
      ]),
    );
  }
}