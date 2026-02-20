import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/pages/home/models/offeres_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OffersSection extends StatefulWidget {
  const OffersSection({super.key});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  int indexoffer = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            height: 180,
            aspectRatio: 1.0,
            viewportFraction: .8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
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
            offeresData.length,
            (index) => ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
              child: Image.asset(
                offeresData[index].image,
                width: 400,
                height: 200,

                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Gap(10),
        AnimatedSmoothIndicator(
          activeIndex: indexoffer,
          count: offeresData.length,

          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 8,
            expansionFactor: 3,
            activeDotColor: Colors.pinkAccent,
          ),
        ),
      ],
    );
  }
}
