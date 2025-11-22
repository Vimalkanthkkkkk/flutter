import 'package:flutter/material.dart';

class TimePickerdialog extends StatelessWidget {
  const TimePickerdialog({
    super.key,
    required this.segment,
    required this.segfunc,
  });
  final String segment;
  final Function segfunc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor: Color.fromARGB(255, 31, 31, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.only(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Time and reminders",
              style: TextStyle(
                color: const Color.fromARGB(255, 165, 160, 160),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            SizedBox(height: 24),
            Icon(
              IconData(0xe44d, fontFamily: 'MaterialIcons'),
              color: const Color.fromARGB(225, 225, 26, 66),
              size: 50,
            ),
            SizedBox(height: 20),
            Text(
              "No reminders for this activity",
              style: TextStyle(
                color: const Color.fromARGB(255, 144, 144, 144),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            TextButton.icon(
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return Size(480, 50);
                }),
                shape: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(0)),
                  );
                }),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (innercontext) => AdditionalDialog(
                    initialSegment: segment,
                    onSegmentChanged: segfunc,
                  ),
                );
              },
              icon: const Icon(
                IconData(0xf52c, fontFamily: 'MaterialIcons'),
                color: Color.fromARGB(255, 225, 26, 66),
                size: 19,
              ),
              label: const Text(
                'NEW REMINDER',
                style: TextStyle(
                  color: Color.fromARGB(255, 225, 26, 66),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconAlignment: IconAlignment.start,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            TextButton(
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return Size(480, 50);
                }),
                shape: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(0)),
                  );
                }),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "CLOSE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Option { always, specific, days }

class AdditionalDialog extends StatefulWidget {
  const AdditionalDialog({
    super.key,
    required this.initialSegment,
    required this.onSegmentChanged,
  });

  final String initialSegment;
  final Function onSegmentChanged;

  @override
  State<AdditionalDialog> createState() => _AdditionalDialogState();
}

