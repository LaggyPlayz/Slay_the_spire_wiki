import 'package:flutter/material.dart';

import './favorites.dart';
import '../models/Item.dart';

class DetailsScreen extends StatelessWidget {
  final Item item;
  const DetailsScreen({super.key , required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF12151c),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9aa4b2),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                style: TextStyle(color: Color(0xFF8e3b46), fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight(800)),
                "Details"),
          ],),
        ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(item.imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: const SizedBox(width: 30,),
                ),
                Expanded(
                  flex: 2,
                  child: Text(item.title , style: const TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsetsGeometry.directional(start: 0,end: 0,top: 0, bottom: 0),
                    child: Favorite(element: item),
                  )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "Description",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
