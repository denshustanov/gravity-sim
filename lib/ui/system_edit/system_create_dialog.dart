import 'package:flutter/material.dart';
import 'package:gravity_simulation/service/system_creator/system_creator.dart';
import 'package:gravity_simulation/ui/system_edit/system_pattern.dart';

class SystemCreateDialog extends StatefulWidget {
  const SystemCreateDialog({Key? key}) : super(key: key);

  @override
  State<SystemCreateDialog> createState() => _SystemCreateDialogState();
}

class _SystemCreateDialogState extends State<SystemCreateDialog> {
  SystemPattern? _pattern = SystemPattern.nCircular;
  int _planetsCount = 2;

  final _systemCreator = SystemCreator();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select pattern'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Circular orbits'),
              value: SystemPattern.nCircular,
              groupValue: _pattern,
              onChanged: (value) {
                setState(() {
                  _pattern = value;
                });
              },
            ),
            RadioListTile(
              title: const Text('Sun, Earth, Moon'),
              value: SystemPattern.sunEarthMoon,
              groupValue: _pattern,
              onChanged: (value) {
                _pattern = value;
                setState(() {});
              },
            ),
            Visibility(
                visible: _pattern == SystemPattern.nCircular,
                child: Row(
                  children: [
                    const Text('Planets count'),
                    IconButton(
                      onPressed: () {
                        if(_planetsCount>2){
                          setState(() {
                            _planetsCount--;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.grey,
                      ),
                    ),
                    Text(_planetsCount.toString()),
                    IconButton(
                      onPressed: () {
                        if(_planetsCount<10){
                          setState(() {
                            _planetsCount++;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              _createSystem();
            },
            child: const Text('Create'))
      ],
    );
  }

  _createSystem() async{
    if (_pattern == SystemPattern.nCircular) {
      Navigator.of(context).pop(_systemCreator.createCircularSystem(_planetsCount));
    } else {
      Navigator.of(context).pop(_systemCreator.createSunEarthMoonSystem());
    }
  }
}
