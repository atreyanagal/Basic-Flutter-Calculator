import 'package:flutter/material.dart';
import 'button_values.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(60),
                    color: const Color(0x80000000),
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ? ""
                          : "$number1$operand$number2",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.sqrt) {
      squareRoot();
      return;
    }

    if (value == Btn.fact) {
      factorial();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    if (value == Btn.pi) {
      piFunc(value);
      return;
    }

    appendValue(value);
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    double num1 = double.parse(number1.replaceAll('(', '').replaceAll(')', ''));
    double num2 = double.parse(number2.replaceAll('(', '').replaceAll(')', ''));

    num result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;

      case Btn.subtract:
        result = num1 - num2;
        break;

      case Btn.multiply:
        result = num1 * num2;
        break;

      case Btn.divide:
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: const Text("Cannot divide by zero"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return;
        }
        break;

      case Btn.pow:
        result = pow(num1, num2);
        break;

      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(4);

      if (number1.endsWith(".00")) {
        number1 = number1.substring(0, number1.length - 3);
      }

      if (number1.endsWith(".000")) {
        number1 = number1.substring(0, number1.length - 4);
      }

      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);

    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void squareRoot() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    final result = sqrt(number);

    setState(() {
      if (result % 1 == 0) {
        number1 = result.toInt().toString();
      } else {
        number1 = result.toStringAsFixed(6);
      }

      operand = "";
      number2 = "";
    });
  }

  void factorial() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = int.tryParse(number1);

    if (number == null || number < 0) {
      return;
    }

    int result = 1;
    for (int i = 2; i <= number; i++) {
      result *= i;
    }

    setState(() {
      number1 = "$result";
      operand = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void piFunc(value) {
    setState(() {
      if (value == Btn.pi) {
        if (operand.isEmpty) {
          number1 += pi.toString();
        } else {
          number2 += pi.toString();
        }
      }
    });
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      if (value == Btn.subtract &&
          number1.isEmpty &&
          !number1.endsWith("-") &&
          operand.isEmpty) {
        number1 += value;
        setState(() {});
        return;
      }

      if (value == Btn.subtract && number1.isNotEmpty && operand.isNotEmpty) {
        if (number2.isEmpty) {
          number2 = '(-';
          setState(() {});
          return;
        } else {
          number2 += value;
          setState(() {});
          return;
        }
      }

      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }

      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;

      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }

      if (number2.endsWith(')')) {
        number2 = number2.substring(0, number2.length - 1);
      }

      if (number2.contains('(')) {
        number2 += value;
        if (value != Btn.subtract && number2 != '(-') {
          number2 += ')';
        }
      } else {
        number2 += value;
      }

      setState(() {});
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr, Btn.sqrt, Btn.pi, Btn.fact, Btn.pow]
            .contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : const Color(0x99000000);
  }
}
