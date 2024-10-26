import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:show_touches/show_touches.dart';

void main() {
  group('PointerData', () {
    test('hashCode', () {
      final animationController = AnimationController(vsync: const TestVSync());
      final positionState = ValueNotifier<Offset>(const Offset(1.0, 1.0));
      final pointerOverlayEntry = OverlayEntry(
        builder: (context) => const SizedBox(),
      );
      final PointerData data = PointerData(
        pointerId: 999,
        positionState: positionState,
        animationController: animationController,
        pointerOverlayEntry: pointerOverlayEntry,
      );
      final PointerData dataExpect = PointerData(
        pointerId: 999,
        positionState: positionState,
        animationController: animationController,
        pointerOverlayEntry: pointerOverlayEntry,
      );

      expect(data, dataExpect);
      expect(data.hashCode, dataExpect.hashCode);
    });
  });
}
