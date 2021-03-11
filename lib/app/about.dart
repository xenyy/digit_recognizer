import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          children: [
            Text(
              'This app uses a trained model from https://www.kaggle.com/',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'I made this app to practice some new skills. It is not perfect but it kinda works',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


}
