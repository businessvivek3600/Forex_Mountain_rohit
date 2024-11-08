import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/screens/drawerPages/step_counter/step_history_model.dart';
import 'package:forex_mountain/utils/color.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../providers/dashboard_provider.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';

Future<void> requestPermissions() async {
  var status = await Permission.activityRecognition.request();
  if (status.isGranted) {
    print("Activity recognition permission granted");
  } else {
    print("Activity recognition permission denied");
  }
}

class StepCounter extends StatefulWidget {
  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  Timer? _endOfDayTimer;
  bool _isPedometerAvailable = false;
  int _currentPage = 0;
  final int _perPage = 10;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startListening();
    scheduleEndOfDayApiCall();
    _fetchStepsHistory();

    // Add a listener to the scroll controller to load more data when reaching the bottom
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _endOfDayTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void scheduleEndOfDayApiCall() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day, 23, 59);
    Duration timeUntilEndOfDay = nextMidnight.difference(now);

    if (timeUntilEndOfDay.isNegative) {
      timeUntilEndOfDay = timeUntilEndOfDay + const Duration(days: 1);
    }

    _endOfDayTimer = Timer(timeUntilEndOfDay, () {
      uploadStepsToApi(context);
      scheduleEndOfDayApiCall();
    });
  }

  void startListening() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
      setState(() {
        _isPedometerAvailable = true;
      });
    } catch (e) {
      print('Pedometer not available: $e');
      setState(() {
        _isPedometerAvailable = false;
      });
    }
  }

  void onStepCount(StepCount event) {
    print('Steps detected: ${event.steps}');
    Provider.of<DashBoardProvider>(context, listen: false).setSteps(event.steps);
  }

  void onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void uploadStepsToApi(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    int steps = Provider.of<DashBoardProvider>(context, listen: false).steps;
    Map<String, dynamic> data = {
      "date": formattedDate,
      "count": steps.toString(),
    };
    print("postData: $data");
    Provider.of<DashBoardProvider>(context, listen: false).uploadSteps(data);
  }

  void _fetchStepsHistory() {
    if (_isLoadingMore) return;  // Prevent multiple simultaneous requests
    setState(() {
      _isLoadingMore = true;
    });

    Provider.of<DashBoardProvider>(context, listen: false).getStepsHistory({
      "perPage": _perPage.toString(),
      "page": _currentPage.toString(),
    }).then((_) {
      setState(() {
        _isLoadingMore = false;
        _currentPage++;
      });
    }).catchError((error) {
      print("Error fetching steps history: $error");
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchStepsHistory();  // Fetch more data when reaching the end of the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleLargeText('Step Counter', context, useGradient: true, letterSpacing: 2),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
              opacity: 1),
        ),
        child: Consumer<DashBoardProvider>(builder: (context, dashboardProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: 220,
                  child: Card(
                    elevation: 3,
                    color: Colors.white30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          titleLargeText('Today Steps', context, useGradient: true, letterSpacing: 1.5),
                          const SizedBox(height: 8),
                          Text(
                            _isPedometerAvailable ? dashboardProvider.steps.toString() : 'Pedometer not available',
                            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    titleLargeText('Steps History', context, useGradient: true, letterSpacing: 1.5),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,  // Add scroll controller
                    itemCount: dashboardProvider.stepHistory.length,
                    itemBuilder: (context, index) {
                      PadomerData stepData = dashboardProvider.stepHistory[index];
                      return Card(
                        color: Colors.white24,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(
                              "Date: ${stepData.date}",
                              style: const TextStyle(color: Colors.white),
                            ),
                           titleLargeText("Steps: ${stepData.count}", context,useGradient: true)

                          ],),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoadingMore) ...[
                  const Center(child: CircularProgressIndicator()),  // Show loading spinner when fetching more data
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

