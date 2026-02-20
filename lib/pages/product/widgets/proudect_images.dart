import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/pages/product/model/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProudectImages extends StatefulWidget {
  const ProudectImages({super.key});

  @override
  State<ProudectImages> createState() => _ProudectImagesState();
}

class _ProudectImagesState extends State<ProudectImages> {
  int indexoffer = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            clipBehavior: Clip.hardEdge,

            scrollPhysics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            height: 180,
            aspectRatio: 1.0,
            viewportFraction: .9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              setState(() {
                indexoffer = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(
            items[0].images.length,
            (index) => ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: Image.asset(
                items[0].images[index],

                width: 400,
                height: 180,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Gap(10),
        AnimatedSmoothIndicator(
          activeIndex: indexoffer,
          count: items[0].images.length,

          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 2,
            activeDotColor: Colors.pinkAccent,
          ),
        ),
      ],
    );
  }
}
