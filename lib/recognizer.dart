import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'utils/constants.dart';

final cullRect = Rect.fromPoints(Offset(0,0), Offset(image,image));

class DigitRecognizer {

  Future loadModel() {
    Tflite.close();

    return Tflite.loadModel(
      model: "assets/mnist.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future recognize(List<Offset> points) async {
    final picture = picturePoints(points);
    Uint8List bytes = await imageToBytes(picture,dataSize);
    return runModel(bytes);
  }

  Future runModel(Uint8List bytes) {
    return Tflite.runModelOnBinary(binary: bytes);
  }

  Future<Uint8List> imageToBytes(Picture pic,int size) async {
    final img = await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;

    for (int i = 0; i < imgBytes.lengthInBytes; i += 4) {
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i + 1);
      final b = imgBytes.getUint8(i + 2);
      buffer[index++] = (r + g + b) / 3.0 / 255.0;
    }

    return resultBytes.buffer.asUint8List();
  }

  Picture picturePoints(List<Offset> points) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder,cullRect)..scale(dataSize/canvasSize);
    
    canvas.drawRect(Rect.fromLTWH(0, 0, image, image), Paint()..color = Colors.black);
    for (int i = 0; i < points.length -1 ; i++ ){
      if(points[i] != null && points[i+1] != null){
        canvas.drawLine(points[i], points[i+1], Paint()..strokeCap = StrokeCap.round..color = Colors.white..strokeWidth = stroke);
      }
    }

    return recorder.endRecording();
  }
}