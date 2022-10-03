import 'dart:math';

import 'package:gravity_simulation/model/position.dart';

class Planet {
  double mass;
  Position position;
  double vX;
  double vY;
  List<Position> trajectory = [];

  Planet({
    required this.mass,
    required this.position,
    required this.vX,
    required this.vY,
  }) {
    trajectory.add(position);
  }

  double kineticEnergy() {
    return mass * (pow(vX, 2) + pow(vY, 2)) / 2;
  }

  Planet copy() {
    return Planet(mass: mass, position: position, vX: vX, vY: vY);
  }

  static double distance(Planet p1, Planet p2) {
    return sqrt(pow((p1.position.y - p2.position.y), 2) +
        pow((p1.position.x - p2.position.x), 2));
  }

  void translate(Position newPosition, {saveTrajectory=true}){
    position = newPosition;
    if(saveTrajectory){
      trajectory.add(position);
      if(trajectory.length>1000){
        trajectory.removeAt(0);
      }
    }
  }
}
