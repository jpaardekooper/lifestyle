import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceholderImg extends StatelessWidget {
  const PlaceholderImg(
      {this.imgUrl,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight,
      this.borderSize});
  final String imgUrl;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? Radius.circular(borderSize) : Radius.circular(0),
          topRight: topRight ? Radius.circular(borderSize) : Radius.circular(0),
          bottomLeft:
              bottomLeft ? Radius.circular(borderSize) : Radius.circular(0),
          bottomRight:
              bottomRight ? Radius.circular(borderSize) : Radius.circular(0),
        ),
        child: Hero(
          tag: imgUrl,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            imageUrl: imgUrl,
            fit: BoxFit.cover,
          ),
        ));
  }
}