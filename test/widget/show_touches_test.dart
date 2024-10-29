import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:show_touches/show_touches.dart';

import '../show_touches_widget.dart';

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
  });
}
