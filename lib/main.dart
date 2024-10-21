import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const WaterTankApp());
}

class WaterTankApp extends StatelessWidget {
  const WaterTankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Dio dio;

  var percent = 0.5;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(
      baseUrl:
          "https://script.google.com/macros/s/AKfycbzz8utDSkeB18lK5FV3WYR4PE-gqiKGZSlQCykfdFXvlAhnW9dHyqKyiyzhnXYMZmrv/exec",
    ));
    poll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(builder: (context, box) {
              // final height = MediaQuery.of(context).size.height;
              final height = box.maxHeight;
              final h = percent * (height - 110);
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/water_level_animation.json',
                        width: double.infinity,
                      ),
                      Container(
                        height: h,
                        width: double.infinity,
                        color: const Color(0xff2AA2D6),
                        child: Transform.translate(
                          offset: const Offset(0, -3),
                          child: Container(
                            height: 5,
                            color: const Color(0xff2AA2D6),
                            // color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(percent * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "Water Level",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  poll() async {
    while (true) {
      var res = await dio.get('');
      var waterLevelPercent = res.data['waterLevel'];
      setState(() {
        percent = waterLevelPercent;
      });
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
