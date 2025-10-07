import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Page'),
      ),
      body: Center(
        child: Text(
          'TEXT.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
