import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  final String username;
  final String email;
  final int userId;

  const WalletPage({super.key, required this.username, required this.email, required this.userId});
  // const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Wallet:${widget.username}, ${widget.userId}"),
      ),
    );
  }
}
