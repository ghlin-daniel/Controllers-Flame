import 'dart:math';

import 'package:controllers_flame/controllers_flame.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Tank extends SpriteComponent {
  static final angles = {
    Vector2(1, 0): 0.0,
    Vector2(0, -1): -pi / 2,
    Vector2(-1, 0): pi,
    Vector2(0, 1): pi / 2
  };

  final _speed = 3;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tank.png');
    size = Vector2(50, 50);
    anchor = Anchor.center;
  }

  move(Vector2 direction) {
    final x = direction.x;
    final y = direction.y;

    if (x == 0 && y == 0) {
      return;
    }

    final newX = position.x + x * _speed;
    final newY = position.y + y * _speed;
    position = Vector2(newX, newY);

    angle = angles[direction] ?? angle;
  }
}

class MyGame extends FlameGame with HasDraggableComponents {
  final tank = Tank();
  final controller = CrossController();

  @override
  Future<void> onLoad() async {
    tank.center = Vector2(size.x / 2, size.y / 2);
    await add(tank);

    controller.center = Vector2(size.x / 2, size.y - 150);
    await add(controller);
  }

  @override
  void update(double dt) {
    super.update(dt);
    tank.move(controller.direction);
  }

  @override
  Color backgroundColor() => Colors.grey;
}

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
