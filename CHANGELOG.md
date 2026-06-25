# Changelog

## 0.1.0

**Breaking changes**

- `ShowTouchesController.data` now returns an unmodifiable view.

**New features**

- Added `ShowTouchesController.isDisposed`.
- `ShowTouchesController.removePointer` has an optional `onRemoved` callback, 
  fired after the pointer is fully removed.

**Improvements**

- Performance optimizations (fewer rebuilds and repaints).

**Fixes**

- Fixed an active-`Ticker` crash/leak when disposed during a pointer's removal animation.
- The widget no longer disposes of an externally provided controller.

## 0.0.1

- init