/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 15:23:10
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 14:13:16
 */
class Routers {
  /// 首页
  static const String homeOld = "/homeOld";
  static const String home = "/home";
  static const String homeSub = "/homeSub";
  static const String todo = "/todo";
  static const String todoList = "/todoList";
  static const String todoDetail = "/todoDetail";

  /// 数据
  static const String storePage = "/storePage";

  /// 关系
  static const String relation = "/relation";

  /// 数据

  /// 关系
  ///
  /// 好友关系
  static const String relationFriend = "/relationFriend";

  /// 群组关系
  static const String relationCohort = "/relationCohort";

  /// 共用页面
  ///
  /// 实体信息
  static const String entityInfo = "/entityInfo";

  /// 好友/成员列表
  static const String memberList = "/memberList";

  /// 文件目录列表
  static const String fileList = "/fileList";

  /// 沟通会话页面
  static const String chatSession = "/chatSession";

  // 登录
  static const String login = "/login";

  //验证码
  static const String verificationCode = "/verificationCode";

  //注册
  static const String register = "/register";

  //忘记密码
  static const String forgotPassword = "/forgotPassword";

  //登录过渡加载页面
  static const String logintrans = "/logintrans";

  // 简单表单编辑器
  static const String form = "/form";
  // 简单表单编辑器
  static const String formPage = "/formPage";
  //表单详情
  static const String formDetail = "/formDetail";

  // 消息
  static const String messageSetting = "/messageSetting";
  static const String messageChat = "/messageChat";
  static const String messageReceive = "/messageReceive";
  static const String messageChatsList = "/messageChatsList";

  //动态
  static const String targetActivity = "/targetActivity";
  static const String targetActivityOld = "/targetActivityOld";

  // 首页
  static const String index = "/index";

  // 设置
  static const String relationCenter = "/relationCenter";
  static const String companyInfo = "/companyInfo";
  static const String version = "/version";
  static const String userInfo = "/userInfo";
  static const String about = "/about";
  static const String originone = "/originone";
  static const String versionList = "/versionList";

  // 仓库相关
  // 资产管理
  static const String assetsManagement = "/assetsManagement";

  // 杭商城
  static const String market = "/market";

  //添加资产
  static const String addAsset = "/addAsset";

  //选择地点
  static const String storageLocation = "/storageLocation";

  //选择资产分类
  static const String choiceAssets = "/choiceAssets";
  static const String choiceSpecificAssets = "/choiceSpecificAssets";

  //资产详情
  static const String assetsDetails = "/assetsDetails";

  //创建盘点
  static const String createClaim = "/createClaim";

  //创建移交
  static const String createTransfer = "/createTransfer";

  //创建申购
  static const String createDispose = "/createDispose";

  //创建交回
  static const String createHandOver = "/createHandOver";

  //资产盘点
  static const String assetsCheck = "/assetsCheck";

  //资产模块通用详情
  static const String generalDetails = "/generalDetails";

  //审批单据
  static const String approveDocuments = "/approveDocuments";

  //资产模块功能页
  static const String centerFunction = "/centerFunction";

//批量移除资产
  static const String bulkRemovalAsset = "/bulkRemovalAsset";

  //批量操作资产
  static const String batchOperationAsset = "/batchOperationAsset";

  //扫描二维码
  static const String qrScan = "/qrScan";

  //扫码登录
  static const String scanLogin = "/scanLogin";

  //webView
  static const String webView = "/webView";

  //审批详情
  static const String processDetails = '/processDetails';

  //发起会话
  static const String initiateChat = '/initiateChat';

  //发起办事
  static const String initiateWork = '/initiateWork';

  //事项
  static const String workStart = '/workStart';

  //创建办事
  static const String createWork = '/createWork';

  //选择物
  static const String choiceThing = '/choiceThing';

  //应用详情
  static const String applicationDetails = '/applicationDetails';

  //实体列表
  static const String thing = '/thing';

  //实体详情
  static const String thingDetails = '/thingDetails';

  //内部机构详情
  static const String departmentInfo = '/departmentInfo';

  //外部机构详情
  static const String outAgencyInfo = '/outAgencyInfo';

  //岗位详情
  static const String stationInfo = '/stationInfo';

  //单位群组详情
  static const String cohortInfo = '/cohortInfo';

  //角色设置
  static const String roleSettings = '/roleSettings';

  //添加角色
  static const String addMembers = '/addMembers';

  static const String cardbag = "/cardbag";
  static const String dynamic = "/dynamic";
  static const String mark = "/mark";
  static const String security = "/security";

  //权限标准详情
  static const String permissionInfo = "/permissionInfo";

  //分类标准详情
  static const String classificationInfo = "/classificationInfo";

  //字段定义详情
  static const String dictInfo = "/dictInfo";

  //属性定义详情
  static const String attributeInfo = "/attributeInfo";

  //属性定义详情
  static const String workList = "/workList";

  /// 标准数据信息页面 standardEntityInfoPage
  static const String standardEntityInfoPage = "/standardEntityInfoPage";

  /// 标准数据详情页 standardEntityDetailPage
  static const String standardEntityDetailPage = "/standardEntityDetailPage";

  ///数据二级至N级页面
  static const String storeTree = "/storeTree";

  static const String messageFile = "/messageFile";

  static const String messageRecords = "/messageRecords";

  static const String personListPage = "/personListPage";
  static const String pdfReader = "/pdfReader";

  static const String shareQrCode = "/shareQrCode";

  static const String photoView = "/photoView";

  static const String fileReader = "/fileReader";

  static const String generalBreadCrumbs = "/generalBreadCrumbs";

  static const String videoPlay = "/videoPlay";
  static const String markDownPreview = "/markDownPreview";
  static const String activityRelease = "/activityRelease";
  static const String uploadFiles = "/uploadFiles";

  static const String editSubGroup = "/editSubGroup";

  static const String messageChatInfo = "/messageChatInfo";

  static const String createBag = "/createBag";

  static const String guideBag = "/guideBag";

  static const String importWallet = "/importWallet";

  static const String bagDetails = "/bagDetails";

  static const String walletDetails = "/walletDetails";

  static const String transferAccounts = "/transferAccounts";

  static const String searchCoin = "/searchCoin";
  static const errorPage = '/error_page';
}
