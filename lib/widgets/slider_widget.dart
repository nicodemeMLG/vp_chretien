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
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(1.0),
      child: Image(
        image: NetworkImage(photo),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),

    );
  }
}


