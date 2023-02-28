import 'package:controllers_flame/controllers_flame.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Tank extends SpriteComponent {
  final _speed = 3;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tank.png');
    size = Vector2(50, 50);
    anchor = Anchor.center;
  }

  move(Vector2 direction, double radians, double strength) {
    final newX = position.x + direction.x * _speed * strength;
    final newY = position.y + direction.y * _speed * strength;
    position = Vector2(newX, newY);
    angle = radians;
  }
}

class MyGame extends FlameGame with HasDraggableComponents {
  final tank = Tank();
  final crossController = CrossController();
  final circleController = CircleController();

  @override
  Future<void> onLoad() async {
    tank.center = Vector2(size.x / 2, size.y / 2);
    await add(tank);

    crossController.center = Vector2(size.x / 4, size.y - 150);
    await add(crossController);

    circleController.center = Vector2(size.x / 4 * 3, size.y - 150);
    await add(circleController);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (crossController.isMoving) {
      tank.move(crossController.direction, crossController.radians,
          crossController.strength);
    } else if (circleController.isMoving) {
      tank.move(circleController.direction, circleController.radians,
          circleController.strength);
    }
  }

  @override
  Color backgroundColor() => Colors.grey;
}

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
