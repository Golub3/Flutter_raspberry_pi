import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';

class StreamTab extends StatefulWidget {
  @override
  _StreamTabState createState() => _StreamTabState();
}

class _StreamTabState extends State<StreamTab> {
  String _streamUrl;
  VlcPlayerController _vlcViewController;
  @override
  void initState() {
    super.initState();
    _vlcViewController = new VlcPlayerController();
  }

  void _incrementCounter() {
    setState(() {
      if (_streamUrl != null) {
        _streamUrl = null;
      } else {
        _streamUrl = 'http://192.168.0.104:8081';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _streamUrl == null
                ? Container(
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Stream Closed',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                background: Paint()..color = Colors.red),
                          )
                        ]),
                      ),
                    ),
                  )
                : new VlcPlayer(
                    defaultHeight: 480,
                    defaultWidth: 640,
                    url: _streamUrl,
                    controller: _vlcViewController,
                    placeholder: Container(),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.red,
        tooltip: 'Increment',
        child: Icon(_streamUrl == null ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
