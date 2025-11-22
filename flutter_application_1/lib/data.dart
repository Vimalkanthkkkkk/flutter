import 'package:flutter/material.dart';

const Map<int, Map<String, dynamic>> mySharedMap = {
  0: {
    "title": 'Quit a bad habit',
    'icondate': 0xf6c6,
    'color': Color.fromARGB(255, 247, 1, 1),
  },
  1: {
    "title": 'Art',
    'icondate': 0xf5ef,
    'color': Color.fromARGB(255, 217, 22, 22),
  },
  2: {
    "title": 'Task',
    'icondate': 0xf51a,
    'color': Color.fromARGB(255, 241, 29, 96),
  },
  3: {
    "title": 'Meditation',
    'icondate': 0xf0144,
    'color': Color.fromARGB(255, 241, 8, 179),
  },
  4: {
    "title": 'Study',
    'icondate': 0xf012e,
    'color': Color.fromARGB(255, 161, 7, 232),
  },
  5: {
    "title": 'Sports',
    'icondate': 0xe1d2,
    'color': Color.fromARGB(255, 76, 175, 80),
  },
  6: {
    "title": 'Entertainment',
    'icondate': 0xf862,
    'color': Color.fromARGB(255, 27, 172, 180),
  },
  7: {
    "title": 'Social',
    'icondate': 0xf631,
    'color': Color.fromARGB(255, 2, 185, 133),
  },
  8: {
    "title": 'Finance',
    'icondate': 0xf58f,
    'color': Color.fromARGB(255, 3, 188, 86),
  },
  9: {
    "title": 'Health',
    'icondate': 0xf0f2,
    'color': Color.fromARGB(255, 2, 179, 19),
  },
  10: {
    "title": 'Work',
    'icondate': 0xf7f4,
    'color': Color.fromARGB(255, 76, 160, 2),
  },
  11: {
    "title": 'Nutrition',
    'icondate': 0xf869,
    'color': Color.fromARGB(255, 230, 124, 12),
  },
  12: {
    "title": 'Home',
    'icondate': 0xe319,
    'color': Color.fromARGB(255, 234, 149, 4),
  },
  13: {
    "title": 'Outdoor',
    'icondate': 0xf83e,
    'color': Color.fromARGB(255, 218, 89, 14),
  },
  14: {
    "title": 'Other',
    'icondate': 0xf02b9,
    'color': Color.fromARGB(255, 229, 52, 8),
  },
};



/*
      appBar:AppBar(
        backgroundColor: Color.fromARGB(255, 25, 24, 24),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(IconData(0xf8b6, fontFamily: 'MaterialIcons')),
            onPressed: () => Scaffold.of(context).openDrawer(),
            color: Color.fromARGB(255, 225, 26, 66),
          ),
        ),
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation =
                Tween<Offset>(
                  begin: Offset(0.0, 0.25),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );

            final reverseoffsetAnimation =
                Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.0, 0.25),
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );

            return SlideTransition(
              position: animation.status == AnimationStatus.reverse
                  ? reverseoffsetAnimation
                  : offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            _getPageTitle(),
            textAlign: TextAlign.start,
            key: ValueKey<String>(_getPageTitle()),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        actions: [
          AnimatedSlide(
            offset: _selectedIndex == 0 ? Offset.zero : const Offset(0.22, 0.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    IconData(0xf013d, fontFamily: 'MaterialIcons'),
                  ),
                  onPressed: () => {},
                  color: Color.fromARGB(255, 225, 26, 66),
                ),
                IconButton(
                  icon: const Icon(
                    IconData(0xf75b, fontFamily: 'MaterialIcons'),
                  ),
                  onPressed: () => {},
                  color: Color.fromARGB(255, 225, 26, 66),
                ),
                IconButton(
                  icon: const Icon(
                    IconData(0xf06c8, fontFamily: 'MaterialIcons'),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return TableCalendar(
                              firstDay: kFirstDay,
                              lastDay: kLastDay,
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              headerStyle: HeaderStyle(
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: Color.fromARGB(255, 225, 26, 66),
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: Color.fromARGB(255, 225, 26, 66),
                                ),
                                titleCentered: true,
                                formatButtonVisible: false,
                                titleTextStyle: TextStyle(
                                  color: Color.fromARGB(255, 253, 253, 253),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                titleTextFormatter: (date, locale) {
                                  return "${months[date.month - 1]}\n${date.year}";
                                },
                              ),
                              rowHeight: 62.0,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekendStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 26, 66),
                                ),
                                weekdayStyle: TextStyle(
                                  color: Color.fromARGB(255, 156, 145, 148),
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                todayTextStyle: DateTime.now() == _selectedDay
                                    ? TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.w800,
                                      )
                                    : TextStyle(
                                        color: Color.fromARGB(255, 255, 26, 66),
                                        fontWeight: FontWeight.w800,
                                      ),
                                todayDecoration: DateTime.now() == _selectedDay
                                    ? BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          225,
                                          26,
                                          66,
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(16),
                                      )
                                    : BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          26,
                                          26,
                                          26,
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                selectedTextStyle: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 225, 26, 66),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                defaultDecoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color.fromARGB(255, 34, 34, 34),
                                ),
                                defaultTextStyle: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    147,
                                    144,
                                    144,
                                  ),
                                  fontWeight: FontWeight.w800,
                                ),
                                outsideDecoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 25, 25, 25),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                outsideTextStyle: TextStyle(
                                  color: const Color.fromARGB(255, 90, 89, 89),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                if (!isSameDay(_selectedDay, selectedDay)) {
                                  setdate(selectedDay, focusedDay);
                                }
                                Navigator.pop(context);
                              },
                              onFormatChanged: (format) {
                                if (_calendarFormat != format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                }
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                            );
                          },
                        );
                      },
                      backgroundColor: Color.fromARGB(234, 19, 18, 18),
                    );
                  },
                  color: Color.fromARGB(255, 225, 26, 66),
                ),
                AnimatedOpacity(
                  opacity: _selectedIndex == 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  child: IconButton(
                    icon: const Icon(
                      IconData(0xf7e4, fontFamily: 'MaterialIcons'),
                    ),
                    onPressed: () {},
                    color: Color.fromARGB(255, 225, 26, 66),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

*/