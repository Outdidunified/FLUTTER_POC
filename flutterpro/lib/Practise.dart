import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width:400,
                  height:50,
                  margin:EdgeInsets.only(bottom:20),
                  child: Card(
                      elevation: 11,
                      shadowColor: Colors.blue,
                      child:Center(child: Text("data 1",style:TextStyle(color:Colors.red)))
                  ),
                ),
                Container(
                  width:400,
                  height:50,
                  margin:EdgeInsets.only(bottom: 20),
                  child: Card(
                      elevation: 11,
                      shadowColor: Colors.blue,
                      child:Center(child: Text("data 2",style:TextStyle(color:Colors.red)))
                  ),
                ),
                Container(
                  width:400,
                  height:50,
                  margin:EdgeInsets.only(bottom: 20),
                  child: Card(
                      elevation: 11,
                      shadowColor: Colors.blue,
                      child:Center(child: Text("data 3",style:TextStyle(color:Colors.red)))
                  ),
                ),
                Container(
                  width:400,
                  height:50,
                  margin:EdgeInsets.only(bottom: 20),
                  child: Card(
                      elevation: 11,
                      shadowColor: Colors.blue,
                      child:Center(child: Text("data 4",style:TextStyle(color:Colors.red)))
                  ),
                ),
                Container(
                  width:400,
                  height:50,
                  margin:EdgeInsets.only(bottom: 20),
                  child: Card(
                      elevation: 11,
                      shadowColor: Colors.blue,
                      child:Center(child: Text("data 5",style:TextStyle(color:Colors.red)))
                  ),
                ),

              ],
            ),
          ),
        )



    );
  }
}
