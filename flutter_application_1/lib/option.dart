import 'package:flutter/material.dart';

class FrequencySelector extends StatefulWidget {
  const FrequencySelector({super.key});

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  String _character = "Every";
  Set<String> selectedWeekdays = {};
  Set<int> selectedMonthDays = {};
  Set<String> selectedYearDates = {};
  bool flexibleWeek = false;
  bool flexibleMonth = false;
  bool useDaysOfWeek = false;
  bool alternateEnabled = false;
  String selectedWeekOccurrence = "";
  String selectedYearDate = "";
  TextEditingController perPeriodController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController restController = TextEditingController();
  String periodType = "WEEK";

  final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final months = [
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRadioOption("Every", "Every Day", null),
          _buildRadioOption(
            "Specificdaysweek",
            "Specific days of the week",
            _buildWeekdaysContent(),
          ),
          _buildRadioOption(
            "Specificdaysmonth",
            "Specific days of the month",
            _buildMonthDaysContent(),
          ),
          _buildRadioOption(
            "Specificdaysyear",
            "Specific days of the year",
            _buildYearDaysContent(),
          ),
          _buildRadioOption(
            "Someperperiod",
            "Some days per period",
            _buildPerPeriodContent(),
          ),
          _buildRadioOption("Repeat", "Repeat", _buildRepeatContent()),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String title, Widget? content) {
    bool isSelected = _character == value;

    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 3,
          minTileHeight: 4,
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          leading: Radio<String>(
            value: value,
            groupValue: _character,
            activeColor: Color.fromARGB(225, 225, 66, 26),
            onChanged: (String? newValue) {
              setState(() {
                _character = newValue!;
              });
            },
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: isSelected && content != null ? 1.0 : 0.0,
            duration: Duration(milliseconds: 150),
            child: isSelected && content != null
                ? Padding(
                    padding: EdgeInsets.only(left: 48, top: 8, bottom: 16),
                    child: content,
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdaysContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            final day = weekdays[index];
            final isSelected = selectedWeekdays.contains(day);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedWeekdays.remove(day);
                  } else {
                    selectedWeekdays.add(day);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color.fromARGB(225, 225, 66, 26)
                      : Color.fromARGB(255, 56, 56, 56),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val!) {
                            selectedWeekdays.add(day);
                          } else {
                            selectedWeekdays.remove(day);
                          }
                        });
                      },
                      activeColor: Colors.white,
                      checkColor: Color.fromARGB(225, 225, 66, 26),
                      side: BorderSide(color: Colors.white),
                    ),
                    Text(
                      day,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Divider(color: Color.fromARGB(255, 67, 67, 67)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Flexible\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "It will be shown each day until completed",
                  style: TextStyle(
                    color: Color.fromARGB(255, 144, 144, 144),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: flexibleWeek
                    ? Color.fromARGB(225, 225, 66, 26)
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: flexibleWeek
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(225, 225, 66, 26),
                      ),
                    ),
                  )
                : null,
          ),
          onTap: () {
            setState(() {
              flexibleWeek = !flexibleWeek;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMonthDaysContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 32,
          itemBuilder: (context, index) {
            final day = index + 1;
            final displayText = day == 32 ? "Last" : day.toString();
            final isSelected = selectedMonthDays.contains(day);

            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedMonthDays.remove(day);
                  } else {
                    selectedMonthDays.add(day);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Color.fromARGB(225, 225, 66, 26)
                      : Color.fromARGB(255, 56, 56, 56),
                ),
                child: Center(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: day == 32 ? 10 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            "Select at least one day",
            style: TextStyle(
              color: Color.fromARGB(255, 144, 144, 144),
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 16),
        Divider(color: Color.fromARGB(255, 67, 67, 67)),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Flexible\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "It will be shown each day until completed",
                  style: TextStyle(
                    color: Color.fromARGB(255, 144, 144, 144),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: flexibleMonth
                    ? Color.fromARGB(225, 225, 66, 26)
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: flexibleMonth
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(225, 225, 66, 26),
                      ),
                    ),
                  )
                : null,
          ),
          onTap: () {
            setState(() {
              flexibleMonth = !flexibleMonth;
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Use days of the week",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: Switch(
            value: useDaysOfWeek,
            onChanged: (val) {
              setState(() {
                useDaysOfWeek = val;
              });
            },
            activeThumbColor: Color.fromARGB(225, 225, 66, 26),
          ),
        ),
        if (useDaysOfWeek) ...[
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _showWeekOccurrenceDialog(),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 56, 56, 56),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    selectedWeekOccurrence.isEmpty
                        ? "Select at least one day"
                        : selectedWeekOccurrence,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () => _showWeekOccurrenceDialog(),
                icon: Icon(Icons.edit, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 56, 56),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildYearDaysContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _showYearDateDialog(),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 56, 56),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  selectedYearDate.isEmpty
                      ? "Select at least one day"
                      : selectedYearDate,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () => _showYearDateDialog(),
              icon: Icon(Icons.edit, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 56, 56, 56),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerPeriodContent() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 56, 56),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: TextField(
              controller: perPeriodController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text("days per", style: TextStyle(color: Colors.white)),
          SizedBox(width: 12),
          DropdownButton<String>(
            value: periodType,
            dropdownColor: Color.fromARGB(255, 56, 56, 56),
            style: TextStyle(color: Colors.white),
            items: ["WEEK", "MONTH", "YEAR"].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                periodType = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 56, 56, 56),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text("Every", style: TextStyle(color: Colors.white)),
              SizedBox(width: 12),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: repeatController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text("days", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Flexible\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "It will be shown each day until completed",
                  style: TextStyle(
                    color: Color.fromARGB(255, 144, 144, 144),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: flexibleWeek
                    ? Color.fromARGB(225, 225, 66, 26)
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: flexibleWeek
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(225, 225, 66, 26),
                      ),
                    ),
                  )
                : null,
          ),
          onTap: () {
            setState(() {
              flexibleWeek = !flexibleWeek;
            });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Alternate days",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: Switch(
            value: alternateEnabled,
            onChanged: (val) {
              setState(() {
                alternateEnabled = val;
              });
            },
            activeColor: Color.fromARGB(225, 225, 66, 26),
          ),
        ),
        if (alternateEnabled) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 56, 56, 56),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: activityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Activity",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text("X", style: TextStyle(color: Colors.white, fontSize: 20)),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: restController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Rest",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showWeekOccurrenceDialog() {
    String? selectedOccurrence;
    String? selectedDay;

    final occurrences = ["First", "Second", "Third", "Fourth", "Fifth", "Last"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Color.fromARGB(255, 31, 31, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select a date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Color.fromARGB(255, 67, 67, 67)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount: occurrences.length,
                              itemBuilder: (context, index) {
                                final occ = occurrences[index];
                                return ListTile(
                                  title: Text(
                                    occ,
                                    style: TextStyle(
                                      color: selectedOccurrence == occ
                                          ? Color.fromARGB(225, 225, 66, 26)
                                          : Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedOccurrence = occ;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        VerticalDivider(color: Color.fromARGB(255, 67, 67, 67)),
                        Expanded(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount: weekdays.length,
                              itemBuilder: (context, index) {
                                final day = weekdays[index];
                                return ListTile(
                                  title: Text(
                                    day,
                                    style: TextStyle(
                                      color: selectedDay == day
                                          ? Color.fromARGB(225, 225, 66, 26)
                                          : Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedDay = day;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (selectedOccurrence != null &&
                                selectedDay != null) {
                              setState(() {
                                selectedWeekOccurrence =
                                    "$selectedOccurrence $selectedDay";
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Color.fromARGB(225, 225, 66, 26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showYearDateDialog() {
    String? selectedMonth;
    int? selectedDay;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Color.fromARGB(255, 31, 31, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select a date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Color.fromARGB(255, 67, 67, 67)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount: months.length,
                              itemBuilder: (context, index) {
                                final month = months[index];
                                return ListTile(
                                  title: Text(
                                    month,
                                    style: TextStyle(
                                      color: selectedMonth == month
                                          ? Color.fromARGB(225, 225, 66, 26)
                                          : Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedMonth = month;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        VerticalDivider(color: Color.fromARGB(255, 67, 67, 67)),
                        Expanded(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              itemCount: 31,
                              itemBuilder: (context, index) {
                                final day = index + 1;
                                return ListTile(
                                  title: Text(
                                    day.toString(),
                                    style: TextStyle(
                                      color: selectedDay == day
                                          ? Color.fromARGB(225, 225, 66, 26)
                                          : Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedDay = day;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (selectedMonth != null && selectedDay != null) {
                              setState(() {
                                selectedYearDate =
                                    "$selectedMonth $selectedDay";
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Color.fromARGB(225, 225, 66, 26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
