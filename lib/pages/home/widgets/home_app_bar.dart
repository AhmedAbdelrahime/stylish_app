import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.profileimageUrl});
  final String? profileimageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset('assets/svgs/menu.svg', height: 30),
          ),
          SvgPicture.asset('assets/logo/logo.svg', height: 35),
          GestureDetector(
            onTap: () {},
            child: ClipOval(
              child: profileimageUrl != null
                  ? Image.network(
                      profileimageUrl!,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/profile.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
