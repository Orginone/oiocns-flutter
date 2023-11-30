
// import 'package:orginone/dart/base/schema.dart';
// import 'package:orginone/main.dart';

// /// 授权方法提供者
// class AuthProvider {
//   // 授权成功事件
//   late Future<void> Function(XTarget user) _onAuthed;
//   AuthProvider(Future<void> Function(XTarget user) authed) {
//     _onAuthed = authed;
//     kernel.tokenAuth().then((success) async {
//       if (success) {
//         await _onAuthed.call(kernel.user!);
      
//     });
//   }
//   /// 获取动态密码
//   /// @param {RegisterType} params 参数
//   public async dynamicCode(
//     params = model.DynamicCodeModel,
//   ): Promise<model.ResultType<model.DynamicCodeModel>> {
//     return Promise((resolve) => {
//       resolve({
//         success: true,
//         code: 200,
//         msg: '',
//         data: {
//           dynamicId: 'X-12345',
//           account: params.account,
//           platName: params.platName,
//         },
//       });
//     });
//   }
//   /// 登录
//   /// @param {RegisterType} params 参数
//   public async login(
//     params = model.LoginModel,
//   ): Promise<model.ResultType<model.TokenResultModel>> {
//     let res = await kernel.auth<model.TokenResultModel>('Login', params);
//     if (res.success) {
//       await this.onAuthed(res.data.target);
//     }
//     return res;
//   }
//   /// 注册用户
//   /// @param {RegisterType} params 参数
//   public async register(
//     params = model.RegisterModel,
//   ): Promise<model.ResultType<model.TokenResultModel>> {
//     let res = await kernel.auth<model.TokenResultModel>('Register', params);
//     if (res.success) {
//       await this.onAuthed(res.data.target);
//     }
//     return res;
//   }
//   /// 变更密码
//   /// @param account 账号
//   /// @param password 密码
//   /// @param privateKey 私钥
//   /// @returns
//   public async resetPassword(
//     params = model.ResetPwdModel,
//   ): Promise<model.ResultType<model.TokenResultModel>> {
//     let res = await kernel.auth<model.TokenResultModel>('ResetPwd', params);
//     if (res.success) {
//       await this.onAuthed(res.data.target);
//     }
//     return res;
//   }
// }
