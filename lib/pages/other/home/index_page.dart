import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:getwidget/getwidget.dart';

// import 'package:orginone/components/unified.dart';

// TODO 先完成界面设计，再完成功能，界面兼容性，最后整理代码

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);
  @override
  _SwiperPageState createState() => _SwiperPageState();
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin;

  TestFlowDelegate({this.margin = EdgeInsets.zero});

  double width = 0;
  double height = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i)!.width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i)!.height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // 指定Flow的大小，简单起见我们让宽度竟可能大，但高度指定为200，
    // 实际开发中我们需要根据子元素所占用的具体宽高来设置Flow大小
    return Size(double.infinity, 160.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
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
          const SizedBox(
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
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text("快捷入口")),
            Container(
              padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.red,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
          // 常用应用
          child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text("常用应用")),
          Flow(
            delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.red,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
                child: const Text(
                  '资产监管平台',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center, // 文本水平对齐方式
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.blue,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.blue,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.brown,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.purple,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.blue,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.brown,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                // color: Colors.purple,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg_center1.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(1000)),
              ),
            ],
          ),
        ],
      )),
      Container(
          // 数据监测
          child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text("数据检测")),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(13.0),
                    width: 180.0,
                    height: 90.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 11,
                  ),
                  Container(
                    width: 180.0,
                    height: 90.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          )),
          Container(
            height: 1,
          ),
          Container(
              child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(13.0),
                    width: 180.0,
                    height: 90.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 11,
                  ),
                  Container(
                    width: 180.0,
                    height: 90.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          )),
        ],
      )),
    ]));
  }
}
