import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';

class Category extends ChangeNotifier {
  String name = "";
  Color color;
  List<Channel> _channelList = [];
  Category(this.name, this.color, this._channelList);

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        color = json['color'],
        _channelList = json['_channelList'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['color'] = this.color;
    data['_channelList'] = this._channelList;
    return data;
  }

  getCategoryName() => name;
  getCategoryColor() => color;
  getChannelList() => _channelList;
  getChannelCount() => _channelList.length;

  List<String> getChannelIds() {
    List<String> temp = [];

    for (int i = 0; i < _channelList.length; i++) {
      temp.add(_channelList[i].id);
    }

    print(temp);
    print("?");
    return temp;
  }

  //

  UnmodifiableListView<Channel> get channelList =>
      UnmodifiableListView(_channelList);

  void addChannel(Channel channel) {
    _channelList.add(channel);
    notifyListeners();
  }

  void addCategory(String name, Color color, List<Channel> channels) {
    Category(name, color, channels);
    notifyListeners();
  }

  void updateCategory(
      String newName, Color newColor, List<Channel> newChannels) {
    name = newName;
    color = newColor;
    _channelList = [];
    _channelList.addAll(newChannels);
    notifyListeners();
  }
}
