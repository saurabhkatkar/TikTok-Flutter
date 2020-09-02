import 'package:flutter/material.dart';
import 'package:tiktok_flutter/models/video.dart';
import 'package:tiktok_flutter/screens/home.dart';
import 'package:video_player/video_player.dart';

class VideoManager {
  State<Home> state;
  Function updateController;
  List<int> streamQ = [0, 1, 2];

  List<Video> listVideos;

  Sink<List<Video>> stream;

  VideoManager({this.stream});

  changeVideo(index, prv, next) async {
    if (streamQ.contains(prv) &&
        streamQ.contains(index) &&
        !streamQ.contains(next)) {
      disposeVideo(streamQ[0]);
      print("dispose 1");
    } else if (!streamQ.contains(prv) &&
        streamQ.contains(index) &&
        streamQ.contains(next)) {
      disposeVideo(streamQ[2]);
      print("dispose 2");
    }
    streamQ = [prv, index, next];

    print("Preivous index next is :  $prv  $index $next");
    listVideos[prv]?.controller?.pause();
    listVideos[next]?.controller?.pause();

    await loadVideo(index);

    listVideos[index].controller.play();
    stream.add(listVideos);
  }

  Video getVideo(index) {
    return listVideos[index];
  }

  VideoPlayerController getController(index) {
    return listVideos[index].controller;
  }

  playVideo(index) {
    if (listVideos[index].controller != null) {
      listVideos[index].controller.play();
    }
  }

  pauseVideo(index) {
    if (listVideos[index].controller != null) {
      listVideos[index].controller.pause();
    }
  }

  loadVideo(index) async {
    if (listVideos[index].controller == null) {
      listVideos[index].controller =
          await createController(listVideos[index].url);
      stream.add(listVideos);
    }
  }

  disposeVideo(index) {
    if (index >= 0) {
      if (listVideos[index].controller != null) {
        listVideos[index].controller.dispose();
        listVideos[index].controller = null;
      }
    }
  }

  Future<VideoPlayerController> createController(url) async {
    VideoPlayerController controller = VideoPlayerController.network(url);
    await controller.initialize();
    controller.setLooping(true);
    return controller;
  }

  bool hasVideos() {
    if (listVideos.length > 0) return true;
    return false;
  }

  int numOfVideos() {
    return listVideos.length;
  }

  dispose() {
    listVideos.forEach((element) {
      if (element.controller != null) {
        element.controller.dispose();
      }
    });
  }
}
