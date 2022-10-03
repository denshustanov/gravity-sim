import 'dart:math';
import 'package:gravity_simulation/service/calculation/gravity_service.dart';
import '../../model/planet.dart';
import '../../model/position.dart';

class SystemCreator{
  List<Planet> createCircularSystem(int planetsCount){
    final List<Planet> planets = [];
    planets.add(Planet(mass: 2e30, position: Position(0, 0), vX: 0, vY: 0));
    for (int i = 1; i < planetsCount; i++) {
      final position = i * 1.5e11;
      final speed = sqrt(GravityService.G * 2e30 / position);
      planets.add(
        Planet(
          mass: 5.972e24,
          position: Position(position, 0),
          vX: 0,
          vY: speed,
        ),
      );
    }
    return planets;
  }

  List<Planet> createSunEarthMoonSystem(){
    final List<Planet> planets = [];
    const earthMass = 5.972e26;
    const moonMass = 7.3476e22;
    const sunMass = 1.989e30;
    final earthSpeed = sqrt(GravityService.G * sunMass / 1.5e11);
    const moonX = 1.55e11;
    const moonSpeed =  3.15e4;
    planets.add(Planet(mass: sunMass, position: Position(0, 0), vX: 0, vY: 0));
    planets.add(Planet(mass: earthMass, position: Position(1.5e11, 0), vX: 0, vY: earthSpeed));
    planets.add(Planet(mass: moonMass, position: Position(moonX, 0), vX: 0, vY: moonSpeed));
    return planets;
  }
}