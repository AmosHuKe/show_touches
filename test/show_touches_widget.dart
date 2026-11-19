import 'package:flutter/widgets.dart';
import 'package:show_touches/show_touches.dart';

class ShowTouchesWidget extends StatelessWidget {
  const ShowTouchesWidget({
    super.key,
    this.builder,
    this.enable = true,
    this.controller,
    this.pointerBuilder,
    this.defaultPointerStyle = const DefaultPointerStyle(),
    this.showDuration = const Duration(milliseconds: 50),
    this.removeDuration = const Duration(milliseconds: 200),
  });

  final TransitionBuilder? builder;
  final bool enable;
  final ShowTouchesController? controller;
  final PointerBuilder? pointerBuilder;
  final DefaultPointerStyle defaultPointerStyle;
  final Duration showDuration;
  final Duration removeDuration;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
      builder: ShowTouches.init(
        key: const Key('show_touches_widget'),
        builder: builder,
        enable: enable,
        controller: controller,
        pointerBuilder: pointerBuilder,
        defaultPointerStyle: defaultPointerStyle,
        showDuration: showDuration,
        removeDuration: removeDuration,
      ),
      home: const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Text('ShowTouches'),
        ),
      ),
    );
  }
}
