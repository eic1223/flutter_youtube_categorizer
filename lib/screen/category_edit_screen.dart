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
  Color originCategoryColor;
  List<Channel> originChannels;

  CategoryEditScreen(
      {this.originCategoryName, this.originCategoryColor, this.originChannels});

  @override
  _CategoryEditScreenState createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  String categoryName = "";
  Color originCategoryColor = Colors.teal;
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

    swatch = Colors.teal;
  } //

  Row buildSwatchRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150.0,
          child: RaisedButton(
            child: Text("Swatch Picker"),
            onPressed: () => showMaterialSwatchPicker(
              context: context,
              selectedColor: swatch,
              onChanged: (value) => setState(() => originCategoryColor = value),
            ),
          ),
        ),
        Expanded(child: Container()),
        Container(
          height: 20.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: originCategoryColor,
          ),
        ),
      ],
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => {
                    showMaterialSwatchPicker(
                      context: context,
                      selectedColor: swatch,
                      onChanged: (value) =>
                          setState(() => originCategoryColor = value),
                    )
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.only(left: 10, right: 20),
                    decoration: new BoxDecoration(
                        color: originCategoryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 2, color: Colors.black12)),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 60,
                    margin: EdgeInsets.only(bottom: 10, right: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
                      ),
                    ),
                    child: Row(children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: TextField(
                            controller: nameController,
                            onChanged: (text) =>
                                {categoryName = text.toString()},
                            style: TextStyle(color: Colors.black, fontSize: 32),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Category Name',
                                hintStyle: TextStyle(color: Colors.grey[300])),
                            cursorColor: Colors.blue,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                /*Text(
                  "CATEGORY EDIT",
                  style: TextStyle(fontSize: 30),
                ),*/
                FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                    ),
                    onPressed: () => {
                          (categoryName == null || categoryName == "")
                              ? _showDialogNoName()
                              : (channels == null || channels.length == 0)
                                  ? _showDialogNoChannel()
                                  : Navigator.pop(context, categoryData())
                        }),
              ],
            ),
            Padding(padding: EdgeInsets.all(4)),
            Expanded(
              child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (_, int index) => listItem(index)),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 60,
                    margin: EdgeInsets.only(bottom: 6, right: 10),
                    padding: EdgeInsets.only(left: 20, right: 10),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: Row(children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: TextField(
                            controller: searchController,
                            onChanged: (text) {
                              query = text.toString();
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search & Add Channel',
                                hintStyle: TextStyle(color: Colors.grey[500])),
                            cursorColor: Colors.blue,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: Colors.pinkAccent,
                    child: Icon(
                      Icons.search,
                    ),
                    onPressed: () => {
                          (query == null || query == "")
                              ? _showDialogNoSearchQuery()
                              : _showCategoryVideos(context),
                        }),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
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
    return new Card(
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () => {},
              child: new Row(
                children: <Widget>[
                  new Image.network(
                    channels[index].thumb,
                    width: 64,
                    height: 64,
                  ),
                  new Padding(padding: EdgeInsets.only(right: 20.0)),
                  new Expanded(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        new Text(
                          channels[index].title,
                          softWrap: true,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                        new Text(
                          channels[index].id,
                          softWrap: true,
                        ),
                      ]))
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => {
                    setState(() => {channels.removeAt(index)}),
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.black45,
                  ),
                )),
          ],
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
          builder: (context) => ChannelSearchScreen("검색 결과", query)),
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
    Category temp = new Category(categoryName, Colors.teal, channels);
    SharedPrefController.addString("testKey", temp.toJson().toString());
    /*temp.name = channelName;
    temp.color = Colors.teal;
    temp.channelList.addAll(channels);*/
    return temp;
  }
}
