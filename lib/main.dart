import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  var updateTime = 0.0;
  var _move = 0.0;
  var _stop = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<FragmentProgram>(
          future: _initShader(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return snapshot.data!.fragmentShader()
                    ..setFloat(0, updateTime)
                    ..setFloat(1, bounds.height)
                    ..setFloat(2, bounds.width);
                },
                child: const Center(
                    child: Text(
                  "TEST",
                  style: TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                )),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<FragmentProgram> _initShader() {
    return FragmentProgram.fromAsset("shader.glsl");
  }
}

class _MySweepPainter extends CustomPainter {
  _MySweepPainter(this.shader);

  final Shader shader;

  @override
  void paint(Canvas canvas, Size size) {
    const Rect rect = Rect.largest;
    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
