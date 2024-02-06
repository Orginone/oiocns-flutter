// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.dense,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.mouseCursor,
  });

  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final Widget? trailing;

  final bool? dense;

  final bool enabled;

  final GestureTapCallback? onTap;

  final GestureLongPressCallback? onLongPress;

  final ValueChanged<bool>? onFocusChange;

  final MouseCursor? mouseCursor;

  static Iterable<Widget> divideTiles(
      {BuildContext? context, required Iterable<Widget> tiles, Color? color}) {
    assert(color != null || context != null);
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    Widget wrapTile(Widget tile) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context, color: color),
          ),
        ),
        child: tile,
      );
    }

    return <Widget>[
      ...tiles.take(tiles.length - 1).map(wrapTile),
      tiles.last,
    ];
  }

  bool _isDenseLayout(ThemeData theme, ListTileThemeData tileTheme) {
    return dense ?? tileTheme.dense ?? theme.listTileTheme.dense ?? false;
  }

  Color _tileBackgroundColor(ThemeData theme, ListTileThemeData tileTheme,
      ListTileThemeData defaults) {
    final Color? color = tileTheme.tileColor ?? theme.listTileTheme.tileColor;
    return color ?? defaults.tileColor!;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final ListTileThemeData tileTheme = ListTileTheme.of(context);
    final ListTileStyle listTileStyle =
        tileTheme.style ?? theme.listTileTheme.style ?? ListTileStyle.list;
    final ListTileThemeData defaults = theme.useMaterial3
        ? _LisTileDefaultsM3(context)
        : _LisTileDefaultsM2(context, listTileStyle);
    final Set<MaterialState> states = <MaterialState>{
      if (!enabled) MaterialState.disabled,
    };

    Color? resolveColor(
        Color? explicitColor, Color? selectedColor, Color? enabledColor,
        [Color? disabledColor]) {
      return _IndividualOverrides(
        explicitColor: explicitColor,
        selectedColor: selectedColor,
        enabledColor: enabledColor,
        disabledColor: disabledColor,
      ).resolve(states);
    }

    final Color? effectiveIconColor = resolveColor(tileTheme.iconColor,
            tileTheme.selectedColor, tileTheme.iconColor) ??
        resolveColor(theme.listTileTheme.iconColor,
            theme.listTileTheme.selectedColor, theme.listTileTheme.iconColor) ??
        resolveColor(defaults.iconColor, defaults.selectedColor,
            defaults.iconColor, theme.disabledColor);
    final Color? effectiveColor = resolveColor(tileTheme.textColor,
            tileTheme.selectedColor, tileTheme.textColor) ??
        resolveColor(theme.listTileTheme.textColor,
            theme.listTileTheme.selectedColor, theme.listTileTheme.textColor) ??
        resolveColor(defaults.textColor, defaults.selectedColor,
            defaults.textColor, theme.disabledColor);
    final IconThemeData iconThemeData =
        IconThemeData(color: effectiveIconColor);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle? leadingAndTrailingStyle;
    if (leading != null || trailing != null) {
      leadingAndTrailingStyle = tileTheme.leadingAndTrailingTextStyle ??
          defaults.leadingAndTrailingTextStyle!;
      final Color? leadingAndTrailingTextColor = effectiveColor;
      leadingAndTrailingStyle =
          leadingAndTrailingStyle.copyWith(color: leadingAndTrailingTextColor);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    TextStyle titleStyle = tileTheme.titleTextStyle ?? defaults.titleTextStyle!;
    final Color? titleColor = effectiveColor;
    titleStyle = titleStyle.copyWith(
      color: titleColor,
      fontSize: _isDenseLayout(theme, tileTheme) ? 13.0 : null,
    );
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle =
          tileTheme.subtitleTextStyle ?? defaults.subtitleTextStyle!;
      final Color? subtitleColor =
          effectiveColor ?? theme.textTheme.bodySmall!.color;
      subtitleStyle = subtitleStyle.copyWith(
        color: subtitleColor,
        fontSize: _isDenseLayout(theme, tileTheme) ? 12.0 : null,
      );
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding =
        tileTheme.contentPadding?.resolve(textDirection) ??
            defaults.contentPadding!.resolve(textDirection);

    // Show basic cursor when ListTile isn't enabled or gesture callbacks are null.
    final Set<MaterialState> mouseStates = <MaterialState>{
      if (!enabled || (onTap == null && onLongPress == null))
        MaterialState.disabled,
    };
    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor?>(
                mouseCursor, mouseStates) ??
            tileTheme.mouseCursor?.resolve(mouseStates) ??
            MaterialStateMouseCursor.clickable.resolve(mouseStates);

    final ListTileTitleAlignment effectiveTitleAlignment =
        tileTheme.titleAlignment ??
            (theme.useMaterial3
                ? ListTileTitleAlignment.threeLine
                : ListTileTitleAlignment.titleHeight);

    return InkWell(
      customBorder: tileTheme.shape,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      onFocusChange: onFocusChange,
      mouseCursor: effectiveMouseCursor,
      canRequestFocus: enabled,
      enableFeedback: tileTheme.enableFeedback ?? true,
      child: Semantics(
        enabled: enabled,
        child: Ink(
          decoration: ShapeDecoration(
            shape: tileTheme.shape ?? const Border(),
            color: _tileBackgroundColor(theme, tileTheme, defaults),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: resolvedContentPadding,
            child: IconTheme.merge(
              data: iconThemeData,
              child: IconButtonTheme(
                data: iconButtonThemeData,
                child: _ListTile(
                  leading: leadingIcon,
                  title: titleText,
                  subtitle: subtitleText,
                  trailing: trailingIcon,
                  isDense: _isDenseLayout(theme, tileTheme),
                  visualDensity: tileTheme.visualDensity ?? theme.visualDensity,
                  isThreeLine: false,
                  textDirection: textDirection,
                  titleBaselineType: titleStyle.textBaseline ??
                      defaults.titleTextStyle!.textBaseline!,
                  subtitleBaselineType: subtitleStyle?.textBaseline ??
                      defaults.subtitleTextStyle!.textBaseline!,
                  horizontalTitleGap: tileTheme.horizontalTitleGap ?? 0,
                  minVerticalPadding: tileTheme.minVerticalPadding ??
                      defaults.minVerticalPadding!,
                  minLeadingWidth:
                      tileTheme.minLeadingWidth ?? defaults.minLeadingWidth!,
                  titleAlignment: effectiveTitleAlignment,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Widget>('leading', leading, defaultValue: null));
    properties
        .add(DiagnosticsProperty<Widget>('title', title, defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget>('subtitle', subtitle, defaultValue: null));
    properties.add(
        DiagnosticsProperty<Widget>('trailing', trailing, defaultValue: null));
    properties.add(FlagProperty('isThreeLine',
        value: false,
        ifTrue: 'THREE_LINE',
        ifFalse: 'TWO_LINE',
        showName: true,
        defaultValue: false));
    properties.add(FlagProperty('dense',
        value: dense, ifTrue: 'true', ifFalse: 'false', showName: true));
    properties.add(FlagProperty('enabled',
        value: enabled,
        ifTrue: 'true',
        ifFalse: 'false',
        showName: true,
        defaultValue: true));
    properties
        .add(DiagnosticsProperty<Function>('onTap', onTap, defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('onLongPress', onLongPress,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor,
        defaultValue: null));
  }
}

class _IndividualOverrides extends MaterialStateProperty<Color?> {
  _IndividualOverrides({
    this.explicitColor,
    this.enabledColor,
    this.selectedColor,
    this.disabledColor,
  });

  final Color? explicitColor;
  final Color? enabledColor;
  final Color? selectedColor;
  final Color? disabledColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (explicitColor is MaterialStateColor) {
      return MaterialStateProperty.resolveAs<Color?>(explicitColor, states);
    }
    if (states.contains(MaterialState.disabled)) {
      return disabledColor;
    }
    if (states.contains(MaterialState.selected)) {
      return selectedColor;
    }
    return enabledColor;
  }
}

// Identifies the children of a _ListTileElement.
enum _ListTileSlot {
  leading,
  title,
  subtitle,
  trailing,
}

class _ListTile extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_ListTileSlot> {
  const _ListTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.isThreeLine,
    required this.isDense,
    required this.visualDensity,
    required this.textDirection,
    required this.titleBaselineType,
    required this.horizontalTitleGap,
    required this.minVerticalPadding,
    required this.minLeadingWidth,
    this.subtitleBaselineType,
    required this.titleAlignment,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool isDense;
  final VisualDensity visualDensity;
  final TextDirection textDirection;
  final TextBaseline titleBaselineType;
  final TextBaseline? subtitleBaselineType;
  final double horizontalTitleGap;
  final double minVerticalPadding;
  final double minLeadingWidth;
  final ListTileTitleAlignment titleAlignment;

  @override
  Iterable<_ListTileSlot> get slots => _ListTileSlot.values;

  @override
  Widget? childForSlot(_ListTileSlot slot) {
    switch (slot) {
      case _ListTileSlot.leading:
        return leading;
      case _ListTileSlot.title:
        return title;
      case _ListTileSlot.subtitle:
        return subtitle;
      case _ListTileSlot.trailing:
        return trailing;
    }
  }

  @override
  _RenderListTile createRenderObject(BuildContext context) {
    return _RenderListTile(
      isThreeLine: isThreeLine,
      isDense: isDense,
      visualDensity: visualDensity,
      textDirection: textDirection,
      titleBaselineType: titleBaselineType,
      subtitleBaselineType: subtitleBaselineType,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
      titleAlignment: titleAlignment,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderListTile renderObject) {
    renderObject
      ..isThreeLine = isThreeLine
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..titleBaselineType = titleBaselineType
      ..subtitleBaselineType = subtitleBaselineType
      ..horizontalTitleGap = horizontalTitleGap
      ..minLeadingWidth = minLeadingWidth
      ..minVerticalPadding = minVerticalPadding
      ..titleAlignment = titleAlignment;
  }
}

class _RenderListTile extends RenderBox
    with SlottedContainerRenderObjectMixin<_ListTileSlot> {
  _RenderListTile({
    required bool isDense,
    required VisualDensity visualDensity,
    required bool isThreeLine,
    required TextDirection textDirection,
    required TextBaseline titleBaselineType,
    TextBaseline? subtitleBaselineType,
    required double horizontalTitleGap,
    required double minVerticalPadding,
    required double minLeadingWidth,
    required ListTileTitleAlignment titleAlignment,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _isThreeLine = isThreeLine,
        _textDirection = textDirection,
        _titleBaselineType = titleBaselineType,
        _subtitleBaselineType = subtitleBaselineType,
        _horizontalTitleGap = horizontalTitleGap,
        _minVerticalPadding = minVerticalPadding,
        _minLeadingWidth = minLeadingWidth,
        _titleAlignment = titleAlignment;

  RenderBox? get leading => childForSlot(_ListTileSlot.leading);
  RenderBox? get title => childForSlot(_ListTileSlot.title);
  RenderBox? get subtitle => childForSlot(_ListTileSlot.subtitle);
  RenderBox? get trailing => childForSlot(_ListTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (title != null) title!,
      if (subtitle != null) subtitle!,
      if (trailing != null) trailing!,
    ];
  }

  bool get isDense => _isDense;
  bool _isDense;
  set isDense(bool value) {
    if (_isDense == value) {
      return;
    }
    _isDense = value;
    markNeedsLayout();
  }

  VisualDensity get visualDensity => _visualDensity;
  VisualDensity _visualDensity;
  set visualDensity(VisualDensity value) {
    if (_visualDensity == value) {
      return;
    }
    _visualDensity = value;
    markNeedsLayout();
  }

  bool get isThreeLine => _isThreeLine;
  bool _isThreeLine;
  set isThreeLine(bool value) {
    if (_isThreeLine == value) {
      return;
    }
    _isThreeLine = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextBaseline get titleBaselineType => _titleBaselineType;
  TextBaseline _titleBaselineType;
  set titleBaselineType(TextBaseline value) {
    if (_titleBaselineType == value) {
      return;
    }
    _titleBaselineType = value;
    markNeedsLayout();
  }

  TextBaseline? get subtitleBaselineType => _subtitleBaselineType;
  TextBaseline? _subtitleBaselineType;
  set subtitleBaselineType(TextBaseline? value) {
    if (_subtitleBaselineType == value) {
      return;
    }
    _subtitleBaselineType = value;
    markNeedsLayout();
  }

  double get horizontalTitleGap => _horizontalTitleGap;
  double _horizontalTitleGap;
  double get _effectiveHorizontalTitleGap =>
      _horizontalTitleGap + visualDensity.horizontal * 2.0;

  set horizontalTitleGap(double value) {
    if (_horizontalTitleGap == value) {
      return;
    }
    _horizontalTitleGap = value;
    markNeedsLayout();
  }

  double get minVerticalPadding => _minVerticalPadding;
  double _minVerticalPadding;

  set minVerticalPadding(double value) {
    if (_minVerticalPadding == value) {
      return;
    }
    _minVerticalPadding = value;
    markNeedsLayout();
  }

  double get minLeadingWidth => _minLeadingWidth;
  double _minLeadingWidth;

  set minLeadingWidth(double value) {
    if (_minLeadingWidth == value) {
      return;
    }
    _minLeadingWidth = value;
    markNeedsLayout();
  }

  ListTileTitleAlignment get titleAlignment => _titleAlignment;
  ListTileTitleAlignment _titleAlignment;
  set titleAlignment(ListTileTitleAlignment value) {
    if (_titleAlignment == value) {
      return;
    }
    _titleAlignment = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;
    return leadingWidth +
        math.max(_minWidth(title, height), _minWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;
    return leadingWidth +
        math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  double get _defaultTileHeight {
    final bool hasSubtitle = subtitle != null;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;

    final Offset baseDensity = visualDensity.baseSizeAdjustment;
    if (isOneLine) {
      return (isDense ? 48.0 : 0) + baseDensity.dy;
    }
    if (isTwoLine) {
      return (isDense ? 64.0 : 0) + baseDensity.dy;
    }
    return (isDense ? 76.0 : 0) + baseDensity.dy;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return math.max(
      _defaultTileHeight,
      title!.getMinIntrinsicHeight(width) +
          (subtitle?.getMinIntrinsicHeight(width) ?? 0.0),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(title != null);
    if (title!.parentData! is BoxParentData) {
      final BoxParentData parentData = title!.parentData! as BoxParentData;
      return parentData.offset.dy +
          title!.getDistanceToActualBaseline(baseline)!;
    } else {
      return title!.getDistanceToActualBaseline(baseline)!;
    }
  }

  static double? _boxBaseline(RenderBox box, TextBaseline baseline) {
    return box.getDistanceToBaseline(baseline);
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a full layout.',
    ));
    return Size.zero;
  }

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasSubtitle = subtitle != null;
    final bool hasTrailing = trailing != null;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;

    final BoxConstraints maxIconHeightConstraint = BoxConstraints(
      // One-line trailing and leading widget heights do not follow
      // Material specifications, but this sizing is required to adhere
      // to accessibility requirements for smallest tappable widget.
      // Two- and three-line trailing widget heights are constrained
      // properly according to the Material spec.
      maxHeight: (isDense ? 48.0 : 56.0) + densityAdjustment.dy,
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);
    assert(
      tileWidth != leadingSize.width || tileWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );
    assert(
      tileWidth != trailingSize.width || tileWidth == 0.0,
      'Trailing widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );

    final double titleStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) +
            _effectiveHorizontalTitleGap
        : 0.0;
    final double adjustedTrailingWidth = hasTrailing
        ? math.max(trailingSize.width + _effectiveHorizontalTitleGap, 32.0)
        : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );
    final Size titleSize = _layoutBox(title, textConstraints);
    final Size subtitleSize = _layoutBox(subtitle, textConstraints);

    double? titleBaseline;
    double? subtitleBaseline;
    if (isTwoLine) {
      titleBaseline = isDense ? 28.0 : 32.0;
      subtitleBaseline = isDense ? 48.0 : 52.0;
    } else if (isThreeLine) {
      titleBaseline = isDense ? 22.0 : 28.0;
      subtitleBaseline = isDense ? 42.0 : 48.0;
    } else {
      assert(isOneLine);
    }

    final double defaultTileHeight = _defaultTileHeight;

    double tileHeight;
    double titleY;
    double? subtitleY;
    if (!hasSubtitle) {
      tileHeight = math.max(
          defaultTileHeight, titleSize.height + 2.0 * _minVerticalPadding);
      titleY = (tileHeight - titleSize.height) / 2.0;
    } else {
      assert(subtitleBaselineType != null);
      titleY = titleBaseline! - _boxBaseline(title!, titleBaselineType)!;
      subtitleY = subtitleBaseline! -
          _boxBaseline(subtitle!, subtitleBaselineType!)! +
          visualDensity.vertical * 2.0;
      tileHeight = defaultTileHeight;

      // If the title and subtitle overlap, move the title upwards by half
      // the overlap and the subtitle down by the same amount, and adjust
      // tileHeight so that both titles fit.
      final double titleOverlap = titleY + titleSize.height - subtitleY;
      if (titleOverlap > 0.0) {
        titleY -= titleOverlap / 2.0;
        subtitleY += titleOverlap / 2.0;
      }

      // If the title or subtitle overflow tileHeight then punt: title
      // and subtitle are arranged in a column, tileHeight = column height plus
      // _minVerticalPadding on top and bottom.
      if (titleY < _minVerticalPadding ||
          (subtitleY + subtitleSize.height + _minVerticalPadding) >
              tileHeight) {
        tileHeight =
            titleSize.height + subtitleSize.height + 2.0 * _minVerticalPadding;
        titleY = _minVerticalPadding;
        subtitleY = titleSize.height + _minVerticalPadding;
      }
    }

    final double leadingY;
    final double trailingY;

    switch (titleAlignment) {
      case ListTileTitleAlignment.threeLine:
        {
          if (isThreeLine) {
            leadingY = _minVerticalPadding;
            trailingY = _minVerticalPadding;
          } else {
            leadingY = (tileHeight - leadingSize.height) / 2.0;
            trailingY = (tileHeight - trailingSize.height) / 2.0;
          }
          break;
        }
      case ListTileTitleAlignment.titleHeight:
        {
          // This attempts to implement the redlines for the vertical position of the
          // leading and trailing icons on the spec page:
          //   https://m2.material.io/components/lists#specs
          // The interpretation for these redlines is as follows:
          //  - For large tiles (> 72dp), both leading and trailing controls should be
          //    a fixed distance from top. As per guidelines this is set to 16dp.
          //  - For smaller tiles, trailing should always be centered. Leading can be
          //    centered or closer to the top. It should never be further than 16dp
          //    to the top.
          if (tileHeight > 72.0) {
            leadingY = 16.0;
            trailingY = 16.0;
          } else {
            leadingY = math.min((tileHeight - leadingSize.height) / 2.0, 16.0);
            trailingY = (tileHeight - trailingSize.height) / 2.0;
          }
          break;
        }
      case ListTileTitleAlignment.top:
        {
          leadingY = _minVerticalPadding;
          trailingY = _minVerticalPadding;
          break;
        }
      case ListTileTitleAlignment.center:
        {
          leadingY = (tileHeight - leadingSize.height) / 2.0;
          trailingY = (tileHeight - trailingSize.height) / 2.0;
          break;
        }
      case ListTileTitleAlignment.bottom:
        {
          leadingY = tileHeight - leadingSize.height - _minVerticalPadding;
          trailingY = tileHeight - trailingSize.height - _minVerticalPadding;
          break;
        }
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading) {
            _positionBox(
                leading!, Offset(tileWidth - leadingSize.width, leadingY));
          }
          _positionBox(title!, Offset(adjustedTrailingWidth, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(adjustedTrailingWidth, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(trailing!, Offset(0.0, trailingY));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(0.0, leadingY));
          }
          _positionBox(title!, Offset(titleStart, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(titleStart, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(
                trailing!, Offset(tileWidth - trailingSize.width, trailingY));
          }
          break;
        }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}

class _LisTileDefaultsM2 extends ListTileThemeData {
  _LisTileDefaultsM2(this.context, ListTileStyle style)
      : super(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          minLeadingWidth: 50,
          minVerticalPadding: 4,
          shape: const Border(),
          style: style,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get tileColor => Colors.transparent;

  @override
  TextStyle? get titleTextStyle {
    switch (style!) {
      case ListTileStyle.drawer:
        return _textTheme.bodyLarge;
      case ListTileStyle.list:
        return _textTheme.titleMedium;
    }
    return null;
  }

  @override
  TextStyle? get subtitleTextStyle => _textTheme.bodyMedium;

  @override
  TextStyle? get leadingAndTrailingTextStyle => _textTheme.bodyMedium;

  @override
  Color? get selectedColor => _theme.colorScheme.primary;

  @override
  Color? get iconColor {
    switch (_theme.brightness) {
      case Brightness.light:
        // For the sake of backwards compatibility, the default for unselected
        // tiles is Colors.black45 rather than colorScheme.onSurface.withAlpha(0x73).
        return Colors.black45;
      case Brightness.dark:
        return null; // null, Use current icon theme color
    }
    return null;
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - LisTile

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_162

class _LisTileDefaultsM3 extends ListTileThemeData {
  _LisTileDefaultsM3(this.context)
      : super(
          contentPadding:
              const EdgeInsetsDirectional.only(start: 16.0, end: 24.0),
          minLeadingWidth: 24,
          minVerticalPadding: 8,
          shape: const RoundedRectangleBorder(),
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get tileColor => Colors.transparent;

  @override
  TextStyle? get titleTextStyle => _textTheme.bodyLarge;

  @override
  TextStyle? get subtitleTextStyle => _textTheme.bodyMedium;

  @override
  TextStyle? get leadingAndTrailingTextStyle => _textTheme.labelSmall;

  @override
  Color? get selectedColor => _colors.primary;

  @override
  Color? get iconColor => _colors.onSurfaceVariant;
}

// END GENERATED TOKEN PROPERTIES - LisTile
