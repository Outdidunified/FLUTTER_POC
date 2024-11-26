import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final TextEditingController _textcontroller = TextEditingController();
  String output = "Your output is here";
  bool isLoading = false;


  // void geminiOutput() async {
  //   if (_textcontroller.text.isEmpty) {
  //     return;
  //   }
  //
  //
  //   final model = GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: "AIzaSyCEn0WLDY4RlyMeAROWUqX2Xcz1qb4YkqI",
  //   );
  //   final prompt = [Content.text(_textcontroller.text)];
  //      print(prompt);
  //   final response = await model.generateContent(prompt);
  //   print(response.text);
  //   setState(() {
  //     output = response.text!;
  //   });
  //   _textcontroller.clear();
  // }

  void geminiOutput() async {
    if (_textcontroller.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: "AIzaSyCEn0WLDY4RlyMeAROWUqX2Xcz1qb4YkqI",
      );
      final prompt = [Content.text(_textcontroller.text)];

      final response = await model.generateContent(prompt);

      setState(() {
        output = response.text ?? "No response"; // Update the output
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        output = "An error occurred: $e";
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
      _textcontroller.clear();
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo gemini'),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading?CircularProgressIndicator():Text(output),
               SizedBox(height:500,),
              Stack(
                children: [Positioned(
                  child: TextField(
                    controller: _textcontroller,
                    decoration: InputDecoration(
                      hintText: "Enter your input here",
                  
                    ),
                  ),
                ),]
              ),

            ]
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          geminiOutput();
          },
        child: Icon(Icons.send),

      ),
    );
  }


}