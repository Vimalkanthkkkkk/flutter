import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/flutter_timepicker.dart';
import 'package:flutter_application_1/option.dart';
import 'package:flutter_application_1/priority_dialog.dart';
import 'time_picker.dart';
import 'data.dart';

@pragma('vm:entry-point')
Route<DateTime> _datePickerRoute(BuildContext context, Object? arguments) {
  return DialogRoute<DateTime>(
    context: context,
    barrierColor: Colors.black26,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(
          datePickerTheme: DatePickerThemeData(
            subHeaderForegroundColor: const Color.fromARGB(255, 255, 255, 255),
            toggleButtonTextStyle: TextStyle(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 45, 41, 50),
            headerForegroundColor: const Color.fromARGB(255, 255, 255, 255),
            headerBackgroundColor: const Color.fromARGB(255, 113, 113, 112),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            headerHeadlineStyle: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            weekdayStyle: TextStyle(
              color: const Color.fromARGB(255, 164, 163, 161),
            ),
            dayStyle: TextStyle(backgroundColor: Colors.transparent),
            yearStyle: TextStyle(backgroundColor: Colors.transparent),
            dividerColor: Colors.transparent,
            cancelButtonStyle: ButtonStyle(
              textStyle: WidgetStateTextStyle.resolveWith((states) {
                return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
              }),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return const Color.fromARGB(255, 255, 20, 56);
              }),
            ),
            confirmButtonStyle: ButtonStyle(
              textStyle: WidgetStateTextStyle.resolveWith((states) {
                return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
              }),
              foregroundColor: WidgetStateColor.resolveWith((states) {
                return const Color.fromARGB(255, 255, 20, 56);
              }),
            ),
            dayForegroundColor: WidgetStateColor.resolveWith((states) {
              return const Color.fromARGB(255, 255, 255, 255);
            }),
            dayBackgroundColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 255, 20, 56);
              }
              return Colors.transparent;
            }),
            dayShape: WidgetStateProperty.resolveWith((states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              );
            }),
            todayBorder: BorderSide(
              color: Colors.transparent,
              width: 0,
              style: BorderStyle.none,
            ),
            todayForegroundColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 0, 0, 0);
              }
              return Color.fromARGB(255, 255, 20, 56);
            }),
            todayBackgroundColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 255, 20, 56);
              }
              return Colors.transparent;
            }),
            yearBackgroundColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Color.fromARGB(255, 255, 20, 56);
              }
              return Colors.transparent;
            }),
            yearForegroundColor: WidgetStateColor.resolveWith((states) {
              return const Color.fromARGB(255, 255, 250, 250);
            }),
          ),
        ),
        child: DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2030),
        ),
      );
    },
  );
}

class HabitCreate extends StatefulWidget {
  final String type;
  const HabitCreate({super.key, required this.type});

  @override
  State<HabitCreate> createState() => Create();
}

