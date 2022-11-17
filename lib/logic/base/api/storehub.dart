// /* eslint-disable no-debugger */
//
// /* eslint-disable no-unused-vars */
// import "dart:async";
// import "package:@microsoft/signalr.dart" as signalR;
// import "../common/lifecycle.dart" show IDisposable;
// import "../model.dart" show ResultType;
// import "../protocol.dart" show TxtHubProtocol;
//
// /**
//  * 存储层Hub
//  */
// class StoreHub implements IDisposable {
//   // 超时重试时间
//   num _timeout;
//
//   // 是否已经启动
//   bool _isStarted;
//
//   // signalr 连接
//   signalR.HubConnection _connection;
//
//   // 连接成功回调
//   List <> _connectedCallbacks;
//
//   // 连接断开回调
//   List <> _disconnectedCallbacks;
//
//   /**
//    * 构造方法
//    *
//    *
//    *
//    */
//   StoreHub(String url, [ protocol = "json", timeout = 8000, interval = 3000 ]) {
//     this._isStarted = false;
//     this._timeout = timeout;
//     this._connectedCallbacks = [];
//     this._disconnectedCallbacks = [];
//     signalR.IHubProtocol hubProtocol = new signalR.JsonHubProtocol ();
//     if (protocol == "txt") {
//       hubProtocol = new TxtHubProtocol ();
//     }
//     this._connection =
//         new signalR.HubConnectionBuilder ().withUrl(url).withHubProtocol(
//             hubProtocol).configureLogging(signalR.LogLevel.None).build();
//     this._connection.serverTimeoutInMilliseconds = timeout;
//     this._connection.keepAliveIntervalInMilliseconds = interval;
//     this._connection.onclose((err) {
//       if (this._isStarted && err) {
//         this._disconnectedCallbacks.forEach((c) {
//           c.apply(this, [ err]);
//         });
//         console.log('''连接断开,${ this._timeout}ms后重试。''', err);
//         setTimeout(() {
//           this._starting();
//         }, this._timeout);
//       }
//     });
//   }
//
//   /**
//    * 是否处于连接着的状态
//    *
//    */
//   bool get isConnected {
//     return (this._isStarted && identical(
//         this._connection.state, signalR.HubConnectionState.Connected));
//   }
//
//   /**
//    * 销毁连接
//    *
//    */
//   Promise dispose() {
//     this._isStarted = false;
//     this._connectedCallbacks = [];
//     this._disconnectedCallbacks = [];
//     return this._connection.stop();
//   }
//
//   /**
//    * 启动链接
//    *
//    */
//   void start() {
//     if (!this._isStarted) {
//       this._isStarted = true;
//       this._starting();
//     }
//   }
//
//   /**
//    * 重新建立连接
//    *
//    */
//   void restart() {
//     if (this.isConnected) {
//       this._connection.stop().then(() {
//         this._starting();
//       });
//     }
//   }
//
//   /**
//    * 开始连接
//    *
//    */
//   void _starting() {
//     this._connection.start().then(() {
//       this._connectedCallbacks.forEach((c) {
//         c.apply(this, []);
//       });
//     })
//     . catch ( ( err ) { this . _disconnectedCallbacks . forEach ( ( c ) { c . apply ( this , [ err ] ) ; } ) ; console . log ( '''连接失败,${ this . _timeout}ms后重试。''' , err ) ; setTimeout ( ( ) { this . _starting ( ) ; } , this . _timeout ) ; } );
//   }
//
//   /**
//    * 连接成功事件
//    *
//    *
//    */
//   void onConnected(void callback()) {
//     if (callback) {
//       this._connectedCallbacks.push(callback);
//     }
//   }
//
//   /**
//    * 断开连接事件
//    *
//    *
//    */
//   void onDisconnected(void callback(dynamic /* Error | */ err)) {
//     if (callback) {
//       this._disconnectedCallbacks.push(callback);
//     }
//   }
//
//   /**
//    * 监听服务端方法
//    *
//    *
//    *
//    */
//   void on(String methodName, Function newMethod) {
//     this._connection.on(methodName, newMethod);
//   }
//
//   /**
//    * 请求服务端方法
//    *
//    *
//    *
//    */
//   Promise<ResultType> invoke(String methodName, List <dynamic> args) {
//     return new Promise ((resolve) {
//       if (this.isConnected) {
//         this._connection.invoke(methodName,).then((ResultType res) {
//           resolve(res);
//         })
//       . catch ( ( err ) { resolve ( success : false , data : { } , code : 400 , msg : err ) ; } ) ; } else { resolve ( success : false , data : { } , code : 400 , msg : "" ) ; } });
//   }
// }