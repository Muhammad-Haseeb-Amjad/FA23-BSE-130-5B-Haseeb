import 'package:flutter/material.dart';

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
          Expanded(child: Container(
          margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10.0),

      ),
    ),),
    Expanded(child: Container(
    margin: EdgeInsets.all(15.0),
    decoration: BoxDecoration(
    color: Color(0xFF1D1E33),
    borderRadius: BorderRadius.circular(10.0),

    ),
    ),),
    ],
    ),),
    Expanded(child: Container(
    margin: EdgeInsets.all(15.0),
    decoration: BoxDecoration(
    color: Color(0xFF1D1E33),
    borderRadius: BorderRadius.circular(10.0),

    ),
    ),),
    Expanded(child: Row(
    children: [
    Expanded(child: Container(
    margin: EdgeInsets.all(15.0),
    decoration: BoxDecoration(
    color: Color(0xFF1D1E33),
    borderRadius: BorderRadius.circular(10.0),

    ),
    ),),
    Expanded(child: Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10.0),

      ),
    ),),
    ],
    ),),
    ],
    )
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
