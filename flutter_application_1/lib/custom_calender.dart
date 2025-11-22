import 'package:flutter/material.dart';
class InlineCalendarWithDecorations extends StatefulWidget {
  const InlineCalendarWithDecorations({super.key});

  @override
  State<InlineCalendarWithDecorations> createState() =>
      _InlineCalendarWithDecorationsState();
}

class _InlineCalendarWithDecorationsState
    extends State<InlineCalendarWithDecorations> {
  DateTime selectedDate = DateTime.now();
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  List<DateTime> successDates = [
    DateTime(2025, 11, 22),
    DateTime(2025, 11, 10),
    DateTime(2025, 11, 15),
  ];

  List<DateTime> errorDates = [DateTime(2025, 11, 8), DateTime(2025, 12, 18)];

  List<DateTime> pendingDates = [
    DateTime(2025, 11, 12),
    DateTime(2025, 11, 20),
  ];

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isSuccessDate(DateTime d) => successDates.any((x) => isSameDay(x, d));
  bool isErrorDate(DateTime d) => errorDates.any((x) => isSameDay(x, d));
  bool isPendingDate(DateTime d) => pendingDates.any((x) => isSameDay(x, d));
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

  bool isAfterToday(DateTime d) => d.isAfter(DateTime.now());
  bool isBeforeToday(DateTime d) => d.isBefore(DateTime.now());

  String monthName(DateTime d) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[d.month - 1]}\n${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    int firstWeekday = firstDayOfMonth.weekday % 7;
    final totalCells = firstWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: goToPreviousMonth,
                icon: const Icon(Icons.chevron_left),
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  monthName(displayedMonth),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: goToNextMonth,
                icon: const Icon(Icons.chevron_right),
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(
                child: Center(
                  child: Text('Sun', style: TextStyle(color: Color.fromARGB(255, 225, 26, 66))),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Mon', style: TextStyle(color: Colors.white70)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Tue', style: TextStyle(color: Colors.white70)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Wed', style: TextStyle(color: Colors.white70)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Thu', style: TextStyle(color: Colors.white70)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Fri', style: TextStyle(color: Colors.white70)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Sat', style: TextStyle(color: Color.fromARGB(255, 225, 26, 66))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final gridWidth = constraints.maxWidth;
              final cellWidth = gridWidth / 7;
              final cellHeight = cellWidth * 0.95;
              final gridHeight = cellHeight * rows;
              return SizedBox(
                height: gridHeight,
                width: gridWidth,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: List.generate(rows, (r) {
                          return SizedBox(
                            height: cellHeight,
                            child: Row(
                              children: List.generate(7, (c) {
                                final index = r * 7 + c;
                                final dayNumber = index - firstWeekday + 1;
                                final inMonth =
                                    dayNumber >= 1 && dayNumber <= daysInMonth;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: inMonth
                                        ? () {
                                            if (isBeforeToday(
                                              DateTime(
                                                displayedMonth.year,
                                                displayedMonth.month,
                                                dayNumber,
                                              ),
                                            )) {
                                              setState(() {
                                                selectedDate = DateTime(
                                                  displayedMonth.year,
                                                  displayedMonth.month,
                                                  dayNumber,
                                                );
                                              });
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: inMonth
                                          ? Text(
                                              '$dayNumber',
                                              style: TextStyle(
                                                color:
                                                    isSameDay(
                                                      selectedDate,
                                                      DateTime(
                                                        displayedMonth.year,
                                                        displayedMonth.month,
                                                        dayNumber,
                                                      ),
                                                    )
                                                    ? const Color.fromARGB(255, 255, 255, 255)
                                                    : Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                    ...List<Widget>.generate(daysInMonth, (i) {
                      final day = i + 1;
                      final pos = firstWeekday + (day - 1);
                      final rowIdx = pos ~/ 7;
                      final colIdx = pos % 7;
                      final left = colIdx * cellWidth + (cellWidth - 36) / 2;
                      final top = rowIdx * cellHeight + (cellHeight - 36) / 2;
                      final date = DateTime(
                        displayedMonth.year,
                        displayedMonth.month,
                        day,
                      );
                      Color? bg;
                      Color? border;
                      if (isSuccessDate(date)) {
                        bg = const Color.fromARGB(40, 76, 175, 80);
                        border = const Color.fromARGB(255, 76, 175, 80);
                      } else if (isErrorDate(date)) {
                        bg = const Color.fromARGB(40, 244, 67, 54);
                        border = const Color.fromARGB(255, 244, 67, 54);
                      } else if (isPendingDate(date)) {
                        bg = const Color.fromARGB(40, 255, 193, 7);
                        border = const Color.fromARGB(255, 255, 193, 7);
                      } else if (isSameDay(DateTime.now(), date)) {
                        bg = Color.fromARGB(40, 91, 90, 89);
                        border = Color.fromARGB(255, 171, 171, 171);
                      } else if (isAfterToday(date)) {
                        bg = Colors.transparent;
                        border = Color.fromARGB(255, 44, 44, 44);
                      }

                      if (bg == null) return const SizedBox.shrink();

                      return Positioned(
                        left: left,
                        top: top,
                        width: 36,
                        height: 36,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bg,
                              border: Border.all(color: border!, width: 1.5),
                              borderRadius: BorderRadius.circular(13.5),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
