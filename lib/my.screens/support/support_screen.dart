import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forex_mountain/my.screens/support/create_support_ticiket.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/picture_utils.dart'; // This should contain your image provider

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              DrawerHeader(
                child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Iconsax.support, color: Colors.white),
                title: Text("Support", style: TextStyle(color: Colors.white)),
              ),
              // Add more drawer items here
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSupportTicket()),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(Iconsax.add),
        label: const Text("Open Ticket"),
      ),
      body: Stack(
        children: [
          // Background image using your image provider
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: userAppBgImageProvider(context), // <-- main body background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Glass card with status counts
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatusCount(label: "Open", count: "1", color: Colors.red),
                  _StatusCount(label: "In Progress", count: "0", color: Colors.green),
                  _StatusCount(label: "Answered", count: "0", color: Colors.blue),
                  _StatusCount(label: "On Hold", count: "0", color: Colors.orange),
                  _StatusCount(label: "Closed", count: "0", color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
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
