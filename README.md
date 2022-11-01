# orginone

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 框架基础使用
# 页面基类需继承BaseView<Controller> 支持如下自定义特性
<!--
  /// 设置页面的初始状态，默认值为loading
  LoadStatusX initStatus(){}
  /// 默认标题
  String getTitle() {}
  /// 是否使用Scaffold
  bool isUseScaffold() {}
  /// 标题右侧按钮
  List<Widget>? actions() {} -->

# 列表页面需继承基类BaseListView<BaseListController>
    # 重写onRefresh onLoadMore
    # 添加输数需调用addData(isRefresh,data)

# 页面控制器基类 BaseController
    # 更新页面加载状态可调用BaseController.updateLoadStatus(LoadStatusX)

# 列表控制器基类 BaseListController

# 通用确认弹框
    <!--
     showAnimatedDialog(
       context: context,
       barrierDismissible: false,
       animationType: DialogTransitionType.fadeScale,
       builder: (BuildContext context) {
         return DialogSure(
           title: "xxx",
           content:"xxx",
           confirmFun: () {},
         );
       },
     );
     -->
# 通用编辑框弹框
    <!--
     showAnimatedDialog(
       context: context,
       barrierDismissible: false,
       animationType: DialogTransitionType.fadeScale,
       builder: (BuildContext context) {
         return DialogEdit(
           title: "xxx",
           content:"xxx",
           confirmFun: (content) {},
         );
       },
     );
     -->


