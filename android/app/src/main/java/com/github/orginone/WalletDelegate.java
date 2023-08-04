package com.github.orginone;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import walletapi.HDWallet;
import walletapi.QueryByPage;
import walletapi.SignData;
import walletapi.Txdata;
import walletapi.Util;
import walletapi.WalletBalance;
import walletapi.WalletQueryByAddr;
import walletapi.WalletSendTx;
import walletapi.WalletTx;
import walletapi.Walletapi;

public class WalletDelegate implements MethodChannel.MethodCallHandler {
    MethodChannel walletChannel;

    private static final String CHANNEL_NAME = "WALLET";

    private Gson gson;

    private Util util;

    WalletDelegate(BinaryMessenger messenger) {
        walletChannel = new MethodChannel(messenger, CHANNEL_NAME);
        gson = new Gson();
        util = new Util();
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
                    result.success(null);
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
                    result.success(null);
                }
                break;
            case "getBalance":
                WalletBalance walletBalance = new WalletBalance();
                walletBalance.setAddress(call.argument("address"));
                walletBalance.setCointype(call.argument("coinType"));
                walletBalance.setUtil(getUtil(call.argument("util")));
                walletBalance.setTokenSymbol(call.argument("tokenSymbol"));
                try {
                    String balance = getBalance(walletBalance);
                    result.success(balance);
                } catch (Exception e) {
                    result.success(null);
                }
                break;
            case "transactionsByaddress":
                WalletQueryByAddr walletQueryByAddr = new WalletQueryByAddr();
                QueryByPage page = new QueryByPage();
                page.setAddress(call.argument("address"));
                page.setCointype(call.argument("coinType"));
                page.setTokenSymbol(call.argument("tokenSymbol"));
                page.setCount(Long.valueOf(call.argument("count").toString()));
                page.setIndex(Long.valueOf(call.argument("index").toString()));
                page.setType(Long.valueOf(call.argument("type").toString()));
                walletQueryByAddr.setQueryByPage(page);
                walletQueryByAddr.setUtil(getUtil(call.argument("util")));
                try {
                    String records = transactionsByaddress(walletQueryByAddr);
                    result.success(records);
                } catch (Exception e) {
                    result.success(null);
                }
                break;
            case "createTransaction":
                try {
                    WalletTx walletTx = new WalletTx();
                    walletTx.setCointype(call.argument("coinType"));
                    if (call.argument("coinType") == call.argument("tokenSymbol")) {
                        walletTx.setTokenSymbol("");
                    } else {
                        walletTx.setTokenSymbol(call.argument("tokenSymbol"));
                    }
                    Txdata txdata = new Txdata();
                    txdata.setAmount(Double.parseDouble(call.argument("amount").toString()));
                    txdata.setFee(Double.parseDouble(call.argument("fee").toString()));
                    txdata.setFrom(call.argument("from"));
                    txdata.setTo(call.argument("to"));
                    txdata.setNote(call.argument("note"));
                    walletTx.setTx(txdata);
                    walletTx.setUtil(getUtil(call.argument("util")));
                    String resultStr = createTransaction(walletTx, call.argument("privateKey"));

                    result.success(resultStr);
                } catch (Exception e) {
                    result.success(null);
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
    private String loadMnemonicString(int type) throws Exception {
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
    private void createWallet(String mnemonics, String passWord, WalletInfoBean walletInfoBean) throws Exception {
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

    /**
     * 获取账户余额
     *
     * @param balance  钱包信息
     */
    private String getBalance(WalletBalance balance) throws Exception {
        byte[] bytes = Walletapi.getbalance(balance);
        return Walletapi.byteTostring(bytes);
    }

    /**
     * 获取交易记录
     *
     * @param walletQueryByAddr 钱包信息
     */
    private String transactionsByaddress(WalletQueryByAddr walletQueryByAddr) throws Exception {
        byte[] bytes = Walletapi.queryTransactionsByaddress(walletQueryByAddr);
        return Walletapi.byteTostring(bytes);
    }


    private String createTransaction(WalletTx walletTx, String privateKey) throws Exception {
        byte[] raw = Walletapi.createRawTransaction(walletTx);
        String rawStr = Walletapi.byteTostring(raw);
        StringResult stringResult = gson.fromJson(rawStr, StringResult.class);
        String result = stringResult.getResult();
        if (TextUtils.isEmpty(result)) {
            return null;
        }
        SignData signData = new SignData();
        signData.setCointype(walletTx.getCointype());
        signData.setPrivKey(privateKey);
        signData.setData(Walletapi.stringTobyte(result));
        String sign = signTransaction(signData);
        WalletSendTx sendTx = new WalletSendTx();
        sendTx.setSignedTx(sign);
        sendTx.setCointype(walletTx.getCointype());
        sendTx.setUtil(walletTx.getUtil());
        sendTx.setTokenSymbol(walletTx.getTokenSymbol());
        return sendTransaction(sendTx);
    }

    private String signTransaction(SignData signData) throws Exception {
        return Walletapi.signRawTransaction(signData);
    }

    private String sendTransaction(WalletSendTx sendTx) throws Exception {
        return Walletapi.byteTostring(Walletapi.sendRawTransaction(sendTx));
    }


    private Util getUtil(String node) {
        util.setNode(node);
        return util;
    }

    void onDestroy() {
        walletChannel = null;
    }
}


class StringResult {
    private String error;
    private int id;
    private String result;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}