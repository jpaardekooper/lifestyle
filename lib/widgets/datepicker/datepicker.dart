import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

typedef ColorCallback = void Function(Color color);

class DatePickerTimeLine extends StatefulWidget {
  DatePickerTimeLine({Key key}) : super(key: key);

  @override
  _DatePickerTimeLineState createState() => _DatePickerTimeLineState();
}

class _DatePickerTimeLineState extends State<DatePickerTimeLine>
    with TickerProviderStateMixin {
  DatePickerController _controller = DatePickerController();
  DateTime selectedValue;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool visible;

  @override
  void initState() {
    super.initState();
    selectedValue = DateTime.now();

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    visible = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // void _onDaySelected(DateTime day, List events) {
  //   print('CALLBACK: _onDaySelected');
  //   setState(() {
  //     // _selectedEvents = events;
  //   });
  // }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    _toggle(visible);
  }

  // void _onCalendarCreated(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   print('CALLBACK: _onCalendarCreated');
  // }
  TextStyle styling() {
    return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      // events: _events,
      //   holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        weekdayStyle: styling(),
        weekendStyle: styling(),
        holidayStyle: styling(),
        selectedStyle: TextStyle(color: Colors.red[400]),
        todayStyle: styling(),
        outsideStyle: styling(),
        outsideWeekendStyle: TextStyle(color: Colors.grey),
        outsideHolidayStyle: TextStyle(color: Colors.grey),
        unavailableStyle: TextStyle(color: Colors.grey),
        selectedColor: Colors.white,
        todayColor: Colors.red[400],
        markersColor: Colors.blue[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle(color: Colors.red[400], fontSize: 16.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        formatButtonVisible: true,
        formatButtonShowsNext: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: styling(),
        weekendStyle: styling(),
      ),
      // onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      // onCalendarCreated: _onCalendarCreated,
      locale: 'NL',
      initialSelectedDay: selectedValue,
    );
  }

  void _toggle(bool value) {
    if (value) {
      setState(() {
        visible = false;
      });
    } else {
      visible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.red[400],
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

          !visible
              ? Hero(
                  tag: 'showCalender',
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: DatePicker(
                      DateTime.now(),
                      width: 40,
                      height: 40,
                      controller: _controller,
                      initialSelectedDate: selectedValue == null
                          ? DateTime.now()
                          : selectedValue,
                      selectionColor: Colors.white,
                      selectedTextColor: Colors.red[400],
                      deactivatedColor: Colors.white,
                      dayTextStyle: TextStyle(
                        fontSize: 0,
                        color: Colors.blue,
                      ),
                      dateTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      monthTextStyle:
                          TextStyle(color: Colors.white, fontSize: 0),
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
                          //_selectDate(context);
                          _toggle(visible);
                        });
                      },
                    ),
                  ),
                )
              : Hero(
                  tag: 'showCalender',
                  child: _buildTableCalendar(),
                ),
        ],
      ),
    );
  }
}
