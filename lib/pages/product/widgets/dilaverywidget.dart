import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_text.dart';

class DelevaryWidget extends StatelessWidget {
  const DelevaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 5, 20, 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.pink.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: 'Delivery in ', size: 16, weight: FontWeight.w600),
            CustomText(
              text: '1 within Hour ',
              size: 20,
              weight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}