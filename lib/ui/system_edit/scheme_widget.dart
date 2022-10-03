import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gravity_simulation/service/calculation/difference_scheme/difference_sheme.dart';
import 'package:gravity_simulation/store/system_store.dart';
import '../../service/calculation/difference_scheme/impl/euler_cromer_scheme.dart';
import '../../service/calculation/difference_scheme/impl/irregular_euler_cromer_method.dart';
import '../../service/calculation/method_type.dart';

class SchemeEditWidget extends StatefulWidget {
  const SchemeEditWidget({Key? key}) : super(key: key);

  @override
  State<SchemeEditWidget> createState() => _SchemeEditWidgetState();
}

class _SchemeEditWidgetState extends State<SchemeEditWidget> {
  final SystemStore _store = GetIt.instance<SystemStore>();

  final _timeStepController = TextEditingController();
  final _timeStepCloseController = TextEditingController();
  final _thresholdController = TextEditingController();
  late MethodType _methodType;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (_store.differenceScheme is IrregularEulerCromerScheme) {
      IrregularEulerCromerScheme scheme =
          _store.differenceScheme as IrregularEulerCromerScheme;
      _timeStepController.text = scheme.dt.toString();
      _timeStepCloseController.text = scheme.dt2.toString();
      _thresholdController.text = scheme.distanceThreshold.toString();
      _methodType = MethodType.irregular;
    } else if (_store.differenceScheme is EulerCromerScheme) {
      EulerCromerScheme scheme = _store.differenceScheme as EulerCromerScheme;
      _timeStepController.text = scheme.dt.toString();
      _methodType = MethodType.eulerKromer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<MethodType>(
              value: _methodType,
              items: const [
                DropdownMenuItem(
                  value: MethodType.eulerKromer,
                  child: Text('Euler-Cromer'),
                ),
                DropdownMenuItem(
                  value: MethodType.irregular,
                  child: Text('Irregular Euler-Cromer'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _methodType = value;
                    if (value == MethodType.irregular) {
                      final scheme = GetIt.instance<IrregularEulerCromerScheme>();
                      _store.setScheme(scheme);
                      _timeStepController.text = scheme.dt.toString();
                      _timeStepCloseController.text = scheme.dt2.toString();
                      _thresholdController.text = scheme.distanceThreshold.toString();

                    } else if (value == MethodType.eulerKromer) {
                      final scheme = GetIt.instance<EulerCromerScheme>();
                      _store.setScheme(scheme);
                      _timeStepController.text = scheme.dt.toString();
                    }
                  });
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: _formFields(),
            ),
          ),
        ),
      ],
    );
  }

  String? _doubleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required filed";
    } else if (double.tryParse(value) == null) {
      return "Number field";
    }
    return null;
  }

  List<Widget> _formFields(){
    if(_methodType == MethodType.eulerKromer){
      return _eulerCromerFields();
    } else if(_methodType == MethodType.irregular){
      return _irregularEulerCromerFields();
    } else{
      return [];
    }
  }

  List<Widget> _eulerCromerFields() {
    return [
      TextFormField(
        controller: _timeStepController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Time step'),
        validator: _doubleValidator,
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            (_store.differenceScheme as EulerCromerScheme).dt =
                double.parse(value);
          }
        },
      )
    ];
  }

  List<Widget> _irregularEulerCromerFields() {
    return [
      TextFormField(
        controller: _timeStepController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Time step'),
        validator: _doubleValidator,
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            (_store.differenceScheme as IrregularEulerCromerScheme).dt =
                double.parse(value);
          }
        },
      ),
      TextFormField(
        controller: _timeStepCloseController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Close planets time step'),
        validator: _doubleValidator,
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            (_store.differenceScheme as IrregularEulerCromerScheme).dt2 =
                double.parse(value);
          }
        },
      ),
      TextFormField(
        controller: _thresholdController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Distance threshold'),
        validator: _doubleValidator,
        onChanged: (value) {
          if (_formKey.currentState!.validate()) {
            (_store.differenceScheme as IrregularEulerCromerScheme)
                .distanceThreshold = double.parse(value);
          }
        },
      ),
    ];
  }
}
