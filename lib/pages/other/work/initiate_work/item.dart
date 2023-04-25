




import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';

import 'state.dart';

class InitiateWorkItem extends BaseBreadcrumbNavItem<WorkBreadcrumbNav> {
  final VoidCallback? onCreateWork;
  const InitiateWorkItem({Key? key,required super.item,super.onTap,super.onNext,this.onCreateWork});


  @override
  Widget action() {
    if(item.source!=null){
      return IconButton(onPressed: onCreateWork, icon: Icon(Icons.add,color: Colors.black,));
    }
    return const SizedBox();
  }

}
