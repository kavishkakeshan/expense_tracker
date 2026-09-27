import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/expense_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

// Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Selected Category Filter State (Default: 'All')
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Selected Month State (Default: Current Year & Month)
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

// Stream all expenses for current user
final allExpensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final authUser = ref.watch(authStateProvider).value ??
      ref.watch(authServiceProvider).currentUser;

  if (authUser == null) {
    return Stream.value([]);
  }

  return firestoreService.getExpenses(userId: authUser.uid);
});

// Backward-compatible expenses stream
final expensesStreamProvider = allExpensesStreamProvider;

// Monthly Total Calculation Provider (scoped to selected month)
final monthlyTotalProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(allExpensesStreamProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) =>
        firestoreService.calculateMonthlyTotal(expenses, selectedMonth),
    orElse: () => 0.0,
  );
});

// Category-wise totals for Pie Chart (scoped to selected month)
final categoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final expensesAsync = ref.watch(allExpensesStreamProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) {
      final Map<String, double> totals = {};
      final monthExpenses = expenses.where((e) =>
          e.date.year == selectedMonth.year &&
          e.date.month == selectedMonth.month);

      for (var expense in monthExpenses) {
        totals[expense.category] =
            (totals[expense.category] ?? 0.0) + expense.amount;
      }
      return totals;
    },
    orElse: () => {},
  );
});

// Track Theme Mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Expenses Provider (Month + Category + Search query filtering for the list)
final filteredExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(allExpensesStreamProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();

  return expensesAsync.whenData((expenses) {
    // Filter by the selected month
    var result = expenses
        .where((e) =>
            e.date.year == selectedMonth.year &&
            e.date.month == selectedMonth.month)
        .toList();

    // Filter by category
    if (selectedCategory != 'All') {
      result = result.where((e) => e.category == selectedCategory).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      result = result
          .where((e) =>
              e.title.toLowerCase().contains(searchQuery) ||
              (e.note != null && e.note!.toLowerCase().contains(searchQuery)))
          .toList();
    }
    return result;
  });
});