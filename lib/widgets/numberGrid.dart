import 'package:flutter/material.dart';
import 'package:flutter_tf_digit_recognizer/models/prediction.dart';

class NumbersGrid extends StatelessWidget {
  final List<Prediction> predictions;

  const NumbersGrid({Key key, this.predictions}) : super(key: key);

  List<dynamic> getStyle(List<Prediction> predictions) {
    List<dynamic> data = [null, null, null, null, null, null, null, null, null, null];
    predictions?.forEach((item) {
      data[item.index] = item;
    });
    return data;
  }

  Widget _number(int num, Prediction prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.amber.withOpacity(
              (prediction.confidence * 2).clamp(0, 1).toDouble(),
            ),
          ),
        ),
        Text(
          '${prediction == null ? '' : (prediction.confidence * 100).toStringAsFixed(2) + '%'}',
          style: TextStyle(
            fontSize: 12,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = getStyle(this.predictions);

    /// todo change
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[for (var i = 0; i < 5; i++) _number(i, style[i])],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[for (var i = 5; i < 10; i++) _number(i, style[i])],
        )
      ],
    );
  }
}
