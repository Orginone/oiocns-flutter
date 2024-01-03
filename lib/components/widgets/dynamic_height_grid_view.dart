
import 'package:flutter/material.dart';

class DynamicHeightGridView extends StatelessWidget {
  const DynamicHeightGridView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
    this.shrinkWrap = false,
    this.physics,  this.scrollDirection = Axis.vertical,
  }) : super(key: key);
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;

  int columnLength() {
    if (itemCount % crossAxisCount == 0) {
      return itemCount ~/ crossAxisCount;
    } else {
      return (itemCount ~/ crossAxisCount) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      itemBuilder: (ctx, columnIndex) {
        return _GridRow(
          columnIndex: columnIndex,
          builder: builder,
          itemCount: itemCount,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisAlignment: rowCrossAxisAlignment,
          scrollDirection: scrollDirection,
        );
      },
      itemCount: columnLength(),
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    Key? key,
    required this.columnIndex,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.crossAxisAlignment,  this.scrollDirection = Axis.vertical,
  }) : super(key: key);
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  final int columnIndex;
  final Axis scrollDirection;
  @override
  Widget build(BuildContext context) {

    List<Widget> children = List.generate(
      (crossAxisCount * 2) - 1,
          (rowIndex) {
        final rowNum = rowIndex + 1;
        if (rowNum % 2 == 0){
          return SizedBox(width: crossAxisSpacing);
        }
        final rowItemIndex = ((rowNum + 1) ~/ 2) - 1;
        final itemIndex = (columnIndex * crossAxisCount) + rowItemIndex;
        if (itemIndex > itemCount - 1) {
          return const Expanded(child: SizedBox());
        }
        return Expanded(
          child: builder(context, itemIndex),
        );
      },
    );

    Widget body;

    if(scrollDirection == Axis.vertical){
      body = Row(
          crossAxisAlignment: crossAxisAlignment,
          children: children
      );
    }else{
      body = Column(
        children: children,
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: (columnIndex == 0) ? 0 : mainAxisSpacing,
      ),
      child: body
    );
  }
}