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
    
      
      walletChannel.setMethodCallHandler { call, result in
          var argument = call.arguments as! Dictionary<String, Any>
          
          if(call.method == "loadMnemonicString"){
              var type:Int = argument["type"] as! Int;
              var lang:CLong;
              var bitsize:CLong;
              if(type == 0){
                  lang = 0;
                  bitsize = 128;
              }else{
                  lang = 1;
                  bitsize = 160;
              }
              var str = WalletapiNewMnemonicString(lang, bitsize,nil);
              result(str);
          }
          if(call.method == "createWallet"){
              var dic = [String: Any]();
              var mnemonics:String = argument["mnemonics"] as! String;
              
              var account:String = argument["account"] as! String;
              
              var passWord:String = argument["passWord"] as! String;
              
              dic["account"] = account;
              
              dic["passWord"] = passWord;
              
              
              var walletHD:WalletapiHDWallet? = WalletapiNewWalletFromMnemonic_v2(WalletapiTypeETHString, mnemonics, nil);
              if(walletHD !== nil){
                  var encptionDic:Dictionary<String, Any> = self.encption(mnemonics: mnemonics,passWord: passWord);
                  
                  do{
                      var privateKey:String = WalletapiByteTohex(try walletHD!.newKeyPriv(0));
                      dic["privateKey"] = privateKey;
                      
                      var publicKey:String = WalletapiByteTohex(try walletHD!.newKeyPub(0));
                      dic["publicKey"] = publicKey;
                      
                      var address:String = walletHD!.newAddress_v2(0, error: nil);
                      dic["address"] = address;
   
                  } catch {
                    
                  }
                  
                  let total = dic.merging(encptionDic) { (first, _) -> Any in return first }
                  
                  var json:String = self.convertDictionaryToString(dict: total);
                  
                  result(json)
              }else{
                  result(nil)
              }
              
          }
          if(call.method == "getBalance"){
              
          }
          if(call.method == "transactionsByaddress"){
              
          }
          if(call.method == "createTransaction"){
              
          }
      }

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    func encption(mnemonics:String, passWord:String)-> [String: Any]{
        
        var dic = [String: Any]();
        
        var encPasswd:Data? = WalletapiEncPasswd(passWord);
        
        dic["encPasswd"] = encPasswd?.base64EncodedString();
        
        var passwdHash:String = WalletapiPasswdHash(encPasswd);
        
        dic["passwdHash"] = passwdHash;
        
        var bMnemonics:Data? = WalletapiStringTobyte(mnemonics, nil)
        
        var mnemonicsEncKey:Data? = WalletapiSeedEncKey(encPasswd, bMnemonics, nil)
        
        dic["mnemonicsEncKey"] = mnemonicsEncKey?.base64EncodedString();
        return dic;
    }
    
    
    func convertDictionaryToString(dict:[String: Any]) -> String {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        
        let str = String(data: data!, encoding: String.Encoding.utf8) ?? "";
        
        return str

    }
}
