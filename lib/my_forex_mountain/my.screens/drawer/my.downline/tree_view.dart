import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.model/my_generation_model.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key, required this.childNodes, required this.username});
  final List<CustomerChild> childNodes;
  final String username;
  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  @override
  void initState() {
    super.initState();
    // Lock to landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

/// Width reserved for each node
    final screenWidth = MediaQuery.of(context).size.width;
    final double calculatedNodeWidth = (screenWidth - 40) / widget.childNodes.length;
    final double nodeWidth = calculatedNodeWidth < 60 ? 60 : calculatedNodeWidth;

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
          title: bodyLargeText('My Generation Tree View', context, fontSize: 20),
          elevation: 0,
        ),
        body: SafeArea(
        child: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
          boundaryMargin: const EdgeInsets.all(30
             ),
          minScale: 0.1,
          maxScale: 5.6,
        child: Center(
          child: SizedBox(
            width: widget.childNodes.length * nodeWidth,
            height: 250,
            child: Column(
              children: [
              NodeWidget(label: widget.username, isMain: true),
                const SizedBox(height: 10),

                // Connector (custom lines)
                CustomPaint(
                  size: Size( widget.childNodes.length * nodeWidth, 60), // Less height
                  painter: ConnectorPainter(
                    count:  widget.childNodes.length,
                    nodeWidth: nodeWidth,
                  ),
                ),
                const SizedBox(height: 10),

                // Child nodes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.childNodes.map((child) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: NodeWidget(label: child.username ?? ""),
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          ),
        ),
      ),
      ),

      ),
    );
  }
}
///Displays a node with an image and a text label.
class NodeWidget extends StatelessWidget {
  final String label;
  final bool isMain;

  const NodeWidget({super.key, required this.label, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/green.png',
          width: isMain ? 50 : 30,
          height: isMain ? 50 : 30,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMain ? 14 : 10,
            color: Colors.white,
            fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}


class ConnectorPainter extends CustomPainter {
  final int count;
  final double nodeWidth;

  ConnectorPainter({required this.count, required this.nodeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double spacing = size.width / count; // Dynamically space based on actual width
    final double top = 0;
    final double bottom = size.height;
    final double lineY = bottom / 3;

    // 🔶 Line from top (main node) to horizontal center line
    canvas.drawLine(
      Offset(size.width / 2, top),
      Offset(size.width / 2, lineY),
      paint,
    );

    // 🔶 Horizontal line across all child nodes
    canvas.drawLine(
      Offset(spacing / 2, lineY),
      Offset(size.width - spacing / 2, lineY),
      paint,
    );

    // 🔶 Connector from horizontal line to each child node center
    for (int i = 0; i < count; i++) {
      final double x = spacing * i + spacing / 2;

      final path = Path();
      path.moveTo(x, lineY);
      path.relativeCubicTo(0, 10, 0, 30, 0, 60); // smoother curve down
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectorPainter oldDelegate) => true;
}

