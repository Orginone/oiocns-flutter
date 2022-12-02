import 'package:orginone/component/form/form_widget.dart';
import 'package:orginone/component/maintain_widget.dart';

List<FormItem> get _cohortFields {
  return const [
    FormItem(
      fieldKey: 'name',
      fieldName: "群组名称",
      itemType: ItemType.text,
      required: true,
    ),
    FormItem(
      fieldKey: 'code',
      fieldName: "群组编号",
      itemType: ItemType.text,
      required: true,
    ),
    FormItem(
      fieldKey: 'remark',
      fieldName: "群组简介",
      itemType: ItemType.text,
      required: true,
    ),
  ];
}

class CreateCohort extends MaintainInfo {
  CreateCohort(Function(Map<String, dynamic>) create)
      : super(
          formConfig: FormConfig(
            title: "创建群组",
            status: MaintainStatus.create,
            items: _cohortFields,
          ),
          call: create,
        );
}

class UpdateCohort extends MaintainInfo {
  UpdateCohort(Function(Map<String, dynamic>) update)
      : super(
          formConfig: FormConfig(
            title: "更新群组",
            status: MaintainStatus.create,
            items: _cohortFields,
          ),
          call: update,
        );
}

List<FormItem> get _companyFields {
  return [
    const FormItem(
      fieldKey: 'name',
      fieldName: "单位名称",
      itemType: ItemType.text,
      required: true,
    ),
    const FormItem(
      fieldKey: 'code',
      fieldName: "社会统一信用代码",
      itemType: ItemType.text,
      required: true,
    ),
    const FormItem(
      fieldKey: 'teamName',
      fieldName: "团队简称",
      itemType: ItemType.text,
      required: true,
    ),
    const FormItem(
      fieldKey: 'teamCode',
      fieldName: "团队标识",
      itemType: ItemType.text,
      required: true,
    ),
    const FormItem(
      fieldKey: 'teamRemark',
      fieldName: "团队信息备注",
      itemType: ItemType.text,
      required: true,
    ),
  ];
}

class CreateCompany extends MaintainInfo {
  CreateCompany(Function(Map<String, dynamic>) create)
      : super(
          formConfig: FormConfig(
            title: "创建单位",
            status: MaintainStatus.create,
            items: _companyFields,
          ),
          call: create,
        );
}

class UpdateCompany extends MaintainInfo {
  UpdateCompany(Function(Map<String, dynamic>) update)
      : super(
          formConfig: FormConfig(
            title: "更新单位",
            status: MaintainStatus.create,
            items: _companyFields,
          ),
          call: update,
        );
}

List<FormItem> _marketFields = const [
  FormItem(
    fieldKey: "name",
    fieldName: "商店名称",
    itemType: ItemType.text,
    required: true,
  ),
  FormItem(
    fieldKey: "code",
    fieldName: "商店编码",
    itemType: ItemType.text,
    required: true,
  ),
  FormItem(
    fieldKey: "remark",
    fieldName: "商店介绍",
    itemType: ItemType.text,
    required: true,
  ),
  FormItem(
    fieldKey: "public",
    fieldName: "是否公开",
    itemType: ItemType.onOff,
    defaultValue: true,
    required: true,
  ),
];

class CreateMarket extends MaintainInfo {
  CreateMarket(Function(Map<String, dynamic>) create)
      : super(
          formConfig: FormConfig(
            title: "创建市场",
            status: MaintainStatus.create,
            items: _marketFields,
          ),
          call: create,
        );
}

class UpdateMarket extends MaintainInfo {
  UpdateMarket(Function(Map<String, dynamic>) update)
      : super(
          formConfig: FormConfig(
            title: "更新市场",
            status: MaintainStatus.create,
            items: _marketFields,
          ),
          call: update,
        );
}

List<FormItem> _uploadFields = const [
  FormItem(
    fieldKey: "version",
    fieldName: "版本",
    itemType: ItemType.text,
    required: true,
  ),
  FormItem(
    fieldKey: "remark",
    fieldName: "更新信息",
    itemType: ItemType.text,
    required: true,
  ),
  FormItem(
    fieldKey: "path",
    fieldName: "文件路径",
    itemType: ItemType.upload,
    required: true,
  ),
];

class NewVersion extends MaintainInfo {
  NewVersion(Function(Map<String, dynamic>) upload)
      : super(
          formConfig: FormConfig(
            title: "上传 APK",
            status: MaintainStatus.create,
            items: _uploadFields,
          ),
          call: upload,
        );
}
