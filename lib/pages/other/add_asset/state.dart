

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dart/core/getx/base_get_state.dart';

class AddAssetState extends BaseGetState{
  TextEditingController searchController = TextEditingController();

  var selectCount = 0.obs;

  var selectAll = false.obs;

  var selectAssetList = <SelectAssetList>[].obs;

}


class SelectAssetList {
  String? id;
  bool isSelected = false;
  bool isOpen = false;
  int? syncStatus;
  int? assetSourceApp;
  String? createTime;
  String? modifiedTime;
  dynamic idCardNo;
  String? phoneNumber;
  dynamic printCount;
  int? informationType;
  dynamic businessCategory;
  dynamic customCategory;
  String? oRGID;
  String? gS1;
  String? zICHANFLID;
  String? zICHANBH;
  String? zICHANMC;
  String? lIUCZT;
  String? kAPIANZT;
  dynamic oLDID;
  String? zICHANFLBM;
  dynamic cHANQUANDW;
  dynamic sHIYONGDW;
  String? gUOBIAOFLBM;
  String? zICHANGBDLID;
  dynamic gONGXIANGFW;
  dynamic jINGWEID;
  double? pRICE;
  String? jIAZHILXID;
  int? sHULIANG;
  dynamic dANJIA;
  String? qUDERQ;
  String? tOURUSYRQ;
  int? yUJISYSMSMZLYJSMZL;
  dynamic yISHIYONGQS;
  String? sHIYONGZK2ID;
  String? sHIYONGGLBMID;
  String? sHIYONGRID;
  String? qUDEFSID;
  String? kUAIJIPZH;
  String? zIJINLY;
  String? jILIANGDW;
  String? bEIZHU;
  dynamic bIANZHIQKID;
  String? zHEJIUFFID;
  String? zHEJIUZTID;
  dynamic yITIZJYS;
  dynamic lEIJIZJ;
  dynamic jINGZHI;
  dynamic yUEZHEJE;
  dynamic jUNGONGRQ;
  dynamic jIANZHUJGID;
  String? zUOLUOWZ;
  double? mIANJI;
  dynamic cHUZUMJ;
  dynamic zIYONGMJ;
  dynamic sUNHIUIMJ;
  dynamic xIANZHIMJ;
  dynamic qITAMJ;
  dynamic qIZHONGWFMJ;
  dynamic cHANQUANXSID;
  dynamic qUANSHUXZID;
  dynamic yOUCHANQUANQK;
  dynamic qUANSHUZM;
  dynamic qUANSHUZH;
  dynamic fAZHENGRQ;
  dynamic tUDISYQRFWSYQR;
  dynamic wUCHANQUANQK;
  dynamic pINPAI;
  dynamic gUIGEXH;
  dynamic sHIYONGFXID;
  dynamic fAPIAOH;
  dynamic rEGISTERDATE;
  dynamic bAOXIUJZRQ;
  dynamic sUPPLIER;
  dynamic pAIQIL;
  dynamic cHEPAIH;
  dynamic fADONGJH;
  dynamic cHELIANGSBH;
  dynamic cHELIANGCD;
  dynamic cHESHENYS;
  dynamic vEHICLETYPE;
  dynamic vEHICLEOWNER;
  dynamic cHELIANGXSZID;
  dynamic cHELIANGYTFLID;
  dynamic cHELIANGXSZSYR;
  dynamic cUNFANGDDID;
  dynamic sHENGCHANCJ;
  dynamic cHANPINXLH;
  dynamic dIAOCHUDANWEI;
  dynamic cHUJIEMJ;
  dynamic tUDISYQLXID;
  dynamic dIHAO;
  dynamic yUEZHEJL;
  dynamic wENWUDJID;
  dynamic cOLLECTIONDATE;
  dynamic hERITAGEBRIEFINTRODUCTION;
  dynamic hERITAGENO;
  dynamic wENWULY;
  dynamic sOURCEPLACE;
  dynamic zANGPINND;
  dynamic zHUCEDJJG;
  dynamic cERTNO;
  dynamic iAFEATUREINFO;
  dynamic iNVENTOR;
  dynamic kAIGONGDATE;
  dynamic zAIJIANZT;
  dynamic aPPROVALNUMBER;
  dynamic sUNYITZ;
  dynamic dUIWAITZJZ;
  dynamic pIZHUNWH;
  dynamic pARVALAMT;
  dynamic pARVALPERC;
  dynamic qIYEJB;
  dynamic pIZHUNDW;
  dynamic fARENDB;
  dynamic sHENFENID;
  dynamic cHIGUBL;
  dynamic sHISHOUZB;
  dynamic pIFURQ;
  dynamic zHUCEZB;
  dynamic sHIJICZJE;
  dynamic lIANXIFS;
  dynamic yINGYEKS;
  dynamic yINGYEJZ;
  dynamic iSCONTROL;
  dynamic oRGANID;
  dynamic sHANGSHI;
  dynamic jINGYINGFW;
  dynamic zUZHIXS;
  dynamic iNVESTEDAGENCYINFO;
  dynamic iNVESTEDAGENCYSTOCKNO;
  dynamic iNVESTEDPROValue;
  dynamic iNITIALINVESTAMT;
  dynamic bGR;
  dynamic sFXC;
  dynamic sJSYR;
  EXTRA? eXTRA;
  int? rECEIVETIME;
  String? rECEIVETYPE;
  bool? iSOVERDUE;

