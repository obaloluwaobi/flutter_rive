import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class ControlledPage extends StatefulWidget {
  const ControlledPage({super.key});

  @override
  State<ControlledPage> createState() => _ControlledPageState();
}

class _ControlledPageState extends State<ControlledPage> {
  Artboard? _artboard;
  SMIInput<double>? isGrow;
  double _slider = 2;
  RiveAnimationController? controller;

  @override
  void initState() {
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

  void _plus() {
    setState(() {
      isGrow?.value += 2;
    });
  }

  void _minus() {
    setState(() {
      isGrow?.value -= 2;
    });
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 0),
                        height: 400,
                        child: Rive(
                          artboard: _artboard!,
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Slider.adaptive(
                          value: _slider,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              _slider = value;
                              isGrow?.value = _slider;
                            });
                          }),
                    ),
                    const Text(
                      'Drag to grow!',
                      style: TextStyle(fontSize: 20),
                    )

                    //if you wish to use btn + and - uncomment the code
                    // Row
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             shape: const RoundedRectangleBorder(),
                    //             backgroundColor: Colors.grey[700]),
                    //         onPressed: () {
                    //           _plus();
                    //         },
                    //         child: const Text(
                    //           '+',
                    //           style:
                    //               TextStyle(fontSize: 30, color: Colors.white),
                    //         )),
                    //     const Text(
                    //       '1',
                    //       style: TextStyle(fontSize: 40),
                    //     ),
                    //     ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             shape: const RoundedRectangleBorder(),
                    //             backgroundColor: Colors.grey[700]),
                    //         onPressed: () {
                    //           _minus();
                    //         },
                    //         child: const Text(
                    //           '-',
                    //           style:
                    //               TextStyle(fontSize: 30, color: Colors.white),
                    //         )),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
