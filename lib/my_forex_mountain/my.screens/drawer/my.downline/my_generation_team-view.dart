import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../my.model/my_generation_model.dart';
import '../../../my.provider/my_mlm_provider.dart';
import '../my.downline/tree_view.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../widgets/glass_card.dart';

class MyGenerationTeamView extends StatefulWidget {
  const MyGenerationTeamView({super.key});

  @override
  State<MyGenerationTeamView> createState() => _MyGenerationTeamViewState();
}

class _MyGenerationTeamViewState extends State<MyGenerationTeamView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyMlmProvider>(context, listen: false)
          .fetchGenerationData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> childNodes = ["100002", "100003", "100004", "100005"];

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
          title:
              bodyLargeText('My Generation Tree View', context, fontSize: 20),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SingleChildScrollView(
              child: Consumer<MyMlmProvider>(builder: (_, provider, __) {
                final clientData = provider.generationData?.data!.client;
                final customerChild = provider.generationData?.data!.customerChild;
                if (provider.isLoadingGeneration) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Section
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Search Customer",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Customer username",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    hintStyle: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Submit"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Name :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Team Member Card
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "🎯 Team Member",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                clientData!.totalMember ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Replaced with Row-based layout
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Direct Member",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                clientData.directMember ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Active Team Member",
                                style: TextStyle(color: Colors.white54),
                              ),
                              Text(
                                clientData.activeTotalMember ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Active Direct Member",
                                style: TextStyle(color: Colors.white54),
                              ),
                              Text(
                                clientData.activeDirectMember ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Refer By Card
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "🎯 Refer By",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                clientData.directSponserUsername ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Use Rows for clean layout
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Refer By",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "succedofinancial",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                clientData.salesActive == "1"
                                    ? "Active"
                                    : ("Inactive" ?? ""),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Self Volume Card
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Self Volume",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Team Volume",
                                  style: TextStyle(color: Colors.white70)),
                              Text("\$ ${clientData.teamSale!}",
                                  style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Direct Volume",
                                  style: TextStyle(color: Colors.white70)),
                              Text("\$ ${clientData.directSale}",
                                  style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Self Volume",
                                  style: TextStyle(color: Colors.white70)),
                              Text("\$ ${clientData.selfSale!}",
                                  style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TreeViewPage()),
                        );
                      },
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Team Tree",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: MiniTreePreview(
                                childNodes: customerChild ?? [],
                                nodeWidth: 50,
                                onNodeTap: (String tappedUsername) {
                                  Provider.of<MyMlmProvider>(context, listen: false)
                                      .fetchGenerationData(context, customerId: tappedUsername);
                                },
                              ),

                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Tap to expand →",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class MiniTreePreview extends StatelessWidget {
  final List<CustomerChild> childNodes;
  final double nodeWidth;
  final Function(String username)? onNodeTap;

  const MiniTreePreview({
    super.key,
    required this.childNodes,
    this.nodeWidth = 50,
    this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const NodeWidget(label: '100001', isMain: true),
        const SizedBox(height: 8),
        CustomPaint(
          size: Size(childNodes.length * nodeWidth, 40),
          painter: ConnectorPainter(
            count: childNodes.length,
            nodeWidth: nodeWidth,
            lineHeight: 40,
          ),
        ),
        const SizedBox(height: 8),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(childNodes.length, (index) {
              final customer = childNodes[index];
              return GestureDetector(
                onTap: () {
                  if (onNodeTap != null) {
                    onNodeTap!(customer.customerId ?? '');
                  }
                },
                child: SizedBox(
                  width: nodeWidth,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: NodeWidget(label: customer.username!),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}


class ConnectorPainter extends CustomPainter {
  final int count;
  final double nodeWidth;
  final double lineHeight; // ✅ NEW PARAMETER

  ConnectorPainter({
    required this.count,
    required this.nodeWidth,
    this.lineHeight = 60, // ✅ Default value if not passed
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double spacing = nodeWidth;
    final double top = 0;
    final double bottom = lineHeight;
    final double lineY = bottom / 3;

    // Vertical line from main node
    canvas.drawLine(
      Offset(size.width / 2, top),
      Offset(size.width / 2, lineY),
      paint,
    );

    // Horizontal connector line
    final double startX = nodeWidth / 2;
    final double endX = size.width - nodeWidth / 2;
    canvas.drawLine(
      Offset(startX, lineY),
      Offset(endX, lineY),
      paint,
    );

    // Curve to each child node
    for (int i = 0; i < count; i++) {
      double x = spacing * i + spacing / 2;
      Path path = Path();
      path.moveTo(x, lineY);
      path.relativeCubicTo(0, 10, 0, 20, 0, bottom - lineY); // smoother curve
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
