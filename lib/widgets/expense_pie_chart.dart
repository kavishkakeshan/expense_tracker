import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';

class ExpensePieChart extends ConsumerWidget {
  const ExpensePieChart({super.key});

  // Category Colors 
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orangeAccent;
      case 'Transport':
        return Colors.blueAccent;
      case 'Bills':
        return Colors.redAccent;
      case 'Entertainment':
        return Colors.purpleAccent;
      case 'Health':
        return Colors.green;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryTotals = ref.watch(categoryTotalsProvider);

    if (categoryTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalAmount = categoryTotals.values.fold(0.0, (sum, val) => sum + val);
    if (totalAmount <= 0) {
      return const SizedBox.shrink();
    }

    // fl_chart Sections
    final sections = categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalAmount) * 100;
      return PieChartSectionData(
        value: entry.value,
        color: _getCategoryColor(entry.key),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: categoryTotals.keys.map((cat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(cat),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(cat, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}