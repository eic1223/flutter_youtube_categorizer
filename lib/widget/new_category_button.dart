import 'package:flutter/material.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:flutteryoutubecategorizer/screen/category_edit_screen.dart';
import 'package:flutteryoutubecategorizer/screen/channel_search_screen.dart';
import 'package:flutteryoutubecategorizer/screen/video_list_screen.dart';
import 'package:provider/provider.dart';

class NewCategoryButton extends StatefulWidget {
  String name;
  Color color;
  NewCategoryButton(this.name, this.color);

  @override
  _NewCategoryButtonState createState() =>
      _NewCategoryButtonState(this.name, this.color);
}

class _NewCategoryButtonState extends State<NewCategoryButton> {
  String name;
  Color color;

  _NewCategoryButtonState(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: () => {_showCategoryVideos(context)},
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryEditScreen()),
        )
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: Icon(
                Icons.add_circle_outline,
                size: 30,
              ),
            ),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black45,
                width: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
