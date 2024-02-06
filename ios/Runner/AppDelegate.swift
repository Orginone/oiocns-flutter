import Foundation
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let messenger : FlutterBinaryMessenger = window?.rootViewController as! FlutterBinaryMessenger
      
      let walletChannel:FlutterMethodChannel = FlutterMethodChannel(name: "WALLET", binaryMessenger: messenger);
     
      GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    
      
//      walletChannel.setMethodCallHandler { call, result in
//          var argument = call.arguments as! Dictionary<String, Any>
          
//          if(call.method == "loadMnemonicString"){
//              var type:Int = argument["type"] as! Int;
//              var lang:CLong;
//              var bitsize:CLong;
//              if(type == 0){
//                  lang = 0;
//                  bitsize = 128;
//              }else{
//                  lang = 1;
//                  bitsize = 160;
//              }
//              var str = WalletapiNewMnemonicString(lang, bitsize,nil);
//              result(str);
//          }
//          if(call.method == "createWallet"){
//              var dic = [String: Any]();
//              var mnemonics:String = argument["mnemonics"] as! String;
//              
//              var account:String = argument["account"] as! String;
//              
//              var passWord:String = argument["passWord"] as! String;
//              
//              dic["account"] = account;
//              
//              dic["passWord"] = passWord;
//              
//              
//              var walletHD:WalletapiHDWallet? = WalletapiNewWalletFromMnemonic_v2(WalletapiTypeETHString, mnemonics, nil);
//              if(walletHD !== nil){
//                  var encptionDic:Dictionary<String, Any> = self.encption(mnemonics: mnemonics,passWord: passWord);
//                  
//                  do{
//                      var privateKey:String = WalletapiByteTohex(try walletHD!.newKeyPriv(0));
//                      dic["privateKey"] = privateKey;
//                      
//                      var publicKey:String = WalletapiByteTohex(try walletHD!.newKeyPub(0));
//                      dic["publicKey"] = publicKey;
//                      
//                      var address:String = walletHD!.newAddress_v2(0, error: nil);
//                      dic["address"] = address;
//   
//                  } catch {
//                    
//                  }
//                  
//                  let total = dic.merging(encptionDic) { (first, _) -> Any in return first }
//                  
//                  var json:String = self.convertDictionaryToString(dict: total);
//                  
//                  result(json)
//              }else{
//                  result(nil)
//              }
//              
//          }
//          if(call.method == "getBalance"){
//              var balance:WalletapiWalletBalance = WalletapiWalletBalance();
//              balance.address = argument["address"] as! String;
//              balance.cointype = argument["coinType"] as! String;
//              var util:WalletapiUtil = WalletapiUtil();
//              util.node = argument["util"] as! String
//              balance.util = util;
//              balance.tokenSymbol = argument["tokenSymbol"] as! String;
//              var data:Data? = WalletapiGetbalance(balance, nil);
//              if(data != nil){
//                  result(WalletapiByteTostring(data));
//              }else{
//                  result(nil);
//              }
//              
//          }
//          if(call.method == "transactionsByaddress"){
//              var query:WalletapiWalletQueryByAddr = WalletapiWalletQueryByAddr();
//              var util:WalletapiUtil = WalletapiUtil();
//              util.node = argument["util"] as! String
//              query.util = util;
//              var page:WalletapiQueryByPage = WalletapiQueryByPage();
//              page.address = argument["address"] as! String;
//              page.cointype = argument["coinType"] as! String;
//              page.tokenSymbol = argument["tokenSymbol"] as! String;
//              page.count = argument["count"] as! Int64;
//              page.index = argument["index"] as! Int64;
//              page.type = argument["type"] as! Int64;
//              query.queryByPage = page;
//              var data:Data? = WalletapiQueryTransactionsByaddress(query, nil);
//              if(data != nil){
//                  result(WalletapiByteTostring(data));
//              }else{
//                  result(nil);
//              }
//              
//          }
//          if(call.method == "createTransaction"){
//              var tx:WalletapiWalletTx = WalletapiWalletTx();
//              tx.cointype = argument["coinType"] as! String;
//              if(argument["coinType"] as? String == argument["tokenSymbol"] as? String){
//                  tx.tokenSymbol = "";
//              }else{
//                  tx.tokenSymbol = argument["tokenSymbol"] as! String;
//              }
//              var util:WalletapiUtil = WalletapiUtil();
//              util.node = argument["util"] as! String
//              tx.util = util;
//              var txdata:WalletapiTxdata = WalletapiTxdata();
//              txdata.amount = Double(argument["amount"] as! String) ?? 0;
//              txdata.fee = Double(argument["fee"] as! String) ?? 0;
//              txdata.from = argument["from"] as! String;
//              txdata.to = argument["to"] as! String;
//              txdata.note = argument["note"] as! String;
//              tx.tx = txdata;
//              var raw:Data? = WalletapiCreateRawTransaction(tx, nil);
//              if(raw != nil){
//                
//                  let sendResult = self.createTransaction(raw: raw!, walletTx: tx, privateKey: argument["privateKey"] as! String);
//                  
//                  result(sendResult);
//                  
//              }else{
//                  result(nil)
//              }
//          }
//      }

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
//    func createTransaction(raw:Data,walletTx:WalletapiWalletTx,privateKey:String)->String?{
//        var rawStr = WalletapiByteTostring(raw);
//        let jsonData = rawStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
//        let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
//        let jsonDecoder = JSONDecoder();
//        let result = try? jsonDecoder.decode(StringResult.self,from: json as! Data)
//        if(result != nil){
//            let signData = WalletapiSignData();
//            signData.cointype = walletTx.cointype
//            signData.privKey = privateKey
//            signData.data = WalletapiStringTobyte(result?.result, nil)
//            let signStr = WalletapiSignRawTransaction(signData, nil);
//            
//            let sendTx = WalletapiWalletSendTx();
//            sendTx.signedTx = signStr;
//            sendTx.cointype = walletTx.cointype;
//            sendTx.util = walletTx.util;
//            sendTx.tokenSymbol = walletTx.tokenSymbol;
//            return WalletapiByteTostring(WalletapiSendRawTransaction(sendTx, nil))
//        }else{
//            return nil;
//        }
//    }
    
    func encption(mnemonics:String, passWord:String)-> [String: Any]{
        
        var dic = [String: Any]();
        
//        var encPasswd:Data? = WalletapiEncPasswd(passWord);
//        
//        dic["encPasswd"] = encPasswd?.base64EncodedString();
//        
//        var passwdHash:String = WalletapiPasswdHash(encPasswd);
//        
//        dic["passwdHash"] = passwdHash;
//        
//        var bMnemonics:Data? = WalletapiStringTobyte(mnemonics, nil)
//        
//        var mnemonicsEncKey:Data? = WalletapiSeedEncKey(encPasswd, bMnemonics, nil)
//        
//        dic["mnemonicsEncKey"] = mnemonicsEncKey?.base64EncodedString();
        return dic;
    }
    
    
    func convertDictionaryToString(dict:[String: Any]) -> String {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        
        let str = String(data: data!, encoding: String.Encoding.utf8) ?? "";
        
        return str

    }
}


struct StringResult:Codable{
    let error:String
    let id:Int
    let result:String
    
}
