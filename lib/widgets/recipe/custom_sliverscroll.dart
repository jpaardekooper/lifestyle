import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/placeholder/placeholder_img.dart';
import 'package:lifestylescreening/widgets/recipe/stacked_details.dart';
import 'package:lifestylescreening/widgets/text/white_text.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  MySliverAppBar(
      {@required this.expandedHeight,
      @required this.imgUrl,
      @required this.name,
      @required this.onTap});

  final double expandedHeight;
  final String imgUrl;
  final String name;

  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(fit: StackFit.expand, overflow: Overflow.visible, children: [
      PlaceholderImg(
        imgUrl: imgUrl,
        topLeft: false,
        topRight: false,
        bottomLeft: true,
        bottomRight: true,
        size: 40,
      ),
      Opacity(
        opacity: shrinkOffset / expandedHeight,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(255, 129, 128, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.arrow_back_ios),
              ),
              Center(child: WhiteText(text: name, size: 23)),
              Icon(Icons.favorite),
            ],
          ),
        ),
      ),
      Opacity(
        opacity: (1 - shrinkOffset / expandedHeight),
        child: Container(
          padding:
              EdgeInsets.only(top: expandedHeight / 15, left: 40, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(onTap: onTap, child: Icon(Icons.arrow_back_ios)),
              Icon(Icons.favorite),
            ],
          ),
        ),
      ),
      StackedDetails(
        expandedHeight: expandedHeight,
        shrinkOffset: shrinkOffset,
        name: name,
        colored: true,
      ),
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
