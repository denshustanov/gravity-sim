import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:gravity_simulation/store/system_store.dart';
import 'package:gravity_simulation/ui/system_edit/planet_edit_dialog.dart';
import 'package:gravity_simulation/ui/system_edit/scheme_widget.dart';
import 'package:gravity_simulation/ui/system_edit/system_create_dialog.dart';
import '../../model/planet.dart';

class SystemEditPage extends StatefulWidget {
  const SystemEditPage({this.newSystem = false, Key? key}) : super(key: key);
  final bool newSystem;

  @override
  State<SystemEditPage> createState() => _SystemEditPageState();
}

class _SystemEditPageState extends State<SystemEditPage> {
  static const double cellWidth = 70;
  final SystemStore _systemStore = GetIt.instance<SystemStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_systemStore.planets.isEmpty || widget.newSystem) {
        _showInitialDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System edit'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(
                builder: (context) => ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text('Planets'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          SizedBox(width: 30, child: Text('#')),
                          SizedBox(width: cellWidth, child: Text('M')),
                          SizedBox(width: cellWidth, child: Text('X')),
                          SizedBox(width: cellWidth, child: Text('Y')),
                          SizedBox(width: cellWidth, child: Text('Vx')),
                          SizedBox(width: cellWidth, child: Text('Vy')),
                        ],
                      ),
                    ),
                    for (int i = 0; i < _systemStore.planets.length; i++) ...[
                      GestureDetector(
                        onTap: () => _editPlanetHandler(
                            _systemStore.planets.elementAt(i)),
                        // onLongPress: () => _removePlanetHandler(i),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                (i % 2 == 0) ? Colors.white : Colors.grey[300],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 30, child: Text((i + 1).toString())),
                                SizedBox(
                                  width: cellWidth,
                                  child: Text(_systemStore.planets
                                      .elementAt(i)
                                      .mass
                                      .toStringAsExponential(2)),
                                ),
                                SizedBox(
                                  width: cellWidth,
                                  child: Text(_systemStore.planets
                                      .elementAt(i)
                                      .position
                                      .x
                                      .toStringAsExponential(2)),
                                ),
                                SizedBox(
                                  width: cellWidth,
                                  child: Text(_systemStore.planets
                                      .elementAt(i)
                                      .position
                                      .y
                                      .toStringAsExponential(2)),
                                ),
                                SizedBox(
                                  width: cellWidth,
                                  child: Text(_systemStore.planets
                                      .elementAt(i)
                                      .vX
                                      .toStringAsExponential(2)),
                                ),
                                SizedBox(
                                  width: cellWidth,
                                  child: Text(_systemStore.planets
                                      .elementAt(i)
                                      .vY
                                      .toStringAsExponential(2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SchemeEditWidget(),
          ],
        ),
      ),
    );
  }

  _showInitialDialog() async {
    List<Planet> planets = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const SystemCreateDialog());
    _systemStore.setPlanets(planets);
  }

  // _removePlanetHandler(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: const Text('Remove planet?'),
  //       actions: [
  //         TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 planetarySystem.planets.removeAt(index);
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Ok')),
  //         TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel')),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _editPlanetHandler(Planet planet) async {
    await showDialog(
      context: context,
      builder: (context) => PlanetEditDialog(
        planet: planet,
      ),
    );
    setState(() {});
  }
}
