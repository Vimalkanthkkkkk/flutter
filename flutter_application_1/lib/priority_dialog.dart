import 'package:flutter/material.dart';

class PriorityDialog extends StatefulWidget {
  const PriorityDialog({super.key});

  @override
  State<PriorityDialog> createState() => _PriDialogState();
}

class _PriDialogState extends State<PriorityDialog> {
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    priorityController.dispose();
  }

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
              "Set a priority",
              style: TextStyle(
                color: const Color.fromARGB(255, 243, 243, 243),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                IconButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      );
                    }),
                    fixedSize: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return Size(40, 47);
                    }),
                    backgroundColor: WidgetStateColor.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return Color.fromARGB(255, 56, 56, 56);
                    }),
                    shape: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(12) , 
                          bottomLeft: Radius.circular(12),
                        )
                      );
                    }),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    IconData(0xec12, fontFamily: 'MaterialIcons'),
                    color: const Color.fromARGB(223, 112, 108, 109),
                    size: 30,
                  ),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: priorityController,
                    cursorColor: Color.fromARGB(255, 225, 26, 66),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 56, 56, 56),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      );
                    }),
                    fixedSize: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return Size(40, 47);
                    }),
                    backgroundColor: WidgetStateColor.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return Color.fromARGB(255, 56, 56, 56);
                    }),
                    shape: WidgetStateProperty.resolveWith((
                      Set<WidgetState> callback,
                    ) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.only(
                          topRight: Radius.circular(12) , 
                          bottomRight: Radius.circular(12),
                        )
                      );
                    }),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    IconData(0xee47, fontFamily: 'MaterialIcons'),
                    color: const Color.fromARGB(223, 112, 108, 109),
                    size: 30,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
            SizedBox(height: 12),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return const Color.fromARGB(111, 255, 26, 64);
                }),
                fixedSize: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return Size(140, 50);
                }),
                shape: WidgetStateProperty.resolveWith((
                  Set<WidgetState> callback,
                ) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
                  );
                }),
              ),
              onPressed: () {
              },
              icon: Icon(
                IconData(0xf52c, fontFamily: 'MaterialIcons'),
                color: Color.fromARGB(255, 225, 26, 66),
                size: 19,
              ),
              label: const Text(
                'Default - 1',
                style: TextStyle(
                  color: Color.fromARGB(255, 242, 9, 56),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconAlignment: IconAlignment.end,
            ),
            SizedBox(height: 20,),
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            Padding(
              padding: EdgeInsets.all(12) ,
              child: Text(
              "Higher priority activities will be displayed higher in the list",
              style: TextStyle(
                color: Color.fromARGB(255, 242, 9, 56),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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
                    minimumSize: const Size(170, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(0),
                    ),
                  ),
                  child: const Text(
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
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(0),
                    ),
                  ),
                  child: const Text(
                    "OK",
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
    );
  }
}



/*
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
      backgroundColor: const Color.fromARGB(255, 31, 31, 30),
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
              const SizedBox(height: 10),
              const Divider(color: Color.fromARGB(255, 67, 67, 67)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                ),
                child: const Column(
                  children: [
                    Text(
                      '12:00 PM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
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
              const Divider(color: Color.fromARGB(255, 67, 67, 67)),
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
                    const ListTile(
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
                    const ListTile(
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
                    const ListTile(
                      minTileHeight: 0.50,
                      horizontalTitleGap: 3,
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Days before',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      leading: Radio<Option>(
                        value: Option.days,
                        activeColor: Color.fromARGB(255, 255, 26, 66),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // ignore: avoid_print
                  print(currentSegment);
                },
                style: TextButton.styleFrom(minimumSize: const Size(200, 48)),
                child: const Text(
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
      ),
    );
  }
}

*/