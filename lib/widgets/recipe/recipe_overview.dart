import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/placeholder/placeholder_img.dart';
import 'package:lifestylescreening/widgets/recipe/row_with_icons.dart';

import 'recipe_details.dart';

class RecipeOverview extends StatelessWidget {
  RecipeOverview({this.name, this.id, this.url});
  final String name;
  final String id;
  final String url;

  Padding _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 17),
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Divider(),
          Column(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RowWithIconAndText(
                icon: Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                text: "4.1",
              ),
              RowWithIconAndText(
                icon: Icon(
                  Icons.timer,
                  color: Colors.blue,
                ),
                text: "15 min",
              ),
              RowWithIconAndText(
                icon: Icon(
                  Icons.food_bank,
                  color: Colors.red,
                ),
                text: "makkelijk",
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardDetails(name: name, id: id, url: url),
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[800],
                        blurRadius: 0.5,
                        offset: Offset(0.0, 1.0),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: PlaceholderImg(
                    imgUrl: url,
                    topLeft: true,
                    topRight: false,
                    bottomLeft: true,
                    bottomRight: false,
                    borderSize: 20,
                  )),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 2 - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[800],
                      blurRadius: 0.5,
                      offset: Offset(0.0, 1.0),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: _buildTitleSection(),
              )
            ],
          ),
        )
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        //   child: Card(
        //     //   color: Colors.white70,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         // We overlap the image and the button by
        //         // creating a Stack object:
        //         Stack(
        //           children: <Widget>[
        //             AspectRatio(
        //               aspectRatio: 16 / 8,
        //               child: Hero(
        //                 tag: "url",
        //                 child: CachedNetworkImage(
        //                   placeholder: (context, url) =>
        //                       CircularProgressIndicator(),
        //                   imageUrl: url,
        //                   fit: BoxFit.fill,
        //                 ),

        //                 //  Image.network(
        //                 //   ,
        //                 //   fit: BoxFit.fill,
        //                 // ),
        //               ),
        //             ),
        //             //needs to become a statefull widget to do something properly
        //             Positioned(
        //               child: ButtonIcon(
        //                 icon: Icon(
        //                   Icons.favorite,
        //                   color: Colors.black,
        //                 ),
        //                 showText: false,
        //                 onTap: null,
        //                 backgroundText: "",
        //               ),
        //               top: 2.0,
        //               right: 2.0,
        //             ),
        //           ],
        //         ),
        //         _buildTitleSection()
        //       ],
        //     ),
        //   ),
        // ),)

        );
  }
}
