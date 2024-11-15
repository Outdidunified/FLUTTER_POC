import 'package:flutter/material.dart';


class HeartPage extends StatefulWidget {
  const HeartPage({super.key});

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> with SingleTickerProviderStateMixin {
 late AnimationController _controller;
 late Animation _colorController;
 late Animation<double> _sizeController;
 bool isFav = false;


 @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    _colorController = ColorTween(begin: Colors.grey, end: Colors.red).animate(_controller);
    _controller.addListener((){
      setState(() {

      });
      print(_controller.value);
      print(_colorController.value);
    });

    _sizeController = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30.0, end: 50.0),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50.0, end: 30.0),
          weight: 50.0,
        ),
      ],

    ).animate(_controller);
    _controller.addStatusListener((status){
      print(status);
      if(status==AnimationStatus.completed){
        isFav = true;
      }
      else{
        isFav = false;
      }
    });
 }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _){
        return  IconButton(
          onPressed: (){
              isFav? _controller.reverse() : _controller.forward();
          },
          icon: Icon(Icons.favorite,
            size: _sizeController.value,),
          color: _colorController.value,);
      },
    );
  }
}