class _AdditionalDialogState extends State<AdditionalDialog> {
  TimeOfDay? selectedTime;
  late String currentSegment;
  late String currentSegment2;
  Option character = Option.always;
  Set<String> selectedDays = {};
  TextEditingController daysController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentSegment = widget.initialSegment;
    currentSegment2 = widget.initialSegment;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor:  Color.fromARGB(255, 31, 31, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520, maxWidth: 340),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              const Text(
                "New reminders",
                style: TextStyle(
                  color: Color.fromARGB(255, 165, 160, 160),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
               SizedBox(height: 10),
               Divider(color: Color.fromARGB(255, 67, 67, 67)),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    barrierColor: const Color.fromARGB(150, 0, 0, 0),
                    initialTime: selectedTime ?? TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                    orientation: Orientation.portrait,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme:  ColorScheme.dark(
                            primary: Color(0xFFFF3B30),
                            onSurface: Color.fromARGB(255, 196, 191, 191),
                          ),
                          dialogTheme: DialogThemeData(
                            backgroundColor: Color.fromARGB(255, 51, 50, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          timePickerTheme: TimePickerThemeData(
                            dialTextColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            backgroundColor: const Color(0xFF333333),
                            dialBackgroundColor: const Color.fromARGB(
                              255,
                              79,
                              77,
                              77,
                            ),
                            dialHandColor: const Color.fromARGB(
                              255,
                              250,
                              41,
                              83,
                            ),
                            hourMinuteTextColor: WidgetStateColor.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(
                                  255,
                                  255,
                                  20,
                                  56,
                                ); 
                              }
                              return const Color.fromARGB(255, 144, 144, 144);
                            }),
                            hourMinuteColor: WidgetStateColor.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(
                                  74,
                                  255,
                                  20,
                                  55,
                                ); 
                              }
                              return const Color.fromARGB(120, 61, 59, 59);
                            }),
                            entryModeIconColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            helpTextStyle: const TextStyle(
                              color: Color.fromARGB(179, 224, 217, 217),
                              fontSize: 18,
                            ),
                            dayPeriodTextColor: WidgetStateColor.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color.fromARGB(
                                  255,
                                  255,
                                  20,
                                  56,
                                ); // Selected → White text
                              }
                              return const Color.fromARGB(255, 144, 144, 144);
                            }),
                            dayPeriodColor: const Color.fromARGB(
                              85,
                              255,
                              40,
                              72,
                            ),
                            dayPeriodTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            dayPeriodShape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF3B30),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );

                  setState(() {
                    selectedTime = time;
                  });
                  // ignore: avoid_print
                  print(selectedTime);
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(450, 80),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(0),
                  ),
                 
                ),
                child: Column(
                  children: [
                    Text(
                  selectedTime == null
                  ? '12:00 PM'
                  : selectedTime!.format(context), 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Reminder time',
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Color.fromARGB(255, 67, 67, 67)),
              Padding(
                padding: EdgeInsets.only(left: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reminder type",
                    style: TextStyle(
                      color: Color.fromARGB(255, 225, 26, 66),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                height: 80,
                child: SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment<String>(
                      value: "none",
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconData(0xf236, fontFamily: 'MaterialIcons'),
                            size: 28,
                          ),
                          SizedBox(height: 6),
                          Text("Don't Remind", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    ButtonSegment<String>(
                      value: "notification",
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconData(0xf235, fontFamily: 'MaterialIcons'),
                            size: 28,
                          ),
                          SizedBox(height: 6),
                          Text("Notification", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    ButtonSegment<String>(
                      value: "alarm",
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.alarm_on_outlined, size: 28),
                          SizedBox(height: 6),
                          Text("Alarm", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                  selected: <String>{currentSegment},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      currentSegment = newSelection.first;
                    });
                    widget.onSegmentChanged(newSelection.first);
                  },
                  style: ButtonStyle(
                    side: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.transparent,
                        width: 0,
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
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color.fromARGB(117, 225, 26, 66);
                      }
                      return const Color.fromARGB(255, 56, 56, 56);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color.fromARGB(255, 255, 0, 51);
                      }
                      return const Color.fromARGB(255, 183, 177, 177);
                    }),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    ),
                  ),
                ),
              ),
               Divider(color: Color.fromARGB(255, 67, 67, 67)),
              Padding(
                padding: EdgeInsets.only(left: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reminder schedule",
                    style: TextStyle(
                      color: Color.fromARGB(255, 225, 26, 66),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              RadioGroup<Option>(
                groupValue: character,
                onChanged: (Option? value) {
                  setState(() {
                    if (value != null) {
                      character = value;
                    }
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     ListTile(
                      minTileHeight: 0.50,
                      horizontalTitleGap: 0.50,
                      style: ListTileStyle.drawer,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Always enabled',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      leading: Radio<Option>(
                        value: Option.always,
                        activeColor: Color.fromARGB(255, 255, 26, 66),
                      ),
                    ),
                     ListTile(
                      minTileHeight: 0.50,
                      horizontalTitleGap: 3,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Specific days of this week',
                        style: TextStyle(
                          color: Color.fromARGB(255, 254, 255, 255),
                        ),
                      ),
                      leading: Radio<Option>(
                        value: Option.specific,
                        activeColor: Color.fromARGB(255, 255, 26, 66),
                      ),
                    ),
                    if (character == Option.specific) ...[
                      SizedBox(
                        height: 45,
                        child: SegmentedButton<String>(
                          showSelectedIcon: false,
                          multiSelectionEnabled: false,
                          emptySelectionAllowed: true,
                          segments: [
                            _buildDaySegment('Mon'),
                            _buildDaySegment('Tue'),
                            _buildDaySegment('Wed'),
                            _buildDaySegment('Thu'),
                            _buildDaySegment('Fri'),
                            _buildDaySegment('Sat'),
                            _buildDaySegment('Sun'),
                          ],
                          selected: selectedDays,
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              selectedDays = newSelection;
                            });
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            side: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return BorderSide(
                                style: BorderStyle.solid,
                                color: const Color.fromARGB(255, 59, 58, 58),
                                width: 1,
                              );
                            }),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              return Colors.transparent;
                            }),
                          ),
                        ),
                      ),
                    ],
                    ListTile(
                      minTileHeight: 0.50,
                      dense: true,
                      horizontalTitleGap: 3,
                      contentPadding: EdgeInsets.all(2),
                      title: Text(
                        'Days before',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      leading: Radio<Option>(
                        value: Option.days,
                      ),
                    ),
                    if (character == Option.days) ...[
                      SizedBox(
                        height: 50,
                        child:Row(
                        children: [
                          SizedBox(width: 126),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: daysController,
                              cursorColor: Color.fromARGB(255, 225, 26, 66),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 56, 56, 56),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'days before',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      )
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      minimumSize:  Size(170, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(0),
                      ),
                    ),
                    child:  Text(
                      "CLOSE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // ignore: avoid_print
                      print(currentSegment);
                    },
                    style: TextButton.styleFrom(
                      minimumSize:  Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(0),
                      ),
                    ),
                    child:  Text(
                      "CONFIRM",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  ButtonSegment<String> _buildDaySegment(String day) {
    return ButtonSegment<String>(
      value: day,
      label: Container(
        width: 44,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selectedDays.contains(day)
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(255, 120, 120, 120),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: selectedDays.contains(day)
                    ? Color.fromARGB(255, 255, 26, 66)
                    : Color.fromARGB(255, 120, 120, 120),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
