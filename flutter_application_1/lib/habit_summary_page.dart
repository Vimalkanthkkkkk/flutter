import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/circle_progress.dart';
import 'package:flutter_application_1/custom_calender.dart';
import 'package:flutter_application_1/data.dart';
import 'package:flutter_application_1/flutter_timepicker.dart';
import 'package:flutter_application_1/priority_dialog.dart';
import 'package:flutter_application_1/utils.dart';

class HabitSummarypage extends StatefulWidget {
  const HabitSummarypage({super.key});

  @override
  State<HabitSummarypage> createState() => Summary();
}

class Summary extends State<HabitSummarypage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  double _currentProgress = 0.0;
  final List<String> items = ["All", "Habits", "Tasks"];
  String value = "All";
  DateTime today = DateTime.now();
  List<int> get years => [
    today.year - 2,
    today.year - 1,
    today.year,
    today.year + 1,
    today.year + 2,
  ];
  List<String> weeks = [];
  List<int> monthsnum = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  List<String> get months => [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  List<String> get fullmonths => [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  List<String> get weekdays => [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  double previousAngle = 0;
  late Offset containerCenter;
  double rotationAngle = 0;
  double startRotation = 0;
  DateTime selectedDate = DateTime(2025, 3, 2);
  String type = 'Week';
  String sumtype = 'Sum';
  int todayyear = DateTime.now().year;
  TextEditingController habitName = TextEditingController(text: "Cord");
  TextEditingController unitstext = TextEditingController(text: "Cord");
  TextEditingController descriptionName = TextEditingController();
  FocusNode habitNameFocusNode = FocusNode();
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  int selectedcategory = 0;
  String segmentValue = "none";

  void segmentfunction(String value) {
    setState(() {
      segmentValue = value;
    });
  }

  void showTimePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          TimePickerdialog(segment: segmentValue, segfunc: segmentfunction),
    );
  }

  void onpress(int index) {
    setState(() {
      selectedcategory = index;
    });
  }

  void goToPreviousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  void goToNextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  void change() {
    setState(() {
      selectedDate = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    weekslist();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void weekslist() {
    final year = DateTime.now().year;
    final lastyear = DateTime(year - 1, 12, 31);
    final lastyearlastday = lastyear.weekday;
    setState(() {
      if (lastyearlastday == 7) {
        weeks.add('${months[11]} ${lastyear.day}');
      } else {
        weeks.add('${months[11]} ${31 - lastyear.weekday}');
      }
      for (var i = 1; i <= 12; i++) {
        final firstDay = DateTime(year, i, 1);
        final totalDays = monthsnum[i - 1];
        int weekday = firstDay.weekday;
        int firstSunday;
        if (weekday == 7) {
          firstSunday = 1;
        } else {
          firstSunday = 1 + (7 - weekday);
        }
        int day = firstSunday;
        while (day <= totalDays) {
          weeks.add('${months[i - 1]} $day');
          day += 7;
        }
      }
    });
  }

  void onChanged(String selected) {
    setState(() {
      value = selected;
    });
  }

  void animateProgress(double targetProgress) {
    final animationDuration = Duration(milliseconds: 600);
    final steps = 60;
    final stepDuration = animationDuration.inMilliseconds ~/ steps;
    final startProgress = _currentProgress;
    final increment = (targetProgress - startProgress) / steps;
    int currentStep = 0;
    Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      currentStep++;
      if (currentStep <= steps) {
        setState(() {
          _currentProgress = startProgress + (increment * currentStep);
        });
      } else {
        setState(() {
          _currentProgress = targetProgress;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = [30.0, 40.0, 20.0, 10.0];
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 24, 24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  IconData(
                    0xf63a,
                    fontFamily: 'MaterialIcons',
                    matchTextDirection: true,
                  ),
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
                color: Color.fromARGB(255, 225, 26, 66),
              ),
              title: Text(
                'Book',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                IconData(
                  0xe6a0,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true,
                ),
                size: 30,
                color: Color.fromARGB(255, 225, 26, 66),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            onTap: (value) {
              if (_tabController!.index != 1) {
                setState(() {
                  _currentProgress = 0.0;
                });
              } else {
                animateProgress(0.75);
              }
            },
            tabs: [
              Tab(
                child: Text(
                  'Calender',
                  style: TextStyle(
                    color: Color.fromARGB(255, 185, 182, 182),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Statistics',
                  style: TextStyle(
                    color: Color.fromARGB(255, 185, 182, 182),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Color.fromARGB(255, 185, 182, 182),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            indicatorColor: Color.fromARGB(255, 188, 26, 58),
            indicatorWeight: 4.0,
            dividerHeight: 0.09,
            overlayColor: WidgetStateColor.resolveWith((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return Color.fromARGB(99, 77, 75, 75);
              }
              return Colors.transparent;
            }),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownMenu<String>(
                      initialSelection: value,
                      menuStyle: const MenuStyle(
                        fixedSize: WidgetStatePropertyAll(Size(250, 160)),
                        alignment: Alignment(-0.55, -0.24),
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 34, 34, 34),
                        ),
                        surfaceTintColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.49,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      onSelected: (value) {
                        if (value != null) onChanged(value);
                      },
                      dropdownMenuEntries: items.map((e) {
                        return DropdownMenuEntry(
                          value: e,
                          label: e,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 34, 34, 34),
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.only(left: 100),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    InlineCalendarWithDecorations(),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[700], thickness: 1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          color: Color.fromARGB(255, 225, 26, 66),
                          IconData(
                            0xf01a,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true,
                          ),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(
                            bottom: 12,
                            left: 125,
                          ),
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 54, 53),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Description',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 181, 176, 176),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "This is description text",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[700], thickness: 1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          color: Color.fromARGB(255, 225, 26, 66),
                          IconData(
                            0xf01a,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true,
                          ),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(
                            bottom: 12,
                            left: 125,
                          ),
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 54, 53),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Notes',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 181, 176, 176),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "This is description text",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownMenu<String>(
                        initialSelection: value,
                        textAlign: TextAlign.center,
                        menuStyle: const MenuStyle(
                          fixedSize: WidgetStatePropertyAll(Size(250, 160)),
                          alignment: Alignment(-0.55, -0.24), //y = -0.24
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 34, 34, 34),
                          ),
                          surfaceTintColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          shadowColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        textStyle: TextStyle(
                          color: Colors.white,
                          wordSpacing: 0,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        onSelected: (value) {
                          if (value != null) onChanged(value);
                        },
                        dropdownMenuEntries: items.map((e) {
                          return DropdownMenuEntry(
                            value: e,
                            label: e,
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(250, 10)),
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 34, 34, 34),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.only(left: 100),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Color.fromARGB(255, 225, 26, 66),
                            IconData(
                              0xf01a,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: 12,
                              left: 145,
                            ),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 54, 53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Habit1',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(150, 150),
                            painter: RingPainter(
                              progress: _currentProgress,
                              taskCompletedColor: Color.fromARGB(
                                255,
                                225,
                                26,
                                66,
                              ),
                              taskNotCompletedColor: const Color.fromARGB(
                                255,
                                54,
                                53,
                                53,
                              ),
                            ),
                          ),
                          Text(
                            '${(_currentProgress * 100).toInt()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        textAlign: TextAlign.center,
                        'Average of all tracks',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 181, 176, 176),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Color.fromARGB(255, 225, 26, 66),
                            IconData(
                              0xf81e,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: 12,
                              left: 145,
                            ),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 54, 53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Streak',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Current\n",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "1 Day",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 225, 26, 66),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              width: 3,
                              color: Colors.grey[700],
                              thickness: 0.50,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "Best\n",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "5 Days",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 225, 26, 66),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Color.fromARGB(255, 225, 26, 66),
                            IconData(
                              0xf818,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: 12,
                              left: 125,
                            ),
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 54, 53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Total minutes',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This week',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This month',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This year',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'All',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Color.fromARGB(255, 225, 26, 66),
                            IconData(
                              0xef47,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: 12,
                              left: 120,
                            ),
                            child: Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 54, 53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Total completed',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This week',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This month',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'This year',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      ListTile(
                        minTileHeight: 30,
                        leading: Text(
                          'All',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 181, 176, 176),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 0.30,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      ListTile(
                        leading: IconButton(
                          icon: Icon(
                            IconData(
                              0xf63a,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 30,
                          ),
                          onPressed: () {
                            goToPreviousMonth();
                          },
                          color: Color.fromARGB(255, 225, 26, 66),
                        ),
                        title: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                            '${fullmonths[displayedMonth.month - 1 % 12]}\n',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '${displayedMonth.year}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 181, 176, 176),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            goToNextMonth();
                          },
                          icon: Icon(
                            IconData(
                              0xf579,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 19,
                            color: Color.fromARGB(255, 225, 26, 66),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                      monthsnum[displayedMonth.month - 1 % 12],
                                      (index) =>
                                      Container(
                                        width: 34,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          index ==6 ? "6" : "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ...List.generate(
                                        monthsnum[displayedMonth.month -
                                            1 % 12],
                                        (index) => Container(
                                          width: 34,
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:index == 6 ? const Color.fromARGB(255, 27, 217, 21) : Colors.transparent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                                topRight: Radius.circular(6),
                                              ),
                                            ),
                                            height: 100,
                                            width: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 2,
                                    width:
                                        monthsnum[displayedMonth.month -
                                            1 % 12] *
                                        34,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                      monthsnum[displayedMonth.month - 1 % 12],
                                      (index) => Container(
                                        width: 34,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      ListTile(
                        leading: IconButton(
                          icon: Icon(
                            IconData(
                              0xf63a,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              todayyear = todayyear - 1;
                            });
                          },
                          color: Color.fromARGB(255, 225, 26, 66),
                        ),
                        title: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "$todayyear\n",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: sumtype == 'Sum'
                                    ? "Total Minutes"
                                    : "Daily average",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 181, 176, 176),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              todayyear = todayyear + 1;
                            });
                          },
                          icon: Icon(
                            IconData(
                              0xf579,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 18,
                            color: Color.fromARGB(255, 225, 26, 66),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (type == 'Month') ...[
                        Container(
                          decoration: BoxDecoration(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        12,
                                        (index) => Container(
                                          width: 24,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                           index ==6 ? "2.0" : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          12,
                                          (index) => Container(
                                            width: 24,
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:index==6 ? const Color.fromARGB(255, 243, 49, 49) : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                ),
                                              ),
                                              height: 100,
                                              width: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 2,
                                      width: 31 * 10,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        12,
                                        (index) => Container(
                                          width: 24,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            months[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (type == 'Year') ...[
                        Container(
                          decoration: BoxDecoration(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        5,
                                        (index) => Container(
                                          width: 30,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                          index ==2 ? "2" : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (index) => Container(
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:index==2? const Color.fromARGB(255, 255, 51, 51) : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                ),
                                              ),
                                              height: 100,
                                              width: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 2,
                                      width: 31 * 5,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        5,
                                        (index) => Container(
                                          width: 30,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${years[index]}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (type == 'Week') ...[
                        Container(
                          decoration: BoxDecoration(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        weeks.length,
                                        (index) => Container(
                                          width: 40,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                           index ==12 ? "${index + 1}" : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          weeks.length,
                                          (index) => Container(
                                            width: 40,
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:index ==12 ? const Color.fromARGB(255, 253, 44, 44) : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                ),
                                              ),
                                              height: 100,
                                              width: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 2,
                                      width: 40 * weeks.length.toDouble(),
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        weeks.length,
                                        (index) => Container(
                                          width: 40,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            weeks[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 10),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: SegmentedButton<String>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment<String>(
                              value: "Week",
                              label: Text("Week", textAlign: TextAlign.center),
                            ),
                            ButtonSegment<String>(
                              value: "Month",
                              label: Text("Month", textAlign: TextAlign.center),
                            ),
                            ButtonSegment<String>(
                              value: "Year",
                              label: Text("Year", textAlign: TextAlign.center),
                            ),
                          ],
                          selected: <String>{type},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              type = newSelection.first;
                            });
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 71, 70, 70),
                                width: 1,
                              );
                            }),
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(16),
                                ),
                              );
                            }),
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(117, 225, 26, 66);
                              }
                              return const Color.fromARGB(255, 56, 56, 56);
                            }),
                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(255, 255, 0, 51);
                              }
                              return const Color.fromARGB(255, 183, 177, 177);
                            }),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: SegmentedButton<String>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment<String>(
                              value: "Sum",
                              label: Text("Sum", textAlign: TextAlign.center),
                            ),
                            ButtonSegment<String>(
                              value: "Avg",
                              label: Text(
                                "Daily average",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          selected: <String>{sumtype},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              sumtype = newSelection.first;
                            });
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 71, 70, 70),
                                width: 1,
                              );
                            }),
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(16),
                                ),
                              );
                            }),
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(117, 225, 26, 66);
                              }
                              return const Color.fromARGB(255, 56, 56, 56);
                            }),
                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(255, 255, 0, 51);
                              }
                              return const Color.fromARGB(255, 183, 177, 177);
                            }),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey[700], thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            color: Color.fromARGB(255, 225, 26, 66),
                            IconData(
                              0xf0099,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: 12,
                              left: 120,
                            ),
                            child: Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 55, 54, 53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                'Success / Fail',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    181,
                                    176,
                                    176,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onPanStart: (details) {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          final Offset localCenter = box.size.center(
                            Offset.zero,
                          );
                          containerCenter = box.localToGlobal(localCenter);
                          final touchPosition = details.globalPosition;
                          final dx = touchPosition.dx - containerCenter.dx;
                          final dy = touchPosition.dy - containerCenter.dy;
                          previousAngle = atan2(dy, dx);
                          startRotation = rotationAngle;
                        },
                        onPanUpdate: (details) {
                          final touchPosition = details.globalPosition;
                          final dx = touchPosition.dx - containerCenter.dx;
                          final dy = touchPosition.dy - containerCenter.dy;
                          final currentAngle = atan2(dy, dx);
                          final angleDelta = currentAngle - previousAngle;
                          setState(() {
                            rotationAngle = startRotation + angleDelta;
                          });
                        },
                        child: Transform.rotate(
                          angle: rotationAngle,
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: const Size(200, 200),
                                painter: PieCharPainter(
                                  data: data,
                                  colors: colors,
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  alignment: Alignment.center,
                                  transform: Matrix4.translationValues(
                                    38,
                                    38,
                                    0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(190, 255, 255, 255),
                                  ),
                                ),
                              ),
                              Container(
                                height: 105,
                                width: 105,
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(45, 45, 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: ".",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Done",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: ".",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 0, 0),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Fail",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: ".",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 238, 0),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Pending",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          showdescriptiondialog(
                            context,
                            habitNameFocusNode,
                            habitName,
                            1,
                            "Habit",
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: SizedBox(
                          width: 450 - 36 - 51,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                IconData(0xef8d, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 10),
                              Text("Habit name"),
                              Spacer(),
                              Flexible(
                                flex: 0,
                                child: Text(
                                  "vimal",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 20, 56),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        label: SizedBox(width: 0),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showCategoryDialog(context, onpress);
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: SizedBox(
                          width: 450 - 36 - 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                IconData(0xef37, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 10),
                              Text("Category"),
                              //SizedBox(width: 170),
                              Spacer(),
                              Flexible(
                                flex: 0,
                                child: Text(
                                  mySharedMap[selectedcategory]?.values
                                      .elementAt(0),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 20, 56),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        label: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: mySharedMap[selectedcategory]?.values
                                .elementAt(2),
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          child: Icon(
                            IconData(
                              mySharedMap[selectedcategory]?.values.elementAt(
                                1,
                              ),
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showdescriptiondialog(
                            context,
                            null,
                            descriptionName,
                            4,
                            "Description",
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf815, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Description"),
                            SizedBox(width: 249),
                          ],
                        ),
                        label: SizedBox(),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showTimePicker(context);
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf0027, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Time and remainders"),
                            SizedBox(width: 145),
                          ],
                        ),
                        label: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PriorityDialog(),
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 0),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf07b, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Priority"),
                            SizedBox(width: 160),
                          ],
                        ),
                        label: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            "Default",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: SizedBox(
                          width: 450 - 36 - 51,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                IconData(0xf05f5, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 10),
                              Text("Frequency"),
                              Spacer(),
                              Flexible(
                                flex: 0,
                                child: Text(
                                  "Every day",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 126, 124, 124),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        label: SizedBox(width: 0),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          //_restorableDatePickerRouteFuture.present();
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf44d, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Start date"),
                            SizedBox(width: 140),
                          ],
                        ),
                        label: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            "2/3/25", //"${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          //_restorableDatePickerRouteFuture.present();
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf02f, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("End date"),
                            SizedBox(width: 148),
                          ],
                        ),
                        label: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            "12/2/22", //"${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showTimePicker(context);
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf02d, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Old frequencies"),
                            SizedBox(width: 180),
                          ],
                        ),
                        label: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          //_restorableDatePickerRouteFuture.present();
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf2e4, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Daily goals"),
                            SizedBox(width: 80),
                            Text(
                              "Less than",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        label: Container(
                          width: 120,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            "12/2/22", //"${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf07ec, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Extra goals"),
                            SizedBox(width: 210),
                          ],
                        ),
                        label: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.only(top: 8.9, left: 0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(76, 247, 22, 67),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Text(
                            "0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(223, 255, 4, 54),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: (){
                          showdescriptiondialog(
                            context,
                            null,
                            unitstext,
                            1,
                            "Unit",
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xe402, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Unit"),
                            SizedBox(width: 296),
                          ],
                        ),
                        label: SizedBox(),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: (){
                          generalDialog(
                            context,
                            "Archive habit?",
                            "CANCEL",
                            "ARCHIVE",
                            const Color.fromARGB(255, 255, 39, 15),
                            const Color.fromARGB(255, 255, 39, 15),
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xee82, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Archive"),
                            SizedBox(width: 273),
                          ],
                        ),
                        label: SizedBox(),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: (){
                          generalDialog(
                            context,
                            "Confirm restart the habit progress?",
                            "CANCEL",
                            "RESTART",
                            const Color.fromARGB(255, 255, 39, 15),
                            const Color.fromARGB(255, 255, 39, 15),
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf414, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Restart habit progress"),
                            SizedBox(width: 180),
                          ],
                        ),
                        label: SizedBox(),
                        iconAlignment: IconAlignment.start,
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          generalDialog(
                            context,
                            "Delete habit?",
                            "CANCEL",
                            "DELETE",
                            const Color.fromARGB(255, 255, 39, 15),
                            const Color.fromARGB(255, 255, 39, 15),
                          );
                        },
                        style: ButtonStyle(
                          iconAlignment: IconAlignment.start,
                          side: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return BorderSide(
                              color: const Color.fromARGB(255, 44, 42, 42),
                            );
                          }),
                          shape: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return LinearBorder(
                              bottom: LinearBorderEdge(size: 1),
                              top: LinearBorderEdge(size: 1),
                            );
                          }),
                          backgroundColor: WidgetStateColor.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Colors.transparent;
                          }),
                          fixedSize: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return Size(450, 60);
                          }),
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              IconData(0xf696, fontFamily: 'MaterialIcons'),
                              size: 28,
                              color: Color.fromARGB(224, 247, 22, 67),
                            ),
                            SizedBox(width: 13),
                            Text("Delete habit"),
                            SizedBox(width: 246),
                          ],
                        ),
                        label: SizedBox(),
                        iconAlignment: IconAlignment.start,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
