import 'package:flutter/material.dart';
import 'package:forex_mountain/my.screens/drawer/my.downline/tree_view.dart';

import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/glass_card.dart';

class MyGenerationTeamView extends StatefulWidget {
  const MyGenerationTeamView({super.key});

  @override
  State<MyGenerationTeamView> createState() => _MyGenerationTeamViewState();
}

class _MyGenerationTeamViewState extends State<MyGenerationTeamView> {

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
        ),
        body: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
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
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "🎯 Team Member",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "6",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Replaced with Row-based layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Direct Member",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "6",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Team Member",
                              style: TextStyle(color: Colors.white54),
                            ),
                            Text(
                              "5",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Direct Member",
                              style: TextStyle(color: Colors.white54),
                            ),
                            Text(
                              "6",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  // Refer By Card
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "🎯 Refer By",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "SF0000001",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Use Rows for clean layout
                        Row(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(color: Colors.white54),
                            ),
                            Text(
                              "succedofinancial(SF0000001)",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Active",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Self Volume Card
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Self Volume",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Team Volume",
                                style: TextStyle(color: Colors.white70)),
                            Text("\$ 51000",
                                style: TextStyle(color: Colors.amber)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Direct Volume",
                                style: TextStyle(color: Colors.white70)),
                            Text("\$ 51000",
                                style: TextStyle(color: Colors.amber)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Self Volume",
                                style: TextStyle(color: Colors.white70)),
                            Text("\$ 6143",
                                style: TextStyle(color: Colors.amber)),
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
                        MaterialPageRoute(builder: (_) => const TreeViewPage()),
                      );
                    },
                    child:  GlassCard(
                      padding: EdgeInsets.all(16),
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
                              childNodes: childNodes,
                              nodeWidth: 50, // adjust for compact size
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Tap to expand →",
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class MiniTreePreview extends StatelessWidget {
  final List<String> childNodes;
  final double nodeWidth;

  const MiniTreePreview({
    super.key,
    required this.childNodes,
    this.nodeWidth = 50, // compact width
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const NodeWidget(label: '100001', isMain: true),
        const SizedBox(height: 8),

        // Smaller connector height
        CustomPaint(
          size: Size(childNodes.length * nodeWidth, 40), // reduced height
          painter: ConnectorPainter(
            count: childNodes.length,
            nodeWidth: nodeWidth,
            lineHeight: 40, // pass shorter height
          ),
        ),

        const SizedBox(height: 8),

        // Child nodes with horizontal alignment
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(childNodes.length, (index) {
            return SizedBox(
              width: nodeWidth,
              child: Align(
                alignment: Alignment.topCenter,
                child: NodeWidget(label: childNodes[index]),
              ),
            );
          }),
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

