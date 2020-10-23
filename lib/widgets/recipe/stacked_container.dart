import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/placeholder/placeholder_img.dart';
import 'package:lifestylescreening/widgets/recipe/stacked_details.dart';

class StackedContainer extends StatelessWidget {
  const StackedContainer({@required this.imgUrl, this.borderTop});
  final String imgUrl;
  final bool borderTop;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 40, top: 40),
          child: PlaceholderImg(
            imgUrl: imgUrl,
            topLeft: true,
            topRight: true,
            bottomLeft: false,
            bottomRight: false,
            size: 20,
          ),
        ),
        StackedDetails(
          expandedHeight: 240,
          shrinkOffset: 29,
          name: "Text",
          colored: false,
        ),
      ],
    );
  }
}
