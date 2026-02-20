import 'package:flutter/material.dart';
import 'package:hungry/shared/custom_text.dart';

class CatSection extends StatelessWidget {
  const CatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, 
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  height: 50,
                  width: 50,
                  'assets/images/cat.png',
                  fit: BoxFit.cover,
                ),
              ),
              CustomText(text: 'Beauty', size: 12, weight: FontWeight.w400),
            ],
          ),
        ),
      ),
    );
  }
}
