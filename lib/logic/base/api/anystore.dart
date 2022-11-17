// /* eslint-disable no-unused-vars */
// import "dart:async";
// import 'package:orginone/logic/base/api/storehub.dart';
//
// import "../model.dart" show ResultType;
//
// /**
//  * 任意数据存储类
//  */
// class AnyStore {
//   // 存储集线器
//   StoreHub _storeHub;
//
//   // 单例
//   static AnyStore _instance;
//
//   // 订阅回调字典
//   Record<String, dynamic /* (data: any) => void */> _subscribeCallbacks;
//
//   // 获取accessToken
//   String get accessToken {
//     return sessionStorage.getItem("accessToken") || "";
//   }
//
//   // 设置accessToken
//   set accessToken(String val) {
//     sessionStorage.setItem("accessToken", val);
//   }
//
//   /**
//    * 私有构造方法
//    *
//    *
//    */
//   AnyStore(String accessToken, String url) {
//     this.accessToken = accessToken;
//     this._subscribeCallbacks = {};
//     this._storeHub = new StoreHub (url);
//     this._storeHub.on("updated", (String key, String domain, dynamic data) {
//       this._updated(key, domain, data);
//     });
//     this._storeHub.onConnected(() {
//       this._storeHub.invoke("TokenAuth", this.accessToken, "user").then(() {
//         Object.keys(this._subscribeCallbacks).forEach((fullKey) {
//           final key = fullKey.split("|") [ 0 ];
//           final domain = fullKey.split("|") [ 1 ];
//           this.subscribed(key, domain, this._subscribeCallbacks [ fullKey ]);
//         });
//       })
//       . catch ( ( err ) { console . log ( err ) ; } );
//     });
//     this._storeHub.on("Updated", (key, domain, data) {
//       this._updated(key, domain, data);
//     });
//     this._storeHub.start();
//   }
//
//   /**
//    * 获取任意数据存储单例
//    *
//    *
//    *
//    */
//   static AnyStore getInstance(String accessToken,
//       [ String url = "/orginone/anydata/hub" ]) {
//     if (this._instance == null) {
//       this._instance = new AnyStore (accessToken, url);
//     } else {
//       this._instance.updateToken(accessToken);
//     }
//     return this._instance;
//   }
//
//   /**
//    * 是否在线
//    *
//    */
//   bool get isOnline {
//     return this._storeHub.isConnected;
//   }
//
//   /**
//    * 更新token
//    *
//    */
//   void updateToken(String accessToken) {
//     if (this.accessToken != accessToken) {
//       this.accessToken = accessToken;
//       this._storeHub.restart();
//     }
//   }
//
//   /**
//    * 订阅对象变更
//    *
//    *
//    *
//    *
//    */
//
//   // eslint-disable-next-line no-unused-vars
//   void subscribed(String key, String domain, void callback(dynamic data)) {
//     if (callback) {
//       final fullKey = key + "|" + domain;
//       this._subscribeCallbacks [ fullKey ] = callback;
//       if (this._storeHub.isConnected) {
//         this._storeHub.invoke("Subscribed", key, domain).then((ResultType res) {
//           if (res.success) {
//             callback.apply(this, [ res.data]);
//           }
//         })
//     . catch ( ( err ) { console . log ( err ) ; } );
//   }
//   }
//   }
//
//   /**
//    * 取消订阅对象变更
//    *
//    *
//    *
//    */
//   void unSubscribed(String key, String domain) {
//     final fullKey = key + "|" + domain;
//     if (this._subscribeCallbacks [ fullKey ] && this._storeHub.isConnected) {
//       this._storeHub.invoke("UnSubscribed", key, domain).then(() {
//         console.debug('''${ key}取消订阅成功.''');
//       })
//     . catch ( ( err ) { console . log ( err ) ; } );
//   };
//   }
//
//   /**
//    * 查询对象
//    *
//    *
//    *
//    */
//   Future<ResultType> get(String key, String domain) {
//     return;
//   }
//
//   /**
//    * 修改对象
//    *
//    *
//    *
//    *
//    */
//   Future<ResultType> set(String key, dynamic setData, String domain) {
//     return;
//   }
//
//   /**
//    * 删除对象
//    *
//    *
//    *
//    */
//   Future<ResultType> delete(String key, String domain) {
//     return;
//   }
//
//   /**
//    * 添加数据到数据集
//    *
//    *
//    *
//    *
//    */
//   Future<ResultType> insert(String collName, dynamic data, String domain) {
//     return;
//   }
//
//   /**
//    * 更新数据到数据集
//    *
//    *
//    *
//    *
//    */
//   Future<ResultType> update(String collName, dynamic update, String domain) {
//     return;
//   }
//
//   /**
//    * 从数据集移除数据
//    *
//    *
//    *
//    *
//    */
//   Future<ResultType> remove(String collName, dynamic match, String domain) {
//     return;
//   }
//
//   /**
//    * 从数据集查询数据
//    *
//    *
//    *
//    *
//    */
//   Future<ResultType> aggregate(String collName, dynamic options,
//       String domain) {
//     return;
//   }
//
//   /**
//    * 对象变更通知
//    *
//    *
//    *
//    */
//   void _updated(String key, String domain, dynamic data) {
//     final lfullkey = key + "|" + domain;
//     Object.keys(this._subscribeCallbacks).forEach((fullKey) {
//       if (identical(fullKey, lfullkey)) {
//         final dynamic /* (data: any) => void */ callback = this
//             ._subscribeCallbacks [ fullKey ];
//         if (callback) {
//           callback.call(callback, data);
//         }
//       }
//     });
//   }
// }