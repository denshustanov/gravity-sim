import 'package:flutter/material.dart';
import 'package:gravity_simulation/model/position.dart';

import '../../model/planet.dart';

class PlanetEditDialog extends StatefulWidget {
  PlanetEditDialog({this.planet, Key? key}) : super(key: key);
  Planet? planet;

  @override
  State<PlanetEditDialog> createState() => _PlanetEditDialogState();
}

class _PlanetEditDialogState extends State<PlanetEditDialog> {
  late final Planet _planet;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _massController = TextEditingController();
  final TextEditingController _xPosController = TextEditingController();
  final TextEditingController _yPosController = TextEditingController();
  final TextEditingController _xVelController = TextEditingController();
  final TextEditingController _yVelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _planet = widget.planet!;
      final planet = widget.planet!;
      _massController.text = planet.mass.toStringAsExponential(5);
      _xPosController.text = planet.position.x.toStringAsExponential(5);
      _yPosController.text = planet.position.y.toStringAsExponential(5);
      _xVelController.text = planet.vX.toStringAsExponential(5);
      _yVelController.text = planet.vY.toStringAsExponential(5);
    } else{
      _planet = Planet(mass: 0, position: Position(0, 0), vX: 0, vY: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _massController,
                  decoration: const InputDecoration(
                    labelText: 'Planet mass',
                  ),
                  validator: _validateDouble,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _xPosController,
                  decoration: const InputDecoration(
                    labelText: 'X position',
                  ),
                  validator: _validateDouble,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yPosController,
                  decoration: const InputDecoration(
                    labelText: 'Y position',
                  ),
                  validator: _validateDouble,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _xVelController,
                  decoration: const InputDecoration(labelText: 'X velocity'),
                  validator: _validateDouble,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yVelController,
                  decoration: const InputDecoration(labelText: 'Y velocity'),
                  validator: _validateDouble,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if(_formKey.currentState!.validate()) {
                _planet.mass = double.parse(_massController.text);
                final xPos = double.parse(_xPosController.text);
                final yPos = double.parse(_yPosController.text);
                if (_planet.position.x != xPos || _planet.position.y != yPos) {
                  _planet.position = Position(xPos, yPos);
                  _planet.trajectory = [];
                }
                _planet.vX = double.parse(_xVelController.text);
                _planet.vY = double.parse(_yVelController.text);
                Navigator.of(context).pop(_planet);
              }
            },
            child: const Text('Save')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
      ],
    );
  }

  String? _validateDouble(String? value){
    if(value==null || value.isEmpty){
      return 'Required filed';
    }
    if(double.tryParse(value)==null){
      return 'Invalid value';
    }
    return null;
  }
}
