import 'package:calculator/calculator_buttons.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _inputExpression = '';
  String _resultToShow = '';

  void _expressionResult() {
    String finalResult = _inputExpression;
    finalResult = finalResult.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalResult);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    _resultToShow = eval.toString();
  }

  bool _isOperator(String x) {
    if (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _inputExpression,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _resultToShow,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ],
          )),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: GridView.builder(
                  itemCount: Constants().buttonsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:
                          MediaQuery.of(context).size.width < 600 ? 1 : 4,
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CalculatorButtons(
                          onTap: () {
                            setState(() {
                              _inputExpression = '';
                              _resultToShow = '';
                            });
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                          text: Constants().buttonsList[index]);
                    } else if (index == 1) {
                      return CalculatorButtons(
                          onTap: () {
                            setState(() {
                              if (_inputExpression != '') {
                                _inputExpression = _inputExpression.substring(
                                    0, _inputExpression.length - 1);
                              }
                            });
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                          text: Constants().buttonsList[index]);
                    } else if (index == Constants().buttonsList.length - 1) {
                      return CalculatorButtons(
                          onTap: () {
                            setState(() {
                              _expressionResult();
                            });
                          },
                          color: Colors.amber.shade900,
                          textColor: Colors.white,
                          text: Constants().buttonsList[index]);
                    } else if (index == Constants().buttonsList.length - 2) {
                      return CalculatorButtons(
                          onTap: () {
                            setState(() {
                              _expressionResult();
                            });
                          },
                          color: Colors.deepPurple.shade50,
                          textColor: Colors.deepPurple,
                          text: Constants().buttonsList[index]);
                    } else {
                      return CalculatorButtons(
                          onTap: () {
                            setState(() {
                              _inputExpression +=
                                  Constants().buttonsList[index];
                            });
                          },
                          color: _isOperator(Constants().buttonsList[index])
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade50,
                          textColor: _isOperator(Constants().buttonsList[index])
                              ? Colors.white
                              : Colors.deepPurple,
                          text: Constants().buttonsList[index]);
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
