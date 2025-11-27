import 'package:bmi/constfile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Icontextfile.dart';
import 'Containerfile.dart';
const activeColor = Color(0xFF1D1E33);
const deActiveColor = Color(0xFF111328);
enum Gender{
  male,
  female,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Gender selectGender=Gender.male;
  int sliderHeight=180;
  int sliderWeight=60;
  // Color maleColor = deActiveColor;
  // Color femaleColor = deActiveColor;
  //
  // void updateColor(Gender gendertype){
  //   if(gendertype==Gender.male){
  //     maleColor = activeColor;
  //     femaleColor = deActiveColor;
  //   }
  //   if(gendertype==Gender.female){
  //     femaleColor = activeColor;
  //     maleColor = deActiveColor;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Row(
                children: [
                  Expanded(
                      child:  repeatcontainer(
                        onPressed: (){
                          setState(() {
                            selectGender=Gender.male;
                          });
                        },
                        colors: selectGender==Gender.male? activeColor:deActiveColor ,
                        cardWidget: repeatIcon(
                          icondata: FontAwesomeIcons.male,
                          label: 'Male',
                        ),
                      ),

                  ),
                  Expanded(
                    child: repeatcontainer(
                      onPressed: (){
                        setState(() {
                          selectGender=Gender.female;
                        });
                      },
                      colors: selectGender==Gender.female? activeColor:deActiveColor,
                      cardWidget: repeatIcon(
                        icondata: FontAwesomeIcons.female,
                        label: 'Female',
                      ),
                    ),
                ),
                ],
              ),),
              Expanded(child:  repeatcontainer(
                  colors: Color(0xFF1D1E33),
                cardWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Height',style: KLabelStyle,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                        sliderHeight.toString(),
                        style: kNumberStyle,
                      ),
                      Text(
                        'cm',
                        style: KLabelStyle,
                      ),

                     ],
                    ),
                    Slider(
                        value:sliderHeight.toDouble(),
                        min: 120.0,
                        max: 220.0,
                        activeColor: Color(0xFFEB1555),
                        inactiveColor: Color(0xFF8D8E98),
                        onChanged: (double newValue){
                          setState(() {
                            sliderHeight=newValue.round();
                          });
                        }
                    ),
                  ],
                ),
              ),),
              Expanded(child: Row(
                children: [
                  Expanded(child: repeatcontainer(
                      colors: Color(0xFF1D1E33),
                    cardWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weight',
                          style: KLabelStyle,
                        ),
                        Text(
                          sliderWeight.toString(),
                          style: kNumberStyle,

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                          ],
                        ),
                      ],
                    ),
                  ),),
                  Expanded(child:  repeatcontainer(colors: Color(0xFF1D1E33)),),
                ],
              ),),
            ]
        )
    );
  }
}
