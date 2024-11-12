import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher extends StatefulWidget {
  const UrlLauncher({super.key});

  @override
  State<UrlLauncher> createState() => _UrlLauncherState();
}

class _UrlLauncherState extends State<UrlLauncher> {
  // Method to handle phone call
  Future<void> call(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw "Cannot launch phone call to $phoneNumber";
    }
  }

  // Method to handle URL launch (e.g., YouTube link)
  Future<void> launchUrlHandler() async {
    const url = "https://www.youtube.com/@KunalKushwaha";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Cannot launch $url";
    }
  }

  // Method to handle email launch
  Future<void> launchMail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'shreegourikulkarni24@gmail.com',
      queryParameters: {
        'subject': 'TestEmail',
        'body': 'Subscribe To This Channel Please',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw "Cannot launch email client";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "URL Launcher",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // MaterialButton(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: Text("Call"),
            //   color: Colors.red,
            //   onPressed: () {
            //     call("7349175769");
            //   },
            // ),
            SizedBox(height: 10),
            MaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Launch YouTube URL", style: TextStyle(color: Colors.white),),
              color: Colors.blueGrey,
              onPressed: launchUrlHandler,
            ),
            SizedBox(height: 10),
            MaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: launchMail,
              color: Colors.blueGrey,
              child: Text("Launch Email", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
