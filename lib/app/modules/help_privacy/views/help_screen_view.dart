import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

class ImageSliderPage extends StatelessWidget {
  List<String> sampleImages = [
    'assets/screens/p1.jpeg',
    'assets/screens/p2.jpg',
    'assets/screens/p5.jpeg',
    'assets/screens/p6.jpeg',
    'assets/screens/p7.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 20,
            ),
            FanCarouselImageSlider(
              imagesLink: sampleImages,
              sliderHeight: 630,
              isAssets: true,
              autoPlay: false,
              isClickable: false,
            ),
          ],
        ),
      ),
    );
  }
}
