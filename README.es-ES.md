

[![GitHub stars](https://img.shields.io/github/stars/AmosHuKe/show_touches?style=social&logo=github&logoColor=1F2328&label=stars)](https://github.com/AmosHuKe/show_touches)
[![Pub.dev likes](https://img.shields.io/pub/likes/show_touches?style=social&logo=flutter&logoColor=168AFD&label=likes)](https://pub.dev/packages/show_touches)

📓 Idioma: Inglés | [中文](README-ZH.md)  

<br/><br/>

<h1 align="center">Show Touches</h1>

<p align="center">
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/pub/v/show_touches?color=3e4663&label=stable&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/pub/v/show_touches?color=3e4663&label=dev&logo=flutter&include_prereleases" alt="dev package" /></a>
  <a href="https://pub.dev/packages/show_touches/score"><img src="https://img.shields.io/pub/points/show_touches?color=2E8B57&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/AmosHuKe/show_touches"><img src="https://img.shields.io/codefactor/grade/github/AmosHuKe/show_touches?color=0CAB6B&logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://codecov.io/gh/AmosHuKe/show_touches"><img src="https://img.shields.io/codecov/c/github/AmosHuKe/show_touches?label=coverage&logo=codecov" alt="codecov" /></a>
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/github/languages/top/AmosHuKe/show_touches?color=00B4AB" alt="top language" /></a>
</p>

<p align="center">
  <strong >¡Muestra efectos de toque de dedos para Flutter!</strong>
</p>

<br/>

<div align="center">
  <img alt="preview1.gif" width="600" src="https://raw.githubusercontent.com/AmosHuKe/show_touches/main/README/preview1.gif" />
</div>

<br/>

## Tabla de contenidos 🪄

<sub>

- [Características](#features-)

- [Instalación](#install-)

  - [Compatibilidad de versiones](#versions-compatibility-)

  - [Compatibilidad de plataformas](#platforms-compatibility-)

  - [Agregar paquete](#add-package-)

- [Uso sencillo](#simple-usage-)

  - [ShowTouches](#showtouches-)

- [Uso](#usage-)

  - [Parámetros del widget ShowTouches][]

  - [PointerBuilder][]

  - [ShowTouchesController][]

- [Colaboradores](#contributors-)

- [Licencia](#license-)

</sub>

<br/>


## Características ✨  

- 👇 Múltiples dedos (punteros)
- 🔧 Control por controlador
- ⚙️ Widgets y animaciones de puntero personalizables


## Instalación 🎯
### Compatibilidad de versiones 🐦  

| Flutter             | 3.3.0+ |
| ------------------- | :----: |
| show_touches 0.0.1+ |   ✅   |


### Compatibilidad de plataformas 📱  

| Android | iOS | Web | macOS | Windows | Linux |
| :-----: | :-: | :-: | :---: | :-----: | :---: |
|   ✅    | ✅  | ✅  |  ✅   |   ✅    |  ✅   |


### Agregar paquete 📦  

Ejecuta este comando con Flutter,  

```sh
$ flutter pub add show_touches
```

o agrega `show_touches` manualmente a las dependencias en `pubspec.yaml`.  

```yaml
dependencies:
  show_touches: ^latest_version
```


## Uso sencillo 📖  

Ejemplo: [show_touches/example][]


### ShowTouches 📦  

El widget [ShowTouches][ShowTouches widget parameters] tendrá lógica de gestos y widgets de puntero predeterminados. 

```dart
/// Import show_touches
import 'package:show_touches/show_touches.dart';

MaterialApp(
  builder: ShowTouches.init(),
  home: XxxPage(),
);

/// or

ShowTouches(child: XxxPage()),

```


## Uso 📖  
### Parámetros del widget `ShowTouches` 🤖  

| Parámetro                   | Tipo                       | Predeterminado                | Descripción                                                                       |
| --------------------------- | -------------------------- | ----------------------------- | --------------------------------------------------------------------------------- |
| child <sup>`required`</sup> | `Widget`                   | -                             | -                                                                                 |
| enable                      | `bool`                     | `true`                        | true (habilitar) <br/> false (deshabilitar)                                       |
| controller                  | [ShowTouchesController][]? | `null`                        | Controlador `ShowTouchesController` para manejar el puntero.                      |
| pointerBuilder              | [PointerBuilder][]?        | `null`                        | Widget de puntero personalizado, pero esto invalidará el `defaultPointerStyle`.  |
| defaultPointerStyle         | `DefaultPointerStyle`      | `DefaultPointerStyle()`       | Estilo predeterminado para el widget de puntero cuando no se usa `pointerBuilder`.|
| showDuration                | `Duration`                 | `Duration(milliseconds: 50)`  | Duración de la animación de aparición (puntero).                                  |
| removeDuration              | `Duration`                 | `Duration(milliseconds: 200)` | Duración de la animación de desaparición (puntero).                               |


### PointerBuilder 📄  

Ejemplo:  
```dart

ShowTouches(
  pointerBuilder: (
    BuildContext context,
    int pointerId,
    Offset position,
    Animation<double> animation,
  ) {
    const double size = 60.0;
    return Positioned(
      left: position.dx - size / 2,
      top: position.dy - size / 2,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: ScaleTransition(
            scale: animation.drive(Tween<double>(begin: 2.0, end: 1.0)),
            child: FadeTransition(
              opacity: animation,
              child: Container(
                width: size,
                height: size,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  },
  child: XxxPage(),
),

```

| Parámetro | Tipo                | Descripción             |
| --------- | ------------------- | ----------------------- |
| context   | `BuildContext`      | -                       |
| pointerId | `int`               | ID del puntero (toque). |
| position  | `Offset`            | Posición actual del toque. |
| animation | `Animation<double>` | Controlador de animación. |


### ShowTouchesController 📄  

Puedes usar el controlador para gestionar los punteros en el widget `ShowTouches`,  
o también puedes implementar tu propia lógica de gestos para controlar los punteros.  

Ejemplo:  
```dart

final ShowTouchesController controller = ShowTouchesController();

......

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

......

Listener(
  onPointerDown: (event) => controller.addPointer(...),
  onPointerMove: (event) => controller.updatePointer(...),
  onPointerUp: (event) => controller.removePointer(...),
  onPointerCancel: (event) => controller.removePointer(...),
  behavior: HitTestBehavior.translucent,
  child: child,
);

```

#### Obtener todos los datos de punteros

Usa `controller.data` para obtener todos los datos de los punteros (`Map<int, PointerData>`).  

> Map<int, PointerData> -> `key`: pointerId, `value`: PointerData  

##### PointerData

| Parámetro           | Tipo                    | Descripción             |
| ------------------- | ----------------------- | ----------------------- |
| pointerId           | `int`                   | ID del puntero (toque). |
| positionState       | `ValueNotifier<Offset>` | Posición actual del toque. |
| animationController | `AnimationController`   | Controlador de animación. |
| pointerOverlayEntry | `OverlayEntry?`         | Entrada `OverlayEntry` del puntero. |

#### addPointer()

| Parámetro                                 | Tipo                  | Predeterminado            | Descripción                                                                       |
| ----------------------------------------- | --------------------- | ------------------------- | --------------------------------------------------------------------------------- |
| context <sup>`required`</sup>             | `BuildContext`        | -                         | -                                                                                 |
| pointerId <sup>`required`</sup>           | `int`                 | -                         | ID del puntero (toque).                                                           |
| position <sup>`required`</sup>            | `Offset`              | -                         | Posición actual del toque.                                                        |
| animationController <sup>`required`</sup> | `AnimationController` | -                         | Controlador de animación.                                                         |
| pointerBuilder                            | `PointerBuilder?`     | `null`                    | Widget de puntero personalizado, pero esto invalidará el `defaultPointerStyle`.  |
| defaultPointerStyle                       | `DefaultPointerStyle` | `DefaultPointerStyle()`   | Estilo predeterminado para el widget de puntero cuando no se usa `pointerBuilder`.|

#### updatePointer()

| Parámetro                       | Tipo     | Predeterminado | Descripción             |
| ------------------------------- | -------- | --------------- | ----------------------- |
| pointerId <sup>`required`</sup> | `int`    | -               | ID del puntero (toque). |
| position <sup>`required`</sup>  | `Offset` | -               | Posición actual del toque. |

#### removePointer()

| Parámetro                       | Tipo            | Predeterminado | Descripción                                                   |
| ------------------------------- | --------------- | --------------- | ------------------------------------------------------------- |
| pointerId <sup>`required`</sup> | `int`           | -               | ID del puntero (toque).                                       |
| onRemoved                       | `VoidCallback?` | `null`          | Se invoca una vez que el puntero y su animación se han eliminado por completo. |

#### disposePointer()

| Parámetro                       | Tipo  | Predeterminado | Descripción             |
| ------------------------------- | ----- | --------------- | ----------------------- |
| pointerId <sup>`required`</sup> | `int` | -               | ID del puntero (toque). |


## Colaboradores ✨  

<!-- readme: contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/AmosHuKe">
                    <img src="https://avatars.githubusercontent.com/u/32262985?v=4" width="100;" alt="AmosHuKe"/>
                    <br />
                    <sub><b>AmosHuKe</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: contributors -end -->


## Licencia 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AmosHuKe/show_touches/blob/main/LICENSE)  
Código abierto bajo la licencia MIT.  

© AmosHuKe


[show_touches/example]: https://github.com/AmosHuKe/show_touches/tree/main/example
[ShowTouches widget parameters]: #showtouches-widget-parameters-
[PointerBuilder]: #pointerbuilder-
[ShowTouchesController]: #showtouchescontroller-
