import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/transparent_container.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timelines/timelines.dart';

import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/glass_card.dart';

class MyTeamViewScreen extends StatefulWidget {
  const MyTeamViewScreen({super.key});

  @override
  State<MyTeamViewScreen> createState() => _MyTeamViewScreenState();
}

class _MyTeamViewScreenState extends State<MyTeamViewScreen> {
  final List<Map<String, String>> users = [
    {
      "username": "100002",
      "name": "bina pariyar",
      "referrer": "100001",
      "email": "succeedomaster@gmail.com",
      "country": "Afghanistan",
      "doj": "2025-01-28 17:07:04",
      "status": "Active",
      "activeDate": "2025-01-28 20:09:40"
    },
    {
      "username": "Usman6",
      "name": "usman rana",
      "referrer": "100001",
      "email": "usmanrana9239@gmail.com",
      "country": "Afghanistan",
      "doj": "2025-01-28 22:32:23",
      "status": "Active",
      "activeDate": "2025-01-28 22:37:06"
    },
    {
      "username": "649493",
      "name": "mallappa sabanna",
      "referrer": "100001",
      "email": "bsmallikarjun414@gmail.com",
      "country": "Afghanistan",
      "doj": "2025-03-18 14:47:10",
      "status": "Active",
      "activeDate": "2025-03-18 14:55:33"
    },
    {
      "username": "Usmanpk",
      "name": "usman rana",
      "referrer": "100001",
      "email": "usmanranapk37@gmail.com",
      "country": "Afghanistan",
      "doj": "2025-01-28 22:28:00",
      "status": "Active",
      "activeDate": "2025-01-28 22:36:17"
    },
    {
      "username": "usmanpk14",
      "name": "usman rana",
      "referrer": "100001",
      "email": "succeedomarketsglobal@gmail.com",
      "country": "Afghanistan",
      "doj": "2025-02-01 16:38:14",
      "status": "Active",
      "activeDate": "2025-02-01 19:58:14"
    },
    {
      "username": "sayamma",
      "name": "SAYAMMA KISANAPPA BOYA",
      "referrer": "100001",
      "email": "bsmallikarjun414@gmail.com.com",
      "country": "Afghanistan",
      "doj": "2025-03-19 21:44:47",
      "status": "Active",
      "activeDate": "2025-05-06 12:14:22"
    }
  ];
  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy h:mm a").format(dateTime);
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: bodyLargeText('My Team', context, fontSize: 20),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isExpanded = expandedIndex == index;

                return TransparentContainer(
                  borderBlurRadius: 0.9,
                  borderWidth: 1.5,
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Username & Status
                      /// Username & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.amber,
                            child: Text(
                              user["username"] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.lightGreenAccent,
                              child: Text(
                                user["status"] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      Text(
                        user["name"]?.toUpperCase() ?? '',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user["email"] ?? '',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white54),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      /// Additional Details (shown only if expanded)
                      /// Expanded content with animation
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isExpanded
                            ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Divider(color: Colors.amber.shade800),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.group, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Ref ID: ${user["referrer"]}",
                                    style: const TextStyle(fontSize: 13, color: Colors.white54)),
                                const Spacer(),
                                const Icon(Icons.flag, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(user["country"] ?? '',
                                    style: const TextStyle(fontSize: 13, color: Colors.white54)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                const SizedBox(width: 6),
                                const Text("Joined:",
                                    style: TextStyle(fontSize: 13, color: Colors.white54)),
                                const SizedBox(width: 4),
                                Text(formatDate(user["doj"] ?? ''),
                                    style: const TextStyle(fontSize: 13, color: Colors.white54)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled, size: 16, color: Colors.green),
                                const SizedBox(width: 6),
                                const Text("Active on:",
                                    style: TextStyle(fontSize: 13, color: Colors.white54)),
                                const SizedBox(width: 4),
                                Text(formatDate(user["activeDate"] ?? ''),
                                    style: const TextStyle(fontSize: 13, color: Colors.white54)),
                              ],
                            ),
                          ],
                        )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
