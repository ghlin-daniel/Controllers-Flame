library controllers_flame;

import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';

const String _imagesPrefix = 'packages/controllers_flame/assets/images/';
final Vector2 _defaultDirection = Vector2.zero();

class CrossController extends SpriteComponent with DragCallbacks {
  static const String _defaultSpriteName = 'cross_flat_dark.png';
  static final Vector2 _defaultSize = Vector2.all(150);
  static const int _degreesRange = 45;
  static final _radians = {
    _defaultDirection: 0.0,
    Vector2(1, 0): 0.0,
    Vector2(0, -1): -pi / 2,
    Vector2(-1, 0): pi,
    Vector2(0, 1): pi / 2
  };

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

  bool get isMoving => _direction != _defaultDirection;

  Vector2 get direction => _direction;

  double get radians => _radians[_direction]!;

  double get strength => 1.0;

  @override
  void onDragStart(DragStartEvent event) {
    _calculate(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _calculate(event.canvasPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _direction = _defaultDirection;
  }

  _calculate(Vector2 position) {
    final offset = position - center;

    final theta = atan2(offset.y, offset.x);
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

class CircleController extends SpriteComponent with DragCallbacks {
  static const String _defaultCircleSpriteName = 'circle_flat_dark_circle.png';
  static final Vector2 _defaultCircleSize = Vector2.all(160);

  static const String _defaultAxisSpriteName = 'circle_flat_dark_axis.png';
  static final Vector2 _defaultAxisSize = Vector2.all(96);

  final String _circleSpriteName;
  final String _axisSpriteName;

  final SpriteComponent _axis;

  late final double _radiusCircle;
  late final double _radiusAxis;
  late final double _radiusMovingRange;

  Vector2 _direction = _defaultDirection;
  double _radians = 0.0;
  double _strength = 0.0;

  CircleController(
      {String? circleSpriteName,
      Vector2? circleSize,
      String? axisSpriteName,
      Vector2? axisSize})
      : _circleSpriteName = circleSpriteName ?? _defaultCircleSpriteName,
        _axisSpriteName = axisSpriteName ?? _defaultAxisSpriteName,
        _axis = SpriteComponent(size: axisSize ?? _defaultAxisSize),
        super(size: circleSize ?? _defaultCircleSize) {
    _radiusCircle = width / 2;
    _radiusAxis = _axis.width / 2;
    _radiusMovingRange = _radiusCircle - _radiusAxis;
  }

  @override
  Future<void> onLoad() async {
    final imagesForCircle = _circleSpriteName != _defaultCircleSpriteName
        ? Flame.images
        : Images(prefix: _imagesPrefix);
    sprite = await Sprite.load(_circleSpriteName, images: imagesForCircle);
    final imagesForAxis = _axisSpriteName != _defaultAxisSpriteName
        ? Flame.images
        : Images(prefix: _imagesPrefix);
    _axis.sprite = await Sprite.load(_axisSpriteName, images: imagesForAxis);
    _axis.center = Vector2(width / 2, height / 2);
    await add(_axis);
  }

  bool get isMoving => _direction != _defaultDirection;

  Vector2 get direction => _direction;

  double get radians => _radians;

  double get strength => _strength;

  @override
  void onDragStart(DragStartEvent event) {
    _calculate(event.canvasPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _calculate(event.canvasPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _reset();
  }

  _calculate(Vector2 position) {
    final offset = position - center;

    _radians = atan2(offset.y, offset.x);
    _direction = Vector2(cos(_radians), sin(_radians));

    final radius = sqrt(offset.x * offset.x + offset.y * offset.y);
    if (radius < _radiusMovingRange) {
      _strength = radius / _radiusMovingRange;
      _axis.center = position - this.position;
    } else {
      _strength = 1;
      final rangeX = width / 2 + _radiusMovingRange * _direction.x;
      final rangeY = height / 2 + _radiusMovingRange * _direction.y;
      _axis.position = Vector2(rangeX - _radiusAxis, rangeY - _radiusAxis);
    }
  }

  _reset() {
    _direction = _defaultDirection;
    _radians = 0.0;
    _strength = 0.0;
    _axis.center = Vector2(width / 2, height / 2);
  }
}
