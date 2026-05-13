import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  final String url;
  final String text;
  const Feed({required this.url, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(url, width: 160,),
            SizedBox(width: 8,),
            Expanded(
              child: Text(
                style: TextStyle(color: Colors.black, fontWeight: FontWeight(600), fontSize: 14,),
                text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}