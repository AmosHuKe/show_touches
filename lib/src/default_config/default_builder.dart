import 'package:flutter/widgets.dart';

class DefaultBuilder extends StatelessWidget {
  const DefaultBuilder({
    super.key,
    required this.position,
    required this.animation,
  });

  final Offset position;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const Size touchSize = Size(30, 30);
    final Animation<double> scaleAnimation = Tween<double>(
      begin: 2.0,
      end: 1.0,
    ).animate(animation);

    return Positioned(
      left: position.dx - touchSize.width / 2.0,
      top: position.dy - touchSize.height / 2.0,
      child: IgnorePointer(
        ignoring: true,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Opacity(
              opacity: 0.2,
              child: Container(
                width: touchSize.width,
                height: touchSize.height,
                decoration: BoxDecoration(
                  color: Color(0xFF525252),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
