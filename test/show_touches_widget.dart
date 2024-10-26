import 'package:flutter/material.dart';
import 'package:show_touches/show_touches.dart';

class ShowTouchesWidget extends StatelessWidget {
  const ShowTouchesWidget({
    super.key,
    this.enable = true,
    this.controller,
    this.pointerBuilder,
    this.defaultPointerStyle = const DefaultPointerStyle(),
    this.showDuration = const Duration(milliseconds: 50),
    this.removeDuration = const Duration(milliseconds: 200),
  });

  final bool enable;
  final ShowTouchesController? controller;
  final PointerBuilder? pointerBuilder;
  final DefaultPointerStyle defaultPointerStyle;
  final Duration showDuration;
  final Duration removeDuration;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowTouches(
        key: const Key('show_touches_widget'),
        enable: enable,
        controller: controller,
        pointerBuilder: pointerBuilder,
        defaultPointerStyle: defaultPointerStyle,
        showDuration: showDuration,
        removeDuration: removeDuration,
        child: const Scaffold(
          key: Key('show_touches_scaffold'),
          body: SizedBox(
            width: 100,
            height: 100,
            child: Text('ShowTouches'),
          ),
        ),
      ),
    );
  }
}
