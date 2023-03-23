import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'dart:async';
import 'package:flutter_crud_sqlite/controller/ListController.dart';

class SplashControllerState extends StatefulWidget {
  @override
  _SplashControllerScreenState createState() => _SplashControllerScreenState();
}

class _SplashControllerScreenState extends State<SplashControllerState>{

  Timer? _timer;

  void _startTimeout() {
    const duration = Duration(seconds: 3);
    _timer = Timer(duration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListControllerState()),
      );
    });
  }

  void _cancelTimeout() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void dispose() {
    _cancelTimeout();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: Scaffold(
        backgroundColor: Color(0xfffffffff),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.4,
                  ],
                  colors: [
                    Colors.yellow,
                    Colors.red,
                  ],
                )
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'The CRUD SQLite',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'List, Add, Remove, Filter',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
