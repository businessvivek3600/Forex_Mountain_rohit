import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.provider/my_mlm_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/transparent_container.dart';

class DirectMemberScreen extends StatefulWidget {
  const DirectMemberScreen({super.key});

  @override
  State<DirectMemberScreen> createState() => _DirectMemberScreenState();
}

class _DirectMemberScreenState extends State<DirectMemberScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyMlmProvider>(context, listen: false)
          .fetchDirectMemberData(context);
    });
  }


  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyMlmProvider>(context);

    final members = provider.directMembers;

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
              title: bodyLargeText('Direct Member', context, fontSize: 20),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.amber),
            ),
            body:SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: provider.isLoading
                    ? ListView.builder(
                  itemCount: 5,
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                )
                    : members.isEmpty
                    ? const Center(
                  child: Text(
                    "No record found",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                    :  ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final user = members[index];
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.username?.toUpperCase() ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),

                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (user.salesActive == "1") ? Colors.green.shade600 : Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  (user.salesActive == "1") ? 'Active' : 'Not Active',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),
                          Text(
                            '${user.customerName}' ?? '',
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
                                  user.customerEmail ?? '',
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
                                    Text("Ref ID: ${user.directSponserUsername}",
                                        style: const TextStyle(fontSize: 13, color: Colors.white54)),
                                    const Spacer(),
                                    const Icon(Icons.flag, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(user.countryText ?? '',
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
                                    Text(formatDate(user.createdAt ?? ''),
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
                                    Text(formatDate(user.salesActiveDate ?? ''),
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
            ),));
  }
}
