![deep_logo_horizontal.png](images/light_logo_horizontal.png)

# 框架基础使用
# 页面基类需继承BaseView<Controller> 支持如下自定义特性
```
  /// 设置页面的初始状态，默认值为loading
  LoadStatusX initStatus(){}
  /// 默认标题
  String getTitle() {}
  /// 是否使用Scaffold
  bool isUseScaffold() {}
  /// 标题右侧按钮
  List<Widget>? actions() {}
```
# 列表页面需继承基类BaseListView<BaseListController>
    # 重写onRefresh onLoadMore
    # 添加输数需调用addData(isRefresh,data)

# 页面控制器基类 BaseController
    # 更新页面加载状态可调用BaseController.updateLoadStatus(LoadStatusX)

# 列表控制器基类 BaseListController

# 通用确认弹框
```
     showAnimatedDialog(
       context: context,
       barrierDismissible: false,
       animationType: DialogTransitionType.fadeScale,
       builder: (BuildContext context) {
         return DialogConfirm(
           title: "xxx",
           content:"xxx",
           confirmFun: () {},
         );
       },
     );

```
# 通用编辑框弹框
```
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
```

# 网络请求
    # 网络请求工具类HttpUtil
    # 在controller中使用时建议如下链式调用，在回调方法中使用BaseController或BaseListController进行页面交互
```
    await WorkflowApi.task(limit, offset, 'string', typeName)
            .then((pageResp) {
              addData(true, pageResp);
            })
            .onError((error, stackTrace) {})
            .whenComplete(() {});
```
# 生成图片路径脚本，在AIcons.dart中查看
```
    iOS:python auto/build_ios.py
    Android:python auto/icons.py
```
# 图片加载方式如下
```
    /// 本地图片加载方式
    AImage.localImage(AIcons.back_black,
                            size: Size(64.w, 64.w)),
    /// 网络图片加载方式
    AImage.netImage(AIcons.placeholder,
                            url: value[index]['icon'], size: Size(64.w, 64.w)),

```