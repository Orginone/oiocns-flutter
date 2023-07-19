<img width="1060" alt="image" src="https://user-images.githubusercontent.com/8328012/201800690-9f5e989e-4ed3-4817-85b9-b594ac89fd31.png">  
奥集能是面向下一代互联网发展趋势，基于动态演化的复杂系统多主体建模方法，以所有权作为第一优先级，运用零信任安全机制，按自组织分形方法提炼和抽象“沟通、办事、仓库、商店、市场和设置”等基础功能，为b端和c端融合的全场景业务的提供新一代分布式应用架构。

# 项目目录

```
├── assets                              // 静态资源
├── android                             // android 原生实现
├── ios                                 // ios 原生实现
├── web                                 // web 原生实现
├── linux                               // linux 原生实现
├── macos                               // macos 原生实现
├── windows                             // windows 原生实现
└── lib                                 // flutter 实现
    ├── widget                          // 通用组件
    ├── config                          // 配置
    ├── dart                            // 核心
    ├── pages                           // 页面
    	├── chat                        // 沟通
        ├── ohter                       // 其他通用页面
        ├── home                        // 主页
        ├── setting                     // 设置
        ├── work                        // 办事
        ├── login                       // 登录
        ├── setting                     // 设置
        ├── store                       // 仓库
    ├── util                            // 工具库
    ├── main.dart                       // 入口
    ├── routers.dart                    // 路由
├── .gitignore                          // 忽视文件
├── .metadata                           // 元数据
├── pubspec.yaml                        // 包依赖配置
```

# 依赖环境

目前官方 Flutter 版本迭代较快，其中引用的一些库在新版本中并没有适配,，建议 Flutter 版本与以下相同，后期考虑兼容升级。

1. Flutter 3.7.0
2. Dart 2.19.0
3. DevTools 2.20.1 

Flutter 安装过程可以参考 [Flutter 中文开发者网站 - Flutter](https://flutter.cn/docs)

## 如何参与项目

Orginone 采用开放、开源共建模式，避免重复造轮子，以持续迭代，不断演进的模式，完善公共平台的建设。引入开放社区治理模式，保障平台的开放和中心，建设成果以开放或开源模式输出，鼓励在公共平台基础上开展商业服务，以市场化竞争方式提高资源效率，降低社会运行成本。

正式进入实际开发之前，需要做一些准备工作，比如：Dart 语言、Pub（[Dart packages](https://pub.flutter-io.cn/)）库的使用、Getx（[jonataslaw/getx](https://github.com/jonataslaw/getx)）响应式框架的使用。

测试环境：https://orginone.cn。注册账号后，加入research群，可以在线沟通。


## git规范

1. 命名要求：
   1.1 统一前缀-姓名缩写-描述及日期。如 增加XX功能 `feature-lw-addmain1101`
   1.2 分支名称前缀如下

- common：调整通用组件、通用功能、通用数据接口、通用样式等
- feature：新功能
- fix：bug修复
- hotfix：线上紧急修复
- perf：性能优化
- other：配置信息调整等非上面5种的改动改动

1. 迭代要求：
   2.1 `main` 分支为主干，所有迭代基于此分支进行获取
   2.2 所有新功能迭代，问题修复等，需要进行发布，需要提交 `PR` 请求到 `main` 分支。
   2.3 待系统上线后会拉出 `test` ,后续迭代与 `ISSUE`中问题进行关联的模式
