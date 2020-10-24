import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/buttons/button_icon.dart';
import 'package:lifestylescreening/widgets/recipe/recipe_overview.dart';
import 'package:lifestylescreening/widgets/recipe/stacked_container.dart';
import 'package:lifestylescreening/widgets/text/dark_text.dart';

import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  final TextEditingController _queryController = TextEditingController();
  List<bool> isSelected = [false, false, true];
  int isSelectedNr = 2;
  Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //          height: 50,
            //          width: MediaQuery.of(context).size.width - 50,
            SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: _queryController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, bottom: 15),
                        hintText: 'Zoek recepten',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonIcon(
                  icon: Icon(Icons.ac_unit),
                  showText: true,
                  onTap: null,
                  backgroundText: "Filter",
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    ButtonIcon(
                      icon: Icon(
                        Icons.rate_review,
                        color: Colors.red,
                      ),
                      showText: false,
                      onTap: null,
                      backgroundText: "",
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text('''
Ontdek honderden gezonde en 
heerlijke recepten voor u gemaakt 
door onze voedingsexperts!'''),

            SizedBox(
              height: 30,
            ),
            Text("Trend van vandaag",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            SizedBox(
              height: 30,
            ),
            StackedContainer(
              imgUrl:
                  "https://bettyskitchen.nl/wp-content/uploads/2019/08/pinda_kip_uit_de_slowcooker_%C2%A9-bettyskitchen_DSC_3039-650x892.jpg",
              topLeft: true,
              topRight: true,
              bottomLeft: true,
              bottomRight: true,
              size: 20,
            ),
            SizedBox(
              height: 40,
            ),

            ToggleButtons(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Center(
                      child: Text("Ochtend",
                          style: TextStyle(
                              fontSize: 18,
                              color: isSelectedNr == 0
                                  ? Colors.white
                                  : Colors.black)),
                    )),

                //    Icon(Icons.ac_unit),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Center(
                      child: Text("Middag",
                          style: TextStyle(
                              fontSize: 18,
                              color: isSelectedNr == 1
                                  ? Colors.white
                                  : Colors.black)),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Center(
                        child: Text("Avond",
                            style: TextStyle(
                                fontSize: 18,
                                color: isSelectedNr == 2
                                    ? Colors.white
                                    : Colors.black)))),
              ],
              borderRadius: BorderRadius.all(Radius.circular(19)),
              splashColor: const Color.fromRGBO(255, 129, 128, 1),
              selectedBorderColor: const Color.fromRGBO(255, 129, 128, 1),
              fillColor: const Color.fromRGBO(255, 129, 128, 1),
              highlightColor: const Color.fromRGBO(255, 129, 128, 1),
              borderWidth: 1,
              onPressed: (int index) {
                setState(() {
                  isSelectedNr = index;
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
            SizedBox(
              height: 30,
            ),
            DarkText(
              text: "Hot recepten",
              size: 30,
            ),

            //      all recipes
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("recipes").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return FadeInTransition(
                    child: Column(children: getExpenseItems(snapshot)));
              },
            ),
          ],
        ),
      ),
    ));
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => RecipeOverview(
              name: doc['title'],
              id: doc.id,
              url: doc['url'],
            ))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
