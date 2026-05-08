import 'package:flutter/material.dart';
import 'models/modelos.dart';
import 'theme/app_theme.dart';
import 'theme/colores.dart';
import 'screens/calendario_screen.dart';
import 'screens/otras_screens.dart';

// ════════════════════════════════════════════
//  MAIN — punto de entrada
// ════════════════════════════════════════════
void main() => runApp(const CalendarioApp());

class CalendarioApp extends StatefulWidget {
  const CalendarioApp({super.key});

  @override
  State<CalendarioApp> createState() => _CalendarioAppState();
}

class _CalendarioAppState extends State<CalendarioApp> {
  // Semana 8: patrón ValueNotifier similar a Provider
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder se redibuja cuando cambia el tema
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: 'Mi Calendario',
        debugShowCheckedModeBanner: false,
        theme: temaClaro,
        darkTheme: temaOscuro,
        themeMode: mode,
        home: PantallaHome(themeNotifier: _themeNotifier),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  PANTALLA HOME con TabBar + botón de tema
// ════════════════════════════════════════════
class PantallaHome extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  const PantallaHome({super.key, required this.themeNotifier});

  @override
  State<PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<PantallaHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _tabActual = 0;

  final Map<String, List<Evento>> _eventos = {};
  final List<Nota> _notas = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() => setState(() => _tabActual = _tabCtrl.index));
    _cargarEjemplos();
  }

  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

  void _cargarEjemplos() {
    final h = DateTime.now();
    _eventos[_key(h)] = [
      Evento(titulo: 'Reunión de equipo', hora: '10:00 AM', color: kRosa, emoji: '👥'),
      Evento(titulo: 'Clase de diseño', hora: '3:00 PM', color: kRosaClaro, emoji: '🎨'),
    ];
    _eventos[_key(h.add(const Duration(days: 2)))] = [
      Evento(titulo: 'Entrega proyecto', hora: '6:00 PM', color: kMorado, emoji: '🚀'),
    ];
    _notas.addAll([
      Nota(titulo: 'Ideas Flutter', contenido: 'Paleta rosa + morado. Eventos y notas interactivos...', fecha: h, color: kRosa),
      Nota(titulo: 'Lista de compras', contenido: 'Leche, pan, frutas, yogurt...', fecha: h.subtract(const Duration(days: 1)), color: kPastel),
    ]);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ext.fondo,
      // ✅ Sin floatingActionButton — el botón va en la navbar
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          CalendarioScreen(
            eventos: _eventos,
            onAgregado: (k, e) => setState(() => _eventos[k] = [...(_eventos[k] ?? []), e]),
            onEliminado: (k, i) => setState(() => _eventos[k]?.removeAt(i)),
            onToggle: (k, i) => setState(() => _eventos[k]![i].completado = !_eventos[k]![i].completado),
          ),
          TareasScreen(
            eventos: _eventos,
            onToggle: (k, i) => setState(() => _eventos[k]![i].completado = !_eventos[k]![i].completado),
          ),
          NotasScreen(
            notas: _notas,
            onAgregada: (n) => setState(() => _notas.insert(0, n)),
            onEliminada: (i) => setState(() => _notas.removeAt(i)),
          ),
        ],
      ),
      bottomNavigationBar: _navBar(context),
    );
  }

  Widget _navBar(BuildContext context) {
    final ext = context.ext;
    final tabs = [
      {'icon': Icons.calendar_month_rounded, 'label': 'Calendario'},
      {'icon': Icons.check_circle_outline_rounded, 'label': 'Tareas'},
      {'icon': Icons.sticky_note_2_outlined, 'label': 'Notas'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: ext.superficie,
        border: Border(top: BorderSide(color: kRosa.withOpacity(0.15))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // ── Las 3 pestañas normales ──────────────
              ...List.generate(tabs.length, (i) {
                final activo = _tabActual == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _tabCtrl.animateTo(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: activo ? kRosa.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            tabs[i]['icon'] as IconData,
                            color: activo ? kRosaClaro : ext.textoSec.withOpacity(0.4),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabs[i]['label'] as String,
                          style: TextStyle(
                            color: activo ? kRosaClaro : ext.textoSec.withOpacity(0.4),
                            fontSize: 10,
                            fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // ── Botón de tema (claro/oscuro) ─────────
              ValueListenableBuilder<ThemeMode>(
                valueListenable: widget.themeNotifier,
                builder: (_, mode, __) => GestureDetector(
                  onTap: widget.themeNotifier.toggleTema,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            mode == ThemeMode.dark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: ext.textoSec.withOpacity(0.4),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mode == ThemeMode.dark ? 'Claro' : 'Oscuro',
                          style: TextStyle(
                            color: ext.textoSec.withOpacity(0.4),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
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