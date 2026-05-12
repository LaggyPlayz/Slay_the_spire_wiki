import 'package:flutter/material.dart';

import '../models/Item.dart';
import '../models/Feed.dart';
import '../models/DatabaseHelper.dart';
import '../navigation/AppRoutes.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> items = const [
    Item(id:1, imagePath: "assets/image1.png", title: "Elon Musk becomes first person worth \$700 billion following pay package ruling"),
    Item(id:2, imagePath: "assets/image2.png", title: "Gold price climbs above \$4,400 to hit record high"),
    Item(id:3, imagePath: "assets/image3.png", title: "This billionaire tested China's limits. It cost him his freedom"),
    Item(id:4, imagePath: "assets/image4.png", title: "Trump Media to merge with fusion energy firm in \$6bn deal"),
    Item(id:5, imagePath: "assets/image5.png", title: "AI likely to displace jobs, says Bank of England governor"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu, color: Colors.red, size: 25, fontWeight: FontWeight(900),),
            Text(
                style: TextStyle(color: Colors.red, fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight(800)),
                "The News Post"),
            InkWell(
              onTap: (){

                Navigator.pushNamed(context, AppRoutes.favorites).then((_) {

                  setState(() {
                    print("Returned from Favorites - Refreshing Home...");
                  });
                });
              },
              child: Icon(Icons.favorite, color: Colors.grey, size: 25, fontWeight: FontWeight(900),),
            ),
          ],
        ),),


      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(children: [
              Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonBuilder(),
                          ]

                      ),
                    ],
                  )
              ),


              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                      padding: const EdgeInsetsGeometry.directional(
                          start: 16, end: 16, top: 16, bottom: 24),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.details , arguments: items[0]);
                        },
                        child: Column(
                          children: [
                            Image.asset(items[0].imagePath),
                            Text(
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight(700),
                                  fontSize: 15,),
                                items[0].title),
                          ],
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsetsGeometry.directional(
                          start: 0, end: 0, top: 32, bottom: 0),
                      child: Favorite(element: items[0]),
                  )
                ],
              ),

              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.details , arguments: items[1]);
                    },
                    child: Feed(url: items[1].imagePath,
                        text: items[1].title),
                  ),
                  Favorite(element: items[1],),
                ],
              ),
              Divider(),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.details , arguments: items[2]);
                    },
                    child: Feed(url: items[2].imagePath,
                        text: items[2].title),
                  ),
                  Favorite(element: items[2],),
                ],
              ),
              Divider(),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.details , arguments: items[3]);
                    },
                    child: Feed(url: items[3].imagePath,
                        text: items[3].title),
                  ),
                  Favorite(element: items[3],),
                ],
              ),
              Divider(),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.details , arguments: items[4]);
                    },
                    child: Feed(url: items[4].imagePath,
                        text: items[4].title),
                  ),
                  Favorite(element: items[4],),
                ],
              ),
              Divider(),

              SizedBox(
                height: 10,
              )
            ],);
          }),
    );
  }
}

class Label extends StatefulWidget {
  final String text;
  final Color color;
  final Color background;

  const Label({required this.text, required this.color, required this.background,super.key});

  @override
  State<Label> createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.background,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 14.0),
          child: Text(widget.text, style: TextStyle(color: widget.color, fontSize: 12),),
        ),
      ],
    );
  }
}

class Feed extends StatelessWidget {
  final String url;
  final String text;
  const Feed({required this.url, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(url, width: 140,),
          SizedBox(width: 8,),
          Expanded(
            child: Text(
              style: TextStyle(color: Colors.black, fontWeight: FontWeight(600), fontSize: 14,),
              text,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonX extends StatefulWidget {
  final String text;
  final bool clicked;

  const ButtonX({required this.text, required this.clicked, super.key});

  @override
  State<ButtonX> createState() => _ButtonXState();
}

class _ButtonXState extends State<ButtonX> {
  late bool clicked = widget.clicked;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      setState(() {
        clicked = !clicked;
      });
    },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Label(text: widget.text, color: Colors.white, background: clicked? Colors.red : Colors.grey),

          if (clicked)
            Icon(Icons.check, color: Colors.white, size: 16,),

        ],
      ),);
  }
}

class ButtonBuilder extends StatefulWidget {
  const ButtonBuilder({super.key});

  @override
  State<ButtonBuilder> createState() => _ButtonBuilderState();
}

class _ButtonBuilderState extends State<ButtonBuilder> {
  List labels = ['Home', 'Business', 'Politics', 'Sports'];
  int selected = 1;

  void updateSelection(int newIndex){
    setState(() {
      selected = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index){
          return ButtonX(text: labels[index], clicked: selected==index,);
        })
    ));
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
