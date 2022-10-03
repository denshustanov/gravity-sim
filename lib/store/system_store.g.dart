// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SystemStore on _SystemStore, Store {
  late final _$planetsAtom =
      Atom(name: '_SystemStore.planets', context: context);

  @override
  ObservableList<Planet> get planets {
    _$planetsAtom.reportRead();
    return super.planets;
  }

  @override
  set planets(ObservableList<Planet> value) {
    _$planetsAtom.reportWrite(value, super.planets, () {
      super.planets = value;
    });
  }

  late final _$_SystemStoreActionController =
      ActionController(name: '_SystemStore', context: context);

  @override
  void setPlanets(List<Planet> planets) {
    final _$actionInfo = _$_SystemStoreActionController.startAction(
        name: '_SystemStore.setPlanets');
    try {
      return super.setPlanets(planets);
    } finally {
      _$_SystemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateNext() {
    final _$actionInfo = _$_SystemStoreActionController.startAction(
        name: '_SystemStore.calculateNext');
    try {
      return super.calculateNext();
    } finally {
      _$_SystemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
planets: ${planets}
    ''';
  }
}
