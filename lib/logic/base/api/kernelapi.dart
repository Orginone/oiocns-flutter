 //
 // /* eslint-disable no-unused-vars */
 // import "dart:async"; import "../model.dart" show ReceiveType , ReqestType , ResultType ;
 // /**
 // * 奥集能内核api
 // */
 // class KernelApi {
 // // 存储集线器
 // StoreHub _storeHub ;
 // // axios实例
 // var _axiosInstance = axios . create ( { } ) ;
 // // 单例
 // static KernelApi _instance ;
 // // 任意数据存储对象
 // dynamic /* AnyStore | */ _anystore ;
 // // 订阅方法
 // Map < String , List < > > _methods ;
 // /**
 //   * 私有构造方法
 //   *
 //   */
 // KernelApi ( String url ) { this . _methods = { } ; this . _storeHub = new StoreHub ( url , "txt" ) ; this . _storeHub . on ( "Receive" , ( ReceiveType res ) { final methods = this . _methods [ res . target . toLowerCase ( ) ] ; if ( methods ) { try { methods . forEach ( ( m ) => m . apply ( this , res . data ) ) ; } catch ( e , e_stack ) { console . log ( e ) ; } } } ) ; this . _storeHub . onConnected ( ( ) { if ( this . _anystore ) { this . _storeHub . invoke ( "TokenAuth" , this . anystore ?  . accessToken :  ) . then ( ( ResultType res ) { if ( res . success ) { console . debug ( "认证成功！" ) ; } } ) . catch ( ( err ) { console . log ( err ) ; } ) ; } } ) ; this . _storeHub . start ( ) ; }
 // /**
 //   * 获取单例
 //   *
 //   *
 //   */
 // static KernelApi getInstance ( [ String url = "/orginone/kernel/hub" ] ) { if ( this . _instance == null ) { this . _instance = new KernelApi ( url ) ; } return this . _instance ; }
 // /**
 //   * 任意数据存储对象
 //   *
 //   */
 // dynamic /* AnyStore | */ get anystore { return this . _anystore ; }
 // /**
 //   * 是否在线
 //   *
 //   */
 // bool get isOnline { return this . _storeHub . isConnected ; }
 // /**
 //   * 登录到后台核心获取accessToken
 //   *
 //   *
 //   *
 //   */
 // Promise< ResultType > login ( String userName , String password ) { ResultType res ; var req = { "account" : userName , "pwd" : password } ; if ( this . _storeHub . isConnected ) { res = ; } else { res = ; } if ( res . success ) { this . _anystore = AnyStore . getInstance ( res . data . accessToken ) ; } return res ; }
 // /**
 //   * 注册到后台核心获取accessToken
 //   *
 //   *
 //   *
 //   *
 //   *
 //   *
 //   *
 //   */
 // Promise< ResultType > register ( String name , String motto , String phone , String account , String password , String nickName ) { ResultType res ; var req = { "name" : name , "motto" : motto , "phone" : phone , "account" : account , "password" : password , "nickName" : nickName } ; if ( this . _storeHub . isConnected ) { res = ; } else { res = ; } if ( res . success ) { this . _anystore = AnyStore . getInstance ( res . data . accessToken ) ; } return res ; }
 // /**
 //   * 创建字典类型
 //   *
 //   *
 //   */
 // Promise< ResultType > createDict ( dynamic params ) { return ; }
 // /**
 //   * 创建日志记录
 //   *
 //   *
 //   */
 // Promise< ResultType > createLog ( dynamic params ) { return ; }
 // /**
 //   * 创建字典项
 //   *
 //   *
 //   */
 // Promise< ResultType > createDictItem ( dynamic params ) { return ; }
 // /**
 //   * 删除字典类型
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteDict ( dynamic params ) { return ; }
 // /**
 //   * 删除字典项
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteDictItem ( dynamic params ) { return ; }
 // /**
 //   * 更新字典类型
 //   *
 //   *
 //   */
 // Promise< ResultType > updateDict ( dynamic params ) { return ; }
 // /**
 //   * 更新字典项
 //   *
 //   *
 //   */
 // Promise< ResultType > updateDictItem ( dynamic params ) { return ; }
 // /**
 //   * 创建类别
 //   *
 //   *
 //   */
 // Promise< ResultType > createSpecies ( dynamic params ) { return ; }
 // /**
 //   * 创建度量标准
 //   *
 //   *
 //   */
 // Promise< ResultType > createAttribute ( dynamic params ) { return ; }
 // /**
 //   * 创建物
 //   *
 //   *
 //   */
 // Promise< ResultType > createThing ( dynamic params ) { return ; }
 // /**
 //   * 删除类别
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteSpecies ( dynamic params ) { return ; }
 // /**
 //   * 删除度量标准
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteAttribute ( dynamic params ) { return ; }
 // /**
 //   * 删除物
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteThing ( dynamic params ) { return ; }
 // /**
 //   * 更新类别
 //   *
 //   *
 //   */
 // Promise< ResultType > updateSpecies ( dynamic params ) { return ; }
 // /**
 //   * 更新度量标准
 //   *
 //   *
 //   */
 // Promise< ResultType > updateAttribute ( dynamic params ) { return ; }
 // /**
 //   * 更新物
 //   *
 //   *
 //   */
 // Promise< ResultType > updateThing ( dynamic params ) { return ; }
 // /**
 //   * 物添加类别
 //   *
 //   *
 //   */
 // Promise< ResultType > thingAddSpecies ( dynamic params ) { return ; }
 // /**
 //   * 物添加度量数据
 //   *
 //   *
 //   */
 // Promise< ResultType > thingAddAttribute ( dynamic params ) { return ; }
 // /**
 //   * 物移除类别
 //   *
 //   *
 //   */
 // Promise< ResultType > thingRemoveSpecies ( dynamic params ) { return ; }
 // /**
 //   * 物移除度量数据
 //   *
 //   *
 //   */
 // Promise< ResultType > thingRemoveAttribute ( dynamic params ) { return ; }
 // /**
 //   * 物的元数据查询
 //   *
 //   *
 //   */
 // Promise< ResultType > queryThingData ( dynamic params ) { return ; }
 // /**
 //   * 物的历史元数据查询
 //   *
 //   *
 //   */
 // Promise< ResultType > queryThingHistroyData ( dynamic params ) { return ; }
 // /**
 //   * 物的关系元数据查询
 //   *
 //   *
 //   */
 // Promise< ResultType > queryThingRelationData ( dynamic params ) { return ; }
 // /**
 //   * 创建职权
 //   *
 //   *
 //   */
 // Promise< ResultType > createAuthority ( dynamic params ) { return ; }
 // /**
 //   * 创建身份
 //   *
 //   *
 //   */
 // Promise< ResultType > createIdentity ( dynamic params ) { return ; }
 // /**
 //   * 创建组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > createTarget ( dynamic params ) { return ; }
 // /**
 //   * 创建标准规则
 //   *
 //   *
 //   */
 // Promise< ResultType > createRuleStd ( dynamic params ) { return ; }
 // /**
 //   * 删除职权
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteAuthority ( dynamic params ) { return ; }
 // /**
 //   * 删除身份
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteIdentity ( dynamic params ) { return ; }
 // /**
 //   * 删除组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteTarget ( dynamic params ) { return ; }
 // /**
 //   * 删除标准规则
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteRuleStd ( dynamic params ) { return ; }
 // /**
 //   * 递归删除组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > recursiveDeleteTarget ( dynamic params ) { return ; }
 // /**
 //   * 更新职权
 //   *
 //   *
 //   */
 // Promise< ResultType > updateAuthority ( dynamic params ) { return ; }
 // /**
 //   * 更新身份
 //   *
 //   *
 //   */
 // Promise< ResultType > updateIdentity ( dynamic params ) { return ; }
 // /**
 //   * 更新组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > updateTarget ( dynamic params ) { return ; }
 // /**
 //   * 更新标准规则
 //   *
 //   *
 //   */
 // Promise< ResultType > updateRuleStd ( dynamic params ) { return ; }
 // /**
 //   * 分配身份
 //   *
 //   *
 //   */
 // Promise< ResultType > giveIdentity ( dynamic params ) { return ; }
 // /**
 //   * 移除身份
 //   *
 //   *
 //   */
 // Promise< ResultType > removeIdentity ( dynamic params ) { return ; }
 // /**
 //   * 申请加入组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > applyJoinTeam ( dynamic params ) { return ; }
 // /**
 //   * 加入组织/个人申请审批
 //   *
 //   *
 //   */
 // Promise< ResultType > joinTeamApproval ( dynamic params ) { return ; }
 // /**
 //   * 拉组织/个人加入组织/个人的团队
 //   *
 //   *
 //   */
 // Promise< ResultType > pullAnyToTeam ( dynamic params ) { return ; }
 // /**
 //   * 取消申请加入组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > cancelJoinTeam ( dynamic params ) { return ; }
 // /**
 //   * 从组织/个人移除组织/个人的团队
 //   *
 //   *
 //   */
 // Promise< ResultType > removeAnyOfTeam ( dynamic params ) { return ; }
 // /**
 //   * 递归从组织及子组织/个人移除组织/个人的团队
 //   *
 //   *
 //   */
 // Promise< ResultType > recursiveRemoveAnyOfTeam ( dynamic params ) { return ; }
 // /**
 //   * 从组织/个人及归属组织移除组织/个人的团队
 //   *
 //   *
 //   */
 // Promise< ResultType > removeAnyOfTeamAndBelong ( dynamic params ) { return ; }
 // /**
 //   * 退出组织
 //   *
 //   *
 //   */
 // Promise< ResultType > exitAnyOfTeam ( dynamic params ) { return ; }
 // /**
 //   * 递归退出组织
 //   *
 //   *
 //   */
 // Promise< ResultType > recursiveExitAnyOfTeam ( dynamic params ) { return ; }
 // /**
 //   * 退出组织及退出组织归属的组织
 //   *
 //   *
 //   */
 // Promise< ResultType > exitAnyOfTeamAndBelong ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询组织/个人信息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTargetById ( dynamic params ) { return ; }
 // /**
 //   * 查询加入关系
 //   *
 //   *
 //   */
 // Promise< ResultType > queryRelationById ( dynamic params ) { return ; }
 // /**
 //   * 根据名称和类型查询组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTargetByName ( dynamic params ) { return ; }
 // /**
 //   * 模糊查找组织/个人根据名称和类型
 //   *
 //   *
 //   */
 // Promise< ResultType > searchTargetByName ( dynamic params ) { return ; }
 // /**
 //   * 查询组织制定的标准
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTeamRuleAttrs ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询子组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > querySubTargetById ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询归属的组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > queryBelongTargetById ( dynamic params ) { return ; }
 // /**
 //   * 查询组织/个人加入的组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > queryJoinedTargetById ( dynamic params ) { return ; }
 // /**
 //   * 查询加入组织/个人申请
 //   *
 //   *
 //   */
 // Promise< ResultType > queryJoinTeamApply ( dynamic params ) { return ; }
 // /**
 //   * 查询组织/个人加入审批
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTeamJoinApproval ( dynamic params ) { return ; }
 // /**
 //   * 查询组织职权树
 //   *
 //   *
 //   */
 // Promise< ResultType > queryAuthorityTree ( dynamic params ) { return ; }
 // /**
 //   * 查询职权子职权
 //   *
 //   *
 //   */
 // Promise< ResultType > querySubAuthoritys ( dynamic params ) { return ; }
 // /**
 //   * 查询组织职权
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTargetAuthoritys ( dynamic params ) { return ; }
 // /**
 //   * 查询组织身份
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTargetIdentitys ( dynamic params ) { return ; }
 // /**
 //   * 查询职权身份
 //   *
 //   *
 //   */
 // Promise< ResultType > queryAuthorityIdentitys ( dynamic params ) { return ; }
 // /**
 //   * 查询赋予身份的组织/个人
 //   *
 //   *
 //   */
 // Promise< ResultType > queryIdentityTargets ( dynamic params ) { return ; }
 // /**
 //   * 查询在当前空间拥有角色的组织
 //   *
 //   *
 //   */
 // Promise< ResultType > queryTargetsByAuthority ( dynamic params ) { return ; }
 // /**
 //   * 查询在当前空间拥有的身份
 //   *
 //   *
 //   */
 // Promise< ResultType > querySpaceIdentitys ( dynamic params ) { return ; }
 // /**
 //   * 创建即使消息
 //   *
 //   *
 //   */
 // Promise< ResultType > createImMsg ( dynamic params ) { return ; }
 // /**
 //   * 消息撤回
 //   *
 //   *
 //   */
 // Promise< ResultType > recallImMsg ( dynamic params ) { return ; }
 // /**
 //   * 查询聊天会话
 //   *
 //   *
 //   */
 // Promise< ResultType > queryImChats ( dynamic params ) { return ; }
 // /**
 //   * 查询群历史消息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryCohortImMsgs ( dynamic params ) { return ; }
 // /**
 //   * 查询好友聊天消息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryFriendImMsgs ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询名称
 //   *
 //   *
 //   */
 // Promise< ResultType > queryNameBySnowId ( dynamic params ) { return ; }
 // /**
 //   * 创建市场
 //   *
 //   *
 //   */
 // Promise< ResultType > createMarket ( dynamic params ) { return ; }
 // /**
 //   * 产品上架:产品所有者
 //   *
 //   *
 //   */
 // Promise< ResultType > createMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 创建产品
 //   *
 //   *
 //   */
 // Promise< ResultType > createProduct ( dynamic params ) { return ; }
 // /**
 //   * 创建产品资源
 //   *
 //   *
 //   */
 // Promise< ResultType > createProductResource ( dynamic params ) { return ; }
 // /**
 //   * 商品加入暂存区
 //   *
 //   *
 //   */
 // Promise< ResultType > createStaging ( dynamic params ) { return ; }
 // /**
 //   * 创建订单:商品直接购买
 //   *
 //   *
 //   */
 // Promise< ResultType > createOrder ( dynamic params ) { return ; }
 // /**
 //   * 创建订单:暂存区下单
 //   *
 //   *
 //   */
 // Promise< ResultType > createOrderByStags ( dynamic params ) { return ; }
 // /**
 //   * 创建订单支付
 //   *
 //   *
 //   */
 // Promise< ResultType > createOrderPay ( dynamic params ) { return ; }
 // /**
 //   * 创建对象拓展操作
 //   *
 //   *
 //   */
 // Promise< ResultType > createSourceExtend ( dynamic params ) { return ; }
 // /**
 //   * 删除市场
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteMarket ( dynamic params ) { return ; }
 // /**
 //   * 下架商品:商品所有者
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 下架商品:市场管理员
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteMerchandiseByManager ( dynamic params ) { return ; }
 // /**
 //   * 删除产品
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteProduct ( dynamic params ) { return ; }
 // /**
 //   * 删除产品资源(产品所属者可以操作)
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteProductResource ( dynamic params ) { return ; }
 // /**
 //   * 移除暂存区商品
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteStaging ( dynamic params ) { return ; }
 // /**
 //   * 创建对象拓展操作
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteSourceExtend ( dynamic params ) { return ; }
 // /**
 //   * 根据Code查询市场
 //   *
 //   *
 //   */
 // Promise< ResultType > queryMarketByCode ( dynamic params ) { return ; }
 // /**
 //   * 查询拥有的市场
 //   *
 //   *
 //   */
 // Promise< ResultType > queryOwnMarket ( dynamic params ) { return ; }
 // /**
 //   * 查询软件共享仓库的市场
 //   *
 //   *
 //   */
 // Promise< ResultType > getPublicMarket ( dynamic params ) { return ; }
 // /**
 //   * 查询市场成员集合
 //   *
 //   *
 //   */
 // Promise< ResultType > queryMarketMember ( dynamic params ) { return ; }
 // /**
 //   * 查询市场对应的暂存区
 //   *
 //   *
 //   */
 // Promise< ResultType > queryStaging ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询订单信息
 //   *
 //   *
 //   */
 // Promise< ResultType > getOrderInfo ( dynamic params ) { return ; }
 // /**
 //   * 根据ID查询订单详情项
 //   *
 //   *
 //   */
 // Promise< ResultType > getOrderDetailById ( dynamic params ) { return ; }
 // /**
 //   * 卖方:查询出售商品的订单列表
 //   *
 //   *
 //   */
 // Promise< ResultType > querySellOrderList ( dynamic params ) { return ; }
 // /**
 //   * 卖方:查询指定商品的订单列表
 //   *
 //   *
 //   */
 // Promise< ResultType > querySellOrderListByMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 买方:查询购买订单列表
 //   *
 //   *
 //   */
 // Promise< ResultType > queryBuyOrderList ( dynamic params ) { return ; }
 // /**
 //   * 查询订单支付信息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryPayList ( dynamic params ) { return ; }
 // /**
 //   * 申请者:查询加入市场申请
 //   *
 //   *
 //   */
 // Promise< ResultType > queryJoinMarketApply ( dynamic params ) { return ; }
 // /**
 //   * 管理者:查询加入市场申请
 //   *
 //   *
 //   */
 // Promise< ResultType > queryJoinMarketApplyByManager ( dynamic params ) { return ; }
 // /**
 //   * 申请者:查询商品上架申请
 //   *
 //   *
 //   */
 // Promise< ResultType > queryMerchandiseApply ( dynamic params ) { return ; }
 // /**
 //   * 市场:查询商品上架申请
 //   *
 //   *
 //   */
 // Promise< ResultType > queryMerchandiesApplyByManager ( dynamic params ) { return ; }
 // /**
 //   * 查询市场中所有商品
 //   *
 //   *
 //   */
 // Promise< ResultType > searchMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 查询产品详细信息
 //   *
 //   *
 //   */
 // Promise< ResultType > getProductInfo ( dynamic params ) { return ; }
 // /**
 //   * 查询产品资源列表
 //   *
 //   *
 //   */
 // Promise< ResultType > queryProductResource ( dynamic params ) { return ; }
 // /**
 //   * 查询组织/个人产品
 //   *
 //   *
 //   */
 // Promise< ResultType > querySelfProduct ( dynamic params ) { return ; }
 // /**
 //   * 根据产品查询商品上架信息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryMerchandiseListByProduct ( dynamic params ) { return ; }
 // /**
 //   * 查询指定产品/资源的拓展信息
 //   *
 //   *
 //   */
 // Promise< ResultType > queryExtendBySource ( dynamic params ) { return ; }
 // /**
 //   * 查询可用产品
 //   *
 //   *
 //   */
 // Promise< ResultType > queryUsefulProduct ( dynamic params ) { return ; }
 // /**
 //   * 查询可用资源列表
 //   *
 //   *
 //   */
 // Promise< ResultType > queryUsefulResource ( dynamic params ) { return ; }
 // /**
 //   * 更新市场
 //   *
 //   *
 //   */
 // Promise< ResultType > updateMarket ( dynamic params ) { return ; }
 // /**
 //   * 更新商品信息
 //   *
 //   *
 //   */
 // Promise< ResultType > updateMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 更新产品
 //   *
 //   *
 //   */
 // Promise< ResultType > updateProduct ( dynamic params ) { return ; }
 // /**
 //   * 更新产品资源
 //   *
 //   *
 //   */
 // Promise< ResultType > updateProductResource ( dynamic params ) { return ; }
 // /**
 //   * 更新订单
 //   *
 //   *
 //   */
 // Promise< ResultType > updateOrder ( dynamic params ) { return ; }
 // /**
 //   * 更新订单项
 //   *
 //   *
 //   */
 // Promise< ResultType > updateOrderDetail ( dynamic params ) { return ; }
 // /**
 //   * 退出市场
 //   *
 //   *
 //   */
 // Promise< ResultType > quitMarket ( dynamic params ) { return ; }
 // /**
 //   * 申请加入市场
 //   *
 //   *
 //   */
 // Promise< ResultType > applyJoinMarket ( dynamic params ) { return ; }
 // /**
 //   * 拉组织/个人加入市场
 //   *
 //   *
 //   */
 // Promise< ResultType > pullAnyToMarket ( dynamic params ) { return ; }
 // /**
 //   * 取消加入市场
 //   *
 //   *
 //   */
 // Promise< ResultType > cancelJoinMarket ( dynamic params ) { return ; }
 // /**
 //   * 取消订单详情
 //   *
 //   *
 //   */
 // Promise< ResultType > cancelOrderDetail ( dynamic params ) { return ; }
 // /**
 //   * 移除市场成员
 //   *
 //   *
 //   */
 // Promise< ResultType > removeMarketMember ( dynamic params ) { return ; }
 // /**
 //   * 审核加入市场申请
 //   *
 //   *
 //   */
 // Promise< ResultType > approvalJoinApply ( dynamic params ) { return ; }
 // /**
 //   * 交付订单详情中的商品
 //   *
 //   *
 //   */
 // Promise< ResultType > deliverMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 退还商品
 //   *
 //   *
 //   */
 // Promise< ResultType > rejectMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 商品上架审核
 //   *
 //   *
 //   */
 // Promise< ResultType > approvalMerchandise ( dynamic params ) { return ; }
 // /**
 //   * 产品上架:市场拥有者
 //   *
 //   *
 //   */
 // Promise< ResultType > pullProductToMarket ( dynamic params ) { return ; }
 // /**
 //   * 创建流程定义
 //   *
 //   *
 //   */
 // Promise< ResultType > createDefine ( dynamic params ) { return ; }
 // /**
 //   * 创建流程实例(启动流程)
 //   *
 //   *
 //   */
 // Promise< ResultType > createInstance ( dynamic params ) { return ; }
 // /**
 //   * 创建流程绑定
 //   *
 //   *
 //   */
 // Promise< ResultType > createFlowRelation ( dynamic params ) { return ; }
 // /**
 //   * 删除流程定义
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteDefine ( dynamic params ) { return ; }
 // /**
 //   * 删除流程实例(发起人撤回)
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteInstance ( dynamic params ) { return ; }
 // /**
 //   * 删除流程绑定
 //   *
 //   *
 //   */
 // Promise< ResultType > deleteFlowRelation ( dynamic params ) { return ; }
 // /**
 //   * 查询流程定义
 //   *
 //   *
 //   */
 // Promise< ResultType > queryDefine ( dynamic params ) { return ; }
 // /**
 //   * 查询发起的流程实例
 //   *
 //   *
 //   */
 // Promise< ResultType > queryInstance ( dynamic params ) { return ; }
 // /**
 //   * 查询待审批任务
 //   *
 //   *
 //   */
 // Promise< ResultType > queryApproveTask ( dynamic params ) { return ; }
 // /**
 //   * 查询待审阅抄送
 //   *
 //   *
 //   */
 // Promise< ResultType > queryNoticeTask ( dynamic params ) { return ; }
 // /**
 //   * 查询审批记录
 //   *
 //   *
 //   */
 // Promise< ResultType > queryRecord ( dynamic params ) { return ; }
 // /**
 //   * 流程节点审批
 //   *
 //   *
 //   */
 // Promise< ResultType > approvalTask ( dynamic params ) { return ; }
 // /**
 //   * 重置流程定义
 //   *
 //   *
 //   */
 // Promise< ResultType > resetDefine ( dynamic params ) { return ; }
 // /**
 //   * 请求一个内核方法
 //   *
 //   *
 //   */
 // Promise< ResultType > request ( ReqestType req ) { if ( this . _storeHub . isConnected ) { return ; } else { return ; } }
 // /**
 //   * 请求多个内核方法,使用同一个事务
 //   *
 //   *
 //   */
 // Promise< ResultType > requests ( List < ReqestType > reqs ) { if ( this . _storeHub . isConnected ) { return ; } else { return ; } }
 // /**
 //   * 监听服务端方法
 //   *
 //   *
 //   */
 // void on ( String methodName , Function newMethod ) { if ( ! methodName || ! newMethod ) { return ; } methodName = methodName . toLowerCase ( ) ; if ( ! this . _methods [ methodName ] ) { this . _methods [ methodName ] = [ ] ; } if ( ! identical ( this . _methods [ methodName ] . indexOf ( newMethod ) , - 1 ) ) { return ; } this . _methods [ methodName ] . push ( newMethod ) ; }
 // /**
 //   * 使用rest请求后端
 //   *
 //   *
 //   *
 //   */
 // Promise< ResultType > _restRequest ( String methodName , dynamic args ) { final res = ; if ( res . data && ( ) ) { return ; } return { "success" : false , "data" : { } , "code" : 400 , "msg" : "" } ; } }