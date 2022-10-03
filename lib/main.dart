import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gravity_simulation/service/calculation/difference_scheme/impl/euler_cromer_scheme.dart';
import 'package:gravity_simulation/service/calculation/difference_scheme/impl/irregular_euler_cromer_method.dart';
import 'package:gravity_simulation/store/system_store.dart';
import 'package:gravity_simulation/ui/system_render/sysytem_reder_page.dart';

void main() {
  final getIt = GetIt.instance;
  getIt.allowReassignment = true;
  getIt.registerSingleton<EulerCromerScheme>(EulerCromerScheme());
  getIt.registerSingleton<IrregularEulerCromerScheme>(
      IrregularEulerCromerScheme());
  getIt.registerSingleton<SystemStore>(SystemStore());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gravity sim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SystemRenderPage(),
    );
  }
}
