import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:show_touches/show_touches.dart';

void main() {
  group('PointerData', () {
    test('holds the provided fields', () {
      final animationController = AnimationController(vsync: const TestVSync());
      addTearDown(animationController.dispose);
      final positionState = ValueNotifier<Offset>(const Offset(1.0, 1.0));
      addTearDown(positionState.dispose);
      final pointerOverlayEntry = OverlayEntry(
        builder: (context) => const SizedBox(),
      );
      addTearDown(pointerOverlayEntry.dispose);

      final PointerData data = PointerData(
        pointerId: 999,
        positionState: positionState,
        animationController: animationController,
        pointerOverlayEntry: pointerOverlayEntry,
      );

      expect(data.pointerId, 999);
      expect(data.positionState, same(positionState));
      expect(data.animationController, same(animationController));
      expect(data.pointerOverlayEntry, same(pointerOverlayEntry));
    });

    test('== uses pointerId value and reference identity', () {
      final animationController = AnimationController(vsync: const TestVSync());
      addTearDown(animationController.dispose);
      final positionState = ValueNotifier<Offset>(const Offset(1.0, 1.0));
      addTearDown(positionState.dispose);
      final pointerOverlayEntry = OverlayEntry(
        builder: (context) => const SizedBox(),
      );
      addTearDown(pointerOverlayEntry.dispose);

      PointerData build(int pointerId) {
        return PointerData(
          pointerId: pointerId,
          positionState: positionState,
          animationController: animationController,
          pointerOverlayEntry: pointerOverlayEntry,
        );
      }

      final PointerData a = build(1);
      final PointerData b = build(1);

      /// Same id and same references -> equal.
      expect(a, b);
      expect(a.hashCode, b.hashCode);

      /// Different id -> not equal.
      expect(a, isNot(build(2)));

      /// Same id but a different position reference -> not equal.
      final ValueNotifier<Offset> otherPosition =
          ValueNotifier<Offset>(const Offset(1.0, 1.0));
      addTearDown(otherPosition.dispose);
      expect(
        a,
        isNot(
          PointerData(
            pointerId: 1,
            positionState: otherPosition,
            animationController: animationController,
            pointerOverlayEntry: pointerOverlayEntry,
          ),
        ),
      );
    });
  });

  group('ShowTouchesController', () {
    test('data is an unmodifiable view', () {
      final ShowTouchesController controller = ShowTouchesController();
      addTearDown(controller.dispose);
      expect(() => controller.data.clear(), throwsUnsupportedError);
    });
  });
}
