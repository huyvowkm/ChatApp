import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DynamicImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isCircle;
  final Widget placeHolder;
  Color? color;

  DynamicImage(
    this.url, {
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = BorderRadius.zero,
    this.isCircle = false,
    this.placeHolder = const SizedBox.shrink(),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final imageType = url.substring(url.lastIndexOf('.') + 1);
    Widget image = Container(color: Colors.transparent);
    switch (imageType) {
      case 'svg':
        {
          if (url.startsWith('http')) {
            image = SvgPicture.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              color: color,
            );
          } else {
            image = SvgPicture.asset(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              color: color,
            );
          }
        }
      default:
        {
          if (url.startsWith('http')) {
            image = Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.transparent),
            );
          } else if (url.startsWith('/')) {
            image = Image.file(
              File(url),
              width: width,
              height: height,
              fit: BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) => 
                Container(color: Colors.transparent),
            );
          } else {
            image = Image.asset(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.transparent),
            );
          }
        }
    }
    return isCircle
        ? SizedBox(
            width: width,
            height: height,
            child: ClipOval(
              child: image,
            ),
          )
        : SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: image,
            ),
          );
  }
}
