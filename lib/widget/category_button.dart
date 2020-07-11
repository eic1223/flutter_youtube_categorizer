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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoListScreen(
                    widget.category.getCategoryName(),
                    widget.category.getChannelList())),
          )
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: isExpanded ? 172 : 68,
          child: Column(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: <Widget>[
                          Text(widget.category.getCategoryName(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:
                                Text("(${widget.category.getChannelCount()})",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                          ),
                          InkWell(
                            onTap: () => {_editCategory(context)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ),
              isExpanded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 88,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  widget.category.getChannelList().length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChannelIcon(
                                    widget.category.getChannelList()[index]);
                              },
                            ),
                          ),
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

  _editCategory(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryEditScreen(
              widget.category.getCategoryName(),
              widget.category.getChannelList())),
    );

    //print("$result");

    setState(() {
      if (result != null) {
        widget.category
            .updateCategory(result.getCategoryName(), result.getChannelList());
      }
    });
  }
}

class ChannelIcon extends StatelessWidget {
  ChannelIcon(
    this.ch,
  );

  final Channel ch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoListScreen(ch.title, [ch])),
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
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(ch.getChannelThumb()))),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  ch.getChannelTitle(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
