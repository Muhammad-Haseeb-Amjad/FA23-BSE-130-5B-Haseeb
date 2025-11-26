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
  Color maleColor = deActiveColor;
  Color femaleColor = deActiveColor;

  void updateColor(Gender gendertype){
    if(gendertype==Gender.male){
      maleColor = activeColor;
      femaleColor = deActiveColor;
    }
    if(gendertype==Gender.female){
      femaleColor = activeColor;
      maleColor = deActiveColor;
    }
  }

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
            children: [
              Expanded(child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          updateColor(Gender.male);
                        });
                      },
                      child:  repeatcontainer(
                        colors: maleColor,
                        cardWidget: repeatIcon(
                          icondata: FontAwesomeIcons.male,
                          label: 'Male',
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      setState(() {
                        updateColor(Gender.female);
                      });
                    },
                    child: repeatcontainer(
                      colors: femaleColor,
                      cardWidget: repeatIcon(
                        icondata: FontAwesomeIcons.female,
                        label: 'Female',
                      ),
                    ),
                  ),),
                ],
              ),),
              Expanded(child:  repeatcontainer(colors: Color(0xFF1D1E33)),),
              Expanded(child: Row(
                children: [
                  Expanded(child: repeatcontainer(colors: Color(0xFF1D1E33)),),
                  Expanded(child:  repeatcontainer(colors: Color(0xFF1D1E33)),),
                ],
              ),),
            ]
        )
    );
  }
}
