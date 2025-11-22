import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/create_habit.dart';
import 'package:flutter_application_1/habit_summary_page.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:flutter_application_1/category_page.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color.fromARGB(255, 225, 26, 66),
        ),
      ),
      title: 'HabitNow',
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      home: HabitNow(),
    );
  }
}

class HabitNow extends StatefulWidget {
  const HabitNow({super.key});

  @override
  State<HabitNow> createState() => _HabitNowState();
}

class _HabitNowState extends State<HabitNow>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  DateTime? _selectedDay;
  bool routebool = false;
  DateTime _focusedDay = DateTime.now();
  List<String> list = <String>['All', 'Habits', 'Tasks'];
  late String dropdownValue = list.first;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late TabController _tabController;
  String habitType = 'Habit';
  bool showfilter = false;
  TextEditingController? activitycontroller;

  DateTime kToday = DateTime.now();
  DateTime get kFirstDay =>
      DateTime(kToday.year, kToday.month - 10, kToday.day);
  DateTime get kLastDay => DateTime(kToday.year, kToday.month + 10, kToday.day);
  List<String> get months => [
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
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static const List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'Single tasks',
        style: TextStyle(
          color: Color.fromARGB(255, 185, 182, 182),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    Tab(
      child: Text(
        'Recurring tasks',
        style: TextStyle(
          color: Color.fromARGB(255, 185, 182, 182),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setdate(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Today';
      case 1:
        return 'Habits';
      case 2:
        return 'Tasks';
      case 3:
        return 'Categories';
      case 4:
        return 'Timer';
      default:
        return 'Today';
    }
  }

  Widget _getPageBody() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            ScrollDays(selectedday: _selectedDay),
            SizedBox(height: 12),
            Cards(big: false,),
          ],
        );
      case 1:
        return Container(
          decoration: BoxDecoration(),
          child: Column(children: [
            Cards(big: true)
            ],
          ),
        );
      case 2:
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
                controller: _tabController,
                tabs: tabs,
                indicatorColor: Color.fromARGB(255, 188, 26, 58),
                indicatorWeight: 4.0,
                dividerHeight: 0.09,
                overlayColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color.fromARGB(100, 114, 25, 43);
                  }
                  return Colors.transparent;
                }),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabs.map((Tab tab) {
                    return Center(
                      child: Text(
                        'Tab',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      case 3:
        return CategoryPage();
      case 4:
        return Center(
          child: Text(
            'Timer Page',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScrollDays(selectedday: _selectedDay),
            SizedBox(height: 12),
            Cards(big: false,),
          ],
        );
    }
  }

  Widget page() {
    return _selectedIndex == 4 ? const TimerPage() : const CategoryPage();
  }

  Route<void> _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => CategoryPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(2.5, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  Route<void> _createRoute2() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          HabitCreate(type: habitType),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(2.5, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 24, 24),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 225, 26, 66),
        ),
        child: IconButton(
          style: IconButton.styleFrom(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 225, 26, 66),
            foregroundColor: Color.fromARGB(255, 225, 26, 66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            splashFactory: InkRipple.splashFactory,
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (BuildContext context) {
                return Container(
                  width: 800,
                  height: 320,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 31, 31, 30),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            habitType = 'Habit';
                          });
                          Navigator.of(context).push(_createRoute2());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 32,
                                left: 20,
                              ),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(85, 225, 26, 66),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconData(0xf01a, fontFamily: 'MaterialIcons'),
                                  color: Color.fromARGB(255, 225, 26, 66),
                                  size: 32,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    bottom: 0,
                                    top: 16,
                                  ),
                                  child: Text(
                                    "Habit",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          170,
                                    ),
                                    child: Text(
                                      "Activity that repeats over time. It has detailed tracking and statistics",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 16),
                              child: Icon(
                                IconData(
                                  0xe79a,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                color: Color.fromARGB(255, 225, 26, 66),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Color.fromARGB(255, 43, 42, 42),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            habitType = 'Recur';
                          });
                          Navigator.of(context).push(_createRoute2());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 32,
                                left: 20,
                              ),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(85, 225, 26, 66),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconData(0xec18, fontFamily: 'MaterialIcons'),
                                  color: Color.fromARGB(255, 225, 26, 66),
                                  size: 32,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    bottom: 0,
                                    top: 16,
                                  ),
                                  child: Text(
                                    "Recurring Task",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          170,
                                    ),
                                    child: Text(
                                      "Activity that repeats over time without tracking or statistics",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 16),
                              child: Icon(
                                IconData(
                                  0xe79a,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                color: Color.fromARGB(255, 225, 26, 66),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Color.fromARGB(255, 43, 42, 42),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            habitType = 'Task';
                          });
                          Navigator.of(context).push(_createRoute2());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 32,
                                left: 20,
                              ),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(85, 225, 26, 66),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconData(0xe8f5, fontFamily: 'MaterialIcons'),
                                  color: Color.fromARGB(255, 225, 26, 66),
                                  size: 32,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 2,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    bottom: 0,
                                    top: 16,
                                  ),
                                  child: Text(
                                    "Task",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          170,
                                    ),
                                    child: Text(
                                      "Single instance activity without tracking over time",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 16),
                              child: Icon(
                                IconData(
                                  0xe79a,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                color: Color.fromARGB(255, 225, 26, 66),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 19, 19, 19),
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Row(
                children: [
                  Text(
                    "Habit",
                    style: TextStyle(
                      color: Color.fromARGB(255, 225, 26, 66),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Now",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 78, 113),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                weekdays[kToday.weekday - 1],
                style: TextStyle(
                  color: const Color.fromARGB(255, 230, 225, 225),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${kToday.day.toString()} ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 158, 155, 155),
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(text: '${months[kToday.month - 1]} '),
                    TextSpan(text: kToday.year.toString()),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Divider(
                height: 1,
                thickness: 1,
                endIndent: 16,
                color: const Color.fromARGB(255, 67, 67, 67),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabitNow()),
                  );
                },
                child: Row(
                children: [
                  Icon(
                    IconData(0xf107, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimerPage()),
                  );
                },
                child: Row(
                children: [
                  Icon(
                    IconData(0xed5d, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Timer",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                },
                child: Row(
                children: [
                  Icon(
                    IconData(0xf4c7, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Categories",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(height: 30),
              Divider(
                height: 1,
                thickness: 1,
                endIndent: 16,
                color: const Color.fromARGB(255, 67, 67, 67),
              ),
              SizedBox(height: 30),

              Row(
                children: [
                  Icon(
                    IconData(0xe9ac, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Customize",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    IconData(0xf466, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    IconData(0xeeb6, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Backups",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Divider(
                height: 1,
                thickness: 1,
                endIndent: 16,
                color: const Color.fromARGB(255, 67, 67, 67),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    IconData(0xed8f, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Get premium",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    IconData(0xecf3, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Rate this app",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    IconData(0xf04f, fontFamily: 'MaterialIcons'),
                    color: Color.fromARGB(255, 225, 26, 66),
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Contact us",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: const Color.fromARGB(0, 0, 0, 0),
          highlightColor: const Color.fromARGB(0, 0, 0, 0),
          applyElevationOverlayColor: false,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          selectedIconTheme: IconThemeData(
            color: const Color.fromARGB(255, 225, 26, 66),
          ),
          unselectedIconTheme: IconThemeData(
            color: const Color.fromARGB(255, 133, 131, 132),
          ),
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          selectedItemColor: const Color.fromARGB(255, 225, 26, 66),
          unselectedItemColor: const Color.fromARGB(255, 133, 131, 132),
          selectedLabelStyle: TextStyle(
            color: const Color.fromARGB(255, 225, 26, 66),
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            color: const Color.fromARGB(255, 133, 131, 132),
            fontWeight: FontWeight.w400,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 26,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf045, fontFamily: 'MaterialIcons'),
                color: Color.fromARGB(255, 176, 176, 176),
              ),
              activeIcon: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: const Color.fromARGB(135, 225, 26, 66),
                ),
                child: Icon(IconData(0xe256, fontFamily: 'MaterialIcons')),
              ),
              label: "Today",
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconData(0xf06a1, fontFamily: 'MaterialIcons')),
              label: "Habits",
              activeIcon: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: const Color.fromARGB(135, 225, 26, 66),
                ),
                child: Icon(IconData(0xf05ae, fontFamily: 'MaterialIcons')),
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconData(0xf428, fontFamily: 'MaterialIcons')),
              label: "Tasks",
              activeIcon: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: const Color.fromARGB(135, 225, 26, 66),
                ),
                child: Icon(
                  IconData(0xf428, fontFamily: 'MaterialIcons'),
                  color: const Color.fromARGB(255, 225, 26, 66),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_createRoute());
                },
                child: Icon(IconData(0xf4c7, fontFamily: 'MaterialIcons')),
              ),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerPage(),
                    ),
                  );
                },
                child: Icon(IconData(0xed5d, fontFamily: 'MaterialIcons')),
              ),
              label: "Timer",
            ),
          ],
          backgroundColor: Color.fromARGB(255, 38, 38, 38),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!showfilter) ...[
            AppBar(
              backgroundColor: Color.fromARGB(255, 25, 24, 24),
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(
                    IconData(0xf8b6, fontFamily: 'MaterialIcons'),
                  ),
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
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      );
                  final reverseoffsetAnimation =
                      Tween<Offset>(
                        begin: Offset.zero,
                        end: Offset(0.0, 0.25),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
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
                  offset: _selectedIndex == 0
                      ? Offset.zero
                      : const Offset(0.22, 0.0),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          IconData(0xf013d, fontFamily: 'MaterialIcons'),
                        ),
                        onPressed: () {
                          setState(() {
                            showfilter = !showfilter;
                          });
                        },
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
                                builder:
                                    (
                                      BuildContext context,
                                      StateSetter setState,
                                    ) {
                                      return TableCalendar(
                                        firstDay: kFirstDay,
                                        lastDay: kLastDay,
                                        focusedDay: _focusedDay,
                                        calendarFormat: _calendarFormat,
                                        headerStyle: HeaderStyle(
                                          leftChevronIcon: Icon(
                                            Icons.chevron_left,
                                            color: Color.fromARGB(
                                              255,
                                              225,
                                              26,
                                              66,
                                            ),
                                          ),
                                          rightChevronIcon: Icon(
                                            Icons.chevron_right,
                                            color: Color.fromARGB(
                                              255,
                                              225,
                                              26,
                                              66,
                                            ),
                                          ),
                                          titleCentered: true,
                                          formatButtonVisible: false,
                                          titleTextStyle: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              253,
                                              253,
                                              253,
                                            ),
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
                                            color: Color.fromARGB(
                                              255,
                                              255,
                                              26,
                                              66,
                                            ),
                                          ),
                                          weekdayStyle: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              156,
                                              145,
                                              148,
                                            ),
                                          ),
                                        ),
                                        calendarStyle: CalendarStyle(
                                          todayTextStyle:
                                              DateTime.now() == _selectedDay
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
                                                  color: Color.fromARGB(
                                                    255,
                                                    255,
                                                    26,
                                                    66,
                                                  ),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          todayDecoration:
                                              DateTime.now() == _selectedDay
                                              ? BoxDecoration(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    225,
                                                    26,
                                                    66,
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                )
                                              : BoxDecoration(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    26,
                                                    26,
                                                    26,
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
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
                                            color: const Color.fromARGB(
                                              255,
                                              225,
                                              26,
                                              66,
                                            ),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          defaultDecoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            color: const Color.fromARGB(
                                              255,
                                              34,
                                              34,
                                              34,
                                            ),
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
                                            color: const Color.fromARGB(
                                              255,
                                              25,
                                              25,
                                              25,
                                            ),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          outsideTextStyle: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              90,
                                              89,
                                              89,
                                            ),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        selectedDayPredicate: (day) {
                                          return isSameDay(_selectedDay, day);
                                        },
                                        onDaySelected:
                                            (selectedDay, focusedDay) {
                                              if (!isSameDay(
                                                _selectedDay,
                                                selectedDay,
                                              )) {
                                                setdate(
                                                  selectedDay,
                                                  focusedDay,
                                                );
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
          ] else ...[
            //SizedBox(height: 30,),
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 36, 35, 35),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color.fromARGB(255, 66, 65, 65),
                              width: 1,
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: DropdownButton<String>(
                          value: "All",
                          menuWidth: 120,
                          underline: SizedBox(),
                          dropdownColor: const Color.fromARGB(255, 22, 21, 21),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: "All",
                              child: Text(
                                "All",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Habits",
                              child: Text(
                                "Habits",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Tasks",
                              child: Text(
                                "Tasks",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onChanged: (v) {},
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: const Color.fromARGB(255, 66, 65, 65),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: const Color.fromARGB(255, 66, 65, 65),
                                width: 1,
                              ),
                            ),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.resolveWith((
                                Set<WidgetState> callback,
                              ) {
                                return const Color.fromARGB(132, 83, 82, 81);
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    AlertDialog(content: Text("Dialog opened")),
                              );
                            },
                            child: const Text(
                              "Select a category",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 108, 106, 106),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: TextField(
                          controller: activitycontroller,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Color.fromARGB(255, 255, 20, 56),
                          decoration: const InputDecoration(
                            hintText: "Activity name",
                            hintStyle: TextStyle(color: Colors.white54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: const Color.fromARGB(255, 66, 65, 65),
                              width: 1,
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.10,
                        height: 50,
                        child: IconButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(0),
                              );
                            }),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            IconData(0xf2d7, fontFamily: 'MaterialIcons'),
                            color: Color.fromARGB(255, 108, 106, 106),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        width: MediaQuery.of(context).size.width * 0.10,
                        height: 50,
                        child: IconButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(0),
                              );
                            }),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            IconData(0xefa9, fontFamily: 'MaterialIcons'),
                            color: Color.fromARGB(255, 108, 106, 106),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        width: MediaQuery.of(context).size.width * 0.10,
                        height: 50,
                        child: IconButton(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith((
                              Set<WidgetState> callback,
                            ) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(0),
                              );
                            }),
                          ),
                          onPressed: () {
                            setState(() {
                              showfilter = !showfilter;
                            });
                          },
                          icon: const Icon(
                            IconData(0xf71f, fontFamily: 'MaterialIcons'),
                            color: Color.fromARGB(255, 108, 106, 106),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          _getPageBody(),
        ],
      ),
    );
  }
}

