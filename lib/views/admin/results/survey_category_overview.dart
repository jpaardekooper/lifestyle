import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/views/admin/results/survey_result_view.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

import '../../../healthpoint_icons.dart';

class SurveyCategoryOverview extends StatefulWidget {
  SurveyCategoryOverview({Key key, this.result}) : super(key: key);

  final SurveyResultModel result;

  @override
  _SurveyCategoryOverviewState createState() => _SurveyCategoryOverviewState();
}

class _SurveyCategoryOverviewState extends State<SurveyCategoryOverview> {
  Widget showCategories() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.result.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 2,
      ),
      itemBuilder: (BuildContext ctxt, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: ColorTheme.extraLightOrange,
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => SurveyResultView(
                          resultId: widget.result.id,
                          category: widget.result.categories[index],
                        )),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: H2Text(text: widget.result.categories[index]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                          // ignore: lines_longer_than_80_chars
                          "Aantal punten:  ${widget.result.points_per_category[index] ?? ""}"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        title: H1Text(
          text: widget.result.email,
        ),
      ),
      body: Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: 1280),
            child: showCategories()),
      ),
    );
  }
}
