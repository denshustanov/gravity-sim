import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:gravity_simulation/service/calculation/difference_scheme/difference_sheme.dart';
import 'package:gravity_simulation/service/calculation/gravity_service.dart';

import '../model/planet.dart';
import '../model/position.dart';
import '../service/calculation/difference_scheme/impl/euler_cromer_scheme.dart';

part 'system_store.g.dart';

class SystemStore = _SystemStore with _$SystemStore;

abstract class _SystemStore with Store {
  @observable
  DifferenceScheme differenceScheme = GetIt.instance<EulerCromerScheme>();

  @observable
  ObservableList<Planet> planets = ObservableList();

  @action
  void setPlanets(List<Planet> planets) {
    this.planets.clear();
    this.planets.addAll(planets);
  }

  @action
  void calculateNext() {
    for(Planet planet in planets){
      differenceScheme.nextStep(planets: planets, planet: planet);
    }
  }

  @action
  void setScheme(DifferenceScheme scheme){
    differenceScheme = scheme;
  }

  double massSum() =>
      planets.fold(0, (previousValue, element) => previousValue + element.mass);

  Position centerOfGravity() {
    final mass = massSum();
    final double x = planets.fold(
        0,
        (previousValue, element) =>
            previousValue + element.position.x * element.mass / mass);
    final double y = planets.fold(
        0,
        (previousValue, element) =>
            previousValue + element.position.y * element.mass / mass);
    return Position(x, y);
  }

  double impulse() {
    double impulse = 0;
    for (Planet p in planets) {
      impulse += p.mass * sqrt(pow(p.vX, 2) + pow(p.vY, 2));
    }
    return impulse;
  }

  double energy() {
    double potentialEnergy = 0;
    for (Planet p1 in planets) {
      for (Planet p2 in planets) {
        if (p1 != p2) {
          potentialEnergy -= GravityService.G *
              p1.mass *
              p2.mass /
              p1.position.distance(p2.position);
        }
      }
    }
    final double kineticEnergy = planets.fold(
        0, (previousValue, element) => previousValue + element.kineticEnergy());
    return kineticEnergy + potentialEnergy;
  }
}
