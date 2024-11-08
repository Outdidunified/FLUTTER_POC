import 'package:basic_proj/responsive_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive page"),
      ),
      body: SafeArea(
        child: ResponsivePage(
            mobile: Column(
              children: [
                buildBannerSlider(),
                Icon(Icons.adaptive.share),
                Slider.adaptive(value: 0, onChanged: (val) {}),
                // Expanded(child: buildBannerSlider()),
                buildTitleText(),
              ],
            ),
            tab: Row(
              children: [
                buildBannerSlider(),
                buildBannerSlider(),
                Expanded(child: buildTitleText()),
              ],
            )),
        // child: LayoutBuilder(builder: (context, snapshot) {
        //     if(snapshot.maxWidth < 600){
        //       return Column(
        //         children: [
        //           buildBannerSlider(),
        //           buildTitleText(),
        //
        //         ],
        //       );
        //     }
        //     else{
        //       return Row(
        //         children: [
        //           buildBannerSlider(),
        //           Expanded(child: buildTitleText()),
        //
        //         ],
        //       );
        //     }
        //
        //
        //   }
        // ),
      ),
    );
  }

  Text buildTitleText() {
    return const Text(
      "One of Flutter's primary goals is to create a framework that allows you to develop apps from a single codebase that look and feel great on any platform.This means that your app might appear on screens of many different sizes, from a watch, to a foldable phone with two screens, to a high definition monitor. And your input device might be a physical or virtual keyboard, a mouse, a touchscreen, or any number of other devices.",
      style: TextStyle(fontSize: 20),
    );
  }

  Container buildBannerSlider() {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(4)),
    );
  }
}
