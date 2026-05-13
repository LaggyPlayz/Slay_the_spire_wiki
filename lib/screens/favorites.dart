import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/Item.dart';
import '../models/Feed.dart';
import '../models/DatabaseHelper.dart';
import '../navigation/AppRoutes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  Future<List<Item>> _getFavoritesFromDB() async {
    final List<Map<String, dynamic>> maps =
    await DatabaseHelper.getFavorites();

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['itemId'],
        title: maps[i]['title'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

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
                "Favorites"),
          ],),
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
    DatabaseHelper.updateSignal.removeListener(_checkInitialStatus);
    super.dispose();
  }

  void _checkInitialStatus() async {
    final favorites = await DatabaseHelper.getFavorites();
    final isFavorite = favorites.any(
          (map) => map['itemId'] == widget.element.id,
    );

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
        print("🔥 Favorite pressed");

        final newValue = !click;

        setState(() {
          click = newValue;
        });

        try {
          final db = DatabaseService();

          print("🔥 Writing to Firebase...");

          await db.toggleFavorite(
            userId: "data1",
            itemId: widget.element.id,
            isFavorite: newValue,
          );

          print("🔥 Firebase write SUCCESS");
        } catch (e) {
          print("❌ Firebase error: $e");
        }

        try {
          if (newValue) {
            await DatabaseHelper.insertCard(widget.element);
            print("💾 Local insert OK");
          } else {
            await DatabaseHelper.deleteCard(widget.element.id);
            print("🗑️ Local delete OK");
          }
        } catch (e) {
          print("❌ Local DB error: $e");
        }

        DatabaseHelper.triggerUpdate();
      },
      icon: Icon(click ? Icons.favorite : Icons.favorite_border),
      color: click ? Colors.red : Colors.grey,
    );
  }
}






