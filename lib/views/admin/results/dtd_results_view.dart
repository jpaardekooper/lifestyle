import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:intl/intl.dart';

class DtdResultView extends StatefulWidget {
  DtdResultView({@required this.result});
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
          text:
              DateFormat("yyy-MM-dd HH:mm").format(widget.result.date.toDate()),
        ),
      ),
      // body: ,
    );
  }
}
