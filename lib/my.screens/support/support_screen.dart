import 'package:flutter/material.dart';
import 'package:forex_mountain/my.screens/support/support_ticket.dart';
import 'package:iconsax/iconsax.dart';
import 'package:forex_mountain/screens/drawerPages/support_pages/create_new_ticket.dart';
import 'package:forex_mountain/utils/picture_utils.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(Iconsax.add),
        label: const Text('Open Ticket'),
        onPressed: () {
          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   backgroundColor: Colors.transparent,
          //   builder: (_) => createsupp(),
          // );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Support',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusCount("1", "Open", Colors.red),
                      _buildStatusCount("0", "In Progress", Colors.green),
                      _buildStatusCount("0", "Answered", Colors.blue),
                      _buildStatusCount("0", "On Hold", Colors.orange),
                      _buildStatusCount("0", "Closed", Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // You can add a ticket list or content below this
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCount(String count, String label, Color color) {
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
