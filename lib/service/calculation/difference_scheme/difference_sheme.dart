import 'package:gravity_simulation/model/planet.dart';

abstract class DifferenceScheme {
  void nextStep(
      { required List<Planet> planets,
        required Planet planet,
      bool saveTrajectory});
}
