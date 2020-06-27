import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutteryoutubecategorizer/constant_values.dart';
import 'package:flutteryoutubecategorizer/model/category.dart';
import 'package:flutteryoutubecategorizer/screen/category_edit_screen.dart';
import 'package:youtube_api/youtube_api.dart';

class VideoListScreen extends StatefulWidget {
  //final List<String> channelIds;
  final Category originCategory;

  /*VideoListScreen(
      this.originCategory, this.channelIds);*/
  VideoListScreen(this.originCategory);

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
    maxResults: 5,
  );
  List<YT_API> ytResult = [];
  List<YT_API> ytResultTotal = [];

  callVideosByChannelId(List<String> channelIds) async {
    print('callVideosByChannelId() called');

    for (int i = 0; i < channelIds.length; i++) {
      print(channelIds[i]);
      ytResult = await ytApi.channel(channelIds[i]);
      ytResultTotal.addAll(ytResult);
    }

    setState(() {
      print(ytResult);
      print('callVideosByChannelId() updated');
    });
  }

  //

  @override
  void initState() {
    super.initState();
    print(widget.originCategory.getChannelIds());
    callVideosByChannelId(widget.originCategory.getChannelIds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 50,
          right: 15,
        ),
        child: Column(
          children: [
            buildHeaderWidget(context),
            Expanded(
              child: new Container(
                height: 400,
                child: ListView.builder(
                    //itemCount: ytResult.length,
                    itemCount: ytResultTotal.length,
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
          margin: EdgeInsets.only(bottom: 20, left: 10),
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                //widget.ui_title,
                widget.originCategory.name,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: Theme.of(context).primaryColor),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
              InkWell(
                  onTap: () => {
                        _navigateAndDisplaySelection(context),
                      },
                  child: Icon(Icons.edit)),
            ],
          ),
        ),
      ],
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
    return new Card(
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        child: InkWell(
          onTap: () => {
            /*print(ytResult[index].channelTitle +
                ", " +
                ytResult[index].channelId),*/
            Navigator.pop(context, ytResult[index].channelId),
          },
          child: new Row(
            children: <Widget>[
              new Image.network(
                //ytResult[index].thumbnail['default']['url'],
                ytResultTotal[index].thumbnail['default']['url'],
              ),
              new Padding(padding: EdgeInsets.only(right: 20.0)),
              new Expanded(
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    new Text(
                      //ytResult[index].title,
                      ytResultTotal[index].title,
                      softWrap: true,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                    new Text(
                      //ytResult[index].channelTitle,
                      ytResultTotal[index].channelTitle,
                      softWrap: true,
                    ),
                    /*new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                    new Text(
                      //ytResult[index].url,
                      ytResultTotal[index].url,
                      softWrap: true,
                    ),*/
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  // SelectionScreen을 띄우고 navigator.pop으로부터 결과를 기다리는 메서드
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      /*MaterialPageRoute(
          builder: (context) => CategoryEditScreen(),*/
      MaterialPageRoute(
          builder: (context) => CategoryEditScreen(
              originCategoryName: widget.originCategory.name,
              originCategoryColor: widget.originCategory.color,
              originChannels: widget.originCategory.getChannelList())),
    );

    // 선택 창으로부터 결과 값을 받은 후 프린트
    //print("$result");
    print("수정된 사항:");
    if (result != null) {
      print(result);
      print(result.getCategoryName());
      print(result.getCategoryColor());
      print(result.getChannelList());
      print(result.getChannelCount());
      print(result.getChannelList()[0].getChannelId());
      print(result.getChannelList()[0].getChannelTitle());
      print(result.getChannelList()[0].getChannelThumb());

      setState(() {
        widget.originCategory.updateCategory(result.getCategoryName(),
            result.getCategoryColor(), result.getChannelList());
      });
    }
  }
}
