import 'package:flutter/material.dart';
import 'package:flutteryoutubecategorizer/model/category.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:flutteryoutubecategorizer/screen/category_edit_screen.dart';
import 'package:flutteryoutubecategorizer/screen/video_list_screen.dart';

class CategoryButton extends StatefulWidget {
  Category category;

  CategoryButton(this.category);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isExpanded = false;
  //List<String> channelIds;

  //_CategoryButtonState();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
      child: InkWell(
        /*onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoListScreen(widget.category)),
          )
        },*/
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: isExpanded ? 200 : 60,
          child: Column(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(widget.category.getCategoryName(),
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: isExpanded
                          ? Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                              size: 50,
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 50,
                            ),
                    ),
                  ),
                ],
              ),
              isExpanded
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            for (Channel i in widget.category.getChannelList())
                              InkWell(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoListScreen(i)),
                                  )
                                },
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      i.getChannelThumb()))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            i.getChannelTitle(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () =>
                                  {_navigateAndDisplaySelection(context)},
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    color: Colors.transparent),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.black26,
              width: 1,
            ),
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
      MaterialPageRoute(
          builder: (context) => CategoryEditScreen(
              widget.category.getCategoryName(),
              widget.category.getChannelList())),
    );

    // 선택 창으로부터 결과 값을 받은 후 프린트
    //print("$result");
    print("꺼내자 : ");
  }
}
