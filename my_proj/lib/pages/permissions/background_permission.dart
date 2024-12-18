import 'package:flutter/material.dart';
import 'package:my_proj/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class BackgroundPermission extends StatefulWidget {
  const BackgroundPermission({super.key});

  @override
  State<BackgroundPermission> createState() => _BackgroundPermissionState();
}

class _BackgroundPermissionState extends State<BackgroundPermission> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
                   builder: (context, ThemeProvider notifier, child) {
                     return ListTile(
                         leading: Icon(Icons.dark_mode),
                         title: Text("Dark Mode"),
                         trailing: Switch(
                             value: notifier.isDark,
                             onChanged: (value) {
                               notifier.ChangeTheme();
                             })
                     );
                   }
               );
  }
}