  SelectAssetList(
      {this.id,
        this.syncStatus,
        this.assetSourceApp,
        this.createTime,
        this.modifiedTime,
        this.idCardNo,
        this.phoneNumber,
        this.printCount,
        this.informationType,
        this.businessCategory,
        this.customCategory,
        this.oRGID,
        this.gS1,
        this.zICHANFLID,
        this.zICHANBH,
        this.zICHANMC,
        this.lIUCZT,
        this.kAPIANZT,
        this.oLDID,
        this.zICHANFLBM,
        this.cHANQUANDW,
        this.sHIYONGDW,
        this.gUOBIAOFLBM,
        this.zICHANGBDLID,
        this.gONGXIANGFW,
        this.jINGWEID,
        this.pRICE,
        this.jIAZHILXID,
        this.sHULIANG,
        this.dANJIA,
        this.qUDERQ,
        this.tOURUSYRQ,
        this.yUJISYSMSMZLYJSMZL,
        this.yISHIYONGQS,
        this.sHIYONGZK2ID,
        this.sHIYONGGLBMID,
        this.sHIYONGRID,
        this.qUDEFSID,
        this.kUAIJIPZH,
        this.zIJINLY,
        this.jILIANGDW,
        this.bEIZHU,
        this.bIANZHIQKID,
        this.zHEJIUFFID,
        this.zHEJIUZTID,
        this.yITIZJYS,
        this.lEIJIZJ,
        this.jINGZHI,
        this.yUEZHEJE,
        this.jUNGONGRQ,
        this.jIANZHUJGID,
        this.zUOLUOWZ,
        this.mIANJI,
        this.cHUZUMJ,
        this.zIYONGMJ,
        this.sUNHIUIMJ,
        this.xIANZHIMJ,
        this.qITAMJ,
        this.qIZHONGWFMJ,
        this.cHANQUANXSID,
        this.qUANSHUXZID,
        this.yOUCHANQUANQK,
        this.qUANSHUZM,
        this.qUANSHUZH,
        this.fAZHENGRQ,
        this.tUDISYQRFWSYQR,
        this.wUCHANQUANQK,
        this.pINPAI,
        this.gUIGEXH,
        this.sHIYONGFXID,
        this.fAPIAOH,
        this.rEGISTERDATE,
        this.bAOXIUJZRQ,
        this.sUPPLIER,
        this.pAIQIL,
        this.cHEPAIH,
        this.fADONGJH,
        this.cHELIANGSBH,
        this.cHELIANGCD,
        this.cHESHENYS,
        this.vEHICLETYPE,
        this.vEHICLEOWNER,
        this.cHELIANGXSZID,
        this.cHELIANGYTFLID,
        this.cHELIANGXSZSYR,
        this.cUNFANGDDID,
        this.sHENGCHANCJ,
        this.cHANPINXLH,
        this.dIAOCHUDANWEI,
        this.cHUJIEMJ,
        this.tUDISYQLXID,
        this.dIHAO,
        this.yUEZHEJL,
        this.wENWUDJID,
        this.cOLLECTIONDATE,
        this.hERITAGEBRIEFINTRODUCTION,
        this.hERITAGENO,
        this.wENWULY,
        this.sOURCEPLACE,
        this.zANGPINND,
        this.zHUCEDJJG,
        this.cERTNO,
        this.iAFEATUREINFO,
        this.iNVENTOR,
        this.kAIGONGDATE,
        this.zAIJIANZT,
        this.aPPROVALNUMBER,
        this.sUNYITZ,
        this.dUIWAITZJZ,
        this.pIZHUNWH,
        this.pARVALAMT,
        this.pARVALPERC,
        this.qIYEJB,
        this.pIZHUNDW,
        this.fARENDB,
        this.sHENFENID,
        this.cHIGUBL,
        this.sHISHOUZB,
        this.pIFURQ,
        this.zHUCEZB,
        this.sHIJICZJE,
        this.lIANXIFS,
        this.yINGYEKS,
        this.yINGYEJZ,
        this.iSCONTROL,
        this.oRGANID,
        this.sHANGSHI,
        this.jINGYINGFW,
        this.zUZHIXS,
        this.iNVESTEDAGENCYINFO,
        this.iNVESTEDAGENCYSTOCKNO,
        this.iNVESTEDPROValue,
        this.iNITIALINVESTAMT,
        this.bGR,
        this.sFXC,
        this.sJSYR,
        this.eXTRA,
        this.rECEIVETIME,
        this.rECEIVETYPE,
        this.iSOVERDUE});

