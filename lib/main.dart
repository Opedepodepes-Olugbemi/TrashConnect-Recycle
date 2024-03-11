import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: TrashConnect.new));
}

class TrashConnect extends Forge2DGame {
  TrashConnect() : super(gravity: Vector2(0, 7.0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport.add(FpsTextComponent());

    world.addAll(createBoundaries());
    world.add(Player(
      initialPosition: Vector2(0, 10),
      sprite: await loadSprite('trash.png')));
    world.add(Player(
      initialPosition: Vector2(5, 30),
      sprite: await loadSprite('trash_cntnr.png')));
      world.add(Player(
      initialPosition: Vector2(10, 30),
      sprite: await loadSprite('trash_kcup.png')));
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();

    return [
      Wall(topLeft, topRight),
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft),
    ];
  }
}

class Player extends BodyComponent with TapCallbacks {
  final Sprite sprite;

  Player({Vector2? initialPosition, required this.sprite})
      : super(
          fixtureDefs: [
            FixtureDef(
              CircleShape()..radius = 2,
              restitution: 0.2,
              friction: 0.5,
            ),
          ],
          bodyDef: BodyDef(
            angularDamping: 0.8,
            position: initialPosition ?? Vector2.zero(),
            type: BodyType.dynamic,
          ),
        );

@override
  void onTapDown(event) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;


        add(SpriteComponent(
        sprite: sprite,
        size: Vector2(4, 10),
        anchor: Anchor.center));
  }
}

// wall component
class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
