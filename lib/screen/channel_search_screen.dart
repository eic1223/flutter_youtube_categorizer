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
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 50,
          right: 20,
        ),
        child: Column(
          children: [
            buildHeaderWidget(context),
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
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          width: 300,
          child: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: Theme.of(context).primaryColor),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  //

  Widget listItem(index) {
    return new Card(
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
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
            SharedPrefController.addString("idCh1", ytResult[index].channelId),
            print("ㄴ저장함."),
            Navigator.pop(context, {
              'channelId': ytResult[index].channelId,
              'channelTitle': ytResult[index].channelTitle,
              'channelThumb': ytResult[index].thumbnail['default']['url'],
            }),
          },
          child: new Row(
            children: <Widget>[
              new Image.network(
                ytResult[index].thumbnail['default']['url'],
              ),
              new Padding(padding: EdgeInsets.only(right: 20.0)),
              new Expanded(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    new Text(
                      ytResult[index].title,
                      softWrap: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                    new Text(
                      ytResult[index].channelTitle,
                      softWrap: true,
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                    new Text(
                      ytResult[index].url,
                      softWrap: true,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
