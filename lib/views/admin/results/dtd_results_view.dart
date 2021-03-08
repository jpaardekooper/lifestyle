import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/result_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/dtd_answer_model.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:intl/intl.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

class DtdResultView extends StatefulWidget {
  DtdResultView({required this.result});
  final DtdModel result;

  @override
  _DtdResultViewState createState() => _DtdResultViewState();
}

class _DtdResultViewState extends State<DtdResultView> {
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
            text: DateFormat("yyy-MM-dd HH:mm")
                .format(widget.result.date!.toDate()),
          ),
        ),
        body: FutureBuilder<List<DtdAwnserModel>>(
          future: ResultController().getDtdAnswers(widget.result.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Geen data gevonden"));
            } else {
              final List<DtdAwnserModel> _dtdList = snapshot.data!;

              return Container(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _dtdList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(
                            text:
                                // ignore: lines_longer_than_80_chars
                                "${index + 1}.  \t ${_dtdList[index].question} "),
                        SizedBox(
                          height: 10,
                        ),
                        LifestyleText(
                          text: _dtdList[index].answer!.replaceAll(',', ', '),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
