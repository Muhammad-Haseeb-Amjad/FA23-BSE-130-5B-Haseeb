import 'package:bmi/constfile.dart';
import 'package:bmi/input.dart';
import 'package:flutter/material.dart';
import 'Containerfile.dart';
class Result extends StatelessWidget{
  Result({required this.interpretation,required this.bmiResult,required this.resultText});
  final String interpretation;
  final String bmiResult;
  final String resultText;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Expanded(
              child: Container(
                child: Center(
                  child: Text(
                      'Your Result',
                    style: titlestyle,
                  ),
                ),
              ),
          ),
            Expanded(
              flex: 5,
                child:repeatcontainer(
                  colors: activeColor,
                  cardWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(resultText),
                      Text(
                        bmiResult,
                        style: kNumberStyle,
                      ),
                      Text(
                        interpretation,
                        textAlign: TextAlign.center,
                        style: tstyle,
                      ),
                    ],
                  )
                ),
            ),
            Expanded(
              child: GestureDetector(

              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>MyHomePage(title: 'BMI Calculator')));
              },
              child: Container(
                child: Center(
                    child: Text(
                      'Calculate',
                      style: buttonstyle,
                    )),
                color: Color(0xFFEB1555),
                margin: EdgeInsets.only(top: 10.0),
                width: double.infinity,
                height: 80.0,
              ),
            ),
            ),

          ],
        ),
    );
  }
}