import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'recipe_details.dart';

class RecipeStyle extends StatelessWidget {
  RecipeStyle({this.name, this.id, this.url});
  final String name;
  final String id;
  final String url;

  final bool inFavorites = false;

  RawMaterialButton _buildFavoriteButton() {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
      onPressed: () {},
      child: Icon(
          // Conditional expression:
          inFavorites ? Icons.favorite : Icons.favorite_border,
          color: Colors.black),
      elevation: 2.0,
      fillColor: Colors.white,
      shape: CircleBorder(),
    );
  }

  Padding _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.all(15.0),
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
          Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text("15 m"),
              Spacer(),
              Icon(
                Icons.star,
                // color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                //         color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                //          color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                //        color: Colors.yellow,
              ),
              Icon(Icons.star_border)
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
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          //   color: Colors.white70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16 / 8,
                    child: Hero(
                      tag: "url",
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: url,
                        fit: BoxFit.fill,
                      ),

                      //  Image.network(
                      //   ,
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                  ),
                  //needs to become a statefull widget to do something properly
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              _buildTitleSection()
            ],
          ),
        ),
      ),
    );

    // Card(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       ListTile(
    //         leading: url != ""
    //             ? Hero(tag: "url", child: Image.network(u
    //rl, fit: BoxFit.fill))
    //             : Icons.read_more,
    //         title: Text(name),
    //         subtitle: Text('een receipt..'),
    //         trailing: Material(
    //           child: InkWell(
    //             onTap: () => {},
    //             splashColor: Colors.grey,
    //             highlightColor: Colors.grey,
    //             child: Icon(
    //               Icons.favorite,
    //               size: 24,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: <Widget>[
    //           TextButton(
    //             child: const Text('Meer info'),
    //             onPressed: () {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           CardDetails(name: name, id: id, url: url)),
    //               );
    //             },
    //           ),
    //           const SizedBox(width: 8),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
