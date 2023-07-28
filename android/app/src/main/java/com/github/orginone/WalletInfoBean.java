package com.github.orginone;

public class WalletInfoBean {
    private String privateKey;
    private String publicKey;
    private String address;
    private String account;
    private String passWord;
    private byte[] encPasswd;
    private String passwdHash;
    private byte[] mnemonicsEncKey;

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public byte[] getEncPasswd() {
        return encPasswd;
    }

    public void setEncPasswd(byte[] encPasswd) {
        this.encPasswd = encPasswd;
    }

    public String getPasswdHash() {
        return passwdHash;
    }

    public void setPasswdHash(String passwdHash) {
        this.passwdHash = passwdHash;
    }

    public  byte[] getMnemonicsEncKey() {
        return mnemonicsEncKey;
    }

    public void setMnemonicsEncKey(byte[] mnemonicsEncKey) {
        this.mnemonicsEncKey = mnemonicsEncKey;
    }
}
