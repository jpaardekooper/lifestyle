import 'package:flutter/cupertino.dart';

class ExpandedListView extends StatelessWidget {
  const ExpandedListView({this.widgets, this.start});
  final List<Widget> widgets;
  final bool start;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          start ? MainAxisAlignment.start : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widgets.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return widgets[index];
          },
        ),
      ],
    );
  }
}
