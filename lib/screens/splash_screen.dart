import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.deepOrange,
              size: 140,
            ),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
