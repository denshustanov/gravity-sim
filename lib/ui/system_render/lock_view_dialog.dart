import 'package:flutter/material.dart';

import '../../model/planet.dart';

class LockViewDialog extends StatefulWidget {
  const LockViewDialog(
      {Key? key, required this.planetsCount, required this.selected})
      : super(key: key);
  final int planetsCount;
  final int selected;

  @override
  State<LockViewDialog> createState() => _LockViewDialogState();
}

class _LockViewDialogState extends State<LockViewDialog> {
  late int? _selected = widget.selected;

  int get count => widget.planetsCount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select planet'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<int>(
          value: _selected,
          items: generateItems(),
          onChanged: (value) {
            _selected = value;
            setState(() {});
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selected);
            },
            child: const Text('Ok'))
      ],
    );
  }

  List<DropdownMenuItem<int>> generateItems() {
    final items = <DropdownMenuItem<int>>[
      const DropdownMenuItem(
        value: -1,
        child: Text('Fixed'),
      ),
    ];
    for (int i = 0; i < count; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text('Planet ${i + 1}'),
        ),
      );
    }
    return items;
  }
}
