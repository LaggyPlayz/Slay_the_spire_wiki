import 'package:flutter/material.dart';

import '../models/Item.dart';
import '../models/DatabaseHelper.dart';
import '../navigation/AppRoutes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive columns
    int crossAxisCount = 2;

    if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    final List<Item> items = const [
      Item(id:1, imagePath: "assets/SpireShield.png", title: "SpireShield"),
      Item(id:2, imagePath: "assets/Nemesis-pretty.png", title: "Nemesis pretty"),
      Item(id:3, imagePath: "assets/SpireSpear.png", title: "SpireSpear"),
      Item(id:4, imagePath: "assets/Gremlin_Leader.png", title: "Gremlin Leader"),
      Item(id:5, imagePath: "assets/Byrd.png", title: "Byrd"),
      Item(id:6, imagePath: "assets/Gremlin-nob-pretty.png", title: "Gremlin nob pretty"),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        drawer: Drawer(
          backgroundColor: const Color(0xFF1b2230),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF12151c),
                ),
                child: Text(
                  "The Spire Wiki",
                  style: TextStyle(
                    color: Color(0xFFe6e0d4),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text("Home",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),

              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text("Favorites",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.favorites);
                },
              ),
            ],
          ),
        ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF12151c),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFF8e3b46),
                  size: 25,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

            const Text(
              "The Spire Wiki",
              style: TextStyle(
                color: Color(0xFF8e3b46),
                fontFamily: 'serif',
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.favorites);
              },
              child: const Icon(
                Icons.favorite,
                color: Color(0xFF9aa4b2),
                size: 25,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return WikiCard(
              item: item,
              onTap: () {
                debugPrint('Tapped item no. ${item.id}');
                Navigator.pushNamed(context, AppRoutes.details , arguments: item);
              },
            );
          },
        ),
      ),
    );
  }
}

class WikiCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const WikiCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1b2230),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // CARD TAP AREA
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item.title,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFe6e0d4),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FAVORITE BUTTON
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.black45,
                shape: const CircleBorder(),
                child: Favorite(element: item),
              ),
            ),
          ],
        ),
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
        final newValue = !click;


        setState(() {
          click = newValue;
        });


        if (newValue) {
          await DatabaseHelper.insertCard(widget.element);
        } else {
          await DatabaseHelper.deleteCard(widget.element.id);
        }

        DatabaseHelper.triggerUpdate();
      },
      icon: Icon(click ? Icons.favorite : Icons.favorite_border),
      color: click ? Colors.red : Colors.grey,
    );
  }
}
