import 'package:flutter/material.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
   double _width = 200;
   double _opacity = 1;
   Color _color = Colors.blue;
   double _margin = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
      duration: Duration(seconds: 1),
      margin: EdgeInsets.all(_margin),
      width: _width,
      color: _color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget> [
          ElevatedButton(
              onPressed: () => setState(() => _margin = 50),
              child: Text("Margin")),
          ElevatedButton(
              onPressed: () => setState(() => _width = 400),
              child: Text("width")),
          ElevatedButton(
              onPressed: () => setState(() => _color = Colors.purple),
              child: Text("color")),
          ElevatedButton(
              onPressed: () => setState(() => _opacity = 0),
              child: Text("Opacity")),
          AnimatedOpacity(
            child: Text("Hide me", style: TextStyle(color: Colors.white),),
              opacity: _opacity, 
              duration: Duration(seconds: 1)),
        ],
      ),
    ),
    );
  }
}
