import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CompanyLogo extends StatelessWidget {
  final String? url;
  final double radius;
  final String companyName;
  const CompanyLogo({
    Key? key,
    required this.url,
    required this.radius,
    required this.companyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: radius,
          child: CachedNetworkImage(
            imageUrl: url ?? '',
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              height: radius,
              width: radius,
              color: Get.theme.inputDecorationTheme.fillColor,
              child: Center(
                child: Text(
                  companyName.substring(0, 1),
                  style: TextStyle(
                      fontSize: 0.45 * radius,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
