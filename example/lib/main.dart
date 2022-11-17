import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'app_themes.dart';

final List<String> imgList = [
  'https://source.unsplash.com/random/1920x1920/?abstracts',
  'https://source.unsplash.com/random/1920x1920/?fruits,flowers',
  'https://source.unsplash.com/random/1080x640/?sports',
  'https://source.unsplash.com/random/1920x1920/?nature',
  'https://source.unsplash.com/random/1920x1920/?science',
  'https://source.unsplash.com/random/1920x1920/?computer'
];

void main() => runApp(const CarouselDemo());

class CarouselDemo extends StatelessWidget {
  const CarouselDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const CarouselDemoHome(),
        '/manual': (ctx) => NextPrevState(),
      },
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

class DemoItem extends StatelessWidget {
  final String title;
  final String route;

  const DemoItem(this.title, this.route, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: Colors.redAccent.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        margin: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
      ),
    );
  }
}

class CarouselDemoHome extends StatelessWidget {
  const CarouselDemoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carousel Demo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: const [
          SizedBox(height: 8.0),
          DemoItem('Nav State', '/manual'),
        ],
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: Image.network(
            item,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext ctx, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (
              BuildContext context,
              Object exception,
              StackTrace? stackTrace,
            ) {
              return const Text(
                'Oops!! An error occurred. 😢',
                style: TextStyle(fontSize: 16.0),
              );
            },
          ),
        ))
    .toList();


class NextPrevState extends StatefulWidget {
  NextPrevState({Key? key}) : super(key: key);

  @override
  State<NextPrevState> createState() => NextPrevStateState();
}

class NextPrevStateState extends State<NextPrevState> {
  Future<String>? _value;
  final CarouselController _controller = CarouselController();

  Future<String> getValue() async {
    await Future.delayed(Duration(seconds: 3));
    return 'Flutter Devs';
  }

  @override
  void initState() {
    super.initState();
    _value = getValue();
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    return 
    
    Scaffold(
      appBar: AppBar(title: const Text('Image Slider Demo')),
      body:
    
    
    
    Column(children: [
      FutureBuilder<String>(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: _controller.previousPage,
                          child: const Icon(
                            Icons.chevron_left,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data!,
                              ))),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: _controller.nextPage,
                          child: const Icon(
                            Icons.chevron_right,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FlutterCarousel(
                    options: CarouselOptions(
                        showIndicator: true,
                        autoPlay: false,
                        slideIndicator: CircularSlideIndicator(),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
                        .map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Text(i);
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
            }
            return Text('Loading');
          })
    ]));
  }
}

