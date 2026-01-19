// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/*final List stockImg = [
  "images/1.jpg",
  "images/2.jpg",
  "images/3.jpeg",
];*/

class SliderWidget extends StatelessWidget {
  final List stockImg;
  const SliderWidget({super.key, required this.stockImg});

  @override
  Widget build(BuildContext context) {
    //print(stockImg);
    final isNotSmallScreen = MediaQuery.of(context).size.width >300;
    return   CarouselSlider(
      options: CarouselOptions(
        height: isNotSmallScreen?250:200,
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
  height: 120.0, // Version ultra-compacte
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 2.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4.0,
        offset: const Offset(0, 1),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.network(
      photo,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 32.0,
            color: Colors.grey[500],
          ),
        );
      },
    ),
  ),
);
  }
}


