import 'dart:ui';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class ColorBloc extends BlocBase {
  ColorBloc();

  var colorController = BehaviorSubject<Color>.seeded(Colors.white);

  Stream<Color> get colorStream => colorController.stream;
  Sink<Color> get colorSink => colorController.sink;

  setColor(Color color) {
    colorSink.add(color);
  }

  @override
  void dispose() {
    colorController.close();
    super.dispose();
  }
}
