import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tf_digit_recognizer/app/about.dart';
import 'package:flutter_tf_digit_recognizer/models/prediction.dart';
import 'package:flutter_tf_digit_recognizer/recognizer.dart';
import 'package:flutter_tf_digit_recognizer/utils/constants.dart';
import 'package:flutter_tf_digit_recognizer/utils/random_responses.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  final points = <Offset>[];
  final digitRecognizer = DigitRecognizer();
  List<Prediction> prediction = [];
  double avgPrediction = 0;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await digitRecognizer.loadModel();
  }

  void recognize() async {
    List<dynamic> predict = await digitRecognizer.recognize(points);
    setState(() {
      prediction = predict.map((e) => Prediction.fromJson(e)).toList();
      avgPrediction = prediction.map((e) => e.confidence).reduce((a, b) => a + b) / prediction.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'save',
            child: Icon(Icons.save_alt_rounded),
            heroTag: '1', //had to add this so it doesnt crash IDKY
            onPressed: () {
              //Todo add save
            },
          ),
          SizedBox(width: 15),
          FloatingActionButton(
            tooltip: 'clear',
            child: Icon(Icons.clear),
            heroTag: '2', //had to add this so it doesnt crash IDKY
            onPressed: () {
              setState(() {
                avgPrediction = 0;
                prediction?.clear();
                points?.clear();
              });
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Digit Recognizer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.info_outline_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => About()));
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Draw a digit and I will tell you what I guess',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Put me to test',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 15),
            buildDrawingCanvas(),
            SizedBox(height: 15),
            //NumbersGrid(predictions: prediction),
            prediction.isNotEmpty
                ? Column(
                    children: [
                      Text(getResponse(avgPrediction)),
                      SizedBox(height: 16),
                      prediction.length > 1
                          ? Text(
                              'My guesses are: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            )
                          : Text(
                              'My guess is: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                    ],
                  )
                : Container(),
            SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children:
                  prediction != null ? [...prediction.map((item) => Results(item: item)).toList()] : [Container()],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawingCanvas() {
    return Container(
      width: canvasSize + border * 2,
      height: canvasSize + border * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: border,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 0 &&
              _localPosition.dx <= canvasSize &&
              _localPosition.dy >= 0 &&
              _localPosition.dy <= canvasSize) {
            setState(() {
              points.add(_localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
          recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(points),
        ),
      ),
    );
  }

  String getResponse(double percent) {
    Random random = Random();
    int min, max, r;

    double num = double.parse((percent * 100).toStringAsFixed(2));

    if (num < 100.00 && num >= 50.00) {
      max = 15;
      min = 0;
      r = min + random.nextInt(max - min);
    } else if (num < 50.00 && num >= 0.00) {
      min = 15;
      max = randomResponses.length;
      r = min + random.nextInt(max - min);
    }

    final response = randomResponses[r];
    return response;
  }
}

class Results extends StatelessWidget {
  const Results({
    Key key,
    this.item,
  }) : super(key: key);

  final Prediction item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: 'I am ',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${(item.confidence * 100).toStringAsFixed(2)} %',
                style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' sure it is '),
              TextSpan(
                text: '${item.label}',
                style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),       
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.black
    ..strokeWidth = stroke;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
