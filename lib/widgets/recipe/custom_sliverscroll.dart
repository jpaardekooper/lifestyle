import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/recipe/row_with_icons.dart';
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
  final Color red = const Color.fromRGBO(255, 129, 128, 0.9);
  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(fit: StackFit.expand, overflow: Overflow.visible, children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          imageUrl: imgUrl,
          fit: BoxFit.cover,
        ),
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
      Positioned(
        top: expandedHeight / 1.252 - shrinkOffset,
        left: MediaQuery.of(context).size.width / 6,
        right: MediaQuery.of(context).size.width / 6,
        child: Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Material(
            elevation: 10,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: expandedHeight / 5,
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WhiteText(
                        text: name,
                        size: 18,
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                  height: expandedHeight / 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RowWithIconAndText(
                        icon: Icon(
                          Icons.star,
                          color: Colors.orange[300],
                          size: 16,
                        ),
                        text: "4.3 ",
                      ),
                      RowWithIconAndText(
                        icon: Icon(
                          Icons.timer,
                          color: Colors.blue,
                          size: 16,
                        ),
                        text: "40 min",
                      ),
                      RowWithIconAndText(
                        icon: Icon(
                          Icons.food_bank,
                          color: Colors.red,
                          size: 16,
                        ),
                        text: "makkelijk",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
