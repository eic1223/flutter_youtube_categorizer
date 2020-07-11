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
    setDummyData();
  }

  void setDummyData() {
    Category sampleCat1 = Category("프로그래밍", [
      Channel("UCwXdFgeE9KYzlDdR7TG9cMw", "Flutter",
          "https://yt3.ggpht.com/a/AATXAJzNfvJ02vLWy52VQ6UOAuHYnqGCOmsR-3WRCjxM=s176-c-k-c0x00ffffff-no-rj-mo"),
      Channel("UCVHFbqXqoYvEWM1Ddxl0QDg", "Android Developers",
          "https://yt3.ggpht.com/a/AATXAJxn7hsXzaDLEJRpzYgfXlcsc4exElXJnT4yBakfsw=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCJm7i4g4z7ZGcJA_HKHLCVw", "The Flutter Way",
          "https://yt3.ggpht.com/a/AATXAJzEkV2uEs372uXglnQSiNTSUxAV1kBCHhNHk5BI=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UC_Fh8kvtkVPkeihBs42jGcA", "Coding in Flow",
          "https://yt3.ggpht.com/a/AATXAJxBWgqGrP1UDlTUL4fF9dk2U_s0kfslRpC-TtJzJQ=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCU8Mj6LLoNBXqqeoOD64tFg", "Fun with Flutter",
          "https://yt3.ggpht.com/a/AATXAJxIfovNRQRcF-2cEZJnjIFOKloJJhhAfMar390m=s100-c-k-c0xffffffff-no-rj-mo"),
    ]);

    Category sampleCat3 = Category("재밌는 유튜버", [
      Channel("UC9ZLv1m7QDLv991X1-p50AA", "보물섬",
          "https://yt3.ggpht.com/a/AATXAJxBWWQO4FcL4fZoFwhAU6FR4Fqd4k3MI_nLCYEy=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCwx6n_4OcLgzAGdty0RWCoA", "워크맨-Workman",
          "https://yt3.ggpht.com/a/AATXAJw57QrSDhEyMDDqzGegODvbKXGjyFxaHAlE5B_z=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCuq9WVWcsaRqOr3K8E9VkQQ", "조충현",
          "https://yt3.ggpht.com/a/AATXAJw8eCQtVEV2avsO6DJhobiPSi4E2J4Fm10viFDOOw=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCFsyeRb-ShbdPQ2azhd6-fg", "주호민",
          "https://yt3.ggpht.com/a/AATXAJyc2ZzXSQRb--trNgQhyjyypkH8kXTOgRM2Xy6LLw=s100-c-k-c0xffffffff-no-rj-mo"),
    ]);

    Category sampleCat4 = Category("K-POP", [
      Channel("UCzgxx_DM2Dcb9Y1spb9mUJA", "TWICE",
          "https://yt3.ggpht.com/a/AATXAJx3UH5xaSZuSe5QcIJAJ7CyflXhedAvodBwgXEd=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel(
          "UCCRb6nYKaT8tzLA8CwDdUtw",
          "TWICE JAPAN OFFICIAL YouTube Channel",
          "https://yt3.ggpht.com/a/AATXAJxlF2Mum42ljacq6XM-ub92gnAE5sgPFcFb-POd5A=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UC-qYkzKFdekoEniRu_FS3zg", "OH MY GIRL",
          "https://yt3.ggpht.com/a/AATXAJxjBvF7AA6hgOK0I1c2BFDIIHMGQkQNW8vOThZTfA=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCk9GmdlDTBfgGRb7vXeRMoQ", "Red Velvet",
          "https://yt3.ggpht.com/a/AATXAJw6VykwLbFEYKZtNhSTUckytoMvR-xz9WSARJr2MQ=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCfkXDY7vwkcJ8ddFGz8KusA", "SEVENTEEN",
          "https://yt3.ggpht.com/a/AATXAJy-u4OZjKzBVHU3aEYEo0IXwGPjO5CaFG7brdxoVg=s100-c-k-c0xffffffff-no-rj-mo"),
    ]);

    Category sampleCat5 = Category("경제/투자", [
      Channel("UCsJ6RuBiTVWRX156FVbeaGg", "슈카월드",
          "https://yt3.ggpht.com/a/AATXAJx63JpAkUWCO_hLzWmp9XPnurI3Hb1ArvTmW62N=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCvAxoPfCKtMcpuEPNjSsY_Q", "빌사남TV",
          "https://yt3.ggpht.com/a/AATXAJyFRL-WtlgouOnsoXwxAzG1nPaA4LayWiR63sdl6Q=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCaJdckl6MBdDPDf75Ec_bJA", "신사임당",
          "https://yt3.ggpht.com/a/AATXAJx0Zkz7S5XVAxbjyVToJEOnkrGAC5ijCEhhV-jl8A=s100-c-k-c0xffffffff-no-rj-mo"),
    ]);

    Category sampleCat6 = Category("홈트", [
      Channel("UCpg89Ys3E4BaLGgEEWVmI9g", "Thankyou BUBU",
          "https://yt3.ggpht.com/a/AATXAJwQQVXdrWflFmYRMcebshUdQCnciYqRe961xh6AKw=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UC6vAqaWrNipKV3qVfpttoXw", "알로하써니AlohaSunny",
          "https://yt3.ggpht.com/a/AATXAJx7TRiaHu68LD_rqCJzQ44iFLUCWOq13An_pC-g=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UC4yq3FWEWqMvFNFBsV3gbKQ", "힙으뜸",
          "https://yt3.ggpht.com/a/AATXAJxZdZRyqe_OHqpn9XJWjJk5JtPxb7815KZxA4euOQ=s100-c-k-c0xffffffff-no-rj-mo"),
      Channel("UCKBaqaU8eSc-49MPU1umhkA", "미나홈트",
          "https://yt3.ggpht.com/a/AATXAJzvHAWHbycgFbSdcNeRWLTL3SugfjyHqm6TgoZxfQ=s100-c-k-c0xffffffff-no-rj-mo"),
    ]);

    categories.add(sampleCat1);
    categories.add(sampleCat3);
    categories.add(sampleCat4);
    categories.add(sampleCat5);
    categories.add(sampleCat6);

    //
    print("샘플 데이터 들어감");
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
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => {_addNewCategory(context)},
                  ),
                ),
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

  _addNewCategory(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryEditScreen()), // 파라미터 없이 생
    );

    // print(result.getCategoryName());
    // print(result.getChannelList()[0]);

    setState(() {
      if (result != null) {
        categories.add(
            new Category(result.getCategoryName(), result.getChannelList()));
      }
    });
  }
}
