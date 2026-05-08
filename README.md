# 📅 Calendario Maye

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white"/>
</p>

<p align="center">
  Aplicación de calendario semanal móvil desarrollada en Flutter con gestión de eventos, tareas y notas.
</p>

---

## ✨ Características

- 📆 **Calendario mensual** con navegación entre meses
- ➕ **Agregar eventos** con emoji, hora y color personalizado
- ✅ **Gestión de tareas** — marca como completadas deslizando
- 📝 **Notas** en cuadrícula con colores
- 🌙 **Modo oscuro / claro** — cambia con un toque
- 🎨 **Paleta rosa y morada** con gradientes

---

## 📁 Estructura del proyecto

```
lib/
├── main.dart                  # Punto de entrada y configuración de temas
├── models/
│   └── modelos.dart           # Clases Evento y Nota
├── theme/
│   ├── colores.dart           # Paleta de colores
│   └── app_theme.dart         # Temas claro y oscuro
├── screens/
│   ├── calendario_screen.dart # Pantalla principal del calendario
│   └── otras_screens.dart     # Pantallas de tareas y notas
├── widgets/
│   └── widgets.dart           # Widgets reutilizables
└── dialogs/
    └── dialogs.dart           # Diálogos de nuevo evento y nota
```

---

## 🧠 Temas aplicados en clase

| Semana | Tema | Uso en el proyecto |
|--------|------|--------------------|
| Semana 2 | Clases | `Evento`, `Nota`, `ThemeNotifier` |
| Semana 4 | Widgets y Prefer Const | `const` en widgets estáticos |
| Semana 5 | Funciones con argumentos | `_key()`, `BtnNav()`, `_seccion()` |
| Semana 6 | ListView | `ListView.separated` y `GridView.builder` |
| Semana 7 | TextForms | `TextField` con controladores en los diálogos |
| Semana 8 | Provider / ValueNotifier | Cambio de tema claro/oscuro en tiempo real |

---

## 🚀 Elementos adicionales

- `ThemeExtension` — colores adaptativos según el tema
- `Dismissible` — deslizar para eliminar eventos
- `ShaderMask` + `LinearGradient` — títulos con degradado
- `AnimatedContainer` — transiciones suaves en la navbar

---

## 🛠️ Cómo correr el proyecto

```bash
# Clona el repositorio
git clone https://github.com/Mayela3018/calendario_maye.git

# Entra a la carpeta
cd calendario_maye

# Instala dependencias
flutter pub get

# Corre la app
flutter run
```

---

<p align="center">Hecho con 💗 usando Flutter</p>
