import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/helper/theme.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/quiz/addquestion.dart';
import 'package:lifestylescreening/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class UpdateQuiz extends StatefulWidget {
  UpdateQuiz(
      {@required this.isNew,
      this.desc,
      this.title,
      this.quizImageUrl,
      this.quizId});

  final bool isNew;
  final String title;
  final String desc;
  final String quizImageUrl;
  final String quizId;

  @override
  _UpdateQuizState createState() => _UpdateQuizState();
}

class _UpdateQuizState extends State<UpdateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl, quizId;
  DatabaseService databaseService = DatabaseService();

  bool _isLoading = false;

  TextEditingController quizTitleController = TextEditingController();
  TextEditingController quizImageUrlController = TextEditingController();
  TextEditingController quizDescController = TextEditingController();

  var result;

  //
  //File selectedImage;
  var selectedImage;

  updateQuizOnline() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = widget.quizId;

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgurl": quizImageUrlController.text,
        "quizTitle": quizTitleController.text,
        "quizDesc": quizDescController.text
      };

      String userName = await HelperFunctions.getUserNameSharedPreference();

      await databaseService
          .updateQuizData(quizMap, quizId, userName)
          .then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pop(context);
        });
      });
    }
  }

  creteQuizOnline() async {
    if (_formKey.currentState.validate() && quizImageUrlController.text != "") {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgurl": quizImageUrlController.text,
        "quizTitle": quizTitleController.text,
        "quizDesc": quizDescController.text
      };

      String userName = await HelperFunctions.getUserNameSharedPreference();

      await databaseService
          .updateQuizData(quizMap, quizId, userName)
          .then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestion(
                        quizId: quizId,
                        isNew: true,
                      )));
        });
      });
    } else if (quizImageUrlController.text.isEmpty) {
      //  print("error");
    }
  }

  @override
  void initState() {
    quizImageUrlController.text = !widget.isNew ? widget.quizImageUrl : "";
    quizTitleController.text = !widget.isNew ? widget.title : "";
    quizDescController.text = !widget.isNew ? widget.desc : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("create or update quiz")),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Spacer(),
                        widget.isNew
                            ? TextFormField(
                                decoration: MyThemeData.themedecoration(
                                    "Quiz Image Url"),
                                controller: quizImageUrlController,
                                validator: (val) =>
                                    val.isEmpty ? "Enter Image Url" : null,
                                onChanged: (val) {
                                  quizImageUrl = val;
                                },
                              )
                            : TextFormField(
                                decoration: MyThemeData.themedecoration(
                                    "Quiz Image Url"),
                                controller: quizImageUrlController,
                                validator: (val) =>
                                    val.isEmpty ? "Enter Image Url" : null,
                                onChanged: (val) {
                                  quizImageUrl = val;
                                },
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: quizTitleController,
                          decoration: MyThemeData.themedecoration("Quiz Title"),
                          validator: (val) =>
                              val.isEmpty ? "Enter Quiz Title" : null,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: quizDescController,
                          validator: (val) =>
                              val.isEmpty ? "Enter Quiz Description" : null,
                          decoration:
                              MyThemeData.themedecoration("Quiz Description"),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              widget.isNew
                                  ? creteQuizOnline()
                                  : updateQuizOnline();
                            },
                            child: blueButton(
                                context: context,
                                label: widget.isNew
                                    ? "Create Quiz"
                                    : "Update Quiz")),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
