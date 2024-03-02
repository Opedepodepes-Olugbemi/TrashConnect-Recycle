import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

void main() {
  runApp(
    GameWidget(
      game: TrashConnect(),
    ),
  );
}

class TrashConnect extends Forge2DGame {
  TrashConnect() : super(gravity: Vector2(0, 10.0));
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    Vector2 gameSize = screenToWorld(camera.viewport.effectiveSize);
    add(Ground(gameSize));
    add(Player());
  }
}

class Player extends BodyComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(
      SpriteComponent(
        sprite: await game.loadSprite('trash.png'),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 10;
    final fixtureDef = FixtureDef(shape, friction: 0.5);
    final bodyDef = BodyDef(position: Vector2(300, 20), type: BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ground extends BodyComponent {
  final Vector2 gameSize;

  Ground(this.gameSize);

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(Vector2(0, gameSize.y - 3), Vector2(gameSize.x, gameSize.y - 3));
    final fixtureDef = FixtureDef(shape, friction: 0.5);
    final bodyDef = BodyDef(userData: this, position: Vector2.zero());
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
