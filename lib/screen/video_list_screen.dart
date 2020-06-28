import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutteryoutubecategorizer/constant_values.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:html_unescape/html_unescape.dart';

class VideoListScreen extends StatefulWidget {
  /*final Category originCategory;
  VideoListScreen(this.originCategory);*/

  final Channel channelToShow;
  VideoListScreen(this.channelToShow);

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

  callVideosByChannelId(String channelId) async {
    print('callVideosByChannelId() : $channelId');
    ytResult = await ytApi.channel(channelId);

    setState(() {
      print(ytResult);
      print('callVideosByChannelId() updated');
    });
  }

  //

  @override
  void initState() {
    super.initState();
    callVideosByChannelId(widget.channelToShow.getChannelId());
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
                      widget.channelToShow.getChannelTitle(),
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
                      //itemCount: ytResult.length,
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
          height: 80,
          margin: EdgeInsets.all(6),
          child: InkWell(
            onTap: () => {
              //print(ytResult[index].url.replaceAll(" ", "")),
              _launchYoutubeURL(ytResult[index].url.replaceAll(" ", "")),
            },
            child: Row(
              children: <Widget>[
                Image.network(
                  ytResult[index].thumbnail['default']['url'],
                ),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(
                        //ytResult[index].title,
                        HtmlUnescape().convert(ytResult[index].title),
                        softWrap: true,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 1.5)),
                      Text(
                        ytResult[index].publishedAt.substring(0, 10),
                        softWrap: true,
                      ),
                    ]))
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
