import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutteryoutubecategorizer/constant_values.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:html_unescape/html_unescape.dart';

class VideoListScreen extends StatefulWidget {
  final String name;
  final List<Channel> channelsToShow;
  VideoListScreen(this.name, this.channelsToShow);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  //
  static String key =
      ConstantValues.YoutubeDataApiKey; // ** ENTER YOUTUBE API KEY HERE **

  YoutubeAPI ytApi = new YoutubeAPI(
    key,
    type: "video",
    maxResults: 10,
  );
  List<YT_API> ytResult = [];

  List<List<YT_API>> ytResultList = [];

  callVideosByChannelId(String channelId) async {
    print('callVideosByChannelId() : $channelId');
    ytResult = await ytApi.channel(channelId);

    setState(() {
      print(ytResult);
      print('callVideosByChannelId() updated');
    });
  }

  callVideosByCategory(List<String> channelIds) async {
    print("category name");

    for (int i = 0; i < channelIds.length; i++) {
      ytResultList.add(await ytApi.channel(channelIds[i]));
    }

    for (List<YT_API> eachResult in ytResultList) {
      ytResult.addAll(eachResult);
    }

    ytResult.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    ytResult.reversed.toList();

    setState(() {
      print(ytResult);
      print("callVideosByCategory updated");
    });
  }

  //

  @override
  void initState() {
    super.initState();

    List<String> channelIds = [];
    for (Channel channel in widget.channelsToShow) {
      channelIds.add(channel.getChannelId());
    }

    callVideosByCategory(channelIds);
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
                colors: [Colors.pink, Colors.indigo])),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                        )),
                    Text(
                      //widget.ui_title,
                      /*widget.channelToShow.getChannelTitle(),*/
                      widget.name,
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          color: Colors.white),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ],
                ),
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

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }

  //

  Widget listItem(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      child: Card(
        elevation: 2,
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: (MediaQuery.of(context).size.width * 9) / 16 + 60,
          margin: EdgeInsets.all(6),
          child: InkWell(
            onTap: () => {
              //print(ytResult[index].url.replaceAll(" ", "")),
              _launchYoutubeURL(ytResult[index].url.replaceAll(" ", "")),
            },
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.width * 9) / 16,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            ytResult[index].thumbnail['medium']['url'],
                          ),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ytResult[index].channelTitle,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ytResult[index].publishedAt.substring(0, 10),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 1)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    //ytResult[index].title,
                    HtmlUnescape().convert(ytResult[index].title),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchYoutubeURL(String youtubeId) async {
    String target = youtubeId;
    if (await canLaunch(target)) {
      //await launch(target, forceSafariVC: false);
      await launch(target);
    } else {
      throw 'Could not launch $target';
    }
  }

  // SelectionScreen을 띄우고 navigator.pop으로부터 결과를 기다리는 메서드
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    /*final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryEditScreen(
              originCategoryName: widget.originCategory.name,
              originChannels: widget.originCategory.getChannelList())),
    );*/

    // 선택 창으로부터 결과 값을 받은 후 프린트
    //print("$result");
    /*print("수정된 사항:");
    if (result != null) {
      print(result);
      print(result.getCategoryName());
      print(result.getCategoryColor());
      print(result.getChannelList());
      print(result.getChannelCount());
      print(result.getChannelList()[0].getChannelId());
      print(result.getChannelList()[0].getChannelTitle());
      print(result.getChannelList()[0].getChannelThumb());*/

    /*setState(() {
        widget.originCategory.updateCategory(result.getCategoryName(),
            result.getCategoryColor(), result.getChannelList());
      });*/
  }
}
