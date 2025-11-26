import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Icontextfile.dart';
import 'Containerfile.dart';

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




