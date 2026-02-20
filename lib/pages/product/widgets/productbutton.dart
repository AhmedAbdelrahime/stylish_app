

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ProductBotton extends StatelessWidget {
  const ProductBotton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset('assets/svgs/go_to_cart.svg'),
          ),
          Gap(10),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset('assets/svgs/buy_now.svg'),
          ),
        ],
      ),
    );
  }
}
