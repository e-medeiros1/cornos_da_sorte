import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CORNOS DA SORTE',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CORNOS DA SORTE'),
          centerTitle: true,
        ),
        body: const BingoGrid(),
      ),
    );
  }
}

class BingoGrid extends StatefulWidget {
  const BingoGrid({super.key});

  @override
  _BingoGridState createState() => _BingoGridState();
}

class _BingoGridState extends State<BingoGrid> {
  List<bool> isSelected = List.generate(60, (index) => false);
  List<int> shuffledNumbers = [];
  int cardNumber = 0;

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  Future<void> loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedCardNumber = prefs.getInt('cardNumber') ??
        DateTime.now().millisecondsSinceEpoch % 1000;

    setState(() {
      cardNumber = storedCardNumber;
      shuffledNumbers = List.generate(60, (index) => index + 1)
        ..shuffle(Random(cardNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Card Number: $cardNumber'),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              final int number = shuffledNumbers[index];
              return GridTile(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected[index] = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: isSelected[index] ? Colors.grey : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
