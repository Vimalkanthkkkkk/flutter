import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class TimerPage extends StatefulWidget {
  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;

  const TimerPage({
    super.key,
    this.initialHours = 0,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
  });

  @override
  State<TimerPage> createState() => Timepage();
}

class Timepage extends State<TimerPage> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;
  late int selectedHours;
  late int selectedMinutes;
  late int selectedSeconds;
  String timertype = "Stopwatch";
  List<String> options = ['All', 'Block', 'Vi'];
  String? selectedOption;
  final Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  String result = '00:00';
  bool isRunning = false;
  bool isPaused = false;
  Color ringColor = Color.fromARGB(255, 132, 25, 38);
  Timer? colorTimer;
  Duration remainingTime = Duration.zero;
  Duration totalTime = Duration.zero;
  String countdownResult = '00:00';
  bool show = false;
  String resulttime = '';
  String recentrecord = '';
  String selectedactivity = '';

  @override
  void initState() {
    super.initState();
    _hoursController = FixedExtentScrollController(
      initialItem: widget.initialHours,
    );
    _minutesController = FixedExtentScrollController(
      initialItem: widget.initialMinutes,
    );
    _secondsController = FixedExtentScrollController(
      initialItem: widget.initialSeconds,
    );

    selectedHours = widget.initialHours;
    selectedMinutes = widget.initialMinutes;
    selectedSeconds = widget.initialSeconds;
  }

  @override
  void dispose() {
    timer.cancel();
    colorTimer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void startCountdown() {
    totalTime = Duration(
      hours: selectedHours,
      minutes: selectedMinutes,
      seconds: selectedSeconds,
    );
    if (totalTime.inSeconds == 0) return;
    remainingTime = totalTime;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
          countdownResult = _formatDuration(remainingTime);
          resulttime = _formatDuration(
            Duration(seconds: totalTime.inSeconds - remainingTime.inSeconds),
          );
        });
      } else {
        _stopCountdown();
        showStopDialog();
      }
    });
    setState(() {
      isRunning = true;
      isPaused = false;
      countdownResult = _formatDuration(remainingTime);
      resulttime = '';
    });
    colorTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        ringColor = ringColor == Color.fromARGB(255, 132, 25, 38)
            ? Color.fromARGB(255, 202, 22, 43)
            : Color.fromARGB(255, 132, 25, 38);
      });
    });
  }

  void _pauseCountdown() {
    timer.cancel();
    colorTimer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void resumeCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
          countdownResult = _formatDuration(remainingTime);
          resulttime = _formatDuration(
            Duration(seconds: totalTime.inSeconds - remainingTime.inSeconds),
          );
        });
      } else {
        _stopCountdown();
        showStopDialog();
      }
    });
    setState(() {
      isRunning = true;
      isPaused = false;
    });
    colorTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        ringColor = ringColor == Color.fromARGB(255, 132, 25, 38)
            ? Color.fromARGB(255, 202, 22, 43)
            : Color.fromARGB(255, 132, 25, 38);
      });
    });
  }

  void _stopCountdown() {
    timer.cancel();
    colorTimer?.cancel();
    resetCountdown();
    setState(() {
      isRunning = false;
      isPaused = false;
      ringColor = Color.fromARGB(255, 132, 25, 38);
    });
  }

  void resetCountdown() {
    setState(() {
      remainingTime = Duration.zero;
      totalTime = Duration.zero;
      countdownResult = '00:00';
      selectedHours = 0;
      selectedMinutes = 0;
      selectedSeconds = 0;
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(255, 31, 31, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 64),
                SizedBox(height: 16),
                Text(
                  'Time\'s Up!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetCountdown();
                    setState(() {
                      show = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF3B30),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void start() {
    timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        result =
            '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    stopwatch.start();
    setState(() {
      isRunning = true;
      isPaused = false;
    });
    colorTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        ringColor = ringColor == Color.fromARGB(255, 132, 25, 38)
            ? Color.fromARGB(255, 202, 22, 43)
            : Color.fromARGB(255, 132, 25, 38);
      });
    });
  }

  void _stop() {
    timer.cancel();
    stopwatch.stop();
    colorTimer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void resume() {
    start();
  }

  void reset() {
    setState(() {
      resulttime = timertype == 'Stopwatch'
          ? result
          : timertype == 'Countdown'
          ? _formatDuration(
              Duration(seconds: totalTime.inSeconds - remainingTime.inSeconds),
            ).toString()
          : '';
    });
    timer.cancel();
    colorTimer?.cancel();
    stopwatch.stop();
    stopwatch.reset();
    setState(() {
      result = '00:00';
      isRunning = false;
      isPaused = false;
      ringColor = Color.fromARGB(255, 132, 25, 38);
    });
  }

  void showStopDialog() {
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
                  'Save a record?',
                  style: TextStyle(
                    color: Colors.white,
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
                //SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (timertype == "Stopwatch") {
                          Navigator.pop(context);
                          reset();
                        } else if (timertype == "Countdown") {
                          Navigator.pop(context);
                          resetCountdown();
                          setState(() {
                            show = false;
                          });
                        }
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
                        'NO',
                        style: TextStyle(
                          color: Color.fromARGB(255, 144, 144, 144),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (timertype == "Stopwatch") {
                          Navigator.pop(context);
                          reset();
                        } else if (timertype == "Countdown") {
                          Navigator.pop(context);
                          resetCountdown();
                          setState(() {
                            show = false;
                          });
                        }
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
                        'YES',
                        style: TextStyle(
                          color: Color(0xFFFF3B30),
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

  Widget buildStopwatchUI() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: 13),
            ),
            child: Center(
              child: Text(
                timertype == 'Stopwatch'
                    ? result
                    : timertype == 'Countdown'
                    ? countdownResult
                    : result,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 58),
          /*
          if (!isRunning && !isPaused) ...[
            ElevatedButton.icon(
              onPressed: start,
              icon: const Icon(
                IconData(
                  0xe09e,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true,
                ),
                size: 40,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 232, 31, 54),
                foregroundColor: Colors.white,
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              label: Text(
                'START',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ] else if (isRunning && !isPaused) ...[
            ElevatedButton.icon(
              icon: const Icon(
                IconData(
                  0xe09e,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true,
                ),
                size: 40,
              ),
              onPressed: _stop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 232, 31, 54),
                foregroundColor: Colors.white,
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              label: Text(
                'PAUSE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ] else if (isPaused) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    IconData(
                      0xe09e,
                      fontFamily: 'MaterialIcons',
                      matchTextDirection: true,
                    ),
                    size: 40,
                  ),
                  onPressed: resume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 232, 31, 54),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  label: Text(
                    'RESUME',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(
                    IconData(
                      0xf01dc,
                      fontFamily: 'MaterialIcons',
                      matchTextDirection: true,
                    ),
                    size: 34,
                  ),
                  onPressed: showStopDialog,
                  style: ElevatedButton.styleFrom(
                    iconColor: Color.fromARGB(255, 205, 33, 53),
                    backgroundColor: Color.fromARGB(255, 132, 25, 38),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.only(
                      right: 10,
                      top: 8,
                      bottom: 8,
                      left: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  label: Text(
                    'STOP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 11, 60),
                    ),
                  ),
                ),
              ],
            ),
          ],
          */
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: BoxBorder.fromLTRB(
          bottom: BorderSide(
            width: 0.21,
            color: const Color.fromARGB(255, 76, 75, 75),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 25, 24, 24),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              IconData(
                0xf63a,
                fontFamily: 'MaterialIcons',
                matchTextDirection: true,
              ),
              size: 30,
            ),
            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => HabitNow()),),
            color: Color.fromARGB(255, 225, 26, 66),
          ),
        ),
        title: Text(
          "Timer",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              IconData(0xe6a0, fontFamily: 'MaterialIcons'),
              size: 30,
            ),
            onPressed: () => {},
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          IconButton(
            icon: const Icon(
              IconData(0xf4a8, fontFamily: 'MaterialIcons'),
              size: 30,
            ),
            onPressed: () => {},
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 25, 24, 24),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            timertype == 'Countdown' && !show
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 44, 43, 43),
                                      width: 2,
                                    ),
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 44, 43, 43),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            transform: Matrix4.translationValues(-80, 0, 0),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color.fromARGB(255, 44, 43, 43),
                                  width: 2,
                                ),
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 44, 43, 43),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(80, 0, 0),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color.fromARGB(255, 44, 43, 43),
                                  width: 2,
                                ),
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 44, 43, 43),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTimeColumn(
                                controller: _hoursController,
                                maxValue: 13,
                                onChanged: (value) {
                                  setState(() {
                                    selectedHours = value;
                                  });
                                },
                              ),
                              Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              _buildTimeColumn(
                                controller: _minutesController,
                                maxValue: 60,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMinutes = value;
                                  });
                                },
                              ),
                              Text(
                                ":",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              _buildTimeColumn(
                                controller: _secondsController,
                                maxValue: 60,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSeconds = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              "Hours",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 60,
                            child: Text(
                              "Minutes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 60,
                            child: Text(
                              "Seconds",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 138),
                      /*
                      if (!isRunning && !isPaused) ...[
                        ElevatedButton.icon(
                          onPressed: start,
                          icon: const Icon(
                            IconData(
                              0xe09e,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 40,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 232, 31, 54),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          label: Text(
                            'START',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ] else if (isRunning && !isPaused) ...[
                        ElevatedButton.icon(
                          icon: const Icon(
                            IconData(
                              0xe09e,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 40,
                          ),
                          onPressed: _stop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 232, 31, 54),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          label: Text(
                            'PAUSE',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ] else if (isPaused) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                IconData(
                                  0xe09e,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                size: 40,
                              ),
                              onPressed: resume,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 232, 31, 54),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              label: Text(
                                'RESUME',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: const Icon(
                                IconData(
                                  0xf01dc,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                size: 34,
                              ),
                              onPressed: showStopDialog,
                              style: ElevatedButton.styleFrom(
                                iconColor: Color.fromARGB(255, 205, 33, 53),
                                backgroundColor: Color.fromARGB(255, 132, 25, 38),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(
                                  right: 10,
                                  top: 8,
                                  bottom: 8,
                                  left: 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              label: Text(
                                'STOP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 11, 60),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      */
                      //SizedBox(height: 188),
                    ],
                  )
                : timertype == 'Countdown' && show
                ? buildStopwatchUI()
                : SizedBox(),
            timertype == 'Stopwatch' ? buildStopwatchUI() : SizedBox(),
            timertype == 'intervals' ? buildStopwatchUI() : SizedBox(),
            SizedBox(height: 20),
            if (!isRunning && !isPaused) ...[
              ElevatedButton.icon(
                onPressed: () {
                  if (timertype == 'Stopwatch') {
                    start();
                  } else if (timertype == 'Countdown' &&
                      (selectedSeconds > 0 ||
                          selectedMinutes > 0 ||
                          selectedHours > 0)) {
                    startCountdown();
                    setState(() {
                      show = true;
                    });
                  }
                },
                icon: const Icon(
                  IconData(
                    0xe09e,
                    fontFamily: 'MaterialIcons',
                    matchTextDirection: true,
                  ),
                  size: 40,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 31, 54),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                label: Text(
                  'START',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else if (isRunning && !isPaused) ...[
              ElevatedButton.icon(
                icon: const Icon(
                  IconData(
                    0xe09e,
                    fontFamily: 'MaterialIcons',
                    matchTextDirection: true,
                  ),
                  size: 40,
                ),
                onPressed: () {
                  if (timertype == "Stopwatch") {
                    _stop();
                  } else if (timertype == "Countdown") {
                    _pauseCountdown();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 31, 54),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                label: Text(
                  'PAUSE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else if (isPaused) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      IconData(
                        0xe09e,
                        fontFamily: 'MaterialIcons',
                        matchTextDirection: true,
                      ),
                      size: 40,
                    ),
                    onPressed: () {
                      if (timertype == "Stopwatch") {
                        resume();
                      } else if (timertype == "Countdown") {
                        resumeCountdown();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 232, 31, 54),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    label: Text(
                      'RESUME',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(
                      IconData(
                        0xf01dc,
                        fontFamily: 'MaterialIcons',
                        matchTextDirection: true,
                      ),
                      size: 34,
                    ),
                    onPressed: () {
                      if (timertype == "Stopwatch") {
                        reset();
                        showStopDialog();
                        setState(() {
                          recentrecord = resulttime;
                        });
                      } else if (timertype == "Countdown") {
                        setState(() {
                          show = false;
                          recentrecord = resulttime;
                        });
                        _stopCountdown();
                        showStopDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Color.fromARGB(255, 205, 33, 53),
                      backgroundColor: Color.fromARGB(255, 132, 25, 38),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.only(
                        right: 10,
                        top: 8,
                        bottom: 8,
                        left: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    label: Text(
                      'STOP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 11, 60),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 80,
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<String>(
                    value: "Stopwatch",
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xf44a, fontFamily: 'MaterialIcons'),
                          size: 28,
                        ),
                        SizedBox(height: 6),
                        Text("Stopwatch", textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  ButtonSegment<String>(
                    value: "Countdown",
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xf800, fontFamily: 'MaterialIcons'),
                          size: 28,
                        ),
                        SizedBox(height: 6),
                        Text("Countdown", textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  ButtonSegment<String>(
                    value: "intervals",
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconData(0xf0235, fontFamily: 'MaterialIcons'),
                          size: 28,
                        ),
                        SizedBox(height: 6),
                        Text("intervals", textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
                selected: <String>{timertype},
                onSelectionChanged: (newSelection) {
                  if (show) {
                  } else {
                    setState(() {
                      timertype = newSelection.first;
                    });
                  }
                  // ignore: avoid_print
                  print(timertype);
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
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 348,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  border: Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    left: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    right: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 0.75,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: recentrecord != ''
                    ? habitcard(
                        containerbackground: Colors.green,
                        icon: IconData(
                          0xf44a,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true,
                        ),
                        title: "Last record",
                        subtitle: recentrecord,
                        isactivity: false,
                      )
                    : Text(
                        "No recent records",
                        style: TextStyle(
                          color: Color.fromARGB(255, 167, 162, 162),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromARGB(255, 31, 30, 30),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                IconData(
                                  0xf63a,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                size: 30,
                              ),
                              onPressed: () {},
                              color: Color.fromARGB(255, 225, 26, 66),
                            ),
                            SizedBox(width: 100),
                            RichText(
                              text: TextSpan(
                                text: 'Today\n',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'Select an activity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 128, 125, 125),
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 80),
                            IconButton(
                              icon: Icon(
                                IconData(
                                  0xf579,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                size: 19,
                              ),
                              onPressed: () {},
                              color: Color.fromARGB(112, 255, 17, 64),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        StatefulBuilder(
                          builder:
                              (
                                BuildContext context,
                                StateSetter setModalState,
                              ) {
                                return Wrap(
                                  spacing: 8,
                                  children: options.map((option) {
                                    final isSelected = selectedOption == option;
                                    return ChoiceChip(
                                      showCheckmark: false,
                                      side: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadiusGeometry.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      chipAnimationStyle: ChipAnimationStyle(
                                        enableAnimation: AnimationStyle(),
                                      ),
                                      visualDensity: VisualDensity(
                                        horizontal: 0,
                                        vertical: 0,
                                      ),
                                      disabledColor: Color.fromARGB(
                                        255,
                                        141,
                                        138,
                                        138,
                                      ),
                                      label: Text(
                                        option,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Color.fromARGB(255, 225, 26, 66)
                                              : Color.fromARGB(
                                                  255,
                                                  141,
                                                  138,
                                                  138,
                                                ),
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor: const Color.fromARGB(
                                        255,
                                        110,
                                        28,
                                        42,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        44,
                                        39,
                                        39,
                                      ),
                                      onSelected: (selected) {
                                        setModalState(() {
                                          selectedOption = selected
                                              ? option
                                              : null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                        ),
                        SizedBox(height: 8),
                        Divider(
                          height: 0.40,
                          thickness: 1,
                          color: Color.fromARGB(255, 67, 67, 67),
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
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 6, 157, 84),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  IconData(0xf02f, fontFamily: 'MaterialIcons'),
                                  size: 28,
                                  color: Color.fromARGB(224, 247, 22, 67),
                                ),
                              ),
                              SizedBox(width: 13),
                              Text(
                                "End",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 280),
                            ],
                          ),
                          label: SizedBox(),
                          iconAlignment: IconAlignment.start,
                        ),
                        Divider(
                          height: 0.40,
                          thickness: 1,
                          color: Color.fromARGB(255, 67, 67, 67),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 348,
                height: 60,
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  border: Border(
                    left: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    right: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 1.5,
                    ),
                    top: BorderSide(
                      color: Color.fromARGB(255, 71, 70, 70),
                      width: 0.75,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: selectedactivity != ''
                    ? habitcard(
                        title: "Vimal",
                        icon: IconData(
                          0xf645,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true,
                        ),
                        subtitle: "12/5/25",
                        containerbackground: Colors.green,
                        isactivity: true,
                      )
                    : Text(
                        "No activity selected",
                        style: TextStyle(
                          color: Color.fromARGB(255, 167, 162, 162),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget habitcard({
    required Color containerbackground,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isactivity,
  }) {
    return Container(
      height: 60,
      width: 348,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Container(
            height: isactivity ? 36 : 32,
            width: isactivity ? 36 : 32,
            decoration: BoxDecoration(
              color: isactivity
                  ? containerbackground
                  : const Color.fromARGB(255, 71, 71, 70),
              borderRadius: BorderRadius.all(
                Radius.circular(isactivity ? 16 : 12),
              ),
            ),
            child: Icon(
              icon,
              size: isactivity ? 30 : 20,
              color: isactivity
                  ? Colors.black
                  : const Color.fromARGB(255, 162, 162, 162),
            ),
          ),
          SizedBox(width: 10),
          RichText(
            text: TextSpan(
              text: '$title\n',
              style: TextStyle(
                color: isactivity
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(255, 128, 125, 125),
                fontSize: isactivity ? 16 : 14,
                fontWeight: FontWeight.w900,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isactivity
                        ? Color.fromARGB(255, 128, 125, 125)
                        : Color.fromARGB(255, 255, 255, 255),
                    fontSize: isactivity ? 14 : 16,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
          Expanded(child: SizedBox()),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((
                Set<WidgetState> callback,
              ) {
                return const Color.fromARGB(255, 56, 57, 57);
              }),
            ),
            icon: const Icon(IconData(0xf645, fontFamily: 'MaterialIcons')),
            onPressed: () {
              if (timertype == 'Stopwatch') {
                setState(() {
                  recentrecord = '';
                });
              } else if (timertype == 'Countdown') {
                setState(() {
                  recentrecord = '';
                });
              }
            },
            color: Color.fromARGB(255, 115, 109, 111),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTimeColumn({
    required FixedExtentScrollController controller,
    required int maxValue,
    required Function(int) onChanged,
  }) {
    return SizedBox(
      width: 60,
      height: 150,
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            physics: FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            perspective: 0.003,
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= maxValue) return null;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              childCount: maxValue,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 21, 21, 21),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 23, 23, 23),
                      Color.fromARGB(0, 10, 10, 10),
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

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.entries,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final int entries;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 90,
      margin: EdgeInsets.only(right: 0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 44, 42, 42),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(0, 67, 67, 67), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 40,
              color: const Color.fromARGB(255, 34, 32, 32),
            ),
          ),
          SizedBox(height: 6),
          // Title
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          // Entries count
          Text(
            '$entries entries',
            style: TextStyle(
              color: const Color.fromARGB(255, 144, 144, 144),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
