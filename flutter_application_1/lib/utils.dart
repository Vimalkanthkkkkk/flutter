import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource =
    {
      for (var item in List.generate(50, (index) => index))
        DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
          item % 4 + 1,
          (index) => Event('Event $item | ${index + 1}'),
        ),
    }..addAll({
      kToday: [const Event("Today's Event 1"), const Event("Today's Event 2")],
    });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

void showCategoryDialog(BuildContext context, Function onpress) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        constraints: BoxConstraints(maxHeight: 444, maxWidth: 300),
        backgroundColor: const Color.fromARGB(255, 51, 50, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      onpress(index);
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

void showdescriptiondialog(
  BuildContext context,
  FocusNode? focusnode,
  TextEditingController controller,
  int maxlines,
  String labeltext
) {
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
              selectAllOnFocus: true,
              onChanged: (value) {},
              focusNode: focusnode,
              controller: controller,
              maxLines: maxlines,
              cursorColor: Color.fromARGB(255, 225, 26, 66),
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 225, 26, 66),
                focusColor: Color.fromARGB(255, 225, 26, 66),
                labelText: labeltext,
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


void generalDialog(BuildContext context , String title , String cancelText , String acceptText , Color titleTextcolor , Color acceptTextcolor ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        clipBehavior: Clip.hardEdge,
        backgroundColor: Color.fromARGB(255, 31, 31, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleTextcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Divider(
                height: 1,
                thickness: 1,
                color: Color.fromARGB(255, 67, 67, 67),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      fixedSize: Size(160, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(Radius.zero),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: Color.fromARGB(255, 144, 144, 144),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      fixedSize: Size(160, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(Radius.zero),
                      ),
                    ),
                    child: Text(
                      acceptText,
                      style: TextStyle(
                        color: acceptTextcolor,
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
    },
  );
}
