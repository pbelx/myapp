import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/components/dope_box.dart';
import 'package:myapp/components/my_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
// import 'package:myapp/models/radio.dart' as radiosamples;
// import 'package:getwidget/getwidget.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class Myplayer {
  AudioPlayer player = AudioPlayer();

  Future playNow(String urlsong) async {
    String url = urlsong;
    // print("Playing audio...");
    try {
      await player.release();
      player = AudioPlayer();
      await player.play(UrlSource(url));
    } on Exception catch (e) {
      print(e);
      // setState((){
      //   isPlaying = false;
      // });
    }
    // if(player.v)
  }

  Future stopPlay() async {
    // print("Stopping audio...");
    await player.stop();
  }

  void dispose() {
    player.dispose();
  }
}

class Radio {
  String radioName;
  String radioUrl;

  Radio(this.radioName, this.radioUrl);

  static List<Radio> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) =>
            Radio(json as String, "https://bx.cybertv.tv:2053/station/$json"))
        .toList();
  }
}

class _MyWidgetState extends State<MyWidget> {
  late Myplayer myPlayer;
  bool isPlaying = false;
  bool isLoading = false;
  late String stationName = '';
  List<Radio> radioStations = [];

  @override
  void initState() {
    super.initState();
    myPlayer = Myplayer();
    fetchRadioStations();
  }

  Future<void> fetchRadioStations() async {
    final response =
        await http.get(Uri.parse('https://bx.cybertv.tv:2053/all'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final stations = jsonResponse['stations'] as List<dynamic>;
      setState(() {
        radioStations = Radio.fromJsonList(stations);
      });
    } else {
      throw Exception('Failed to load radio stations');
    }
  }

  void printindex(String urlx, String radioName) {
    // print(urlx);
    setState(() {
      isLoading = true;
    });
    myPlayer.stopPlay();
    myPlayer.playNow(urlx);
    setState(() {
      stationName = radioName;
      isLoading = false;
    });
  }

  void volume_up() {
    // print(myPlayer.player.volume);
    if (myPlayer.player.volume < 1) {
      myPlayer.player.setVolume(myPlayer.player.volume + 0.10);
    } else {
      // print("max volume");
    }
  }

  void volume_down() {
    if (myPlayer.player.volume > 0) {
      myPlayer.player.setVolume(myPlayer.player.volume - 0.10);
    } else {}
  }

  @override
  void dispose() {
    myPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // DopeBox(
                //   child: Image.asset(
                //     'assets/images/1.jpeg',
                //     height: 150,
                //     width: 160,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                DopeBox(child: Lottie.asset('assets/lotties/spaceman.json',height: 150)),
                Column(
                  children: [
                    const Text('Now Playing'),
            
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.green,
                          )
                        : Text(
                            stationName,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.yellow,
                              // color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // myPlayer.playNow();
                      volume_down();
                    },
                    child: const DopeBox(
                      child: Icon(
                        Icons.volume_down,
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      myPlayer.stopPlay();
                    },
                    child: const DopeBox(
                      child: Icon(
                        Icons.stop,
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      volume_up();
                    },
                    child: const DopeBox(
                      child: Icon(
                        Icons.volume_up,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10),
            ),
            const SizedBox(height: 4),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4250957085.
                      shrinkWrap: true,
                      itemCount: radioStations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            printindex(radioStations[index].radioUrl,
                                radioStations[index].radioName);
                            // print(radiosamples.Radio.samples[index]);
                          },
                          child: ListTile(
                            title: Text(radioStations[index].radioName),
                            // subtitle: const Text('Fm'),
                            trailing: const Icon(Icons.play_arrow),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
