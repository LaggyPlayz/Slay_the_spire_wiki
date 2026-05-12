import 'package:flutter/material.dart';

import '../models/Item.dart';
import '../models/Feed.dart';
import '../models/DatabaseHelper.dart';
import '../navigation/AppRoutes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  Future<List<Item>> _getFavoritesFromDB() async {
    final List<Map<String, dynamic>> maps = await DatabaseHelper.getFavorites();

    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

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
        title: const Text(
          "The Favorite News",
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'serif',
            fontSize: 24,
            fontWeight: FontWeight(800),
          ),
        ),
      ),
      body: FutureBuilder<List<Item>>(
        future: _getFavoritesFromDB(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }


          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Your favorites list is empty."),
            );
          }


          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.details,
                            arguments: items[index]);
                      },
                      child: Feed(
                          url: items[index].imagePath, text: items[index].title),
                    ),
                    Favorite(element: items[index])
                  ]),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class Favorite extends StatefulWidget {
  final Item element;
  const Favorite({super.key, required this.element});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool click = false;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    DatabaseHelper.updateSignal.addListener(_checkInitialStatus);
  }

  @override
  void dispose() {
    // Stop listening when the widget is destroyed to save memory
    DatabaseHelper.updateSignal.removeListener(_checkInitialStatus);
    super.dispose();
  }

  void _checkInitialStatus() async {
    final favorites = await DatabaseHelper.getFavorites();
    final isFavorite = favorites.any((map) => map['id'] == widget.element.id);

    if (mounted) {
      setState(() {
        click = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (click) {
          await DatabaseHelper.deleteNews(widget.element.id);
        } else {
          await DatabaseHelper.insertNews(widget.element);
        }
      },
      icon: Icon(click ? Icons.favorite : Icons.favorite_border),
      color: click ? Colors.red : Colors.grey,
    );
  }
}






