import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

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
    final childNodes = [
      '100002',
      'Usmanpk',
      'Usman6',
      'usmanpk14',
      '649493',
      'Fatima22',
      'AliTech', 'Usman6',
      'usmanpk14',
      '649493',
      'Fatima22',
      'AliTech',
    ];

/// Width reserved for each node
    final screenWidth = MediaQuery.of(context).size.width;
    final double calculatedNodeWidth = (screenWidth - 40) / childNodes.length;
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
          boundaryMargin: EdgeInsets.all(30
             ),
          minScale: 0.1,
          maxScale: 5.6,
        child: Center(
          child: SizedBox(
            width: childNodes.length * nodeWidth,
            height: 250,
            child: Column(
              children: [
                const NodeWidget(label: '100001', isMain: true),
                const SizedBox(height: 10),

                // Connector (custom lines)
                CustomPaint(
                  size: Size(childNodes.length * nodeWidth, 60), // Less height
                  painter: ConnectorPainter(
                    count: childNodes.length,
                    nodeWidth: nodeWidth,
                  ),
                ),
                const SizedBox(height: 10),

                // Child nodes
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
      children: [
       /// Displays a fixed image for each node.
        Image.asset(
          'assets/images/green.png',
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
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
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double spacing = nodeWidth;
    final double top = 0;
    final double bottom = size.height;
    final double lineY = bottom / 3;

    // Vertical line from top (main node center) to horizontal connector
    canvas.drawLine(
      Offset(size.width / 2, top),
      Offset(size.width / 2, lineY),
      paint,
    );

    // ✨ Horizontal connector line: only from first to last node center
    final double startX = nodeWidth / 2;
    final double endX = size.width - nodeWidth / 2;
    canvas.drawLine(
      Offset(startX, lineY),
      Offset(endX, lineY),
      paint,
    );

    // Curved connector down to each child
    for (int i = 0; i < count; i++) {
      double x = spacing * i + spacing / 2;
      Path path = Path();
      path.moveTo(x, lineY);
      path.relativeCubicTo(0, 20, 0, 40, 0, 60);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
