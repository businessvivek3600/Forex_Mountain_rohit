import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forex_mountain/my.screens/support/create_support_ticiket.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/picture_utils.dart';
import '../../utils/text.dart'; // This should contain your image provider

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
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
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: bodyLargeText('Support', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateSupportTicket()),
            );
          },
          backgroundColor: Colors.lightBlueAccent,
          icon: const Icon(Iconsax.add),
          label: const Text("Open Ticket"),
        ),
        body: const SafeArea(
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                // Glass card with status counts
                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatusCount(label: "Open", count: "1", color: Colors.red),
                      _StatusCount(
                          label: "In Progress", count: "0", color: Colors.green),
                      _StatusCount(
                          label: "Answered", count: "0", color: Colors.blue),
                      _StatusCount(
                          label: "On Hold", count: "0", color: Colors.orange),
                      _StatusCount(label: "Closed", count: "0", color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable widget for status items
class _StatusCount extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatusCount({
    Key? key,
    required this.count,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// Glassmorphic card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double radius;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.08,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: child,
        ),
      ),
    );
  }
}
