import 'package:bmi/constfile.dart';
import 'package:bmi/input.dart';
import 'package:flutter/material.dart';
import 'Containerfile.dart';
class Result extends StatelessWidget{
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
                      Text('Normal'),
                      Text(
                          '18.3',
                        style: kNumberStyle,
                      ),
                      Text(
                        'BMI is Low You Should have More Work',
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
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Result()));
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