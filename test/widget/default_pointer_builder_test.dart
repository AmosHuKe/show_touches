import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:show_touches/show_touches.dart';

void main() {
  group('DefaultPointerBuilder', () {
    testWidgets(
      'reuses the visual subtree when only the position changes',
      (WidgetTester tester) async {
        final ValueNotifier<Offset> position =
            ValueNotifier<Offset>(const Offset(10.0, 10.0));
        addTearDown(position.dispose);
        final AnimationController animation =
            AnimationController(vsync: const TestVSync());
        addTearDown(animation.dispose);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                ValueListenableBuilder<Offset>(
                  valueListenable: position,
                  builder: (context, currentPosition, child) {
                    return DefaultPointerBuilder(
                      position: currentPosition,
                      animation: animation,
                    );
                  },
                ),
              ],
            ),
          ),
        );

        final Widget visualBefore = tester.widget(find.byType(Container));

        position.value = const Offset(20.0, 20.0);
        await tester.pump();

        final Widget visualAfter = tester.widget(find.byType(Container));

        /// The visual subtree must be reused across position changes;
        /// only the [Positioned] offset should update.
        expect(identical(visualBefore, visualAfter), isTrue);
      },
    );

    testWidgets(
      'positions the pointer centered on the touch point',
      (WidgetTester tester) async {
        final AnimationController animation =
            AnimationController(vsync: const TestVSync());
        addTearDown(animation.dispose);
        animation.value = 1.0;

        const DefaultPointerStyle style = DefaultPointerStyle(size: 30.0);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                DefaultPointerBuilder(
                  position: const Offset(100.0, 100.0),
                  animation: animation,
                  defaultPointerStyle: style,
                ),
              ],
            ),
          ),
        );

        final Positioned positioned =
            tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, 100.0 - 30.0 / 2.0);
        expect(positioned.top, 100.0 - 30.0 / 2.0);
      },
    );
  });
}
