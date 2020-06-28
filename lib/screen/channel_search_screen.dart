import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutteryoutubecategorizer/constant_values.dart';
import 'package:flutteryoutubecategorizer/controller/sharedPrefController.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:youtube_api/youtube_api.dart';

class ChannelSearchScreen extends StatefulWidget {
  final String title;
  final String query;

  ChannelSearchScreen(this.title, this.query);

  @override
  _ChannelSearchScreenState createState() => _ChannelSearchScreenState();
}

class _ChannelSearchScreenState extends State<ChannelSearchScreen> {
  Channel resultChannel;
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  //
  static String key =
      ConstantValues.YoutubeDataApiKey; // ** ENTER YOUTUBE API KEY HERE **

  YoutubeAPI ytApi = new YoutubeAPI(
    key,
    type: "channel",
    maxResults: 5,
  );
  List<YT_API> ytResult = [];

  callAPI(String queryString) async {
    print('UI callled');
    ytResult = await ytApi.search(queryString);
    setState(() {
      print('UI Updated');
    });
  }

  //

  @override
  void initState() {
    super.initState();
    callAPI(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [Colors.pink, Colors.blueAccent])),
        child: SafeArea(
          child: Column(
            children: [
              //buildHeaderWidget(context),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ],
              ),
              Expanded(
                child: new Container(
                  height: 400,
                  child: ListView.builder(
                      itemCount: ytResult.length,
                      itemBuilder: (_, int index) => listItem(index)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //

  Widget listItem(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
      child: new Card(
        child: new Container(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => {
              print(ytResult[index].channelTitle +
                  ", " +
                  ytResult[index].channelId +
                  ", " +
                  ytResult[index].thumbnail.toString()),
              SharedPrefController.addString(
                  "selected",
                  ytResult[index].channelTitle +
                      ", " +
                      ytResult[index].channelId +
                      ", " +
                      ytResult[index].thumbnail.toString()),
              SharedPrefController.addString(
                  "idCh1", ytResult[index].channelId),
              print("ㄴ저장함."),
              Navigator.pop(context, {
                'channelId': ytResult[index].channelId,
                'channelTitle': ytResult[index].channelTitle,
                'channelThumb': ytResult[index].thumbnail['default']['url'],
              }),
            },
            child: new Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(
                    ytResult[index].thumbnail['default']['url'],
                  ))),
                ),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                new Expanded(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      new Text(
                        ytResult[index].channelTitle,
                        softWrap: true,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                      new Text(
                        ytResult[index].description,
                        softWrap: true,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
