import 'package:orginone/model/file_data.dart';

class MyAssetsList {
  List<FileData>? fileList;
  Map<String, dynamic>? assetType;
  String? assetName;
  String? assetCode;
  String? startDate;
  Map<String, dynamic>? useDept;
  String? fixedAssAcqCode;
  dynamic estimatedUsefulLife;
  String? quderq;
  dynamic numOrArea;
  String? numUnit;
  dynamic haveUsedIt;
  dynamic netVal;
  dynamic residualRate;
  dynamic monthAccDep;
  dynamic accDepMonth;
  String? depreciationMethod;
  String? accDep;
  dynamic canZhi;
  dynamic initAssetVal;
  int? liuCzt;
  String? id;
  String? gmtCreate;
  String? updateTime;
  String? brand;
  String? specMod;
  String? location;
  String? invoiceNo;
  String? sourcesOfFunding;
  Map<String,dynamic>? user;
  String? manufacturer;
  String? fixedAssetStateCode;
  String? supplier;
  String? remark;
  Map<String,dynamic>? theDepository;
  String? gs1;
  String? minimumLimit;

  String? acquirementWay;

  String? kapianzt;

  int? status;
  String? stockTaskCode;
  String? assetRemark;


  bool isOpen = false;

  bool isSelected = false;


  MyAssetsList(
      {this.fileList,
      this.assetType,
      this.assetName,
      this.assetCode,
      this.startDate,
      this.useDept,
      this.fixedAssAcqCode,
      this.estimatedUsefulLife,
      this.quderq,
      this.numOrArea,
      this.numUnit,
      this.haveUsedIt,
      this.netVal,
      this.residualRate,
      this.monthAccDep,
      this.accDepMonth,
      this.depreciationMethod,
      this.accDep,
      this.canZhi,
      this.initAssetVal,
      this.liuCzt,
      this.id,
      this.gmtCreate,
      this.updateTime});

  MyAssetsList.fromJson(Map<String, dynamic> json) {
    if (json['fileList'] != null) {
      fileList = [];
      json[fileList]?.forEach((json) {
        fileList!.add(FileData.fromJson(json));
      });
    }
    assetType = json['ASSET_TYPE'];
    assetName = json['ASSET_NAME'];
    assetCode = json['ASSET_CODE'];
    startDate = json['START_DATE'];
    useDept = json['USE_DEPT'];
    fixedAssAcqCode = json['FIXED_ASS_ACQ_CODE'];
    estimatedUsefulLife = json['ESTIMATED_USEFUL_LIFE'];
    quderq = json['QUDERQ'];
    numOrArea = json['NUM_OR_AREA'];
    numUnit = json['NUM_UNIT'];
    haveUsedIt = json['HAVE_USED_IT'];
    netVal = json['NET_VAL'];
    residualRate = json['RESIDUAL_RATE'];
    monthAccDep = json['MONTH_ACC_DEP'];
    accDepMonth = json['ACC_DEP_MONTH'];
    depreciationMethod = json['DEPRECIATION_METHOD'];
    accDep = json['ACC_DEP'];
    canZhi = json['CANZHI'];
    initAssetVal = json['INIT_ASSET_VAL'];
    liuCzt = json['LIUCZT'];
    id = json['id'];
    gmtCreate = json['gmtCreate'];
    updateTime = json['UPDATE_TIME'];
    brand = json['BRAND'];
    specMod = json['SPEC_MOD'];
    location = json['LOCATION'];
    invoiceNo = json['INVOICE_NO'];
    sourcesOfFunding = json['SOURCES_OF_FUNDING'];
    user = json['USER'];
    manufacturer = json['MANUFACTURER'];
    fixedAssetStateCode = json['FIXED_ASSET_STATE_CODE'];
    supplier = json['SUPPLIER'];
    remark = json['REMARK'];
    theDepository = json['THE_DEPOSITORY'];
    gs1 = json['GS1'];
    minimumLimit = json['MINIMUM_LIMIT'];
    acquirementWay = json['ACQUIREMENT_WAY'];
    kapianzt = json['KAPIANZT'];
    status = json['status'];
    assetRemark = json['assetRemark'];
    stockTaskCode = json['stockTaskCode'];
  }

