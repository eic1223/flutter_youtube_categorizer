import 'package:flutter/material.dart';
import 'package:flutteryoutubecategorizer/model/category.dart';
import 'package:flutteryoutubecategorizer/model/channel.dart';
import 'package:flutteryoutubecategorizer/screen/category_edit_screen.dart';
import 'package:flutteryoutubecategorizer/widget/category_button.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "아 시발",
      home: HomeScreen(),
      //home: FlappyTest(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Channel> channelsSample1 = [];
  List<Channel> channelsSample2 = [];
  List<Channel> channelsSample3 = [];

  @override
  void initState() {
    super.initState();
    setInitialData();
  }

  void setInitialData() {
    channelsSample1.add(new Channel(
        "UCwXdFgeE9KYzlDdR7TG9cMw",
        "Flutter Offical",
        "https://yt3.ggpht.com/a/AATXAJyPMywRmD62sfK-1CXjwF0YkvrvnmaaHzs4uw=s100-c-k-c0xffffffff-no-rj-mo"));
    channelsSample1.add(new Channel("UCUH2DSbsNUz2sW3kBNn4ibw", "더코딩파파",
        "https://yt3.ggpht.com/a/AATXAJzOLdHngmBM2inMsULvh3X_UVIB5CNOaWuS7g=s100-c-k-c0xffffffff-no-rj-mo"));
    categories.add(new Category("Flutter", channelsSample1));
    //
    channelsSample2.add(new Channel("UCzgxx_DM2Dcb9Y1spb9mUJA", "TWICE",
        "https://yt3.ggpht.com/a/AATXAJyPqlLtvmnqdfcM_DjUC4ezEP3fR5bvIwciZw=s100-c-k-c0xffffffff-no-rj-mo"));
    channelsSample2.add(new Channel("UCLkAepWjdylmXSltofFvsYQ", "방탄TV",
        "https://yt3.ggpht.com/a/AATXAJx0HZh4j0rBz9VYVSQ2nTLHq7exr0hKpC_Ckg=s100-c-k-c0xffffffff-no-rj-mo"));
    channelsSample2.add(new Channel("UC3SyT4_WLHzN7JmHQwKQZww", "IU",
        "https://yt3.ggpht.com/a/AATXAJwlhf14vwfayPqC4y9Ig5_a0iiPP6M74edvqQ=s100-c-k-c0xffffffff-no-rj-mo"));
    categories.add(new Category("K-POP", channelsSample2));
    //
    channelsSample3.add(new Channel("UC3SyT4_WLHzN7JmHQwKQZww", "IU",
        "https://yt3.ggpht.com/a/AATXAJwlhf14vwfayPqC4y9Ig5_a0iiPP6M74edvqQ=s100-c-k-c0xffffffff-no-rj-mo"));
    categories.add(new Category("아이유", channelsSample3));
    //
    print("초기 데이터 들어감");
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
                colors: [Colors.indigoAccent, Colors.pinkAccent])),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "CATEGORY",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: List.generate(categories.length, (index) {
                    return CategoryButton(
                      categories[index],
                    );
                  }),
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {_navigateAndDisplaySelection(context)},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listCategory(index) {
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 7.0),
      child: new Column(
        children: <Widget>[
          CategoryButton(categories[index]),
        ],
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryEditScreen()),
    );

    // 선택 창으로부터 결과 값을 받은 후 프린트
    /*print("$result");
    print(result['categoryName']);
    print(result['channelList']);
    setState(() {
      categories.add(new Category(result['categoryName'],
          result['categoryColor'], result['channelList']));
      print("ㄴ새 카테고리 생성 완료");
    });*/

    /*Category loadedData = Category.fromJson(
        jsonDecode(SharedPrefController.getString("testKey")));
    print("====");
    print(loadedData.name);
    print("====");*/

    setState(() {
      if (result != null) {
        categories.add(
            new Category(result.getCategoryName(), result.getChannelList()));
      }
    });
  }
}
