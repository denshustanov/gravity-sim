import '../../../../model/planet.dart';
import '../../gravity_service.dart';
import '../difference_sheme.dart';
import 'euler_cromer_scheme.dart';

class IrregularEulerCromerScheme extends DifferenceScheme {
  double dt = 1e4;
  double distanceThreshold = 1e10;
  double dt2 = 1e3;

  @override
  void nextStep({
    required List<Planet> planets,
    required Planet planet,
    bool saveTrajectory = true,
  }) {
    List<Planet> distantPlanets = planets
        .where(
            (element) => Planet.distance(element, planet) > distanceThreshold)
        .toList();
    List<Planet> closePlanets =
        planets.where((element) => !distantPlanets.contains(element)).toList();
    closePlanets.remove(planet);
    double ax_d = 0;
    double ay_d = 0;
    if (distantPlanets.isNotEmpty) {
      ax_d = GravityService.accelerationX(distantPlanets, planet);
      ay_d = GravityService.accelerationY(distantPlanets, planet);
    }
    if (closePlanets.isNotEmpty) {
      final maxI = (dt / dt2 - 1).round();
      for (int i = 0; i < dt / dt2; i++) {
        EulerCromerScheme.eulerCromerMethod(
            planet: planet,
            ax: GravityService.accelerationX(closePlanets, planet) + ax_d,
            ay: GravityService.accelerationY(closePlanets, planet) + ay_d,
            dt: dt2,
            saveTrajectory: i == maxI);
      }
    } else if (distantPlanets.isNotEmpty) {
      EulerCromerScheme.eulerCromerMethod(
          planet: planet, ax: ax_d, ay: ay_d, dt: dt);
    }
  }
}
