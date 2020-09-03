import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_flutter/models/video.dart';

import 'demo_data.dart';

class VideosAPI {
  VideosAPI();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Video>> getVideoListForUser(String userId) async {
    var data = await firestore.collection("Videos").get();

    if (data.docs.length == 0) {
      await addDemoData();
    }

    var videoList = <Video>[];
    var videos = await firestore.collection("Videos").get();

    videos.docs.forEach((element) {
      Video video = Video.fromJson(element.data());
      videoList.add(video);
    });

    return videoList;
  }

  Future<Null> addDemoData() async {
    for (var video in data) {
      await firestore.collection("Videos").add(video);
    }
  }

  //Working in User System
  Future<bool> removeVideosFromFeed(
      String userId, List<String> videoIds) async {
    await firestore
        .collection('Users')
        .doc(userId)
        .update({"videosViewed": FieldValue.arrayUnion(videoIds)});
    return true;
  }

  Future<bool> clearHistory(String userId) async {
    var user = await firestore.collection('Users').doc(userId).get();
    var listToRemove = user.data()['videosViewed'];
    await firestore
        .collection('Users')
        .doc(userId)
        .update({"videosViewed": FieldValue.arrayRemove(listToRemove)});
    return true;
  }
}
