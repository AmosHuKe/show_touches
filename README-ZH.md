[![GitHub stars](https://img.shields.io/github/stars/AmosHuKe/show_touches?style=social&logo=github&logoColor=1F2328&label=stars)](https://github.com/AmosHuKe/show_touches)
[![Pub.dev likes](https://img.shields.io/pub/likes/show_touches?style=social&logo=flutter&logoColor=168AFD&label=likes)](https://pub.dev/packages/show_touches)

📓 语言：[English](README.md) | 中文  

<br/><br/>

<h1 align="center">Show Touches</h1>

<p align="center">
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/pub/v/show_touches?color=3e4663&label=%E7%A8%B3%E5%AE%9A%E7%89%88&logo=flutter" alt="stable package" /></a>
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/pub/v/show_touches?color=3e4663&label=%E5%BC%80%E5%8F%91%E7%89%88&logo=flutter&include_prereleases" alt="dev package" /></a>
  <a href="https://pub.dev/packages/show_touches/score"><img src="https://img.shields.io/pub/points/show_touches?color=2E8B57&label=%E5%88%86%E6%95%B0&logo=flutter" alt="pub points" /></a>
  <a href="https://www.codefactor.io/repository/github/AmosHuKe/show_touches"><img src="https://img.shields.io/codefactor/grade/github/AmosHuKe/show_touches?color=0CAB6B&label=%E4%BB%A3%E7%A0%81%E8%B4%A8%E9%87%8F&logo=codefactor" alt="CodeFactor" /></a>
  <a href="https://codecov.io/gh/AmosHuKe/show_touches"><img src="https://img.shields.io/codecov/c/github/AmosHuKe/show_touches?label=%E6%B5%8B%E8%AF%95%E8%A6%86%E7%9B%96&logo=codecov" alt="codecov" /></a>
  <a href="https://pub.dev/packages/show_touches"><img src="https://img.shields.io/github/languages/top/AmosHuKe/show_touches?color=00B4AB" alt="top language" /></a>
</p>

<p align="center">
  <strong >在 Flutter 上显示手指触摸效果！</strong>
</p>

<br/>

<div align="center">
  <img alt="preview1.gif" width="600" src="https://raw.githubusercontent.com/AmosHuKe/show_touches/main/README/preview1.gif" />
</div>

<br/>

## 目录 🪄

<sub>

- [特性](#特性-)

- [安装](#安装-)

  - [版本兼容](#版本兼容-)

  - [平台兼容](#平台兼容-)

  - [添加 show_touches](#添加-show_touches-)

- [简单用法](#简单用法-)

  - [ShowTouches](#showtouches-)

- [使用](#使用-)

  - [ShowTouches widget 参数][]

  - [PointerBuilder][]

  - [ShowTouchesController][]

- [贡献者](#贡献者-)

- [许可证](#许可证-)

</sub>

<br/>


## 特性 ✨  

- 👇 支持多指（指针）
- 🔧 可通过控制器来控制
- ⚙️ 自定义指针 Widget 和动画


## 安装 🎯
### 版本兼容 🐦  

| Flutter             | 3.3.0+ |
| ------------------- | :----: |
| show_touches 0.0.1+ |   ✅   |


### 平台兼容 📱  

| Android | iOS | Web | macOS | Windows | Linux |
| :-----: | :-: | :-: | :---: | :-----: | :---: |
|   ✅    | ✅  | ✅  |  ✅   |   ✅    |  ✅   |


### 添加 show_touches 📦  

使用 Flutter 运行以下指令，  

```sh
$ flutter pub add show_touches
```

或手动将 `show_touches` 添加到 `pubspec.yaml` 依赖项中。  

```yaml
dependencies:
  show_touches: ^latest_version
```


## 简单用法 📖  

示例：[show_touches/example][]


### ShowTouches 📦  

[ShowTouches][ShowTouches widget 参数] widget 会自带默认的手势逻辑和指针 widget。  

```dart
/// 导入 show_touches
import 'package:show_touches/show_touches.dart';

MaterialApp(
  builder: ShowTouches.init(),
  home: XxxPage(),
);

/// 或者

ShowTouches(child: XxxPage()),

```


## 使用 📖  
### `ShowTouches` widget 参数 🤖  

| 参数名                  | 类型                       | 默认值                        | 描述                                                           |
| ----------------------- | -------------------------- | ----------------------------- | -------------------------------------------------------------- |
| child <sup>`必选`</sup> | `Widget`                   | -                             | -                                                              |
| enable                  | `bool`                     | `true`                        | true（启用）<br/> false（禁用）                                |
| controller              | [ShowTouchesController][]? | `null`                        | 通过 `ShowTouchesController` 来控制指针。                      |
| pointerBuilder          | [PointerBuilder][]?        | `null`                        | 自定义指针 Widget，但会导致 `defaultPointerStyle` 失效。       |
| defaultPointerStyle     | `DefaultPointerStyle`      | `DefaultPointerStyle()`       | 默认的指针 Widget 样式（在没有指定 `pointerBuilder` 的时候）。 |
| showDuration            | `Duration`                 | `Duration(milliseconds: 50)`  | 显示动画的持续时间（指针）。                                   |
| removeDuration          | `Duration`                 | `Duration(milliseconds: 200)` | 移除动画的持续时间（指针）。                                   |


### PointerBuilder 📄  

示例：  
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

| 参数名    | 类型                | 描述               |
| --------- | ------------------- | ------------------ |
| context   | `BuildContext`      | -                  |
| pointerId | `int`               | 指针（触摸）ID。   |
| position  | `Offset`            | 当前触摸位置。     |
| animation | `Animation<double>` | 显示和移除的动画。 |


### ShowTouchesController 📄  

你可以使用控制器来控制 `ShowTouches` widget 内的指针，
或者你也可以实现自己的手势逻辑来控制指针。 

示例：  
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

#### 获取所有指针数据

通过 `controller.data` 来获取所有指针数据 (`Map<int, PointerData>`)。  

> Map<int, PointerData> -> `key`: pointerId, `value`: PointerData  

##### PointerData

| 参数名              | 类型                    | 描述                  |
| ------------------- | ----------------------- | --------------------- |
| pointerId           | `int`                   | 指针（触摸）ID。      |
| positionState       | `ValueNotifier<Offset>` | 当前触摸位置。        |
| animationController | `AnimationController`   | 动画控制器。          |
| pointerOverlayEntry | `OverlayEntry?`         | 指针 `OverlayEntry`。 |

#### addPointer()

| 参数名                                | 类型                  | 默认值                  | 描述                                                           |
| ------------------------------------- | --------------------- | ----------------------- | -------------------------------------------------------------- |
| context <sup>`必选`</sup>             | `BuildContext`        | -                       | -                                                              |
| pointerId <sup>`必选`</sup>           | `int`                 | -                       | 指针（触摸）ID。                                               |
| position <sup>`必选`</sup>            | `Offset`              | -                       | 当前触摸位置。                                                 |
| animationController <sup>`必选`</sup> | `AnimationController` | -                       | 动画控制器。                                                   |
| pointerBuilder                        | `PointerBuilder?`     | `null`                  | 自定义指针 Widget，但会导致 `defaultPointerStyle` 失效。       |
| defaultPointerStyle                   | `DefaultPointerStyle` | `DefaultPointerStyle()` | 默认的指针 Widget 样式（在没有指定 `pointerBuilder` 的时候）。 |

#### updatePointer()

| 参数名                      | 类型     | 默认值 | 描述             |
| --------------------------- | -------- | ------ | ---------------- |
| pointerId <sup>`必选`</sup> | `int`    | -      | 指针（触摸）ID。 |
| position <sup>`必选`</sup>  | `Offset` | -      | 当前触摸位置。   |

#### removePointer()

| 参数名                      | 类型            | 默认值 | 描述                           |
| --------------------------- | --------------- | ------ | ------------------------------ |
| pointerId <sup>`必选`</sup> | `int`           | -      | 指针（触摸）ID。               |
| onRemoved                   | `VoidCallback?` | `null` | 指针（含动画）彻底移除后回调。 |

#### disposePointer()

| 参数名                      | 类型  | 默认值 | 描述             |
| --------------------------- | ----- | ------ | ---------------- |
| pointerId <sup>`必选`</sup> | `int` | -      | 指针（触摸）ID。 |


## 贡献者 ✨  

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


## 许可证 📄  

[![MIT License](https://img.shields.io/badge/license-MIT-green)](https://github.com/AmosHuKe/show_touches/blob/main/LICENSE)  
根据 MIT 许可证开源。 

© AmosHuKe


[show_touches/example]: https://github.com/AmosHuKe/show_touches/tree/main/example
[ShowTouches widget 参数]: #showtouches-widget-参数-
[PointerBuilder]: #pointerbuilder-
[ShowTouchesController]: #showtouchescontroller-