class Create extends State<HabitCreate>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  String _character = "Every";
  String progresstype = "yesno";
  bool light = true;
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  final RestorableDateTime _endDate = RestorableDateTime(DateTime(2021, 7, 15));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture;
  late final RestorableRouteFuture<DateTime?>
  endrestorableDatePickerRouteFuture;
  TextEditingController? habitNameController;
  TextEditingController? goalNameController;
  TextEditingController? descriptionController;

  FocusNode habitNameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController? enddateController = TextEditingController(text: "60");
  bool cangonext = false;
  String segmentValue = "none";
  bool isChecked = false;
  int selectedcategory = 0;

  @override
  void initState() {
    super.initState();
    habitNameController = TextEditingController();
    goalNameController = TextEditingController();
    endrestorableDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
      onComplete: (newDate) => _selectEndDate(newDate),
      onPresent: (navigator, arguments) {
        return navigator.restorablePush(
          _datePickerRoute,
          arguments: _endDate.value.millisecondsSinceEpoch,
        );
      },
    );

    _restorableDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
      onComplete: (newDate) => _selectStartDate(newDate),
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(
          _datePickerRoute,
          arguments: _selectedDate.value.millisecondsSinceEpoch,
        );
      },
    );

    _pageViewController = PageController();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(
      _restorableDatePickerRouteFuture,
      'date_picker_route_future',
    );
    registerForRestoration(
      endrestorableDatePickerRouteFuture,
      'end_date_picker_route_future',
    );
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_endDate, 'end_date');
    _endDate.value = _selectedDate.value.add(const Duration(days: 60));
  }

  void _selectStartDate(DateTime? newDate) {
    if (newDate != null) {
      setState(() {
        _selectedDate.value = newDate;

        int days = int.tryParse(enddateController!.text) ?? 0;
        _endDate.value = _selectedDate.value.add(Duration(days: days));
      });
    }
  }

  void _selectEndDate(DateTime? newDate) {
    if (newDate != null) {
      setState(() {
        _endDate.value = newDate;
      });
    }
  }

  @override
  String? get restorationId => 'page_view_screen';

  @override
  void dispose() {
    super.dispose();
    habitNameFocusNode.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  void _handlePageViewChanged(int currentPageIndex) async {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
      // ignore: avoid_print
      print(_currentPageIndex);
      // ignore: avoid_print
      print(_character);
    });
    if (_currentPageIndex == 2) {
      FocusScope.of(context).requestFocus(habitNameFocusNode);
    } else {
      habitNameFocusNode.unfocus();
    }
  }

  String? selectedValue;
  final List<String> items = ['At least', 'Less than', 'Exactly', 'Any value'];
  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  void onTimeSelected(hours, minutes, seconds) {
    setState(() {
      selectedHours = hours;
      selectedMinutes = minutes;
      selectedSeconds = seconds;
    });
  }

  void showTimePickerDialog(
    BuildContext context,
    int hours,
    int minutes,
    int seconds,
  ) {
    showDialog(
      context: context,
      builder: (context) => TimePickDialog(
        initialHours: hours,
        initialMinutes: minutes,
        initialSeconds: seconds,
        onTimeSelected: (hours, minutes, seconds) {
          // ignore: avoid_print
          print("Selected Time: $hours:$minutes:$seconds");
        },
      ),
    );
  }

  void showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          constraints: BoxConstraints(maxHeight: 444, maxWidth: 300),
          backgroundColor: const Color.fromARGB(255, 51, 50, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              const Text(
                "Select a category",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[700], thickness: 1),
              SizedBox(
                height: 270,
                width: 265,
                child: GridView.builder(
                  itemCount: 15,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedcategory = index;
                        });
                        Navigator.pop(context);
                      },
                      child: SizedBox.expand(
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(0, 44, 42, 42),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(0, 67, 67, 67),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: mySharedMap[index]?.values.elementAt(
                                    2,
                                  ), // Colors.primaries[index % Colors.primaries.length],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  IconData(
                                    mySharedMap[index]?.values.elementAt(1),
                                    fontFamily: 'MaterialIcons',
                                    matchTextDirection: true,
                                  ),
                                  size: 26,
                                  color: const Color.fromARGB(255, 34, 32, 32),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                mySharedMap[index]?.values.elementAt(0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(color: Colors.grey[700], thickness: 1),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.resolveWith((
                    Set<WidgetState> callback,
                  ) {
                    return Size(400, 40);
                  }),
                  shape: WidgetStateProperty.resolveWith((
                    Set<WidgetState> callback,
                  ) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(0),
                    );
                  }),
                ),
                child: const Text(
                  "Manage Categories",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.resolveWith((
                    Set<WidgetState> callback,
                  ) {
                    return Size(400, 40);
                  }),
                  shape: WidgetStateProperty.resolveWith((
                    Set<WidgetState> callback,
                  ) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(0),
                    );
                  }),
                ),
                child: const Text(
                  "CLOSE",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showdescriptiondialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        constraints: BoxConstraints(maxWidth: 240),
        backgroundColor: const Color.fromARGB(255, 48, 48, 47),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 14.0,
            left: 14.0,
            right: 14.0,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textAlign: TextAlign.start,
                autofocus: true,
                onChanged: (value) {},
                focusNode: descriptionFocusNode,
                controller: descriptionController,
                maxLines: 4,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Note',
                  constraints: BoxConstraints(maxWidth: 200),
                  labelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Color.fromARGB(255, 225, 26, 66),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: const Color.fromARGB(255, 87, 85, 85),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: const Color.fromARGB(255, 225, 26, 66),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      color: const Color.fromARGB(255, 70, 68, 68),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 5,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return EdgeInsets.only(left: 0, right: 0);
                      }),
                      fixedSize: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return Size(100, 30);
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return Colors.transparent;
                      }),
                      shape: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(0),
                        );
                      }),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Color.fromARGB(223, 255, 255, 255),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return EdgeInsets.only(left: 0, right: 0);
                      }),
                      fixedSize: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return Size(100, 30);
                      }),
                      shape: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(0),
                        );
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith((
                        Set<WidgetState> callback,
                      ) {
                        return Colors.transparent;
                      }),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Color.fromARGB(224, 247, 22, 67),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void _onDaysChanged(String value) {
    int days = int.tryParse(value) ?? 0;
    setState(() {
      _endDate.value = _selectedDate.value.add(Duration(days: days));
    });
  }

  void gonext() {
    if (progresstype == "yesno" && habitNameController!.text.isNotEmpty) {
      setState(() => cangonext = true);
    } else if (progresstype == "num" &&
        habitNameController!.text.isNotEmpty &&
        goalNameController!.text.isNotEmpty) {
      setState(() => cangonext = true);
    } else {
      setState(() => cangonext = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController? descrptionNameController;
    TextEditingController? unitNameController;

    Widget dynamicbuild() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 14),
              progresstype != "yesno"
                  ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 70, 68, 68),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: items[0],
                            dropdownColor: Color.fromARGB(255, 50, 49, 49),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            isExpanded: true,
                            items: items
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            menuMaxHeight: 210,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              progresstype == "num" ? SizedBox(width: 26) : SizedBox(),
              progresstype == "num"
                  ? TextField(
                      controller: goalNameController,
                      onChanged: (value) {
                        if (goalNameController!.text.isNotEmpty) {
                          setState(() {
                            cangonext = true;
                          });
                        } else {
                          setState(() {
                            cangonext = false;
                          });
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Goal',
                        constraints: BoxConstraints(
                          maxWidth: 200,
                          maxHeight: 240,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Color.fromARGB(255, 225, 26, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 87, 85, 85),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 225, 26, 66),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 70, 68, 68),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 10),
            ],
          ),
          progresstype != "yesno" ? SizedBox(height: 20) : SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              progresstype == "timer"
                  ? FilledButton(
                      onPressed: () {
                        showTimePickerDialog(
                          context,
                          selectedHours,
                          selectedMinutes,
                          selectedSeconds,
                        );
                      },
                      style: ButtonStyle(
                        side: WidgetStateProperty.resolveWith((
                          Set<WidgetState> callback,
                        ) {
                          return BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 87, 85, 85),
                            width: 1.0,
                          );
                        }),
                        backgroundColor: WidgetStateColor.resolveWith((
                          Set<WidgetState> callback,
                        ) {
                          return Color.fromARGB(222, 24, 24, 24);
                        }),
                        fixedSize: WidgetStateProperty.resolveWith((
                          Set<WidgetState> callback,
                        ) {
                          return Size(161, 52);
                        }),
                        shape: WidgetStateProperty.resolveWith((
                          Set<WidgetState> callback,
                        ) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12.0),
                          );
                        }),
                      ),
                      child: const Text(
                        '00:00',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : SizedBox(),
              progresstype == "num"
                  ? TextField(
                      controller: unitNameController,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Unit (optional)',
                        constraints: BoxConstraints(maxWidth: 170),
                        labelStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Color.fromARGB(255, 225, 26, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 87, 85, 85),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 225, 26, 66),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 70, 68, 68),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 16),
              progresstype != "yesno"
                  ? Text(
                      "a day.",
                      style: TextStyle(
                        color: Color.fromARGB(222, 255, 255, 255),
                        fontSize: 15,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 24, 24),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            scrollDirection: Axis.horizontal,
            //physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                children: [
                  if (widget.type == 'Task') ...[
                    SizedBox(height: 46),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          width: 100,
                          margin: EdgeInsets.only(right: 270),
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 48, 48, 47),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "New Task",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: const Color.fromARGB(
                                255,
                                48,
                                48,
                                47,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          onChanged: (value) {},
                          focusNode: habitNameFocusNode,
                          controller: habitNameController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: widget.type == 'Habit'
                                ? 'Habit Name'
                                : widget.type == 'Recur' ||
                                      widget.type == 'Task'
                                ? 'Task'
                                : 'Habit Name',
                            constraints: BoxConstraints(maxWidth: 390),
                            labelStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 225, 26, 66),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 87, 85, 85),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 225, 26, 66),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 70, 68, 68),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: showCategoryDialog,
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
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
                            _restorableDatePickerRouteFuture.present();
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
                                IconData(0xf02f, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 13),
                              Text("Date"),
                              SizedBox(width: 175),
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
                              "Today",
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
                            // ignore: avoid_print
                            print(segmentValue);
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
                            showTimePicker(context);
                            // ignore: avoid_print
                            print(segmentValue);
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
                                IconData(0xf637, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 13),
                              RichText(
                                text: TextSpan(
                                  text: "Checklist\n",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Premium feature",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 190),
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
                          onPressed: showdescriptiondialog,
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
                                IconData(0xf3ad, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 13),
                              Text("Note"),
                              SizedBox(width: 290),
                            ],
                          ),
                          label: SizedBox(),
                          iconAlignment: IconAlignment.start,
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
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
                                IconData(0xf719, fontFamily: 'MaterialIcons'),
                                size: 28,
                                color: Color.fromARGB(224, 247, 22, 67),
                              ),
                              SizedBox(width: 13),
                              Text("Pending task"),
                              SizedBox(width: 200),
                            ],
                          ),
                          label: Transform.scale(
                            scale: 1.6,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(50),
                              ),
                              checkColor: const Color.fromARGB(255, 0, 0, 0),
                              fillColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.selected)) {
                                  return Color.fromARGB(224, 247, 22, 67);
                                }
                                return Colors.transparent;
                              }),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          iconAlignment: IconAlignment.start,
                        ),
                        SizedBox(height: 225),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return EdgeInsets.only(left: 0, right: 0);
                                }),
                                fixedSize: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return Size(200, 50);
                                }),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith((
                                      Set<WidgetState> callback,
                                    ) {
                                      return Colors.transparent;
                                    }),
                                shape: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      0,
                                    ),
                                  );
                                }),
                              ),
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  color: Color.fromARGB(223, 255, 255, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return EdgeInsets.only(left: 0, right: 0);
                                }),
                                fixedSize: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return Size(200, 50);
                                }),
                                shape: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      0,
                                    ),
                                  );
                                }),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith((
                                      Set<WidgetState> callback,
                                    ) {
                                      return Colors.transparent;
                                    }),
                              ),
                              child: Text(
                                "CONFIRM",
                                style: TextStyle(
                                  color: Color.fromARGB(224, 247, 22, 67),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  if (widget.type != 'Task') ...[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        'Select a category for your habit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 240, 22, 65),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.only(
                          top: 52,
                          left: 5,
                          right: 5,
                        ),
                        crossAxisSpacing: 10,
                        childAspectRatio: 4,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quit a bad habit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      247,
                                      1,
                                      1,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf6c6,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Art',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      217,
                                      22,
                                      22,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf5ef,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meditation',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      241,
                                      8,
                                      179,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf0144,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Study',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      161,
                                      7,
                                      232,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf012e,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sports',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      104,
                                      1,
                                      247,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xe1d2,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Entertainment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      27,
                                      172,
                                      180,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf862,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Social',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      2,
                                      185,
                                      133,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf631,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Finance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      3,
                                      188,
                                      86,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf58f,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Health',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      2,
                                      179,
                                      19,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf0f2,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Work',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      76,
                                      160,
                                      2,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf7f4,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Nutrition',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      230,
                                      124,
                                      12,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf869,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      234,
                                      149,
                                      4,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xe319,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Outdoor',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      218,
                                      89,
                                      14,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf83e,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Other',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                      255,
                                      229,
                                      52,
                                      8,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf02b9,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 26,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      32,
                                      32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _pageViewController.animateToPage(
                                _currentPageIndex + 1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                59,
                                59,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // spread text & icon
                              children: [
                                Text(
                                  'Create Category',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      60,
                                      59,
                                      59,
                                    ), // icon background color
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ), // rounded background
                                  ),
                                  padding: EdgeInsets.all(
                                    6,
                                  ), // spacing inside icon box
                                  child: Icon(
                                    IconData(
                                      0xf52c,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    size: 40,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      34,
                                      34,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "How do you want to evaluate your",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "progress?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 50,
                      width: 390,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 240, 39, 79),
                            Color.fromARGB(255, 174, 14, 46),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pageViewController.animateToPage(
                            _currentPageIndex + 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            progresstype = "yesno";
                          });
                        },
                        style: TextButton.styleFrom(
                          surfaceTintColor: Color.fromARGB(255, 226, 222, 223),
                          fixedSize: Size(390, 50),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                        ),
                        child: Text(
                          "WITH A YES OR NO",
                          style: TextStyle(
                            color: Color.fromARGB(255, 229, 226, 227),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Record whether you succeed with the activity or not",
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 131, 133),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    if (widget.type == 'Habit') ...[
                      Container(
                        height: 50,
                        width: 390,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 240, 39, 79),
                              Color.fromARGB(255, 174, 14, 46),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _pageViewController.animateToPage(
                              _currentPageIndex + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              progresstype = "num";
                            });
                          },
                          style: TextButton.styleFrom(
                            surfaceTintColor: Color.fromARGB(
                              255,
                              226,
                              222,
                              223,
                            ),
                            fixedSize: Size(390, 50),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                          child: Text(
                            "WITH A NUMERIC VALUE",
                            style: TextStyle(
                              color: Color.fromARGB(255, 229, 226, 227),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Establish a value as a daily goal or limit for the habit",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 131, 133),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 50,
                        width: 390,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 240, 39, 79),
                              Color.fromARGB(255, 174, 14, 46),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _pageViewController.animateToPage(
                              _currentPageIndex + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              progresstype = "timer";
                            });
                          },
                          style: TextButton.styleFrom(
                            surfaceTintColor: Color.fromARGB(
                              255,
                              226,
                              222,
                              223,
                            ),
                            fixedSize: Size(390, 50),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                          child: Text(
                            "WITH A TIMER",
                            style: TextStyle(
                              color: Color.fromARGB(255, 229, 226, 227),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Establish a time value as a daily goal or limit for the habit",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 131, 133),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        height: 50,
                        width: 390,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 240, 39, 79),
                              Color.fromARGB(255, 174, 14, 46),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _pageViewController.animateToPage(
                              _currentPageIndex + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: TextButton.styleFrom(
                            surfaceTintColor: Color.fromARGB(
                              255,
                              226,
                              222,
                              223,
                            ),
                            fixedSize: Size(390, 50),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                          child: Text(
                            "WITH A CHECKLIST",
                            style: TextStyle(
                              color: Color.fromARGB(255, 229, 226, 227),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Evaluate your activity based on a set of sub-items",
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 131, 133),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Premium feature",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 66, 26),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "Define your habit",
                    style: TextStyle(
                      color: Color.fromARGB(255, 225, 26, 66),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    onChanged: (value) {
                      if (habitNameController!.text.isNotEmpty &&
                          progresstype == "yesno") {
                        setState(() {
                          cangonext = true;
                        });
                      } else {
                        setState(() {
                          cangonext = false;
                        });
                      }
                    },
                    focusNode: habitNameFocusNode,
                    controller: habitNameController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: widget.type == 'Habit'
                          ? 'Habit Name'
                          : widget.type == 'Recur'
                          ? 'Task'
                          : 'Habit Name',
                      constraints: BoxConstraints(maxWidth: 390),
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: const Color.fromARGB(255, 87, 85, 85),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: const Color.fromARGB(255, 225, 26, 66),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: const Color.fromARGB(255, 70, 68, 68),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                  progresstype != "yesno" ? SizedBox(height: 20) : SizedBox(),
                  dynamicbuild(),
                  /*
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 14),
                          progresstype != "yesno"
                              ? Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          255,
                                          70,
                                          68,
                                          68,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedValue,
                                        dropdownColor: Color.fromARGB(
                                          255,
                                          50,
                                          49,
                                          49,
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        isExpanded: true,
                                        hint: const Text(
                                          "Select option",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                        items: items
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value;
                                          });
                                        },
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        menuMaxHeight: 210,
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          progresstype == "num"
                              ? SizedBox(width: 26)
                              : SizedBox(),
                          progresstype == "num"
                              ? TextField(
                                  controller: goalNameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Goal',
                                    constraints: BoxConstraints(
                                      maxWidth: 200,
                                      maxHeight: 240,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: Color.fromARGB(255, 225, 26, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          87,
                                          85,
                                          85,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          225,
                                          26,
                                          66,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          70,
                                          68,
                                          68,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 16.0,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: 10),
                        ],
                      ),
                      progresstype != "yesno"
                          ? SizedBox(height: 20)
                          : SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          progresstype == "timer"
                              ? FilledButton(
                                  onPressed: () {
                                    showTimePickerDialog(
                                      context,
                                      selectedHours,
                                      selectedMinutes,
                                      selectedSeconds,
                                    );
                                  },
                                  style: ButtonStyle(
                                    side: WidgetStateProperty.resolveWith((
                                      Set<WidgetState> callback,
                                    ) {
                                      return BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          87,
                                          85,
                                          85,
                                        ),
                                        width: 1.0,
                                      );
                                    }),
                                    backgroundColor:
                                        WidgetStateColor.resolveWith((
                                          Set<WidgetState> callback,
                                        ) {
                                          return Color.fromARGB(
                                            222,
                                            24,
                                            24,
                                            24,
                                          );
                                        }),
                                    fixedSize: WidgetStateProperty.resolveWith((
                                      Set<WidgetState> callback,
                                    ) {
                                      return Size(161, 52);
                                    }),
                                    shape: WidgetStateProperty.resolveWith((
                                      Set<WidgetState> callback,
                                    ) {
                                      return RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(12.0),
                                      );
                                    }),
                                  ),
                                  child: const Text(
                                    '00:00',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : SizedBox(),
                          progresstype == "num"
                              ? TextField(
                                  controller: unitNameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Unit (optional)',
                                    constraints: BoxConstraints(maxWidth: 170),
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: Color.fromARGB(255, 225, 26, 66),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          87,
                                          85,
                                          85,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          225,
                                          26,
                                          66,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: const Color.fromARGB(
                                          255,
                                          70,
                                          68,
                                          68,
                                        ),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 16.0,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: 16),
                          progresstype != "yesno"
                              ? Text(
                                  "a day.",
                                  style: TextStyle(
                                    color: Color.fromARGB(222, 255, 255, 255),
                                    fontSize: 15,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  */
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: TextField(
                      controller: descrptionNameController,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
                        constraints: BoxConstraints(maxWidth: 395),
                        labelStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Color.fromARGB(255, 225, 26, 66),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 87, 85, 85),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 225, 26, 66),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 70, 68, 68),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  progresstype != 'yesno'
                      ? FilledButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return Color.fromARGB(222, 49, 49, 48);
                            }),
                            fixedSize: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return Size(390, 60);
                            }),
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(
                                  12.0,
                                ),
                              );
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
                              SizedBox(width: 190),
                            ],
                          ),
                          label: Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.only(top: 8.9, left: 15),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(76, 247, 22, 67),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              "0",
                              style: TextStyle(
                                color: Color.fromARGB(223, 255, 4, 54),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          iconAlignment: IconAlignment.start,
                        )
                      : SizedBox(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 60, top: 60, bottom: 30),
                    child: Text(
                      "How often do you want to do it?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FrequencySelector(),
                  /*
                  RadioGroup(
                    groupValue: _character,
                    onChanged: (String? value) {
                      setState(() {
                        _character = value!;
                      });
                    },
                    child: const Column(
                      children: <Widget>[
                        ListTile(
                          horizontalTitleGap: 3,
                          minTileHeight: 4,
                          title: Text('Every Day'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Every",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                        ListTile(
                          horizontalTitleGap: 3,
                          minTileHeight: 4,
                          title: Text('Specific days of the week'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Specificdaysweek",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                        ListTile(
                          horizontalTitleGap: 3,
                          minTileHeight: 4,
                          title: Text('Specific days of the month'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Specificdaysmonth",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                        ListTile(
                          minTileHeight: 4,
                          horizontalTitleGap: 3,
                          title: Text('Specific days of the year'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Specificdaysyear",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                        ListTile(
                          minTileHeight: 4,
                          horizontalTitleGap: 3,
                          title: Text('Some days per period'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Someperperiod",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                        ListTile(
                          minTileHeight: 4,
                          horizontalTitleGap: 3,
                          title: Text('Repeat'),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          leading: Radio(
                            value: "Repeat",
                            activeColor: Color.fromARGB(225, 225, 66, 26),
                          ),
                        ),
                      ],
                    ),
                  ),
                  */
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "When do you want to do it?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 225, 26, 66),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 35),
                  FilledButton.icon(
                    onPressed: () {
                      _restorableDatePickerRouteFuture.present();
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
                        return LinearBorder(bottom: LinearBorderEdge(size: 1));
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
                        "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
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
                      setState(() {
                        light = !light;
                      });
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
                        return LinearBorder(bottom: LinearBorderEdge(size: 0));
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
                        SizedBox(width: 225),
                      ],
                    ),
                    label: Switch(
                      inactiveThumbColor: Color.fromARGB(255, 101, 100, 100),
                      inactiveTrackColor: Color.fromARGB(255, 72, 68, 68),
                      activeThumbColor: Color.fromARGB(255, 25, 24, 24),
                      activeTrackColor: Color.fromARGB(255, 225, 26, 66),
                      value: light,
                      onChanged: (bool value) {},
                    ),
                    iconAlignment: IconAlignment.start,
                  ),
                  light
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 110),
                            TextButton(
                              onPressed: () {
                                endrestorableDatePickerRouteFuture.present();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return Color.fromARGB(76, 247, 22, 67);
                                }),
                                shape: WidgetStateProperty.resolveWith((
                                  Set<WidgetState> callback,
                                ) {
                                  return RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                      Radius.circular(8),
                                    ),
                                  );
                                }),
                              ),
                              child: Text(
                                "${_endDate.value.day}/${_endDate.value.month}/${_endDate.value.year}",
                                style: TextStyle(
                                  color: Color.fromARGB(223, 255, 0, 51),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: _onDaysChanged,
                                onSubmitted: (value) {
                                  setState(() {
                                    enddateController = TextEditingController(
                                      text: value,
                                    );
                                  });
                                },
                                keyboardType: TextInputType.number,
                                cursorColor: const Color.fromARGB(
                                  255,
                                  255,
                                  26,
                                  66,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        26,
                                        66,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        26,
                                        66,
                                      ),
                                    ),
                                  ),
                                ),
                                selectionHeightStyle: BoxHeightStyle.max,
                                controller: enddateController,
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "days.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 80),
                          ],
                        )
                      : SizedBox(),
                  AnimatedSlide(
                    offset: light ? Offset(0, 0.40) : Offset(0, 0),
                    duration: Duration(milliseconds: 200),
                    child: FilledButton.icon(
                      onPressed: () {
                        showTimePicker(context);
                        // ignore: avoid_print
                        print(segmentValue);
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
                          SizedBox(width: 150),
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
                  ),
                  AnimatedSlide(
                    offset: light ? Offset(0, 0.45) : Offset(0, 0),
                    duration: Duration(milliseconds: 200),
                    child: FilledButton.icon(
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
                  ),
                ],
              ),
            ],
          ),
          if (widget.type != 'Task') ...[
            PageIndicator(
              tabController: _tabController,
              currentPageIndex: _currentPageIndex,
              controller: _pageViewController,
              cangonext: cangonext,
              onnext: gonext,
            ),
          ],
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.controller,
    required this.cangonext,
    required this.onnext,
  });

  final int currentPageIndex;
  final TabController tabController;
  final PageController controller;
  final bool cangonext;
  final Function onnext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 60, 59, 59), width: 0.50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 24, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                currentPageIndex == 0
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return EdgeInsets.only(right: 0);
                          }),
                        ),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Color.fromARGB(255, 212, 211, 211),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          final target = currentPageIndex - 1;
                          controller.animateToPage(
                            target,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.resolveWith((
                            Set<WidgetState> callback,
                          ) {
                            return EdgeInsets.only(right: 0);
                          }),
                        ),
                        child: Text(
                          "BACK",
                          style: TextStyle(
                            color: Color.fromARGB(255, 212, 211, 211),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                SizedBox(width: 64),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: currentPageIndex >= 1
                        ? Color.fromARGB(255, 225, 26, 66)
                        : Color.fromARGB(255, 25, 24, 24),
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(
                      color: Color.fromARGB(255, 225, 26, 66),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 4),
                ),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: currentPageIndex >= 2
                        ? Color.fromARGB(255, 225, 26, 66)
                        : Color.fromARGB(255, 25, 24, 24),
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(
                      color: Color.fromARGB(255, 225, 26, 66),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 4),
                ),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: currentPageIndex >= 3
                        ? Color.fromARGB(255, 225, 26, 66)
                        : Color.fromARGB(255, 25, 24, 24),
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(
                      color: Color.fromARGB(255, 225, 26, 66),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 4),
                ),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: currentPageIndex >= 4
                        ? Color.fromARGB(255, 225, 26, 66)
                        : Color.fromARGB(255, 25, 24, 24),
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(
                      color: Color.fromARGB(255, 225, 26, 66),
                      width: 1,
                    ),
                  ),
                ),
                SizedBox(width: 60),
                currentPageIndex == 4
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            color: Color.fromARGB(255, 212, 211, 211),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    : currentPageIndex == 2 || currentPageIndex == 3
                    ? TextButton(
                        onPressed: () {
                          if (cangonext) {
                            onnext();
                            final target = currentPageIndex + 1;
                            controller.animateToPage(
                              target,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            onnext();
                            OverlayEntry overlayEntry = OverlayEntry(
                              builder: (context) => Positioned(
                                bottom: 60,
                                left:
                                    MediaQuery.of(context).size.width / 2 - 80,
                                child: Material(
                                  color: const Color.fromARGB(0, 0, 0, 0),
                                  child: Container(
                                    width: 150,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        32,
                                        32,
                                        32,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Enter a value',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            Overlay.of(context).insert(overlayEntry);
                            Future.delayed(
                              Duration(seconds: 2),
                              overlayEntry.remove,
                            );
                          }
                        },
                        child: Text(
                          "NEXT",
                          style: TextStyle(
                            color: Color.fromARGB(255, 212, 211, 211),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    : SizedBox(width: 62),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
