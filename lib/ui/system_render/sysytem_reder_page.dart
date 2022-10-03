import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:gravity_simulation/store/system_store.dart';
import 'package:gravity_simulation/ui/system_edit/system_edit_page.dart';
import 'package:gravity_simulation/ui/system_render/lock_view_dialog.dart';
import 'package:gravity_simulation/ui/system_render/system_painter.dart';

class SystemRenderPage extends StatefulWidget {
  const SystemRenderPage({Key? key}) : super(key: key);

  @override
  State<SystemRenderPage> createState() => _SystemRenderPageState();
}

class _SystemRenderPageState extends State<SystemRenderPage> {
  final SystemStore _systemStore = GetIt.instance<SystemStore>();

  late Timer timer;

  @override
  void initState() {
    super.initState();
  }

  bool _paused = true;
  double _scale = 1.5e9;
  double _xShift = 0;
  double _yShift = 0;
  double _initialScale = 1.5e9;
  // late final double width = MediaQuery.of(context).size.width;
  late final double? appBarHeight = Scaffold.of(context).appBarMaxHeight;
  // late final double height = MediaQuery.of(context).size.height - (appBarHeight !=null ? appBarHeight: 0);
  static const _defaultScale = 1.5e9;
  int coordinatesCenter = -1;

  bool get systemNotEmpty => _systemStore.planets.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planetary system'),
        actions: [
          IconButton(
              onPressed: _pauseButtonHandler,
              icon: Icon(_paused ? Icons.play_arrow : Icons.pause)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('New model'),
                onTap: () {
                  Future.delayed(
                      const Duration(seconds: 0), () => _newSystemHandler());
                },
              ),
              PopupMenuItem(
                onTap: systemNotEmpty
                    ? () {
                        Future.delayed(const Duration(seconds: 0),
                            () => _editSystemHandler());
                      }
                    : null,
                child: Text(
                  'Edit model',
                  style: TextStyle(
                      color: systemNotEmpty ? Colors.black : Colors.grey),
                ),
              ),
              PopupMenuItem(
                onTap: systemNotEmpty
                    ? () {
                        Future.delayed(const Duration(seconds: 0),
                            () => _setLockViewHandler());
                      }
                    : null,
                child: Text(
                  'Lock view',
                  style: TextStyle(
                      color: systemNotEmpty ? Colors.black : Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: Builder(
        builder: (context) {
          final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top-Scaffold.of(context).appBarMaxHeight!;
          final width = MediaQuery.of(context).size.width;
          return SizedBox(
            width: width,
            height: height,
            child: Observer(
              builder: (context) => GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    final center = _systemStore.centerOfGravity();
                    _xShift = -center.x / _scale;
                    _yShift = -center.y / _scale;
                    _scale = _defaultScale;
                  });
                },
                onScaleStart: (details) {
                  _initialScale = _scale;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    _xShift += details.focalPointDelta.dx;
                    _yShift += details.focalPointDelta.dy;
                    _scale = _initialScale / details.scale;
                  });
                },
                child: CustomPaint(
                  painter: SystemPainter(
                    planets: _systemStore.planets,
                    energy: _systemStore.energy(),
                    impulse: _systemStore.impulse(),
                    width: width,
                    height: height,
                    scale: _scale,
                    xShift: _xShift,
                    yShift: _yShift,
                    coordinatesCenter: coordinatesCenter,
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void timerCallback(Timer timer) {
    _systemStore.calculateNext();
    setState(() {});
  }

  void _newSystemHandler(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SystemEditPage(newSystem: true),
      ),
    );
  }

  _editSystemHandler(){
    timer.cancel();
    setState(() {
      _paused = true;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SystemEditPage(),
      ),
    );
  }

  void _pauseButtonHandler() {
    if (!_paused) {
      _paused = true;
      timer.cancel();
    } else {
      _paused = false;
      timer = Timer.periodic(const Duration(milliseconds: 10), timerCallback);
    }
    setState(() {});
  }


  Future<void> _setLockViewHandler() async {
    final int? selected = await showDialog(
      context: context,
      builder: (context) => LockViewDialog(
        planetsCount: _systemStore.planets.length,
        selected: coordinatesCenter,
      ),
    );
    if (selected != null) {
      setState(() {
        coordinatesCenter = selected;
      });
    }
  }
}
