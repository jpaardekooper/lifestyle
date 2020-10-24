import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/placeholder/placeholder_img.dart';
import 'package:lifestylescreening/widgets/recipe/stacked_details.dart';

class StackedContainer extends StatelessWidget {
  const StackedContainer(
      {@required this.imgUrl,
      @required this.topLeft,
      @required this.topRight,
      @required this.bottomLeft,
      @required this.bottomRight,
      @required this.size});

  final String imgUrl;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 30.0),
          alignment: Alignment.topCenter,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: PlaceholderImg(
            imgUrl: imgUrl,
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight,
            borderSize: size,
          ),
        ),
        Container(
          //color: Colors.white,
          width: 400.0,
          padding: EdgeInsets.only(left: 55, right: 55),
          child: StackedDetails(
            expandedHeight: 200,
            shrinkOffset: MediaQuery.of(context).size.width / 25,
            name: "Text",
            colored: false,
          ),
        ),
      ],
    );
    // Positioned(
    //   top: 0,
    //   child:
    // Container(
    //   alignment: Alignment.topCenter,
    //   height: 200,
    //   //     margin: EdgeInsets.only(bottom: 40, top: 40),
    //   child: PlaceholderImg(
    //     imgUrl: imgUrl,
    //     topLeft: topLeft,
    //     topRight: topRight,
    //     bottomLeft: bottomLeft,
    //     bottomRight: bottomRight,
    //     size: size,
    //   ),
    // ),
    // ),
    // Container(
    //   padding: EdgeInsets.only(top: 50, left: 55, right: 55),
    //   color: Colors.blue,
    //   margin: EdgeInsets.symmetric(horizontal: 40),
    //   child: Column(
    //     children: [
    //       Text("Test"),
    //       Row(
    //         children: [
    //           Icon(Icons.ac_unit_rounded),
    //           Icon(Icons.ac_unit_rounded),
    //           Icon(Icons.ac_unit_rounded),
    //         ],
    //       )
    //     ],
    //   ),
    // ),

    // StackedDetails(
    //   expandedHeight: 200,
    //   shrinkOffset: MediaQuery.of(context).size.width / 25,
    //   name: "Text",
    //   colored: false,
    // ),
    //     ],
    //   );
  }
}
