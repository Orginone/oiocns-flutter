import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 实体详情页面
class EntityInfoPage extends OrginoneStatelessWidget {
  EntityInfoPage({super.key, super.data});

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    Widget? content;
    if (data is ISession) {
      data = data.metadata;
    }
    if (data is XTarget || data is IEntity) {
      content = Scrollbar(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                publicInfo(context, data),
                if (data is IPerson) privateInfo(context, data),
                // cardPackageSettings(context, data),
              ],
            )),
      );
    }
    return content ?? const Center(child: Text("空白"));
  }

  /// 公开信息
  publicInfo(BuildContext context, dynamic entity) {
    XTarget? target = _getStorageTarget(entity);
    return Card(
        margin: const EdgeInsets.only(left: 0, right: 0),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTitle('公开信息'),
              _buildColumnInfo('个人头像', XImage.entityIcon(entity, width: 35)),
              // IconWidget(iconData: ,),
              _buildColumnTextInfo('名称', entity.name),
              _buildColumnTextInfo('账号', entity.code),
              if (null != target)
                target.typeName == TargetType.storage.label
                    ? _buildColumnInfo(
                        '当前数据核',
                        Row(
                          children: [
                            XImage.entityIcon(target, width: 30.w),
                            SizedBox(width: 5.h),
                            Text(
                              target.name ?? '奥集能数据核',
                              style: const TextStyle(
                                color: Color(0xFF366EF4),
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ))
                    : _buildColumnInfo(
                        '归属',
                        Row(
                          children: [
                            XImage.entityIcon(target, width: 30.w),
                            SizedBox(width: 5.h),
                            Text(
                              target.name ?? '奥集能数据核',
                              style: const TextStyle(
                                color: Color(0xFF366EF4),
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        )),
              // _buildColumnInfo(
              //     '归属',
              //     Row(
              //       children: [
              //         XImage.entityIcon(belong, width: 30.w),
              //         SizedBox(width: 5.h),
              //         Text(
              //           belong.name ?? '',
              //           style: const TextStyle(
              //             color: Color(0xFF366EF4),
              //             fontSize: 14,
              //             fontFamily: 'PingFang SC',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         )
              //       ],
              //     )),
              _buildColumnTextInfo('简介', entity.remark),
              _buildColumnInfo('二维码', _buildQRCode()),
            ],
          ),
        ));
  }

  Widget _buildQRCode() {
    return QrImageView(
      data: '${Constant.host}/${data.id}',
      semanticsLabel: "${Constant.host}/${data.id}",
      version: QrVersions.auto,
      size: 300.w,
      embeddedImage: data is IEntity && data.share.avatar != null
          ? MemoryImage(data.share.avatar?.thumbnailUint8List)
          : null,
      // errorCorrectionLevel: QrErrorCorrectLevel.H,
      embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60.w, 60.w)),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
    );
  }

  XTarget? _getStorageTarget(dynamic entity) {
    XTarget? target;
    if (entity is XTarget && null != entity.storeId) {
      target = relationCtrl.user?.findMetadata(entity.storeId!);
    } else if (entity is IEntity &&
        entity.metadata is XTarget &&
        null != entity.metadata.storeId) {
      target = relationCtrl.user?.findMetadata(entity.metadata.storeId!);
    } else if (entity is IEntity &&
        entity.metadata is XTarget &&
        null != entity.metadata.belongId &&
        entity.metadata.belongId != entity.id) {
      target = relationCtrl.user?.findMetadata(entity.metadata.belongId!);
    }
    return target;
  }

  Widget _buildHeaderTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  /// 构建文本信息
  Widget _buildColumnTextInfo(String title, String value) {
    return _buildColumnInfo(
        title,
        Text(
          value,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8999999761581421),
            fontSize: 14,
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  /// 构建组件信息
  Widget _buildColumnInfo(String title, Widget value) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4000000059604645),
                fontSize: 14,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            value,
          ],
        ));
  }

  /// 隐私信息
  Widget privateInfo(BuildContext context, dynamic entity) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildHeaderTitle('隐私信息'),
          _buildRowTextInfo("手机号", entity.code),
          _buildRowTextInfo("单位", ""),
          _buildRowTextInfo("邮箱", ''),
          _buildRowTextInfo("微信", ''),
        ],
      ),
    ));
  }

  Widget _buildRowTextInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF6F7686),
                  fontSize: 14,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: const IconWidget(
                  iconData: Icons.edit,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// 卡包设置
  cardPackageSettings(BuildContext context, data) {}
}
