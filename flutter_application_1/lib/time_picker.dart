import 'package:flutter/material.dart';

class TimePickDialog extends StatefulWidget {
  final Function(int hours, int minutes, int seconds) onTimeSelected;
  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;

  const TimePickDialog({
    super.key, 
    required this.onTimeSelected,
    this.initialHours = 0,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
  });

  @override
  State<TimePickDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickDialog> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;

  late int selectedHours;
  late int selectedMinutes;
  late int selectedSeconds;

  @override
  void initState() {
    super.initState();
    selectedHours = widget.initialHours;
    selectedMinutes = widget.initialMinutes;
    selectedSeconds = widget.initialSeconds;
    
    _hoursController = FixedExtentScrollController(initialItem: widget.initialHours);
    _minutesController = FixedExtentScrollController(initialItem: widget.initialMinutes);
    _secondsController = FixedExtentScrollController(initialItem: widget.initialSeconds);
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _resetTime() {
    setState(() {
      selectedHours = 0;
      selectedMinutes = 0;
      selectedSeconds = 0;
      _hoursController.jumpToItem(0);
      _minutesController.jumpToItem(0);
      _secondsController.jumpToItem(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 31, 31, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Goal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
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
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 225, 26, 66),
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 225, 26, 66),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeColumn(
                      controller: _hoursController,
                      maxValue: 24,
                      onChanged: (value) {
                        setState(() {
                          selectedHours = value;
                        });
                      },
                    ),
                    
                    SizedBox(width: 20),
                    
                    _buildTimeColumn(
                      controller: _minutesController,
                      maxValue: 60,
                      onChanged: (value) {
                        setState(() {
                          selectedMinutes = value;
                        });
                      },
                    ),
                    
                    SizedBox(width: 20),
                    
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
            
            SizedBox(height: 16),
            
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
            
            SizedBox(height: 24),
            
            Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color.fromARGB(255, 70, 68, 68),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetTime,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color.fromARGB(255, 225, 26, 66),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: Color.fromARGB(255, 225, 26, 66),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onTimeSelected(
                        selectedHours,
                        selectedMinutes,
                        selectedSeconds,
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 225, 26, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
                      Color.fromARGB(255, 31, 31, 30),
                      Color.fromARGB(0, 31, 31, 30),
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
                      Color.fromARGB(255, 31, 31, 30),
                      Color.fromARGB(0, 31, 31, 30),
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

