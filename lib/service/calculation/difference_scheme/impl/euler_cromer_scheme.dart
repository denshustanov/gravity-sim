import '../../../../model/planet.dart';
import '../../../../model/position.dart';
import '../../gravity_service.dart';
import '../difference_sheme.dart';

class EulerCromerScheme implements DifferenceScheme {
  double dt = 1E4;

  @override
  void nextStep(
      {required List<Planet> planets,
      required Planet planet,
      bool saveTrajectory = false}) {
    final aX = GravityService.accelerationX(planets, planet);
    final aY = GravityService.accelerationY(planets, planet);
    eulerCromerMethod(planet: planet, ax: aX, ay: aY, dt: dt);
  }

  static void eulerCromerMethod(
      {required Planet planet,
      required double ax,
      required double ay,
      required dt,
      saveTrajectory = true}) {
    planet.vX += ax * dt;
    planet.vY += ay * dt;
    final x = planet.position.x + planet.vX * dt;
    final y = planet.position.y + planet.vY * dt;
    final position = Position(x, y);
    planet.translate(position, saveTrajectory: saveTrajectory);
  }
}
