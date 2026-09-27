import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/expense_model.dart';
import '../services/firestore_service.dart';

// Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Selected Category Filter State (Default: 'All')
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Expenses Stream Provider (Auto Refresh when filter changes)
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final currentUser = ref.watch(authServiceProvider).currentUser;

  
  if (currentUser == null) {
    return Stream.value([]);
  }

  return firestoreService.getExpenses(
    userId: currentUser.uid,
    category: selectedCategory,
  );
});

// Monthly Total Calculation Provider
final monthlyTotalProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) =>
        firestoreService.calculateMonthlyTotal(expenses, DateTime.now()),
    orElse: () => 0.0,
  );
});

// Category-wise totals group කරන Provider එක
final categoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) {
      final Map<String, double> totals = {};
      for (var expense in expenses) {
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

// Filtered Expenses Provider (Category + Search query filtering)
final filteredExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return expensesAsync.whenData((expenses) {
    if (searchQuery.isEmpty) return expenses;
    return expenses
        .where((e) =>
            e.title.toLowerCase().contains(searchQuery) ||
            (e.note != null && e.note!.toLowerCase().contains(searchQuery)))
        .toList();
  });
});