import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_earning_model.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/color.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.provider/my_earning_provider.dart';
import '../../../widgets/glass_card.dart';

class BonusScreen extends StatefulWidget {
  final String title;
  final String notePrefix;

  const BonusScreen({
    super.key,
    required this.title,
    this.notePrefix = 'Bonus',
  });

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  late ScrollController _scrollController;
  late String _slug;

  @override
  void initState() {
    super.initState();

    _slug = getSlugFromTitle(widget.title);
    _scrollController = ScrollController()..addListener(_onScroll);

    // Delay provider logic until after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MyEarningProvider>(context, listen: false);
      provider.resetEarnings(_slug);
      provider.fetchEarningsData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      Provider.of<MyEarningProvider>(context, listen: false)
          .fetchEarningsData(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getSlugFromTitle(String title) {
    switch (title.toLowerCase()) {
      case 'direct bonus':
        return 'direct-bonus';
      case 'rank bonus':
        return 'rank-bonus';
      case 'fct bonus':
        return 'fct-bonus';
      case 'mtp bonus':
        return 'mtp-bonus';
      case 'sip bonus':
        return 'sip-bonus';
      case 'fct referral bonus':
        return 'fct-referral-bonus';
      case 'level bonus':
        return 'level-bonus';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: bodyLargeText(widget.title, context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<MyEarningProvider>(
                  builder: (context, earningProvider, _) {
                if (earningProvider.isFirstLoad) {
                  return buildShimmerCard();
                }

                if (earningProvider.errorMessage != null) {
                  return Center(
                      child: Text(earningProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red)));
                }

                final entries = earningProvider.earnings.map((e) {
                  return MyEarning(
                    id: e['id'] ?? '',
                    createdAt: e['created_at'] ?? '',
                    amount: e['amount'] ?? '',
                    note: e['note'] ?? '',
                  );
                }).toList();

                if (entries.isEmpty) {
                  return const Center(
                      child: Text("No data found",
                          style: TextStyle(color: Colors.white70)));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: entries.length + (earningProvider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < entries.length) {
                      return buildBonusCard(entries[index]);
                    } else if (earningProvider.isPaginating) {
                      return buildShimmerCard();
                    } else {
                      return const SizedBox.shrink(); // No more data
                    }
                  },
                );
              }),
            ),
          ),
        ));
  }

  Widget buildBonusCard(MyEarning entry) {
    return TransparentContainer(
      margin: const EdgeInsets.only(top: 16),
      borderWidth: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar, color: Colors.blue, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.createdAt,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  bodyLargeText(
                    '\$${double.tryParse(entry.amount)?.toStringAsFixed(2) ?? '0.00'}',
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Note Row
          Row(
            children: [
              const Icon(Iconsax.note_2, color: Colors.cyanAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.notePrefix} ${entry.note}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildShimmerCard() {
    return TransparentContainer(
      margin: const EdgeInsets.only(top: 16),
      borderWidth: 4,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Date and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 80, height: 12, color: Colors.white),
                  ],
                ),
                Container(width: 60, height: 12, color: Colors.white),
              ],
            ),
            const SizedBox(height: 12),

            // Note row
            Container(width: double.infinity, height: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
