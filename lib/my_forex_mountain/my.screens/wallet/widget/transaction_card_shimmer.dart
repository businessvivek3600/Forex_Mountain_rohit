import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/transparent_container.dart';

Widget buildShimmerTransactionCard() {
  return TransparentContainer(
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date and Balance placeholders
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 100, height: 14, color: Colors.white),
              Container(width: 60, height: 14, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          // Note placeholder
          Row(
            children: [
              Container(width: 24, height: 24, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Container(height: 16, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 18),
          // Credit and Debit placeholders
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 80, height: 14, color: Colors.white),
              Container(width: 80, height: 14, color: Colors.white),
            ],
          ),
        ],
      ),
    ),
  );
}
