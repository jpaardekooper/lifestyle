import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_feed_buildup.dart';
import 'package:lifestylescreening/widgets/dialog/approve_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/feedback_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class RecipeEvaluationView extends StatefulWidget {
  RecipeEvaluationView({required this.recipe, this.userNewRecipe});
  final RecipeModel recipe;
  final bool? userNewRecipe;
  @override
  _RecipeEvaluationViewState createState() => _RecipeEvaluationViewState();
}

class _RecipeEvaluationViewState extends State<RecipeEvaluationView> {
  RecipeController _recipeController = RecipeController();
  String? imageUrl;
  String? collection;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, bool> generalInfoCheckList = {
    'Klopt de bereidingstijd?': false,
    'Is de aangegeven moeilijkheidsgraad een goede indicatie?': false,
    'Bevat de bereidingsduur zowel de voorbereidingstijd als bereidingstijd? ':
        false,
    'Zijn de juiste tags aangegeven?': false,
    // ignore: lines_longer_than_80_chars
    'Zijn de juiste benodigdheden, zoals werkmateriaal en apparatuur aangegeven?':
        false,
    'Is de doelgroep correct?': false,
  };

  Map<String, bool> ingredientCheckList = {
    'Zijn alle ingrediënten die gebruikt worden opgesomd?': false,
    // ignore: lines_longer_than_80_chars
    '•	Zijn er geen ingrediënten vergeten te benoemen terwijl deze wel in de methode staan? ingrediënten opstellen in de volgorde van het gebruiken (dus het eerste ingrediënt dat je gebruikt zet je als eerst in de lijst neer, het laatste ingrediënt dat je gebruikt als laatst = overzichtelijker)':
        false,
  };

  Map<String, bool> methodCheckList = {
    'Zijn de verschillende stappen in chronologische volgorde?': false,
    // ignore: lines_longer_than_80_chars
    'Het werkmateriaal en apparatuur worden in overeenstemming met de bereidingstechniek vermeld.':
        false,
    'Is het specifieke van de apparatuur of het materiaal benoemd?': false,
    'Staan er geen stappen dubbel/ontbreken er stappen?': false,
  };

  Map<String, bool> nutritionCheckList = {
    'Zijn de aangegeven voedingswaardes correct?': false,
    // ignore: lines_longer_than_80_chars
    'Staan de belangrijkste nutriënten erin (energie (kcal), totaal vet, verzadigd vet, koolhydraten, eiwit, vezels en zout)? eventueel alcohol? en totale energie inname per portie':
        false,
    'Zijn er belangrijke nutriënten vergeten te noteren?': false,
  };

  int checkpoints = 0;
  int? validator;

  @override
  void initState() {
    validator = generalInfoCheckList.length +
        ingredientCheckList.length +
        methodCheckList.length +
        nutritionCheckList.length;
    collection = widget.userNewRecipe! ? "createdRecipes" : "recipes";
    super.initState();
  }

