import 'package:flutter/material.dart';

import './favorites.dart';
import '../models/Item.dart';

class DetailsScreen extends StatelessWidget {
  final Item item;
  const DetailsScreen({super.key , required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Details"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(item.imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Text(item.title , style: const TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsetsGeometry.directional(start: 0,end: 12,top: 12, bottom: 0),
                  child: Favorite(element: item),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
