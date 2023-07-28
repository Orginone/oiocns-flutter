package com.github.orginone;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import walletapi.HDWallet;
import walletapi.Walletapi;

public class WalletDelegate implements MethodChannel.MethodCallHandler {
    MethodChannel walletChannel;

    private static final String CHANNEL_NAME = "WALLET";

    private Gson gson;

    WalletDelegate(BinaryMessenger messenger) {
        walletChannel = new MethodChannel(messenger, CHANNEL_NAME);
        gson = new Gson();
        walletChannel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "loadMnemonicString":
                try {
                    String mnemonicString = loadMnemonicString(call.argument("type"));
                    result.success(mnemonicString);
                } catch (Exception e) {
                    result.error(e.toString(), e.getMessage(), e);
                }
                break;
            case "createWallet":
                String mnemonics = call.argument("mnemonics");
                String account = call.argument("account");
                String passWord = call.argument("passWord");
                WalletInfoBean walletInfoBean = new WalletInfoBean();
                walletInfoBean.setAccount(account);
                walletInfoBean.setPassWord(passWord);
                try {
                    createWallet(mnemonics, passWord, walletInfoBean);
                    String json = gson.toJson(walletInfoBean);
                    result.success(json);
                } catch (Exception e) {
                    result.error(e.toString(), e.getMessage(), e);
                }
                break;
        }
    }


    /**
     * 加载助记词
     *
     * @param type Int  1 中文  0 英文
     * @return String
     */
    public String loadMnemonicString(int type) throws Exception {
        if (type == 0) {

            return Walletapi.newMnemonicString(type, 128);
        }
        return Walletapi.newMnemonicString(1, 160);
    }

    /**
     * 加载助记词
     *
     * @param mnemonics      助记词
     * @param passWord       密码
     * @param walletInfoBean 模型
     */
    public void createWallet(String mnemonics, String passWord, WalletInfoBean walletInfoBean) throws Exception {
        HDWallet wallet = Walletapi.newWalletFromMnemonic_v2(Walletapi.TypeETHString, mnemonics);
        String privateKey = Walletapi.byteTohex(wallet.newKeyPriv(0));
        String publicKey = Walletapi.byteTohex(wallet.newKeyPub(0));
        String address = wallet.newAddress_v2(0);
        walletInfoBean.setPrivateKey(privateKey);
        walletInfoBean.setPublicKey(publicKey);
        walletInfoBean.setAddress(address);
        encryption(mnemonics, passWord, walletInfoBean);
    }


    /**
     * 加密
     *
     * @param mnemonics      助记词
     * @param passWord       密码
     * @param walletInfoBean 模型
     */
    private void encryption(String mnemonics, String passWord, WalletInfoBean walletInfoBean) throws Exception {
        byte[] encPasswd = Walletapi.encPasswd(passWord);
        String passwdHash = Walletapi.passwdHash(encPasswd);
        walletInfoBean.setEncPasswd(encPasswd);
        walletInfoBean.setPasswdHash(passwdHash);
        byte[] bMnemonics = Walletapi.stringTobyte(mnemonics);
        byte[] mnemonicsEncKey = Walletapi.seedEncKey(encPasswd, bMnemonics);
        walletInfoBean.setMnemonicsEncKey(mnemonicsEncKey);
    }

    void onDestroy() {
        walletChannel = null;
    }
}
