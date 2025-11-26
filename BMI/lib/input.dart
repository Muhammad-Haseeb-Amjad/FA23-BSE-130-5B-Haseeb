import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
          children: [
      Expanded(child: Row(
      children: [
          Expanded(
            child: new repeatcontainer(
                colors: Color(0xFF1D1E33),
        cardWidget: repeatIcon(
          icondata: FontAwesomeIcons.male,
          label: 'Male',
        ),
            ),
          ),
    Expanded(child: new repeatcontainer(
        colors: Color(0xFF1D1E33),
    cardWidget: repeatIcon(
      icondata: FontAwesomeIcons.female,
      label: 'Female',
    ),
    ),),
    ],
    ),),
    Expanded(child: new repeatcontainer(colors: Color(0xFF1D1E33)),),
    Expanded(child: Row(
    children: [
    Expanded(child: new repeatcontainer(colors: Color(0xFF1D1E33)),),
    Expanded(child: new repeatcontainer(colors: Color(0xFF1D1E33)),),
    ],
    ),),
    ],
    )
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class repeatIcon extends StatelessWidget {
  repeatIcon({required this.icondata, required this.label});
  final IconData icondata;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
    children:[
      Icon(
        icondata,
        size: 40.0,
          ),
        SizedBox(
          height: 15.0,
        ),
        Text(label,style: TextStyle(
          fontSize: 18.0,
          color: Color(0xFF8D8E98)
        ),)
    ],
        );
  }
}

class repeatcontainer extends StatelessWidget {
  repeatcontainer({required this.colors, this.cardWidget});
  final Color colors;
  final Widget? cardWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.all(15.0),
          child: cardWidget,
          decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
  }
}
