import 'package:flutter/material.dart';
import 'package:flutterapp/config/palette.dart';

class FullSizeImage extends StatelessWidget {
  final String imageUrl;

  const FullSizeImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.activeColor,
        title: Text('원본 이미지'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}