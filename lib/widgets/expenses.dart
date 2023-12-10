
import 'package:flutter/material.dart';

import '../model/expense.dart';
import 'chart/chart.dart';
import 'expenses_list/expenses_list.dart';
import 'new_expenses.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Course Flutter",
        amount: 19.5,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: "Cinema",
        amount: 11.5,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverly() {
    showModalBottomSheet(
      isScrollControlled: true, // حتى لا يعيق الكيبورد خانات  الادخال
      context: context,
      useSafeArea: true,//لا يجعل الواجهة تتداخل مع مكونات الجهاز
      builder: (ctx) => NewExpenses(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expanse) {
    setState(() {
      _registeredExpenses.add(expanse);
    });
  }

  void _removeExpense(Expense expense) {
    final indexExpense = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); //حتى لا يحدث مشكله عند مسح واسترجاع اخر حبه
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(indexExpense, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(contex) {
  final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverly,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:width < 500 ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent),
        ],
      ) : Row(children: [
        Expanded(child: Chart(expenses: _registeredExpenses)),
        Expanded(child: mainContent),
      ]),
    );
  }
}
