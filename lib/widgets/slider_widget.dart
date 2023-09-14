import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List stockImg = [
  "images/1.jpg",
  "images/2.jpg",
  "images/3.jpeg",
];


class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 1/1,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
      items: stockImg.map((photo) {
        return Builder(
          builder: (BuildContext context){
            return imageBox(photo);
          },
        );
      }).toList(),
    );
  }

  Widget imageBox(String photo){
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(1.0),
      child: Image(
        image: AssetImage(photo),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),

    );
  }
}


