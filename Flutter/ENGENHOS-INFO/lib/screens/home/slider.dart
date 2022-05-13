import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({Key? key}) : super(key: key);

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List<Slide> slides = [];

  late Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "Welcome",
        styleTitle: const TextStyle(
          color: Color(0xffFBD732),
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
        "Welcome! This app can detect if an object is dangerous or not!\n\n"
            "You can either send a picture or send a form.\n\n"
            "If you choose to send a picture you can tap on Camera button, take the picture and send it.\n\n "
            "Otherwise, go to Form page, complete the form and press send.\n\n The result will be available in Results screen.\n",
        styleDescription:
        TextStyle(color: Colors.grey[400], fontSize: 18.0, fontStyle: FontStyle.italic, fontFamily: 'Raleway'),
        pathImage: "assets/Logo-PS2.png",
      ),
    );
    slides.add(
      Slide(
        title: "Notice",
        styleTitle:
        const TextStyle(color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono'),
        description: "Our goal is to make Engenhos.INFO an informative and useful app, but we cannot guarantee that problems will never arise.\n\n"
            "We guarantee that your data won't be shared with 3rd party applications!\n",
        styleDescription:
        TextStyle(color: Colors.grey[400], fontSize: 20.0, fontStyle: FontStyle.italic, fontFamily: 'Raleway'),
        pathImage: "assets/disclaimer.png",
      ),
    );
  }

  void onDonePress() {
    // Back to the first tab
    goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    /*print(index);*/
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage!,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  )),
              Container(
                child: Text(
                  currentSlide.title!,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description!,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 15,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: const EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // Skip button
      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: const Color(0xffffcc5c),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: renderListCustomTabs(),
      backgroundColorAllSlides: Colors.black,
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: const BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: onTabChangeCompleted,
    );
  }
}

