


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/model/transaction_record_model.dart';
import 'package:orginone/util/date_util.dart';
import 'package:orginone/widget/unified.dart';

class RecordItem extends StatelessWidget {
  final TransactionRecord record;
  const RecordItem({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = record.type == "receive"?(record.from??''):(record.to??'');
    String operation = record.type == "receive"?"+":"-";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((record.blocktime??0)*1000);
    String status = record.status=='-1'?"失败":record.status=='0'?"确认中":"完成";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300,width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title,style: XFonts.size22Black0,maxLines: 1,overflow: TextOverflow.ellipsis)),
              Text("$operation${record.value}",style: XFonts.size24Black0W700,),
            ],
          ),
          SizedBox(height: 5.h,),
          Text("备注:${record.note}",style: XFonts.size18Black9,),
          SizedBox(height: 5.h,),
          Row(
            children: [
              Expanded(child: Text(CustomDateUtil.getDetailTime(dateTime))),
              Text(status),
            ],
          )
        ],
      ),
    );
  }
}
