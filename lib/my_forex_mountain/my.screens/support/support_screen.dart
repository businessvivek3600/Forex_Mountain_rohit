import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forex_mountain/screens/drawerPages/support_pages/create_new_ticket.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timelines/timelines.dart';

import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../widgets/transparent_container.dart';
import 'create_support_ticiket.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<Map<String, String>> tickets = [];

  void _openCreateTicket(BuildContext context) async {
    final newTicket = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => const CreateSupportTicket(),
    );

    if (newTicket != null) {
      setState(() {
        tickets.insert(0, newTicket);
      });
    }
  }

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
          onPressed: () => _openCreateTicket(context),
          backgroundColor: const Color(0xe7ecb730),
          icon: const Icon(Iconsax.add),
          label: const Text("Open Ticket"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                // Glass card with status counts
                const GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatusCount(label: "Open", count: "1", color: Colors.red),
                      _StatusCount(label: "In Progress", count: "0", color: Colors.green),
                      _StatusCount(label: "Answered", count: "0", color: Colors.blue),
                      _StatusCount(label: "On Hold", count: "0", color: Colors.orange),
                      _StatusCount(label: "Closed", count: "0", color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Ticket list (optional preview of created tickets)
                if (tickets.isEmpty)
                  const Text(
                    "No tickets yet.",
                    style: TextStyle(color: Colors.white70),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: TransparentContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Subject - full width
                                Text(
                                  ticket['subject'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 11),

                                // Row 1: Ticket ID & Priority
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text('Ticket ID: ', style: TextStyle(color: Colors.white70)),
                                          Text('#${ticket['id'] ?? ''}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Text('Priority: ', style: TextStyle(color: Colors.white70)),
                                          Text('${ticket['priority'] ?? ''}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Row 2: Department & Status
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Text('Department: ', style: TextStyle(color: Colors.white70)),
                                          Text('${ticket['department'] ?? ''}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Text('Status: ', style: TextStyle(color: Colors.white70)),
                                          Text('${ticket['status'] ?? 'Closed'}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Row 3: Last Reply (full width)
                                Row(
                                  children: [
                                    const Text('Last Reply: ', style: TextStyle(color: Colors.white70)),
                                    Expanded(
                                      child: Text(
                                        '${ticket['lastReply'] ?? ''}',
                                        style: const TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )




              ],
            ),
          ),
        ),
      ),
    );
  }
}

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