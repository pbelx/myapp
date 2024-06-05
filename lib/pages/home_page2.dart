import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class Myplayer {
  AudioPlayer player = AudioPlayer();

  Future<void> playNow(String urlsong) async {
    print("Playing audio...");
    await player.release();
    await player.dispose();
    player = AudioPlayer();
    // await player.setSourceUrl(urlsong);
    player.play(UrlSource(urlsong));
    // await player.play(x);
  }

  Future<void> stopPlay() async {
    print("Stopping audio...");
    await player.stop();
  }

  Future<void> setVolume(double volume) async {
    await player.setVolume(volume);
  }

  void dispose() {
    player.dispose();
  }
}

class _MyWidgetState extends State<MyWidget> {
  late Myplayer myPlayer;
  bool isPlaying = false;
  late String stationName = '';
  double volume = 0.5;
  List<Radio> radioStations = [];

  @override
  void initState() {
    super.initState();
    myPlayer = Myplayer();
    myPlayer.player.setVolume(volume);
    fetchRadioStations();
  }

  Future<void> fetchRadioStations() async {
    final response = await http.get(Uri.parse('https://bx.cybertv.tv:2053/all'));

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

  void playRadio(String urlx, String radioName) {
    setState(() {
      isPlaying = false;
    });
    myPlayer.stopPlay();
    myPlayer.playNow(urlx);
    setState(() {
      stationName = radioName;
      isPlaying = true;
    });
  }

  void stopRadio() {
    myPlayer.stopPlay();
    setState(() {
      isPlaying = false;
    });
  }

  void volumeUp() {
    setState(() {
      volume = (volume + 0.1).clamp(0.0, 1.0);
      myPlayer.setVolume(volume);
    });
  }

  void volumeDown() {
    setState(() {
      volume = (volume - 0.1).clamp(0.0, 1.0);
      myPlayer.setVolume(volume);
    });
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
      drawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/1.jpeg',
                    height: 150,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    const Text('Now Playing'),
                    isPlaying ? Text(stationName) : const Text(''),
                    !isPlaying ? const CircularProgressIndicator(): const Text(''),
                  ],
                ),
      
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: volumeDown,
                  child: const Icon(
                    Icons.volume_down,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: isPlaying ? stopRadio : null,
                  child: Icon(
                    Icons.stop,
                    size: 30,
                    color: isPlaying ? Colors.black : Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: volumeUp,
                  child: const Icon(
                    Icons.volume_up,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: radioStations.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      playRadio(radioStations[index].radioUrl,
                          radioStations[index].radioName);
                    },
                    child: ListTile(
                      title: Text(radioStations[index].radioName),
                      trailing: const Icon(Icons.play_arrow),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
