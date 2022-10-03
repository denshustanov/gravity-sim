import 'dart:math';
import 'package:gravity_simulation/model/planet.dart';

class GravityService{
  static const double G = 6.6743e-11;

  static double accelerationX(List<Planet> planets, Planet planet) {
    double aX = 0;
    for (Planet p in planets) {
      if (planet != p) {
        aX += G *
            p.mass /
            pow(Planet.distance(planet, p), 3) *
            (p.position.x - planet.position.x);
      }
    }
    return aX;
  }

  static double accelerationY(List<Planet> planets, Planet planet) {
    double aX = 0;
    for (Planet p in planets) {
      if (planet != p) {
        aX += G *
            p.mass /
            pow(Planet.distance(planet, p), 3) *
            (p.position.y - planet.position.y);
      }
    }
    return aX;
  }
}