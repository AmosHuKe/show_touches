[![GitHub stars](https://img.shields.io/github/stars/AmosHuKe/show_touches?style=social&logo=github&logoColor=1F2328&label=stars)](https://github.com/AmosHuKe/show_touches)
[![Pub.dev likes](https://img.shields.io/pub/likes/show_touches?style=social&logo=flutter&logoColor=168AFD&label=likes)](https://pub.dev/packages/show_touches)

📓 Language: English | [中文](README-ZH.md)  

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
  <strong >Show finger touch effects for Flutter!</strong>
</p>

<br/>

<div align="center">
  <img alt="preview1.gif" width="600" src="https://raw.githubusercontent.com/AmosHuKe/show_touches/main/README/preview1.gif" />
</div>

<br/>

## Table of contents 🪄

<sub>

- [Features](#features-)

- [Install](#install-)

  - [Versions compatibility](#versions-compatibility-)

  - [Platforms compatibility](#platforms-compatibility-)

  - [Add package](#add-package-)

- [Simple usage](#simple-usage-)

  - [ShowTouches](#showtouches-)

- [Usage](#usage-)

  - [ShowTouches widget parameters][]

  - [PointerBuilder][]

  - [ShowTouchesController][]

- [Contributors](#contributors-)

- [License](#license-)

</sub>

<br/>


## Features ✨  

- 👇 Multiple fingers (pointers)
- 🔧 Controller control
- ⚙️ Customizable pointer widgets and animations


## Install 🎯
### Versions compatibility 🐦  

|       Flutter       |  3.3.0+  |  
|      ---------      | :------: |  
| show_touches 0.0.1+ |    ✅    |  


### Platforms compatibility 📱  

| Android |  iOS  |  Web  | macOS | Windows | Linux |  
| :-----: | :---: | :---: | :---: | :-----: | :---: |  
|   ✅   |   ✅  |  ✅   |  ✅  |   ✅   |  ✅   |  


### Add package 📦  

Run this command with Flutter,  

```sh
$ flutter pub add show_touches
```

or add `show_touches` to `pubspec.yaml` dependencies manually.  

```yaml
dependencies:
  show_touches: ^latest_version
```


## Simple usage 📖  

Example: [show_touches/example][]


### ShowTouches 📦  

[ShowTouches][ShowTouches widget parameters] widget will have default gesture logic and pointer widgets. 

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


## Usage 📖  
### `ShowTouches` widget parameters 🤖  

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| child <sup>`required`</sup> | `Widget` | - | - |  
| enable | `bool` | `true` | true (enable) <br/> false (disable) |  
| controller | [ShowTouchesController][]? | `null` | `ShowTouchesController` to control the pointer. |  
| pointerBuilder | [PointerBuilder][]? | `null` | Custom pointer widget, but it will cause the `defaultPointerStyle` to be invalid. |  
| defaultPointerStyle | `DefaultPointerStyle` | `DefaultPointerStyle()` | Default style for the pointer widget when `pointerBuilder` is not used. |  
| showDuration | `Duration` | `Duration(milliseconds: 50)` | Show animation duration (pointer). |  
| removeDuration | `Duration` | `Duration(milliseconds: 200)` | Remove animation duration (pointer). |  


### PointerBuilder 📄  

Example:  
```dart

ShowTouches(
  pointerBuilder: (
    BuildContext context,
    int pointerId,
    Offset position,
    Animation<double> animation,
  ) {
    final Animation<double> scaleAnimation = Tween<double>(
      begin: 2.0,
      end: 1.0,
    ).animate(animation);

    return Positioned(
      left: position.dx - 30.0,
      top: position.dy - 30.0,
      child: IgnorePointer(
        ignoring: true,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Container(
              width: 60,
              height: 60,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  },
  child: XxxPage(),
),

```

| Parameter | Type | Description |  
| --- | --- | --- |  
| context | `BuildContext` | - |  
| pointerId | `int` | Pointer (touch) ID. |  
| position | `Offset` | Current touch position. |  
| animation | `Animation<double>` | Animation controller. |  


### ShowTouchesController 📄  

You can use the controller to control the pointers in the `ShowTouches` widget,  
or you can implement your own gesture logic to control the pointers.  

Example:  
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

#### Get all pointer data

`controller.data` to get all the pointer data (`Map<int, PointerData>`).  

> Map<int, PointerData> -> `key`: pointerId, `value`: PointerData  

##### PointerData

| Parameter | Type | Description |  
| --- | --- | --- |  
| pointerId | `int` | Pointer (touch) ID. |  
| positionState | `ValueNotifier<Offset>` | Current touch position. |  
| animationController | `AnimationController` | Animation controller. |  
| pointerOverlayEntry | `OverlayEntry?` | Pointer `OverlayEntry`. |  

#### addPointer()

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| context <sup>`required`</sup> | `BuildContext` | - | - |  
| pointerId <sup>`required`</sup> | `int` | - | Pointer (touch) ID. |  
| position <sup>`required`</sup> | `Offset` | - | Current touch position. |  
| animationController <sup>`required`</sup> | `AnimationController` | - | Animation controller. |  
| pointerBuilder | `PointerBuilder?` | `null` | Custom pointer widget, but it will cause the `defaultPointerStyle` to be invalid. |  
| defaultPointerStyle | `DefaultPointerStyle` | `DefaultPointerStyle()` | Default style for the pointer widget when `pointerBuilder` is not used. |  

#### updatePointer()

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| pointerId <sup>`required`</sup> | `int` | - | Pointer (touch) ID. |  
| position <sup>`required`</sup> | `Offset` | - | Current touch position. |  

#### removePointer()

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| pointerId <sup>`required`</sup> | `int` | - | Pointer (touch) ID. |  

#### disposePointer()

| Parameter | Type | Default | Description |  
| --- | --- | --- | --- |
| pointerId <sup>`required`</sup> | `int` | - | Pointer (touch) ID. |  


## Contributors ✨  

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


## License 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AmosHuKe/show_touches/blob/main/LICENSE)  
Open sourced under the MIT license.  

© AmosHuKe


[show_touches/example]: https://github.com/AmosHuKe/show_touches/tree/main/example
[ShowTouches widget parameters]: #showtouches-widget-parameters-
[PointerBuilder]: #pointerbuilder-
[ShowTouchesController]: #showtouchescontroller-
