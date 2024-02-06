import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart' as model;
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/work/rules/lib/tools.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';

//渲染动态信息
class ActivityMessageWidget extends StatelessWidget {
  //动态消息
  late Rx<IActivityMessage> item;
  RxBool isDelete = false.obs;
  //动态
  IActivity activity;
  //动态元数据
  model.ActivityType? metadata;
  //隐藏点赞信息和回复信息，只显示统计数量
  bool hideResource;
  ActivityMessageWidget(
      {super.key,
      required IActivityMessage item,
      required this.activity,
      this.hideResource = false}) {
    this.item = item.obs;
    metadata = this.item.value.metadata;
    //订阅数据变更
    item.unsubscribe();
    item.subscribe((key, args) {
      this.item.refresh();
    }, false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        // margin: EdgeInsets.only(top: hideResource ? 6.h : 0, left: 0, right: 0),
        // padding: EdgeInsets.all(10.h),
        // color: XColors.bgListItem,
        child: Offstage(
          offstage: isDelete.value,
          child: Column(
            children: [
              ListItemMetaWidget(
                title: title(),
                subTitle: subTitle(),
                avatar: avatar(),
                description: description(context),
                onTap: hideResource
                    ? () {
                        Get.toNamed(
                          Routers.targetActivity,
                          arguments: item.value,
                        );
                      }
                    : null,
              ),
              // const Divider(thickness: 6),
              SizedBox(
                height: 5.h,
              )
            ],
          ),
        ),
      );
    });
  }

  //渲染标题
  Widget title() {
    return Container(
      child: Row(
        children: [
          Text(activity.metadata.name!, style: XFonts.activityListTitle),
          Padding(padding: EdgeInsets.only(left: 10.h)),
          if (metadata?.tags.isNotEmpty ?? false)
            ...metadata!.tags
                .map((e) => OutlinedButton(onPressed: () {}, child: Text(e)))
                .toList()
        ],
      ),
    );
  }

  Widget subTitle() {
    XEntity? entity = relationCtrl.user
        .findMetadata<XEntity>(item.value.metadata.createUser!);
    return Row(
      children: [
        // TeamAvatar(
        //   info: TeamTypeInfo(userId: item.value.metadata.createUser!),
        //   size: 24.w,
        // ),
        Container(
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.only(left: 5.w),
          child: Row(
            children: [
              Text(
                  "${showChatTime(item.value.metadata.createTime!)}·${entity?.name}",
                  style: XFonts.activityListSubTitle),
            ],
          ),
        )
      ],
    );
  }

  //渲染内容
  Widget? renderContent() {
    switch (MessageType.getType(metadata!.typeName)) {
      case MessageType.text:
        return Text(metadata!.content,
            style: XFonts.activitListContent,
            maxLines: 3,
            overflow: TextOverflow.ellipsis);
      case MessageType.html:
        if (hideResource) {
          return (Offstage(
            offstage: !hideResource,
            child: Text(parseHtmlToText(metadata!.content),
                style: XFonts.activitListContent,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
          ));
        } else {
          return HtmlWidget(metadata!.content,
              textStyle: TextStyle(fontSize: 24.sp), onTapUrl: (url) {
            Get.toNamed(Routers.webView, arguments: {'url': url});
            return true;
          });
        }
    }
    return null;
  }

  //渲染头像
  Widget avatar() {
    // return CircleAvatar(
    //   backgroundImage: AssetImage(activity.typeName),
    // );
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      TeamAvatar(
        info: TeamTypeInfo(
            share: activity.metadata.shareIcon() ??
                model.ShareIcon(name: '', typeName: activity.typeName ?? "")),
        size: 35.w,
      ),
    ]);
  }

  //渲染描述
  Widget description(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            child: renderContent() ?? Container(),
          ),
          if (!hideResource &&
              null != metadata &&
              metadata!.resource.isNotEmpty)
            ActivityResourceWidget(metadata!.resource, 100),
          RenderCtxMore(
            activity: activity,
            item: item,
            hideResource: hideResource,
            isDelete: isDelete,
          )
        ],
      ),
    );
  }
}

//渲染动态属性信息
class RenderCtxMore extends StatelessWidget {
  Rx<IActivityMessage> item;
  IActivity activity;
  RxBool isDelete;
  bool hideResource;
  late XEntity? replyTo;
  bool commenting = false;

  RenderCtxMore(
      {super.key,
      required this.activity,
      required this.item,
      required this.hideResource,
      required this.isDelete});

  @override
  Widget build(BuildContext context) {
    if (hideResource) {
      return renderTags();
    }
    return Column(children: [
      renderOperate(context),
      Offstage(
        offstage: item.value.metadata.likes.isEmpty &&
            item.value.metadata.comments.isEmpty,
        child: _buildLikeBoxWidget(),
      ),
      Padding(padding: EdgeInsets.only(left: 5.w)),
      Offstage(
        offstage: item.value.metadata.comments.isEmpty,
        child: _buildCommentBoxWidget(context),
      )
    ]);
  }

  //判断是否有回复
  Future<void> handleReply(BuildContext context, [String userId = '']) async {
    replyTo = null;
    if (userId.isNotEmpty) {
      var user = await relationCtrl.user.findEntityAsync(userId);
      replyTo = user;
    }
    ShowCommentBoxNotification((text) async {
      return await item.value.comment(text, replyTo: replyTo?.id);
    },
            getTipInfo: replyTo != null
                ? () {
                    return "回复${replyTo?.name}：";
                  }
                : null)
        .dispatch(context);
  }

