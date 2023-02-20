import 'package:flutter/material.dart';

// 引入轮播图插件
import 'package:flutter_swiper/flutter_swiper.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);
  @override
  _SwiperPageState createState() => _SwiperPageState();
}

class _SwiperPageState extends State<IndexPage> {
  // 轮播图片
  List<Map> imageList = [
    {"img": "images/bg_center1.png"},
    {"img": "images/bg_center2.png"},
    {"img": "images/bg_center1.png"},
    {"img": "images/bg_center2.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            height: 30,
            width: 130,
            child: OutlinedButton.icon(
                onPressed: () {
                  print("object");
                },
                icon: Icon(Icons.cabin_sharp),
                label: Text("")),
          ),
          Container(
            height: 30,
            width: 80,
          ),
          Wrap(
            spacing: 4,
            children: [
              OutlinedButton.icon(
                  onPressed: () {
                    print("object");
                  },
                  icon: Icon(Icons.search),
                  label: Text("")),
              OutlinedButton.icon(
                  onPressed: () {
                    print("object");
                  },
                  icon: Icon(Icons.add),
                  label: Text("")),
              OutlinedButton.icon(
                  onPressed: () {
                    print("object");
                  },
                  icon: Icon(Icons.format_line_spacing_outlined),
                  label: Text("")),
            ],
          ),
        ],
      ),
      Container(
        width: double.infinity,
        child: AspectRatio(
          // 配置宽高比
          aspectRatio: 32 / 9,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              // 配置图片地址
              // return Image.network(
              //   imageList[index]["url"],
              //   fit: BoxFit.fill,
              // );
              return Image.asset(
                imageList[index]["img"].toString(),
                fit: BoxFit.fill,
              );
            },
            // 配置图片数量
            itemCount: imageList.length,
            // 底部分页器
            pagination: new SwiperPagination(),
            // 左右箭头
            control: new SwiperControl(),
            // 无限循环
            loop: true,
            // 自动轮播
            autoplay: true,
          ),
        ),
      ),
      Container(
        // 快捷入口
        height: 130,
        width: 430,
        color: Colors.blue,
      ),
      Container(
        // 常用应用
        height: 180,
        width: 430,
        color: Colors.red,
      ),
      Container(
        // 数据监测
        height: 220,
        width: 430,
        color: Colors.green,
      ),
    ]));
  }
}
