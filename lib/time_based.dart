import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class TimeBased extends StatefulWidget {
  const TimeBased({super.key});

  @override
  State<TimeBased> createState() => _TimeBasedState();
}

class _TimeBasedState extends State<TimeBased> {
  bool _enable = false;
  Artboard? _artboard;
  SMIInput<double>? isGrow;
  RiveAnimationController? controller;
  Timer? _timer;
  int _secs = 0;

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_secs >= 20) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _enable = true;
          _secs++;
          isGrow?.value += 5;
        });
      }
    });
  }

  void _pause() {
    setState(() {
      _enable = false;
      _timer?.cancel();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.load('assets/tree_demo.riv').then((data) async {
      try {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          isGrow = controller.findInput('input');
        }
        setState(() {
          _artboard = artboard;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _artboard == null
          ? const SizedBox()
          : Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 0),
                        height: 400,
                        child: Rive(
                          artboard: _artboard!,
                        )),
                    Text(
                      '00:${_secs.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 40),
                    ),
                    _enable
                        ? IconButton(
                            onPressed: _pause,
                            icon: Icon(
                              _enable ? Icons.pause_circle : Icons.play_circle,
                              size: 60,
                              color: Colors.black,
                            ))
                        : IconButton(
                            onPressed: _startTimer,
                            icon: Icon(
                              _enable ? Icons.pause_circle : Icons.play_circle,
                              size: 60,
                              color: Colors.black,
                            ))
                  ],
                ),
              ),
            ),
    );
  }
}
