import 'dart:math';

class Position {
  final double x;
  final double y;

  Position(this.x, this.y);

  double distance(Position p) {
    return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2));
  }
}