  void approved() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ApproveRecipe(
          recipe: widget.recipe,
        );
      },
    ).then((value) {
      if (value) Navigator.pop(context);
    });
  }

  void denied() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FeedbackRecipe(
          recipeId: widget.recipe.id,
        );
      },
    ).then((value) {
      if (value) Navigator.pop(context);
    });
  }

  String? role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    role = _userData.data.role;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder<String>(
            future: _recipeController.getImage(widget.recipe.url),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                imageUrl = snapshot.data.toString();
              }
              return DefaultTabController(
                length: 1,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        leading: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(HealthpointIcons.arrowLeftIcon),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                        actions: [
                          MediaQuery.of(context).size.width < 1300
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.menu_sharp),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () =>
                                      Scaffold.of(context).openEndDrawer())
                              : Container()
                        ],
                        expandedHeight: kIsWeb ? 500 : 250.0,
                        floating: false,
                        pinned: true,
                        backgroundColor: ColorTheme.extraLightGreen,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: ColorTheme.extraLightGreen,
                            ),
                            child: H1Text(text: widget.recipe.title),
                          ),
                          background: snapshot.data == null
                              ? Center(child: CircularProgressIndicator())
                              : CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ];
                  },
                  body: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomPaint(
                            size: Size(size.width, size.height),
                            painter: BottomLargeWavePainter(
                              color: ColorTheme.extraLightGreen,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RecipeBuildUp(
                                recipe: widget.recipe,
                                user: _userData.data,
                                userNewRecipe: widget.userNewRecipe,
                                collection: collection,
                                imageUrl: imageUrl,
                              ),
                            ),
                            MediaQuery.of(context).size.width < 1300
                                ? Container()
                                : Card(
                                    child: Container(
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        width: 300,
                                        child: buildChecklist("", context)),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        endDrawer: Drawer(
          child: SafeArea(
            child: SingleChildScrollView(
                child: buildChecklist(widget.recipe.title!, context)),
          ),
        ));
  }

  Widget headerGeneralInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(text: "Algemene informatie"),
        SizedBox(height: 15),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: generalInfoCheckList.keys.map((String key) {
            return CheckboxListTile(
              title: IntroGreyText(text: key),
              value: generalInfoCheckList[key],
              activeColor: ColorTheme.accentOrange,
              checkColor: ColorTheme.grey,
              onChanged: (bool? value) {
                setState(() {
                  if (value!)
                    checkpoints++;
                  else
                    checkpoints--;
                  generalInfoCheckList[key] = value;
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }

  Widget headerIngredientschecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(text: "Ingrediënten"),
        SizedBox(height: 15),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: ingredientCheckList.keys.map((String key) {
            return CheckboxListTile(
              title: IntroGreyText(text: key),
              value: ingredientCheckList[key],
              activeColor: ColorTheme.accentOrange,
              checkColor: ColorTheme.grey,
              onChanged: (bool? value) {
                setState(() {
                  if (value!)
                    checkpoints++;
                  else
                    checkpoints--;
                  ingredientCheckList[key] = value;
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }

  Widget headerMethodchecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(text: "Methode"),
        SizedBox(height: 15),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: methodCheckList.keys.map((String key) {
            return CheckboxListTile(
              title: IntroGreyText(text: key),
              value: methodCheckList[key],
              activeColor: ColorTheme.accentOrange,
              checkColor: ColorTheme.grey,
              onChanged: (bool? value) {
                setState(() {
                  if (value!)
                    checkpoints++;
                  else
                    checkpoints--;
                  methodCheckList[key] = value;
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }

  Widget headerNutritionchecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(text: "Voedingswaardes"),
        SizedBox(height: 15),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: nutritionCheckList.keys.map((String key) {
            return CheckboxListTile(
              title: IntroGreyText(text: key),
              value: nutritionCheckList[key],
              activeColor: ColorTheme.accentOrange,
              checkColor: ColorTheme.grey,
              onChanged: (bool? value) {
                setState(() {
                  if (value!)
                    checkpoints++;
                  else
                    checkpoints--;
                  nutritionCheckList[key] = value;
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }

  Widget buildChecklist(String recipeTitle, context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          recipeTitle.isEmpty ? Container() : H1Text(text: recipeTitle),
          SizedBox(height: 10),
          headerGeneralInfo(),
          SizedBox(
            height: 50,
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
          headerIngredientschecklist(),
          SizedBox(
            height: 50,
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
          headerMethodchecklist(),
          SizedBox(
            height: 50,
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
          headerNutritionchecklist(),
          SizedBox(
            height: 50,
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                ),
                child: TextButton(
                  child: Text(
                    "Afkeuren",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                      Navigator.pop(context);
                    }
                    denied();
                  },
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: checkpoints == validator
                      ? Theme.of(context).accentColor
                      : ColorTheme.lightGrey,
                  shape: BoxShape.rectangle,
                ),
                child: TextButton(
                    child: Text(
                      "Goedkeuren",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (checkpoints == validator) {
                        if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                          Navigator.pop(context);
                        }
                        approved();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BodyText(
                                      text: "Niet genoeg punten aangevinkt"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              ColorTheme.accentOrange),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        "Oke",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      ;
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
