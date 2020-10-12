import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ColorCallback = void Function(Color color);

class DatePickerTimeLine extends StatefulWidget {
  DatePickerTimeLine({Key key}) : super(key: key);

  @override
  _DatePickerTimeLineState createState() => _DatePickerTimeLineState();
}

class _DatePickerTimeLineState extends State<DatePickerTimeLine> {
  DatePickerController _controller = DatePickerController();
  DateTime selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedValue,
        firstDate: selectedValue,
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedValue)
      setState(() {
        selectedValue = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.all(
            Radius.circular(30.0) //                 <--- border radius here
            ),
      ),
      child: Column(
        children: <Widget>[
          // Text("You Selected:"),
          // Padding(
          //   padding: EdgeInsets.all(10),
          // ),
          // Text(_selectedValue.toString()),
          // Padding(
          //   padding: EdgeInsets.all(20),
          // ),
          // FloatingActionButton(
          //   child: Icon(Icons.replay),
          //   onPressed: () {
          //     _controller.animateToSelection();
          //   },
          // ),

          Container(
            margin: EdgeInsets.all(10),
            child: DatePicker(
              DateTime.now(),
              width: 50,
              height: 80,
              controller: _controller,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.white,
              selectedTextColor: Colors.red[300],
              deactivatedColor: Colors.white,
              dayTextStyle: TextStyle(
                color: Colors.white,
              ),
              dateTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              monthTextStyle: TextStyle(color: Colors.white, fontSize: 0),
              daysCount: 14,
              locale: "NL",
              // inactiveDates: [
              //   DateTime.now().add(Duration(days: 3)),
              //   DateTime.now().add(Duration(days: 4)),
              //   DateTime.now().add(Duration(days: 7))
              // ],
              onDateChange: (date) {
                // New date selected
                setState(() {
                  selectedValue = date;
                  // showDatePicker(
                  //   context: context,
                  //   initialDate: _selectedValue,
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime(2025),
                  //   initialDatePickerMode: DatePickerMode.day,
                  // );
                  _selectDate(context);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
