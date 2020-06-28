import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteryoutubecategorizer/constant_values.dart';
import 'package:flutteryoutubecategorizer/controller/sharedPrefController.dart';
import 'package:flutteryoutubecategorizer/model/category.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:flutteryoutubecategorizer/screen/channel_search_screen.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class CategoryEditScreen extends StatefulWidget {
  String originCategoryName;
  List<Channel> originChannels;

  CategoryEditScreen([this.originCategoryName, this.originChannels]);

  @override
  _CategoryEditScreenState createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  String categoryName = "";
  List<Channel> channels = [];

  Color swatch;

  String query = "";
  TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    if (widget.originCategoryName != null) {
      categoryName = widget.originCategoryName;
      nameController =
          new TextEditingController(text: widget.originCategoryName);
    }
    if (widget.originChannels != null) {
      channels = widget.originChannels;
    }
  } //

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
                colors: [Colors.teal, Colors.indigo])),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                    "NEW CATEGORY",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "CATEGORY NAME",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Center(
                      child: TextField(
                        controller: nameController,
                        onChanged: (text) => {categoryName = text.toString()},
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Category Name',
                            hintStyle: TextStyle(color: Colors.grey)),
                        cursorColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "CHANNELS",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              //Padding(padding: EdgeInsets.all(2)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          height: 50,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Center(
                              child: TextField(
                                controller: searchController,
                                onChanged: (text) {
                                  query = text.toString();
                                },
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search & Add Channel',
                                    hintStyle: TextStyle(color: Colors.grey)),
                                cursorColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          (query == null || query == "")
                              ? _showDialogNoSearchQuery()
                              : _showCategoryVideos(context),
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    itemCount: channels.length,
                    itemBuilder: (_, int index) => listItem(index)),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              /*Expanded(
                child: Container(),
              ),*/
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: InkWell(
                    onTap: () => {
                      (categoryName == null || categoryName == "")
                          ? _showDialogNoName()
                          : (channels == null || channels.length == 0)
                              ? _showDialogNoChannel()
                              : Navigator.pop(context, categoryData())
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orangeAccent),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
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
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: () => {},
          child: new Row(
            children: <Widget>[
              new Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(channels[index].thumb))),
              ),
              /*new Image.network(
                channels[index].thumb,
                width: 60,
                height: 60,
              ),*/
              new Padding(padding: EdgeInsets.only(right: 16)),
              new Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        channels[index].title,
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      new Text(
                        channels[index].id,
                        softWrap: true,
                      ),
                    ]),
              )),
              InkWell(
                onTap: () => {
                  setState(() => {channels.removeAt(index)}),
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.delete,
                    color: Colors.black45,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showCategoryVideos(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChannelSearchScreen("Search: $query", query)),
    );

    print("결과는 : $result");
    print(result['channelId']);
    print(result['channelTitle']);
    print(result['channelThumb']);

    setState(() {
      channels.add(new Channel(
          result['channelId'], result['channelTitle'], result['channelThumb']));
    });
  }

  Future<void> _showDialogNoSearchQuery() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('채널을 찾고 있나요?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('검색어를 입력해주세요 :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogNoName() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카테고리 이름이 없어요'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('카테고리 이름을 입력하고 저장해주세요 :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogNoChannel() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('등록된 채널이 없어요'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('채널을 등록하고 저장해주세요 :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Category categoryData() {
    Category temp = new Category(categoryName, channels);
    SharedPrefController.addString("testKey", temp.toJson().toString());
    /*temp.name = channelName;
    temp.color = Colors.teal;
    temp.channelList.addAll(channels);*/
    return temp;
  }
}
