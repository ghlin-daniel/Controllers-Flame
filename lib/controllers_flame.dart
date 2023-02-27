library controllers_flame;

import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';

class CrossController extends SpriteComponent with DragCallbacks {
  static const String _imagesPrefix =
      'packages/controllers_flame/assets/images/';
  static const String _defaultSpriteName = 'cross_flat_dark.png';
  static final Vector2 _defaultDirection = Vector2.zero();
  static final Vector2 _defaultSize = Vector2.all(150);
  static const int _degreesRange = 20;

  final String _spriteName;
  Vector2 _direction = _defaultDirection;

  CrossController({String? spriteName, Vector2? size})
      : _spriteName = spriteName ?? _defaultSpriteName,
        super(size: size ?? _defaultSize);

  @override
  Future<void> onLoad() async {
    final images = _spriteName != _defaultSpriteName
        ? Flame.images
        : Images(prefix: _imagesPrefix);
    sprite = await Sprite.load(_spriteName, images: images);
  }

  Vector2 get direction => _direction;

  @override
  void onDragStart(DragStartEvent event) {
    _calculate(event.localPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _calculate(event.localPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _direction = _defaultDirection;
  }

  _calculate(Vector2 position) {
    final offsetX = position.x - width / 2;
    final offsetY = position.y - height / 2;

    final theta = atan2(offsetY, offsetX);
    final degrees = (theta / pi * 180) + (theta > 0 ? 0 : 360);
    if (degrees <= _degreesRange || degrees >= 360 - _degreesRange) {
      _direction = Vector2(1, 0);
    } else if (degrees <= 90 + _degreesRange && degrees >= 90 - _degreesRange) {
      _direction = Vector2(0, 1);
    } else if (degrees <= 180 + _degreesRange &&
        degrees >= 180 - _degreesRange) {
      _direction = Vector2(-1, 0);
    } else if (degrees <= 270 + _degreesRange &&
        degrees >= 270 - _degreesRange) {
      _direction = Vector2(0, -1);
    } else {
      _direction = _defaultDirection;
    }
  }
}
