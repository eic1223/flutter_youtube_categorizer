import 'package:flutter/material.dart';
import 'package:flutteryoutubecategorizer/model/category.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:flutteryoutubecategorizer/screen/category_edit_screen.dart';
import 'package:flutteryoutubecategorizer/screen/channel_search_screen.dart';
import 'package:flutteryoutubecategorizer/screen/video_list_screen.dart';

class CategoryButton extends StatefulWidget {
  String name;
  Color color;
  List<String> channelIds;
  Category category;
  CategoryButton(this.name, this.color, this.channelIds, {this.category});

  @override
  _CategoryButtonState createState() =>
      _CategoryButtonState(this.name, this.color, this.channelIds);
}

class _CategoryButtonState extends State<CategoryButton> {
  String name;
  Color color;
  List<String> channelIds;

  _CategoryButtonState(this.name, this.color, this.channelIds);

  @override
  void initState() {
    print(widget.channelIds);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: () => {_showCategoryVideos(context)},
      onTap: () => {
        Navigator.push(
          context,
          /*MaterialPageRoute(
              builder: (context) =>
                  VideoListScreen("카테고리: ${widget.name}", widget.channelIds)),*/
          MaterialPageRoute(
              builder: (context) => VideoListScreen(widget.category)),
        )
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: Text(widget.name,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black26,
                width: 3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => {_navigateAndDisplaySelection(context)},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /*_showCategoryVideos(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              VideoListScreen("카테고리의 영상들", )),
    );

    print("선택된 채널 Id는 : $result");
  }*/

  // SelectionScreen을 띄우고 navigator.pop으로부터 결과를 기다리는 메서드
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryEditScreen()),
    );

    // 선택 창으로부터 결과 값을 받은 후 프린트
    //print("$result");
    print("꺼내자 : ");
  }
}
