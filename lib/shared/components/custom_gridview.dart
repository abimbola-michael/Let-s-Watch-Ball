// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomGridview extends StatelessWidget {
  final int? itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final NullableIndexedWidgetBuilder? seperatorBuilder;

  final int gridCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const CustomGridview({
    super.key,
    this.itemCount,
    required this.itemBuilder,
    required this.gridCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.seperatorBuilder,
    this.padding,
    this.shrinkWrap = false,
  });
  //const CustomGridview.builder({super.key, });

  @override
  Widget build(BuildContext context) {
    final verticalCount = itemCount == null ? 0 : itemCount! ~/ gridCount;
    final remainderCount = itemCount == null ? 0 : itemCount! % gridCount;
    final colCount = remainderCount == 0 ? verticalCount : verticalCount + 1;
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      return ListView.builder(
        shrinkWrap: shrinkWrap,
        padding: padding,
        physics: physics,
        scrollDirection: scrollDirection,
        itemCount: colCount,
        itemBuilder: (context, colIndex) {
          final rowCount =
              colIndex == verticalCount ? remainderCount : gridCount;
          if (scrollDirection == Axis.horizontal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rowCount, (rowIndex) {
                final index = (colIndex * rowCount) + rowIndex;
                final child = itemBuilder(context, index);
                return Container(
                  width: width / gridCount,
                  margin: EdgeInsets.only(
                      right:
                          rowIndex == rowCount - 1 ? 0 : (mainAxisSpacing ?? 0),
                      bottom: colIndex == colCount - 1
                          ? 0
                          : (crossAxisSpacing ?? 0)),
                  child: SizedBox(child: child),
                );
              }),
            );
          }
          return Row(
            children: List.generate(rowCount, (rowIndex) {
              final index = (colIndex * rowCount) + rowIndex;
              final child = itemBuilder(context, index);
              return Container(
                width: width / gridCount,
                margin: EdgeInsets.only(
                    right:
                        rowIndex == rowCount - 1 ? 0 : (crossAxisSpacing ?? 0),
                    bottom:
                        colIndex == colCount - 1 ? 0 : (mainAxisSpacing ?? 0)),
                child: SizedBox(child: child),
              );
            }),
          );
        },
      );
    });
  }
}
