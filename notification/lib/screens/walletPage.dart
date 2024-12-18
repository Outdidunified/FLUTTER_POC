import 'package:flutter/material.dart';
import 'package:notification/services/walletnotification.dart';

class Walletpage extends StatefulWidget {
  const Walletpage({super.key});

  @override
  State<Walletpage> createState() => _WalletpageState();
}

class _WalletpageState extends State<Walletpage> {

  final NotificationService _notificationService = NotificationService();
  int defualtAmount = 100;
  bool _isNotificatonSent = false;

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _checkWalletBalance();
  }

  Future<void> _initializeNotification() async {
    await _notificationService.initNotifications();
    await _notificationService.requestPermission(); // Request permission for Android 13+
  }
  
  void IncementAmount(){
    setState(() {
      defualtAmount= defualtAmount+1;
    });
    _checkWalletBalance();
  }
  
  void DecrementAmount(){
    setState(() {
      defualtAmount = defualtAmount-1;
    });
    _checkWalletBalance();
  }

  // Check wallet balance and send notification if it's low
  void _checkWalletBalance() {
    if (defualtAmount < 100 && !_isNotificatonSent) {
      _notificationService.showNotification(
        title: 'Wallet Amount Alert!',
        body: 'Your Wallet Amount balance is low.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Amount Balance: $defualtAmount"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: IncementAmount,
                  child: Text("Increment"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: defualtAmount < 100 ? null : DecrementAmount, // Disable button if amount is <= 100
                  child: Text("Decrement"),
                ),
              ],
            ),
          ],
        ),
      ),    );
  }
}