  //渲染操作
  Widget renderOperate(BuildContext context) {
    return Container(child: Obx(() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWidget.iconTextOutlined(
                onTap: () async {
                  handleReply(context);
                },
                // const ImageWidget(
                //   AssetsImages.iconMsg,
                //   size: 18,
                // ),
                XImage.localImage(XImage.forward, width: 24.w),
                '转发',
                textColor: XColors.black3,
              ),
              Offstage(
                  offstage:
                      !item.value.metadata.likes.contains(relationCtrl.user.id),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: ButtonWidget.iconTextOutlined(
                      onTap: () async {
                        await item.value.like();
                      },
                      // const ImageWidget(
                      //   AssetsImages.iconLike,
                      //   size: 18,
                      //   color: Colors.red,
                      // ),
                      XImage.localImage(XImage.likeFill, width: 24.w),
                      '取消',
                      textColor: XColors.black3,
                    ),
                  )),
              Offstage(
                offstage:
                    item.value.metadata.likes.contains(relationCtrl.user.id),
                child: ButtonWidget.iconTextOutlined(
                  onTap: () async {
                    await item.value.like();
                  },
                  // const ImageWidget(
                  //   AssetsImages.iconLike,
                  //   size: 18,
                  // ),
                  XImage.localImage(XImage.likeOutline, width: 24.w),
                  '点赞',
                  textColor: XColors.black3,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 5.w)),
              ButtonWidget.iconTextOutlined(
                onTap: () async {
                  handleReply(context);
                },
                // const ImageWidget(
                //   AssetsImages.iconMsg,
                //   size: 18,
                // ),
                XImage.localImage(XImage.commentOutline, width: 24.w),
                '评论',
                textColor: XColors.black3,
              ),
              if (item.value.canDelete) ...[
                Padding(padding: EdgeInsets.only(left: 5.w)),
                ButtonWidget.iconTextOutlined(
                  onTap: () async {
                    await item.value.delete();
                    isDelete.value = true;
                    //提醒动态分类更新信息
                    activity.activityList.first.changCallback();
                  },
                  // const Icon(
                  //   Icons.delete_outline,
                  //   size: 18,
                  //   color: XColors.black3,
                  // ),
                  XImage.localImage(XImage.deleteOutline,
                      color: XColors.black3, width: 24.w),
                  '删除',
                  textColor: XColors.black3,
                ),
              ]
            ],
          )
        ],
      );
    }));
  }

  ///渲染点赞信息
  Widget _buildLikeBoxWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      color: XColors.bgListItem1,
      padding: EdgeInsets.all(5.w),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 4,
        spacing: 1,
        children: [
          // const ImageWidget(AssetsImages.iconLike,
          //     size: 18, color: Colors.red),
          XImage.localImage(XImage.likeFill, width: 24.w, color: Colors.red),
          for (var e in item.value.metadata.likes) ...getUserAvatar(e)
        ],
      ),
    );
  }

  ///渲染评论信息
  Widget _buildCommentBoxWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: XColors.bgListItem1,
      margin: EdgeInsets.only(top: 5.w),
      padding: EdgeInsets.all(5.w),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
            child: const Text("全部评论",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          ...item.value.metadata.comments.map((e) => ActivityComment(
              comment: e,
              onTap: (comment) => handleReply(context, comment.userId)))
        ],
      ),
    );
  }

  //渲染发布者信息
  Widget renderTags() {
    XEntity? entity = relationCtrl.user
        .findMetadata<XEntity>(item.value.metadata.createUser!);
    var showLikes = item.value.metadata.likes.isEmpty &&
        item.value.metadata.comments.isEmpty;
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 5.h)),
          Offstage(
            offstage: showLikes,
            child: Container(
                padding: EdgeInsets.all(5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        // const ImageWidget(Icons.forward_5, size: 18),
                        XImage.localImage(XImage.forward, width: 24.w),
                        Container(
                            padding: EdgeInsets.only(left: 6.w),
                            child: const Text("转发"))
                      ],
                    ),
                    Row(
                      children: [
                        // const ImageWidget(AssetsImages.iconLike,
                        //     size: 18, color: Colors.red),
                        XImage.localImage(XImage.likeFill,
                            width: 24.w, color: Colors.red),
                        Container(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Text(
                                "${item.value.metadata.likes.isEmpty ? '点赞' : item.value.metadata.likes.length}"))
                      ],
                    ),
                    Row(
                      children: [
                        // const ImageWidget(AssetsImages.iconMsg, size: 18),
                        XImage.localImage(XImage.commentOutline, width: 24.w),
                        Container(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Text(
                                "${item.value.metadata.comments.isEmpty ? '评论' : item.value.metadata.comments.length}"))
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  List<Widget> getUserAvatar(String userId) {
    XEntity? entity = relationCtrl.user.findMetadata<XEntity>(userId);
    return [
      Padding(padding: EdgeInsets.only(left: 5.w)),
      TeamAvatar(
        info: TeamTypeInfo(userId: userId),
        size: 24.w,
      ),
      Padding(padding: EdgeInsets.only(left: 5.w)),
      Text(
        entity?.name ?? "",
      )
    ];
  }
}
