import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/color.dart';
import '../../utils/picture_utils.dart';
import '../../utils/text.dart';
import '../../widgets/glass_card.dart';
import 'component/my_bonus_screen.dart';
import 'component/payout_screen.dart';
import 'component/withdraw_request_history.dart';
import 'widget/glass_card_tile.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.element_4, color: Colors.amber),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: bodyLargeText('EARNING', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Lifetime Earnings card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lifetime Earnings',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '\$0.00',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Image.asset(
                            'assets/images/earning.png', // Replace with your image
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.amber),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {},
                                child: const Text('Fund/Request'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.amber),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {},
                                child: const Text('Withdraw'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GlassCardTile(
                    icon: Iconsax.wallet,
                    label: "Payout",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PayoutScreen(),
                        ),
                      );
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.money_send,
                    label: "Direct Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'Direct Bonus',
                            notePrefix: 'Direct Bonus',
                            entries: [
                              BonusEntry(
                                  date: '2025-05-09 15:34:30',
                                  amount: '0.50',
                                  note: 'FROM 100001'),
                              BonusEntry(
                                  date: '2025-05-09 15:34:15',
                                  amount: '0.50',
                                  note: 'FROM 100001'),
                              BonusEntry(
                                  date: '2025-04-28 19:00:45',
                                  amount: '33.33',
                                  note: 'FROM DASAPPA'),
                              // ... other Direct Bonus entries
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.crown,
                    label: "Rank Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'Rank Bonus',
                            notePrefix: 'Rank Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.bitcoin_card,
                    label: "FCT Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'FCT Bonus',
                            notePrefix: 'FCT Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.trend_up,
                    label: "MTP Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'MTP Bonus',
                            notePrefix: 'MTP Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.activity,
                    label: "SIP Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'SIP Bonus',
                            notePrefix: 'SIP Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.user_add,
                    label: "FCT Referral Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'FCT Referral Bonus',
                            notePrefix: 'FCT Referral Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.hierarchy,
                    label: "Level Bonus",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BonusScreen(
                            title: 'Level Bonus',
                            notePrefix: 'Level Bonus',
                            entries: List.generate(12, (index) {
                              return BonusEntry(
                                date:
                                    '2025-07-${(index + 1).toString().padLeft(2, '0')}',
                                amount: '${(index + 1) * 10}',
                                note: 'Level ${index + 1}',
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.receipt_2,
                    label: "Withdraw Request",
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawRequestScreen(
                       entries: [
                         WithdrawRequestEntry(
                           date: "2025-01-31",
                           requestId: "REQ001",
                           paymentType: "BANK",
                           fundAmount: "\$1540.00",
                           status: "Rejected",
                           userId: "SF000001",
                           name: "succesofinancial",
                           city: "Dubai",
                           country: "United Arab Emirates",
                           mobile: "+971501234567",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-02-05",
                           requestId: "REQ002",
                           paymentType: "BANK",
                           fundAmount: "\$1200.00",
                           status: "Paid",
                           userId: "SF000002",
                           name: "investzone",
                           city: "Abu Dhabi",
                           country: "United Arab Emirates",
                           mobile: "+971502345678",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-02-15",
                           requestId: "REQ003",
                           paymentType: "UPI",
                           fundAmount: "\$950.00",
                           status: "Rejected",
                           userId: "SF000003",
                           name: "wealthguru",
                           city: "Sharjah",
                           country: "United Arab Emirates",
                           mobile: "+971503456789",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-03-01",
                           requestId: "REQ004",
                           paymentType: "BANK",
                           fundAmount: "\$3000.00",
                           status: "Paid",
                           userId: "SF000004",
                           name: "protrade",
                           city: "Ajman",
                           country: "United Arab Emirates",
                           mobile: "+971504567890",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-03-10",
                           requestId: "REQ005",
                           paymentType: "UPI",
                           fundAmount: "\$750.00",
                           status: "Rejected",
                           userId: "SF000005",
                           name: "marketgenius",
                           city: "Fujairah",
                           country: "United Arab Emirates",
                           mobile: "+971505678901",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-03-18",
                           requestId: "REQ006",
                           paymentType: "BANK",
                           fundAmount: "\$2100.00",
                           status: "Paid",
                           userId: "SF000006",
                           name: "cryptoelite",
                           city: "Dubai",
                           country: "United Arab Emirates",
                           mobile: "+971506789012",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-03-28",
                           requestId: "REQ007",
                           paymentType: "BANK",
                           fundAmount: "\$1800.00",
                           status: "Rejected",
                           userId: "SF000007",
                           name: "fintrack",
                           city: "Ras Al Khaimah",
                           country: "United Arab Emirates",
                           mobile: "+971507890123",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-04-02",
                           requestId: "REQ008",
                           paymentType: "UPI",
                           fundAmount: "\$500.00",
                           status: "Paid",
                           userId: "SF000008",
                           name: "trademaster",
                           city: "Umm Al Quwain",
                           country: "United Arab Emirates",
                           mobile: "+971508901234",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-04-12",
                           requestId: "REQ009",
                           paymentType: "BANK",
                           fundAmount: "\$1650.00",
                           status: "Rejected",
                           userId: "SF000009",
                           name: "investpath",
                           city: "Dubai",
                           country: "United Arab Emirates",
                           mobile: "+971509012345",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-04-25",
                           requestId: "REQ010",
                           paymentType: "BANK",
                           fundAmount: "\$2300.00",
                           status: "Paid",
                           userId: "SF000010",
                           name: "finreach",
                           city: "Sharjah",
                           country: "United Arab Emirates",
                           mobile: "+971501112233",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-05-03",
                           requestId: "REQ011",
                           paymentType: "UPI",
                           fundAmount: "\$1340.00",
                           status: "Rejected",
                           userId: "SF000011",
                           name: "tradex",
                           city: "Dubai",
                           country: "United Arab Emirates",
                           mobile: "+971502223344",
                         ),
                         WithdrawRequestEntry(
                           date: "2025-05-11",
                           requestId: "REQ012",
                           paymentType: "BANK",
                           fundAmount: "\$2750.00",
                           status: "Paid",
                           userId: "SF000012",
                           name: "wealthcraft",
                           city: "Abu Dhabi",
                           country: "United Arab Emirates",
                           mobile: "+971503334455",
                         ),
                       ],

                     )

                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
