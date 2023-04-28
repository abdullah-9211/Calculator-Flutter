import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({Key? key}) : super(key: key);

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 40.0;
  double resultFontSize = 50.0;

  buttonPress(String buttonTxt) {
    setState(() {
      if (buttonTxt == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 40.0;
        resultFontSize = 50.0;
      } else if (buttonTxt == "AC") {
        equation = equation.substring(0, equation.length - 1);
        equationFontSize = 50.0;
        resultFontSize = 40.0;
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonTxt == "=") {
        equationFontSize = 40.0;
        resultFontSize = 50.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 50.0;
        resultFontSize = 40.0;
        if (equation == "0") {
          equation = buttonTxt;
        } else {
          equation = equation + buttonTxt;
        }
      }
    });
  }

  Widget buildButton(String buttonTxt, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(16.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: const BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid)))),
        onPressed: () => buttonPress(buttonTxt),
        child: Text(
          buttonTxt,
          style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton("C", 1, Colors.black54),
                        buildButton("AC", 1, Colors.blueGrey),
                        buildButton("÷", 1, Colors.blueGrey),
                      ]),
                      TableRow(children: [
                        buildButton("7", 1, Colors.black26),
                        buildButton("8", 1, Colors.black26),
                        buildButton("9", 1, Colors.black26),
                      ]),
                      TableRow(children: [
                        buildButton("4", 1, Colors.black26),
                        buildButton("5", 1, Colors.black26),
                        buildButton("6", 1, Colors.black26),
                      ]),
                      TableRow(children: [
                        buildButton("1", 1, Colors.black26),
                        buildButton("2", 1, Colors.black26),
                        buildButton("3", 1, Colors.black26),
                      ]),
                      TableRow(children: [
                        buildButton(".", 1, Colors.black26),
                        buildButton("0", 1, Colors.black26),
                        buildButton("00", 1, Colors.black26),
                      ])
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("×", 1, Colors.blueGrey),
                    ]),
                    TableRow(children: [
                      buildButton("+", 1, Colors.blueGrey),
                    ]),
                    TableRow(children: [
                      buildButton("-", 1, Colors.blueGrey),
                    ]),
                    TableRow(children: [
                      buildButton("=", 2, Colors.black54),
                    ])
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
