import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:show_touches/show_touches.dart';

import 'show_touches_widget.dart';

void main() {
  group('ShowTouches', () {
    testWidgets('Default Pointer Builder', (WidgetTester tester) async {
      final Finder childFinder = find.text('ShowTouches');
      final ShowTouchesController controller = ShowTouchesController();

      await tester.pumpWidget(ShowTouchesWidget(controller: controller));

      final TestGesture gesture1 = await tester.createGesture(
        pointer: 888,
        kind: PointerDeviceKind.touch,
      );
      final TestGesture gesture2 = await tester.createGesture(
        pointer: 999,
        kind: PointerDeviceKind.touch,
      );
      final Offset childCenter = tester.getCenter(childFinder);

      /// Touch down
      final Offset touchDown1 = childCenter;
      final Offset touchDown2 = childCenter + const Offset(0, 10);
      await gesture1.down(touchDown1);
      await gesture2.down(touchDown2);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchDownData1 = controller.data[888];
      final PointerData? touchDownData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 2);
      expect(touchDownData1?.pointerId, 888);
      expect(touchDownData1?.positionState.value, touchDown1);
      expect(touchDownData2?.pointerId, 999);
      expect(touchDownData2?.positionState.value, touchDown2);

      /// Touch move
      final Offset touchMove1 = childCenter + const Offset(0, 10);
      final Offset touchMove2 = childCenter;
      await gesture1.moveTo(touchMove1);
      await gesture2.moveTo(touchMove2);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchMoveData1 = controller.data[888];
      final PointerData? touchMoveData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 2);
      expect(touchMoveData1?.pointerId, 888);
      expect(touchMoveData1?.positionState.value, touchMove1);
      expect(touchMoveData2?.pointerId, 999);
      expect(touchMoveData2?.positionState.value, touchMove2);

      /// Touch up
      await gesture1.up();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchUpData1 = controller.data[888];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 1);
      expect(touchUpData1, null);

      /// Touch up
      await gesture2.up();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchUpData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 0);
      expect(touchUpData2, null);
    });

    testWidgets('enable = false', (WidgetTester tester) async {
      final Finder childFinder = find.text('ShowTouches');
      final ShowTouchesController controller = ShowTouchesController();

      await tester.pumpWidget(
        ShowTouchesWidget(enable: false, controller: controller),
      );

      final TestGesture gesture1 = await tester.createGesture(
        pointer: 888,
        kind: PointerDeviceKind.touch,
      );
      final Offset childCenter = tester.getCenter(childFinder);

      /// Touch down
      final Offset touchDown1 = childCenter;
      await gesture1.down(touchDown1);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchDownData1 = controller.data[888];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 0);
      expect(touchDownData1, null);

      /// Touch move
      final Offset touchMove1 = childCenter + const Offset(0, 10);
      await gesture1.moveTo(touchMove1);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchMoveData1 = controller.data[888];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 0);
      expect(touchMoveData1, null);

      /// Touch up
      await gesture1.up();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchUpData1 = controller.data[888];
      expect(childFinder, findsOneWidget);
      expect(controller.data.length, 0);
      expect(touchUpData1, null);
    });

    testWidgets('Pointer Builder', (WidgetTester tester) async {
      final Finder childFinder = find.text('ShowTouches');
      final Finder pointerChildFinder1 = find.text('888');
      final Finder pointerChildFinder2 = find.text('999');
      final ShowTouchesController controller = ShowTouchesController();

      await tester.pumpWidget(
        ShowTouchesWidget(
          controller: controller,
          pointerBuilder: (context, pointerId, position, animation) {
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Text(pointerId.toString()),
            );
          },
        ),
      );

      final TestGesture gesture1 = await tester.createGesture(
        pointer: 888,
        kind: PointerDeviceKind.touch,
      );
      final TestGesture gesture2 = await tester.createGesture(
        pointer: 999,
        kind: PointerDeviceKind.touch,
      );
      final Offset childCenter = tester.getCenter(childFinder);

      /// Touch down
      final Offset touchDown1 = childCenter;
      final Offset touchDown2 = childCenter + const Offset(0, 10);
      await gesture1.down(touchDown1);
      await gesture2.down(touchDown2);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchDownData1 = controller.data[888];
      final PointerData? touchDownData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsOneWidget);
      expect(pointerChildFinder2, findsOneWidget);
      expect(controller.data.length, 2);
      expect(touchDownData1?.pointerId, 888);
      expect(touchDownData1?.positionState.value, touchDown1);
      expect(touchDownData2?.pointerId, 999);
      expect(touchDownData2?.positionState.value, touchDown2);

      /// Touch move
      final Offset touchMove1 = childCenter + const Offset(0, 10);
      final Offset touchMove2 = childCenter;
      await gesture1.moveTo(touchMove1);
      await gesture2.moveTo(touchMove2);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchMoveData1 = controller.data[888];
      final PointerData? touchMoveData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsOneWidget);
      expect(pointerChildFinder2, findsOneWidget);
      expect(controller.data.length, 2);
      expect(touchMoveData1?.pointerId, 888);
      expect(touchMoveData1?.positionState.value, touchMove1);
      expect(touchMoveData2?.pointerId, 999);
      expect(touchMoveData2?.positionState.value, touchMove2);

      /// Touch up
      await gesture1.up();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchUpData1 = controller.data[888];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsNothing);
      expect(pointerChildFinder2, findsOneWidget);
      expect(controller.data.length, 1);
      expect(touchUpData1, null);

      /// Touch cancel
      await gesture2.cancel();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchUpData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsNothing);
      expect(pointerChildFinder2, findsNothing);
      expect(controller.data.length, 0);
      expect(touchUpData2, null);
    });

    testWidgets('dispose', (WidgetTester tester) async {
      final Finder childFinder = find.text('ShowTouches');
      final Finder pointerChildFinder1 = find.text('888');
      final Finder pointerChildFinder2 = find.text('999');
      final ShowTouchesController controller = ShowTouchesController();

      await tester.pumpWidget(
        ShowTouchesWidget(
          builder: (context, child) => child ?? const SizedBox(),
          controller: controller,
          pointerBuilder: (context, pointerId, position, animation) {
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Text(pointerId.toString()),
            );
          },
        ),
      );

      final TestGesture gesture1 = await tester.createGesture(
        pointer: 888,
        kind: PointerDeviceKind.touch,
      );
      final TestGesture gesture2 = await tester.createGesture(
        pointer: 999,
        kind: PointerDeviceKind.touch,
      );
      final Offset childCenter = tester.getCenter(childFinder);

      /// Touch down
      final Offset touchDown1 = childCenter;
      final Offset touchDown2 = childCenter + const Offset(0, 10);
      await gesture1.down(touchDown1);
      await gesture2.down(touchDown2);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final PointerData? touchDownData1 = controller.data[888];
      final PointerData? touchDownData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsOneWidget);
      expect(pointerChildFinder2, findsOneWidget);
      expect(controller.data.length, 2);
      expect(touchDownData1?.pointerId, 888);
      expect(touchDownData1?.positionState.value, touchDown1);
      expect(touchDownData2?.pointerId, 999);
      expect(touchDownData2?.positionState.value, touchDown2);

      /// dispose
      controller.dispose();
      await tester.pumpAndSettle();
      final PointerData? disposePointerData1 = controller.data[888];
      final PointerData? disposePointerData2 = controller.data[999];
      expect(childFinder, findsOneWidget);
      expect(pointerChildFinder1, findsNothing);
      expect(pointerChildFinder2, findsNothing);
      expect(controller.data.length, 0);
      expect(disposePointerData1, null);
      expect(disposePointerData2, null);
    });

    testWidgets(
      'dispose while removal animation is in progress does not throw',
      (WidgetTester tester) async {
        final Finder childFinder = find.text('ShowTouches');

        /// Internal controller (no controller passed),
        /// the widget owns and releases it on dispose.
        await tester.pumpWidget(const ShowTouchesWidget());

        final TestGesture gesture = await tester.createGesture(
          pointer: 888,
          kind: PointerDeviceKind.touch,
        );
        final Offset center = tester.getCenter(childFinder);

        await gesture.down(center);
        await tester.pump();

        /// Lifting the finger starts the removal animation
        /// (forward + reverse); keep it in progress.
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 100));

        /// Destroy ShowTouches while the removal animation is still running.
        await tester.pumpWidget(const SizedBox());

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'external controller is not disposed by the widget',
      (WidgetTester tester) async {
        final ShowTouchesController controller = ShowTouchesController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(ShowTouchesWidget(controller: controller));
        await tester.pumpWidget(const SizedBox());

        expect(controller.isDisposed, isFalse);
      },
    );

    testWidgets(
      'updates when a new child is provided',
      (WidgetTester tester) async {
        Widget wrap(String text) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: ShowTouches(child: Text(text)),
          );
        }

        await tester.pumpWidget(wrap('first'));
        expect(find.text('first'), findsOneWidget);

        await tester.pumpWidget(wrap('second'));
        expect(find.text('first'), findsNothing);
        expect(find.text('second'), findsOneWidget);
      },
    );

    testWidgets(
      'toggling enable does not rebuild the child subtree',
      (WidgetTester tester) async {
        _ProbeState.initCount = 0;

        Widget wrap({required bool enable}) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: ShowTouches(enable: enable, child: const _Probe()),
          );
        }

        await tester.pumpWidget(wrap(enable: true));
        expect(_ProbeState.initCount, 1);

        await tester.pumpWidget(wrap(enable: false));
        await tester.pumpWidget(wrap(enable: true));
        expect(_ProbeState.initCount, 1);
      },
    );

    testWidgets(
      'replacing the controller rebinds gestures to the new controller',
      (WidgetTester tester) async {
        final ShowTouchesController controllerA = ShowTouchesController();
        addTearDown(controllerA.dispose);
        final ShowTouchesController controllerB = ShowTouchesController();
        addTearDown(controllerB.dispose);

        await tester.pumpWidget(ShowTouchesWidget(controller: controllerA));
        await tester.pumpWidget(ShowTouchesWidget(controller: controllerB));

        final TestGesture gesture = await tester.createGesture(
          pointer: 888,
          kind: PointerDeviceKind.touch,
        );
        final Offset center = tester.getCenter(find.text('ShowTouches'));
        await gesture.down(center);
        await tester.pump();

        expect(controllerB.data.containsKey(888), isTrue);
        expect(controllerA.data.containsKey(888), isFalse);

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'does not accumulate owned pointer ids after pointers are removed',
      (WidgetTester tester) async {
        await tester.pumpWidget(const ShowTouchesWidget());
        final dynamic state = tester.state(find.byType(ShowTouches));
        final Offset center = tester.getCenter(find.text('ShowTouches'));

        for (int i = 0; i < 3; i++) {
          final TestGesture gesture = await tester.createGesture(
            pointer: 100 + i,
            kind: PointerDeviceKind.touch,
          );
          await gesture.down(center);
          await tester.pump();
          await gesture.up();
          await tester.pumpAndSettle();
        }

        final Set<int> ownPointerIds = state.ownPointerIds as Set<int>;
        expect(ownPointerIds, isEmpty);
      },
    );
  });
}

/// Probe that counts how many times its [State] is initialised,
/// used to detect whether the child subtree is rebuilt from scratch.
class _Probe extends StatefulWidget {
  const _Probe();

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  static int initCount = 0;

  @override
  void initState() {
    super.initState();
    initCount++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
