import 'package:flutter/material.dart';
import 'package:hungry/pages/home/widgets/card_item.dart';
import 'package:hungry/shared/custom_text.dart';

class ProudectsSection extends StatelessWidget {
  const ProudectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CustomText(
            text: 'Colothes',
            size: 24,
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,

            itemCount: 10,
            itemBuilder: (context, index) => CardItem(),
          ),
        ),
      ],
    );
  }
}