  update(Map<String, dynamic> json) {
    if (json['fileList'] != null) {
      fileList = [];
      json[fileList]?.forEach((json) {
        fileList!.add(FileData.fromJson(json));
      });
    }
    assetType = json['ASSET_TYPE'] ?? assetType;
    assetName = json['ASSET_NAME'] ?? assetName;
    assetCode = json['ASSET_CODE'] ?? assetCode;
    startDate = json['START_DATE'] ?? startDate;
    useDept = json['USE_DEPT'] ?? useDept;
    fixedAssAcqCode = json['FIXED_ASS_ACQ_CODE'] ?? fixedAssAcqCode;
    estimatedUsefulLife = json['ESTIMATED_USEFUL_LIFE'] ?? estimatedUsefulLife;
    quderq = json['QUDERQ'] ?? quderq;
    numOrArea = json['NUM_OR_AREA'] ?? numOrArea;
    numUnit = json['NUM_UNIT'] ?? numUnit;
    haveUsedIt = json['HAVE_USED_IT'] ?? haveUsedIt;
    netVal = json['NET_VAL'] ?? netVal;
    residualRate = json['RESIDUAL_RATE'] ?? residualRate;
    monthAccDep = json['MONTH_ACC_DEP'] ?? monthAccDep;
    accDepMonth = json['ACC_DEP_MONTH'] ?? accDepMonth;
    depreciationMethod = json['DEPRECIATION_METHOD'] ?? depreciationMethod;
    accDep = json['ACC_DEP'] ?? accDep;
    canZhi = json['CANZHI'] ?? canZhi;
    initAssetVal = json['INIT_ASSET_VAL'] ?? initAssetVal;
    liuCzt = json['LIUCZT'] ?? liuCzt;
    id = json['id'] ?? id;
    gmtCreate = json['gmtCreate'] ?? gmtCreate;
    updateTime = json['UPDATE_TIME'] ?? updateTime;
    brand = json['BRAND'] ?? brand;
    specMod = json['SPEC_MOD'] ?? specMod;
    location = json['LOCATION'] ?? location;
    invoiceNo = json['INVOICE_NO'] ?? invoiceNo;
    sourcesOfFunding = json['SOURCES_OF_FUNDING'] ?? sourcesOfFunding;
    user = json['USER'] ?? user;
    manufacturer = json['MANUFACTURER'] ?? manufacturer;
    fixedAssetStateCode = json['FIXED_ASSET_STATE_CODE'] ?? fixedAssetStateCode;
    supplier = json['SUPPLIER'] ?? supplier;
    remark = json['REMARK'] ?? remark;
    theDepository = json['THE_DEPOSITORY'] ?? theDepository;
    gs1 = json['GS1'] ?? gs1;
    minimumLimit = json['MINIMUM_LIMIT'] ?? minimumLimit;
    acquirementWay = json['ACQUIREMENT_WAY'] ?? acquirementWay;
    kapianzt = json['KAPIANZT'] ?? kapianzt;
  }

  bool get notLockStatus =>
      kapianzt != '07' &&
      kapianzt != '08' &&
      kapianzt != '09' &&
      kapianzt != '11' &&
      kapianzt != '12';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assetType != null) {
      data['ASSET_TYPE'] = this.assetType;
    }
    data['ASSET_NAME'] = this.assetName;
    data['ASSET_CODE'] = this.assetCode;
    data['START_DATE'] = this.startDate;
    if (this.useDept != null) {
      data['USE_DEPT'] = this.useDept;
    }
    data['FIXED_ASS_ACQ_CODE'] = this.fixedAssAcqCode;
    data['ESTIMATED_USEFUL_LIFE'] = this.estimatedUsefulLife;
    data['QUDERQ'] = this.quderq;
    data['NUM_OR_AREA'] = this.numOrArea;
    data['NUM_UNIT'] = this.numUnit;
    data['HAVE_USED_IT'] = this.haveUsedIt;
    data['NET_VAL'] = this.netVal;
    data['RESIDUAL_RATE'] = this.residualRate;
    data['MONTH_ACC_DEP'] = this.monthAccDep;
    data['ACC_DEP_MONTH'] = this.accDepMonth;
    data['DEPRECIATION_METHOD'] = this.depreciationMethod;
    data['ACC_DEP'] = this.accDep;
    data['CANZHI'] = this.canZhi;
    data['INIT_ASSET_VAL'] = this.initAssetVal;
    data['LIUCZT'] = this.liuCzt;
    data['id'] = this.id;
    data['gmtCreate'] = this.gmtCreate;
    data['UPDATE_TIME'] = this.updateTime;
    data['SPEC_MOD'] = this.specMod;
    data['BRAND'] = this.brand;
    data['LOCATION'] = this.location;
    data['INVOICE_NO'] = this.invoiceNo;
    data['SOURCES_OF_FUNDING'] = this.sourcesOfFunding;
    data['USER'] = this.user;
    data['MANUFACTURER'] = this.manufacturer;
    data['FIXED_ASSET_STATE_CODE'] = this.fixedAssetStateCode;
    data['SUPPLIER'] = this.supplier;
    data['REMARK'] = this.remark;
    data['THE_DEPOSITORY'] = this.theDepository;
    data['GS1'] = gs1;
    data['MINIMUM_LIMIT'] = minimumLimit;
    data['ACQUIREMENT_WAY'] = acquirementWay;
    data['KAPIANZT'] = this.kapianzt;
    data['status'] = this.status;
    data["stockTaskCode"] = this.stockTaskCode;
    data['assetRemark'] = this.assetRemark;
    return data;
  }

  void initStatus() {
    isOpen = false;
    isSelected = false;
  }
}
