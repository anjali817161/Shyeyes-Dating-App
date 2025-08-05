import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LikesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/like_button.json',
            height: 100,
            width: 100,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 16),
          Text(
            "See people who liked you with ShyEye Gold™",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.black,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              "See who likes you",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
