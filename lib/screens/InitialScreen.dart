import 'package:flutter/material.dart';
import 'package:tiktok_flutter/bloc/videos.bloc.dart';
import 'package:tiktok_flutter/data/videos_api.dart';
import 'package:tiktok_flutter/models/video.dart';
import 'package:tiktok_flutter/screens/Profile/ProfileScreen.dart';
import 'package:tiktok_flutter/widgets/bottom_toolbar.dart';

import 'Home/HomeScreen.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _topSection = TopSection();

  Widget _middleScreen = HomeScreen();

  Widget screenUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _topSection,
        BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: BottomToolbar(
            getScreenByType: getScreenByType,
          ),
        ),
      ],
    );
  }

  void getScreenByType(String type) {
    switch (type) {
      case 'Home':
        _topSection = TopSection();

        _middleScreen = HomeScreen();
        break;
      case 'Search':
        _topSection = Container();
        _middleScreen = Container();

        break;
      case 'Messages':
        _topSection = Container();

        _middleScreen = Container();

        break;
      case 'Profile':
        _topSection = Container();

        _middleScreen = ProfileScreen();

        break;
      default:
        _topSection = Container();

        _middleScreen = Container();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: <Widget>[_middleScreen, screenUI()]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(bottom: 15.0),
      alignment: Alignment(0.0, 1.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Following'),
            Container(
              width: 15.0,
            ),
            Text('For you',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold))
          ]),
    );
  }
}