class ScrollDays extends StatefulWidget {
  final DateTime? selectedday;
  const ScrollDays({super.key, required this.selectedday});

  @override
  State<ScrollDays> createState() => _EachDayWidget();
}

class _EachDayWidget extends State<ScrollDays> {
  int sharedindex = 0;
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentindex();
      _scrollToCurrentDay(sharedindex);
    });
  }

  @override
  void didUpdateWidget(covariant ScrollDays oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedday != oldWidget.selectedday &&
        withinthreemonths(widget.selectedday)) {
      final newIndex = scrollindex(widget.selectedday!);
      setState(() => sharedindex = newIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentDay(newIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isleapyear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        return year % 400 == 0;
      }
      return true;
    }
    return false;
  }

  List<int> get numofdaysinmonth => [
    31,
    isleapyear(DateTime.now().year) ? 29 : 28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
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

  int get currentmonth => DateTime.now().month - 1;
  int get currentyear => DateTime.now().year;
  int get prevmonth => (currentmonth - 1 + 12) % 12;
  int get nextmonth => (currentmonth + 1) % 12;
  int get totaldays =>
      numofdaysinmonth[prevmonth] +
      numofdaysinmonth[currentmonth] +
      numofdaysinmonth[nextmonth];
  int get prevmonthtotal => numofdaysinmonth[prevmonth];
  int get currmonthtotal => numofdaysinmonth[currentmonth];
  int get prevmonthstartingday {
    final firstDayPrevMonth = DateTime(currentyear, prevmonth + 1, 1);
    return (firstDayPrevMonth.weekday - 1) % 7;
  }

  DateTime get nextmonthlastday {
    final lastDayPrevMonth = DateTime(
      currentyear,
      nextmonth + 1,
      numofdaysinmonth[nextmonth],
    );
    return lastDayPrevMonth;
  }

  DateTime get previousmonthstartingday {
    final firstDayPrevMonth = DateTime(currentyear, prevmonth + 1, 1);
    return firstDayPrevMonth;
  }

  int get currentday => DateTime.now().day;
  int get currentdayindex => prevmonthtotal + currentday - 1;

  bool withinthreemonths(DateTime? date) {
    if (date == null) return false;
    return date.isAfter(previousmonthstartingday) &&
        date.isBefore(nextmonthlastday);
  }

  int scrollindex(DateTime day) {
    try {
      var currM = day.day - 1;
      var index = numofdaysinmonth[prevmonth] + currM;
      return index;
    } catch (e) {
      return currentdayindex;
    }
  }

  void currentindex() {
    setState(() {
      sharedindex = currentdayindex;
    });
  }

  void _scrollToCurrentDay(int index) {
    const double itemWidth = 54;
    final double targetOffset = index * itemWidth - (itemWidth * 3) - 16;
    _scrollController.jumpTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: totaldays,
        itemBuilder: (context, index) {
          bool isprevmonth = index < prevmonthtotal;
          bool isnextmonth = index >= (prevmonthtotal + currmonthtotal);
          int dayNumber;
          if (isprevmonth) {
            dayNumber = index + 1;
          } else if (isnextmonth) {
            dayNumber = (index - prevmonthtotal - currmonthtotal) + 1;
          } else {
            dayNumber = (index - prevmonthtotal) + 1;
          }

          String weekday =
              weekdays[(prevmonthstartingday + index) % weekdays.length];

          return GestureDetector(
            onTap: () {
              setState(() {
                sharedindex = index;
              });
            },
            child: Container(
              width: 50,
              height: 65,
              margin: EdgeInsets.only(right: index < totaldays - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: index == sharedindex
                    ? Color.fromARGB(255, 225, 26, 66)
                    : Color.fromARGB(255, 33, 32, 32),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: AlignmentGeometry.topCenter,
                children: [
                  Positioned(
                    top: 4.0,
                    child: Text(
                      weekday,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      width: 50,
                      height: 65,
                      decoration: BoxDecoration(
                        color: index == sharedindex
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 50, 50, 50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(top: 26),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                  Positioned(
                    top: 32.0,
                    child: Text(
                      "$dayNumber",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (index == currentdayindex)
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        width: 20,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(top: 62),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({required this.big, super.key});
  final bool big;
  @override
  State<StatefulWidget> createState() => _SlidingCardState();
}

class _SlidingCardState extends State<Cards> {
  double offset = 0.0;
  final double maxSlide = 70.0;
  Timer? timer;
  bool navigated = false;
  double lerpNormalized(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Route<void> _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          HabitSummarypage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(2.5, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:widget.big ? 200 : 70, //70
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.big ? 16 : 0)),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: widget.big ? 200 : 70,
                height:widget.big ? 200 : 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.big ?16 : 0),
                  color: Color.fromARGB(255, 255, 51, 51),
                ),
              ),
              const Spacer(),
              Container(
                width:widget.big ? 200 : 70,
                height:widget.big ? 200 : 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.big ? 16 : 0),
                  color: Color.fromARGB(255, 255, 51, 51),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Opacity(
                opacity: offset > 0 ? (1 - offset.abs().clamp(0, 1.0)) : 1,
                child: Container(
                  width:widget.big ? 200 : 70,
                  height: widget.big ? 200 : 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.big ? 16 :0),
                    color: Color.fromARGB(255, 255, 51, 51),
                  ),
                ),
              ),
              const Spacer(),
              Opacity(
                opacity: offset < 0 ? (1 - offset.abs().clamp(0, 1.0)) : 1,
                child: Container(
                  width:widget.big ? 200 :70,
                  height:widget.big ? 200 : 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.big ? 16 : 0),
                    color: Color.fromARGB(255, 255, 51, 51),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                offset += details.primaryDelta! / maxSlide;
                offset = offset.clamp(-1.0, 1.0);
                if (offset.abs() > 0.85 && !navigated && timer == null) {
                  timer = Timer(const Duration(milliseconds: 300), () async {
                    if (!navigated) {
                      navigated = true;
                      await Navigator.of(context).push(_createRoute());
                      setState(() {
                        navigated = false;
                        offset = 0.0;
                      });
                    }
                  });
                }
                if (offset.abs() <= 0.85 && timer != null && !navigated) {
                  timer?.cancel();
                  timer = null;
                }
              });
            },
            onHorizontalDragEnd: (_) {
              setState(() => offset = 0.0);
              if (navigated) {
                timer?.cancel();
                timer = null;
              }
            },
            child: Transform(
              transform: Matrix4.translationValues(
                lerpNormalized(0, maxSlide, offset),
                0,
                0,
              ),
              child: Container(
                height: widget.big ? 200 : 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.big ? 16 : 0),
                  color: Color.fromARGB(255, 44, 43, 43),
                ),
              child: widget.big
                  ? Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Habit1",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 46,
                                  alignment: AlignmentGeometry.center,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(136, 227, 18, 18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Habit",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 280),
                            Container(
                              height: 46,
                              width: 46,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                              ),
                              child: Icon(
                                IconData(
                                  0xf815,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Sun',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Mon',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Tue',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Wed',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Thu',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Fri',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Sat',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 102, 101, 101),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 244, 67, 54),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "19",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 76, 175, 80),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "20",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 171, 171, 171),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "21",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 171, 171, 171),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "22",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 171, 171, 171),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "23",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 76, 175, 80),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "24",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 36,
                              height: 36,
                              alignment: AlignmentGeometry.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 37, 36, 36),
                                border: Border.all(
                                  color: Color.fromARGB(255, 255, 193, 7),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                              child: Text(
                                "25",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 247, 14, 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              color: Color.fromARGB(255, 225, 26, 66),
                              IconData(
                                0xf81e,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true,
                              ),
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "0",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              color: Color.fromARGB(255, 225, 26, 66),
                              IconData(
                                0xef47,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true,
                              ),
                              size: 24,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "50%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 190),
                            Icon(
                              color: Color.fromARGB(255, 225, 26, 66),
                              IconData(
                                0xf692,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true,
                              ),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Icon(
                              color: Color.fromARGB(255, 225, 26, 66),
                              IconData(
                                0xf01cb,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true,
                              ),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Icon(
                              color: Color.fromARGB(255, 225, 26, 66),
                              IconData(
                                0xf1ea,
                                fontFamily: 'MaterialIcons',
                                matchTextDirection: true,
                              ),
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    )
                  :  // or any other widget for the else case
              Container(
                height: 70,
                color: Color.fromARGB(255, 25, 24, 24),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      child: Icon(
                        IconData(
                          0xf815,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true,
                        ),
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Habit1",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 46,
                          alignment: AlignmentGeometry.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(136, 227, 18, 18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Habit",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 235),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 48, 48, 47),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