  SelectAssetList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    syncStatus = json['syncStatus'];
    assetSourceApp = json['assetSourceApp'];
    createTime = json['createTime'];
    modifiedTime = json['modifiedTime'];
    idCardNo = json['idCardNo'];
    phoneNumber = json['phoneNumber'];
    printCount = json['printCount'];
    informationType = json['informationType'];
    businessCategory = json['businessCategory'];
    customCategory = json['customCategory'];
    oRGID = json['ORGID'];
    gS1 = json['GS1'];
    zICHANFLID = json['ZICHANFLID'];
    zICHANBH = json['ZICHANBH'];
    zICHANMC = json['ZICHANMC'];
    lIUCZT = json['LIUCZT'];
    kAPIANZT = json['KAPIANZT'];
    oLDID = json['OLDID'];
    zICHANFLBM = json['ZICHANFLBM'];
    cHANQUANDW = json['CHANQUANDW'];
    sHIYONGDW = json['SHIYONGDW'];
    gUOBIAOFLBM = json['GUOBIAOFLBM'];
    zICHANGBDLID = json['ZICHANGBDLID'];
    gONGXIANGFW = json['GONGXIANGFW'];
    jINGWEID = json['JINGWEID'];
    pRICE = json['PRICE'];
    jIAZHILXID = json['JIAZHILXID'];
    sHULIANG = json['SHULIANG'];
    dANJIA = json['DANJIA'];
    qUDERQ = json['QUDERQ'];
    tOURUSYRQ = json['TOURUSYRQ'];
    yUJISYSMSMZLYJSMZL = json['YUJISYSMSM_ZL_YJSM_ZL'];
    yISHIYONGQS = json['YISHIYONGQS'];
    sHIYONGZK2ID = json['SHIYONGZK2ID'];
    sHIYONGGLBMID = json['SHIYONG_GLBMID'];
    sHIYONGRID = json['SHIYONGRID'];
    qUDEFSID = json['QUDEFSID'];
    kUAIJIPZH = json['KUAIJIPZH'];
    zIJINLY = json['ZIJINLY'];
    jILIANGDW = json['JILIANGDW'];
    bEIZHU = json['BEIZHU'];
    bIANZHIQKID = json['BIANZHIQKID'];
    zHEJIUFFID = json['ZHEJIUFFID'];
    zHEJIUZTID = json['ZHEJIUZTID'];
    yITIZJYS = json['YITIZJYS'];
    lEIJIZJ = json['LEIJIZJ'];
    jINGZHI = json['JINGZHI'];
    yUEZHEJE = json['YUEZHEJE'];
    jUNGONGRQ = json['JUNGONGRQ'];
    jIANZHUJGID = json['JIANZHUJGID'];
    zUOLUOWZ = json['ZUOLUOWZ'];
    mIANJI = json['MIANJI'];
    cHUZUMJ = json['CHUZUMJ'];
    zIYONGMJ = json['ZIYONGMJ'];
    sUNHIUIMJ = json['SUNHIUIMJ'];
    xIANZHIMJ = json['XIANZHIMJ'];
    qITAMJ = json['QITAMJ'];
    qIZHONGWFMJ = json['QIZHONG_WFMJ'];
    cHANQUANXSID = json['CHANQUANXSID'];
    qUANSHUXZID = json['QUANSHUXZID'];
    yOUCHANQUANQK = json['YOUCHANQUANQK'];
    qUANSHUZM = json['QUANSHUZM'];
    qUANSHUZH = json['QUANSHUZH'];
    fAZHENGRQ = json['FAZHENGRQ'];
    tUDISYQRFWSYQR = json['TUDISYQR_FWSYQR'];
    wUCHANQUANQK = json['WUCHANQUANQK'];
    pINPAI = json['PINPAI'];
    gUIGEXH = json['GUIGEXH'];
    sHIYONGFXID = json['SHIYONGFXID'];
    fAPIAOH = json['FAPIAOH'];
    rEGISTERDATE = json['REGISTER_DATE'];
    bAOXIUJZRQ = json['BAOXIUJZRQ'];
    sUPPLIER = json['SUPPLIER'];
    pAIQIL = json['PAIQIL'];
    cHEPAIH = json['CHEPAIH'];
    fADONGJH = json['FADONGJH'];
    cHELIANGSBH = json['CHELIANGSBH'];
    cHELIANGCD = json['CHELIANGCD'];
    cHESHENYS = json['CHESHENYS'];
    vEHICLETYPE = json['VEHICLE_TYPE'];
    vEHICLEOWNER = json['VEHICLE_OWNER'];
    cHELIANGXSZID = json['CHELIANGXSZID'];
    cHELIANGYTFLID = json['CHELIANGYTFLID'];
    cHELIANGXSZSYR = json['CHELIANGXSZSYR'];
    cUNFANGDDID = json['CUNFANGDDID'];
    sHENGCHANCJ = json['SHENGCHANCJ'];
    cHANPINXLH = json['CHANPINXLH'];
    dIAOCHUDANWEI = json['DIAOCHUDANWEI'];
    cHUJIEMJ = json['CHUJIEMJ'];
    tUDISYQLXID = json['TUDISYQLXID'];
    dIHAO = json['DIHAO'];
    yUEZHEJL = json['YUEZHEJL'];
    wENWUDJID = json['WENWUDJID'];
    cOLLECTIONDATE = json['COLLECTION_DATE'];
    hERITAGEBRIEFINTRODUCTION = json['HERITAGE_BRIEF_INTRODUCTION'];
    hERITAGENO = json['HERITAGE_NO'];
    wENWULY = json['WENWULY'];
    sOURCEPLACE = json['SOURCE_PLACE'];
    zANGPINND = json['ZANGPINND'];
    zHUCEDJJG = json['ZHUCEDJJG'];
    cERTNO = json['CERT_NO'];
    iAFEATUREINFO = json['IA_FEATURE_INFO'];
    iNVENTOR = json['INVENTOR'];
    kAIGONGDATE = json['KAIGONGDATE'];
    zAIJIANZT = json['ZAIJIANZT'];
    aPPROVALNUMBER = json['APPROVAL_NUMBER'];
    sUNYITZ = json['SUNYITZ'];
    dUIWAITZJZ = json['DUIWAITZJZ'];
    pIZHUNWH = json['PIZHUNWH'];
    pARVALAMT = json['PAR_VAL_AMT'];
    pARVALPERC = json['PAR_VAL_PERC'];
    qIYEJB = json['QIYEJB'];
    pIZHUNDW = json['PIZHUNDW'];
    fARENDB = json['FARENDB'];
    sHENFENID = json['SHENFENID'];
    cHIGUBL = json['CHIGUBL'];
    sHISHOUZB = json['SHISHOUZB'];
    pIFURQ = json['PIFURQ'];
    zHUCEZB = json['ZHUCEZB'];
    sHIJICZJE = json['SHIJICZJE'];
    lIANXIFS = json['LIANXIFS'];
    yINGYEKS = json['YINGYEKS'];
    yINGYEJZ = json['YINGYEJZ'];
    iSCONTROL = json['ISCONTROL'];
    oRGANID = json['ORGANID'];
    sHANGSHI = json['SHANGSHI'];
    jINGYINGFW = json['JINGYINGFW'];
    zUZHIXS = json['ZUZHIXS'];
    iNVESTEDAGENCYINFO = json['INVESTED_AGENCY_INFO'];
    iNVESTEDAGENCYSTOCKNO = json['INVESTED_AGENCY_STOCK_NO'];
    iNVESTEDPROValue = json['INVESTED_PRO_value'];
    iNITIALINVESTAMT = json['INITIAL_INVEST_AMT'];
    bGR = json['BGR'];
    sFXC = json['SFXC'];
    sJSYR = json['SJSYR'];
    // eXTRA = json['EXTRA'] != null ? new EXTRA.fromJson(json['EXTRA']) : null;
    rECEIVETIME = json['RECEIVETIME'];
    rECEIVETYPE = json['RECEIVETYPE'];
    iSOVERDUE = json['IS_OVER_DUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['syncStatus'] = this.syncStatus;
    data['assetSourceApp'] = this.assetSourceApp;
    data['createTime'] = this.createTime;
    data['modifiedTime'] = this.modifiedTime;
    data['idCardNo'] = this.idCardNo;
    data['phoneNumber'] = this.phoneNumber;
    data['printCount'] = this.printCount;
    data['informationType'] = this.informationType;
    data['businessCategory'] = this.businessCategory;
    data['customCategory'] = this.customCategory;
    data['ORGID'] = this.oRGID;
    data['GS1'] = this.gS1;
    data['ZICHANFLID'] = this.zICHANFLID;
    data['ZICHANBH'] = this.zICHANBH;
    data['ZICHANMC'] = this.zICHANMC;
    data['LIUCZT'] = this.lIUCZT;
    data['KAPIANZT'] = this.kAPIANZT;
    data['OLDID'] = this.oLDID;
    data['ZICHANFLBM'] = this.zICHANFLBM;
    data['CHANQUANDW'] = this.cHANQUANDW;
    data['SHIYONGDW'] = this.sHIYONGDW;
    data['GUOBIAOFLBM'] = this.gUOBIAOFLBM;
    data['ZICHANGBDLID'] = this.zICHANGBDLID;
    data['GONGXIANGFW'] = this.gONGXIANGFW;
    data['JINGWEID'] = this.jINGWEID;
    data['PRICE'] = this.pRICE;
    data['JIAZHILXID'] = this.jIAZHILXID;
    data['SHULIANG'] = this.sHULIANG;
    data['DANJIA'] = this.dANJIA;
    data['QUDERQ'] = this.qUDERQ;
    data['TOURUSYRQ'] = this.tOURUSYRQ;
    data['YUJISYSMSM_ZL_YJSM_ZL'] = this.yUJISYSMSMZLYJSMZL;
    data['YISHIYONGQS'] = this.yISHIYONGQS;
    data['SHIYONGZK2ID'] = this.sHIYONGZK2ID;
    data['SHIYONG_GLBMID'] = this.sHIYONGGLBMID;
    data['SHIYONGRID'] = this.sHIYONGRID;
    data['QUDEFSID'] = this.qUDEFSID;
    data['KUAIJIPZH'] = this.kUAIJIPZH;
    data['ZIJINLY'] = this.zIJINLY;
    data['JILIANGDW'] = this.jILIANGDW;
    data['BEIZHU'] = this.bEIZHU;
    data['BIANZHIQKID'] = this.bIANZHIQKID;
    data['ZHEJIUFFID'] = this.zHEJIUFFID;
    data['ZHEJIUZTID'] = this.zHEJIUZTID;
    data['YITIZJYS'] = this.yITIZJYS;
    data['LEIJIZJ'] = this.lEIJIZJ;
    data['JINGZHI'] = this.jINGZHI;
    data['YUEZHEJE'] = this.yUEZHEJE;
    data['JUNGONGRQ'] = this.jUNGONGRQ;
    data['JIANZHUJGID'] = this.jIANZHUJGID;
    data['ZUOLUOWZ'] = this.zUOLUOWZ;
    data['MIANJI'] = this.mIANJI;
    data['CHUZUMJ'] = this.cHUZUMJ;
    data['ZIYONGMJ'] = this.zIYONGMJ;
    data['SUNHIUIMJ'] = this.sUNHIUIMJ;
    data['XIANZHIMJ'] = this.xIANZHIMJ;
    data['QITAMJ'] = this.qITAMJ;
    data['QIZHONG_WFMJ'] = this.qIZHONGWFMJ;
    data['CHANQUANXSID'] = this.cHANQUANXSID;
    data['QUANSHUXZID'] = this.qUANSHUXZID;
    data['YOUCHANQUANQK'] = this.yOUCHANQUANQK;
    data['QUANSHUZM'] = this.qUANSHUZM;
    data['QUANSHUZH'] = this.qUANSHUZH;
    data['FAZHENGRQ'] = this.fAZHENGRQ;
    data['TUDISYQR_FWSYQR'] = this.tUDISYQRFWSYQR;
    data['WUCHANQUANQK'] = this.wUCHANQUANQK;
    data['PINPAI'] = this.pINPAI;
    data['GUIGEXH'] = this.gUIGEXH;
    data['SHIYONGFXID'] = this.sHIYONGFXID;
    data['FAPIAOH'] = this.fAPIAOH;
    data['REGISTER_DATE'] = this.rEGISTERDATE;
    data['BAOXIUJZRQ'] = this.bAOXIUJZRQ;
    data['SUPPLIER'] = this.sUPPLIER;
    data['PAIQIL'] = this.pAIQIL;
    data['CHEPAIH'] = this.cHEPAIH;
    data['FADONGJH'] = this.fADONGJH;
    data['CHELIANGSBH'] = this.cHELIANGSBH;
    data['CHELIANGCD'] = this.cHELIANGCD;
    data['CHESHENYS'] = this.cHESHENYS;
    data['VEHICLE_TYPE'] = this.vEHICLETYPE;
    data['VEHICLE_OWNER'] = this.vEHICLEOWNER;
    data['CHELIANGXSZID'] = this.cHELIANGXSZID;
    data['CHELIANGYTFLID'] = this.cHELIANGYTFLID;
    data['CHELIANGXSZSYR'] = this.cHELIANGXSZSYR;
    data['CUNFANGDDID'] = this.cUNFANGDDID;
    data['SHENGCHANCJ'] = this.sHENGCHANCJ;
    data['CHANPINXLH'] = this.cHANPINXLH;
    data['DIAOCHUDANWEI'] = this.dIAOCHUDANWEI;
    data['CHUJIEMJ'] = this.cHUJIEMJ;
    data['TUDISYQLXID'] = this.tUDISYQLXID;
    data['DIHAO'] = this.dIHAO;
    data['YUEZHEJL'] = this.yUEZHEJL;
    data['WENWUDJID'] = this.wENWUDJID;
    data['COLLECTION_DATE'] = this.cOLLECTIONDATE;
    data['HERITAGE_BRIEF_INTRODUCTION'] = this.hERITAGEBRIEFINTRODUCTION;
    data['HERITAGE_NO'] = this.hERITAGENO;
    data['WENWULY'] = this.wENWULY;
    data['SOURCE_PLACE'] = this.sOURCEPLACE;
    data['ZANGPINND'] = this.zANGPINND;
    data['ZHUCEDJJG'] = this.zHUCEDJJG;
    data['CERT_NO'] = this.cERTNO;
    data['IA_FEATURE_INFO'] = this.iAFEATUREINFO;
    data['INVENTOR'] = this.iNVENTOR;
    data['KAIGONGDATE'] = this.kAIGONGDATE;
    data['ZAIJIANZT'] = this.zAIJIANZT;
    data['APPROVAL_NUMBER'] = this.aPPROVALNUMBER;
    data['SUNYITZ'] = this.sUNYITZ;
    data['DUIWAITZJZ'] = this.dUIWAITZJZ;
    data['PIZHUNWH'] = this.pIZHUNWH;
    data['PAR_VAL_AMT'] = this.pARVALAMT;
    data['PAR_VAL_PERC'] = this.pARVALPERC;
    data['QIYEJB'] = this.qIYEJB;
    data['PIZHUNDW'] = this.pIZHUNDW;
    data['FARENDB'] = this.fARENDB;
    data['SHENFENID'] = this.sHENFENID;
    data['CHIGUBL'] = this.cHIGUBL;
    data['SHISHOUZB'] = this.sHISHOUZB;
    data['PIFURQ'] = this.pIFURQ;
    data['ZHUCEZB'] = this.zHUCEZB;
    data['SHIJICZJE'] = this.sHIJICZJE;
    data['LIANXIFS'] = this.lIANXIFS;
    data['YINGYEKS'] = this.yINGYEKS;
    data['YINGYEJZ'] = this.yINGYEJZ;
    data['ISCONTROL'] = this.iSCONTROL;
    data['ORGANID'] = this.oRGANID;
    data['SHANGSHI'] = this.sHANGSHI;
    data['JINGYINGFW'] = this.jINGYINGFW;
    data['ZUZHIXS'] = this.zUZHIXS;
    data['INVESTED_AGENCY_INFO'] = this.iNVESTEDAGENCYINFO;
    data['INVESTED_AGENCY_STOCK_NO'] = this.iNVESTEDAGENCYSTOCKNO;
    data['INVESTED_PRO_value'] = this.iNVESTEDPROValue;
    data['INITIAL_INVEST_AMT'] = this.iNITIALINVESTAMT;
    data['BGR'] = this.bGR;
    data['SFXC'] = this.sFXC;
    data['SJSYR'] = this.sJSYR;
    if (this.eXTRA != null) {
      data['EXTRA'] = this.eXTRA!.toJson();
    }
    data['RECEIVETIME'] = this.rECEIVETIME;
    data['RECEIVETYPE'] = this.rECEIVETYPE;
    data['IS_OVER_DUE'] = this.iSOVERDUE;
    return data;
  }

  bool get notLockStatus =>
      kAPIANZT != '07' &&
      kAPIANZT != '08' &&
      kAPIANZT != '09' &&
      kAPIANZT != '11' &&
      kAPIANZT != '12';

  void initStatus() {
    isOpen = false;
    isSelected = false;
  }
}

class EXTRA {
  EXTRA();

  EXTRA.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}