import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trailmate/.env.dart';
import 'package:trailmate/map.dart';
import 'firebase_options.dart';
import 'model/OnboardingPage.dart';

//* Utilized flutter template for main page *//

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: OnboardFirstPage());
  }
}

class OnboardFirstPage extends StatelessWidget {
  const OnboardFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          title: 'Mobile Web Application Project',
          description: 'Developed by:\n Melissa Munoz & Christian Mackenzie',
          imageUrl: 'assets/images/onboard1.png',
          bgColor: primaryLightGreen,
        ),
        OnboardingPageModel(
          title: 'What is Trail Mate?',
          description: 'Trailmate is an application that has an interactable map interface, that encourages users to explore their surroundings through community pins.',
          imageUrl: 'assets/images/onboard2.png',
          bgColor: primaryYellow,
        ),
        OnboardingPageModel(
          title: 'It\'s Easy-Peasy!',
          description:
              'All you need to do is tap on the map and enter your information!',
          imageUrl: 'assets/images/onboard3.png',
          bgColor: primaryBrown,
        ),
        OnboardingPageModel(
          title: 'Enjoy!',
          description: 'Thanks for testing it out :)',
          imageUrl: 'assets/images/onboard4.png',
          bgColor: primaryGreen,
        ),
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter({Key? key, required this.pages, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Image.asset(
                              item.imageUrl,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.5
                                ),
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    )),
                              )
                            ]))
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),
              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyMap()),
                        );
                      },
                      child: Row(
                        children: const [
                          Text('Skip', style: TextStyle(color: Colors.black)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.black,),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

