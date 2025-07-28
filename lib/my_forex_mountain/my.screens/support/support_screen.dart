import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forex_mountain/screens/drawerPages/support_pages/create_new_ticket.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../my.model/my_support_model.dart';
import '../../my.provider/my_dashboard_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/transparent_container.dart';
import 'create_support_ticiket.dart';

class MySupportScreen extends StatefulWidget {
  const MySupportScreen({super.key});

  @override
  State<MySupportScreen> createState() => _MySupportScreenState();
}

class _MySupportScreenState extends State<MySupportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<MyDashboardProvider>(context, listen: false);
      provider.getSupportData(context);
    });
  }

  void _openCreateTicket(BuildContext context) async {
    final provider = Provider.of<MyDashboardProvider>(context, listen: false);

    final hasOpenTicket = provider.ticketListResponse?.statusList?.any(
          (status) => (status.name?.toLowerCase() == 'open') && (status.total ?? 0) > 0,
    ) ?? false;

    if (hasOpenTicket) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already have an open ticket.")),
      );
      return;
    }

    final departments = provider.ticketListResponse?.departments ?? [];

   await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.redAccent.withOpacity(0.3),
      builder: (context) => CreateSupportTicket(departments: departments),
    );
  }



  String formatDate(String? rawDate) {
    if (rawDate == null) return '-';
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      return rawDate;
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
          iconTheme: IconThemeData(color: Colors.amber),
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
            child:
                Consumer<MyDashboardProvider>(builder: (context, provider, _) {
              final tickets = provider.ticketListResponse?.ticketList ?? [];
              if (provider.isLoadingSupport) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              return Column(
                children: [
                  // Glass card with status counts
                  GlassCard(
                    child: StatusCount(provider: provider),
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
                          final statusId = ticket.status;
                          final statusObj = provider
                              .ticketListResponse?.statusList
                              ?.firstWhere((s) => s.ticketStatusId == statusId,
                                  orElse: () => TicketStatus(
                                      name: 'Unknown', statusColor: '#cccccc'));

                          final Color statusColor = Color(int.parse(
                              'FF${statusObj!.statusColor?.replaceAll('#', '') ?? 'cccccc'}',
                              radix: 16));
                          final String statusName = statusObj.name ?? 'Unknown';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: Colors.white.withOpacity(0.05),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🔹 Subject
                                    Text(
                                      ticket.subject ?? 'No Subject',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // 🔹 Ticket ID + Department
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Ticket ID: ',
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '#${ticket.ticketId ?? ''}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Department: ',
                                              style: const TextStyle(
                                                  color: Colors.white70),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      ticket.department ?? '-',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // 🔹 Created + Last Reply
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Created: ',
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                              children: [
                                                TextSpan(
                                                  text: ticket.date != null ? formatDate(ticket.date!) : '-',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Last Reply: ',
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                              children: [
                                                TextSpan(
                                                  text: ticket.lastReply != null ? formatDate(ticket.lastReply!) : '-',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // 🔹 Status Badge
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Services: ',
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: ticket.service ?? '-',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border:
                                                Border.all(color: statusColor),
                                          ),
                                          child: Text(
                                            statusName,
                                            style: TextStyle(
                                                color: statusColor,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class StatusCount extends StatelessWidget {
  final MyDashboardProvider provider;

  const StatusCount({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final statusList = provider.ticketListResponse?.statusList ?? [];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statusList.map((status) {
        final colorHex = status.statusColor?.replaceAll('#', '') ?? '000000';
        final color = Color(int.parse('FF$colorHex', radix: 16));

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.total.toString(),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                status.name ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
