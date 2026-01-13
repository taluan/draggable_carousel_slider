library draggable_carousel_slider;

import 'dart:math';

import 'package:draggable_carousel_slider/widgets/draggable_widget_item.dart';
import 'package:draggable_carousel_slider/enums/drag_direction.dart';
import 'package:draggable_carousel_slider/enums/draggable_carousel_slider_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'draggable_carousel_slider_item_settings.dart';
import 'package:vector_math/vector_math.dart' show Vector3;

class DraggableSlider extends StatefulWidget {
  const DraggableSlider({
    super.key,
    required this.children,
    this.onPressed,
    this.loop = false, this.xOffset = 6, this.yOffset = 12
  });

  final double xOffset;
  final double yOffset;
  final List<Widget> children;
  final bool loop;
  final Function(int)? onPressed;

  @override
  State<DraggableSlider> createState() => _DraggableSliderState();
}

class _DraggableSliderState extends State<DraggableSlider> {
  static const int MAX_ITEM_COUNT = 4;

  final prefixKey = Random().nextInt(1000);

  late List<GestureDetector> children;

  Key? lastPopedItem;
  int selectedItem = 0;

  late final settings = {
    DraggableSliderstatus.invisible: DraggableSliderItemSettings(
      angle: Vector3.zero(),
      position: Offset(widget.xOffset, widget.yOffset * 2),
      scale: 1,
      visibility: 1,
      shadow: true,
    ),
    DraggableSliderstatus.start: DraggableSliderItemSettings(
      angle: Vector3.zero(),
      position: Offset(widget.xOffset, widget.yOffset * 2),
      scale: 1,
      visibility: 1,
      shadow: true,
    ),
    DraggableSliderstatus.end: DraggableSliderItemSettings(
      angle: Vector3.zero(),
      position: Offset(0, widget.yOffset),
      scale: 1,
      visibility: 1,
      draggable: true,
      shadow: true,
    ),
    DraggableSliderstatus.top: DraggableSliderItemSettings(
      angle: Vector3.zero(),
      position: Offset(-widget.xOffset, 0),
      scale: 1,
      visibility: 1,
      draggable: true,
      shadow: true,
    ),
  };

  @override
  void initState() {
    children = _buildItems();
    super.initState();
  }

  GestureDetector _buildItem(
    int index,
    DraggableSliderItemSettings targetState, [
    DraggableSliderItemSettings? initialState,
  ]) =>
      GestureDetector(
        key: ValueKey('$prefixKey$index-GestureDetector'),
        onTap: () => onItemPressed(index % widget.children.length),
        child: DraggableSliderItem(
          key: ValueKey('$prefixKey$index-DraggableSliderItem'),
          onRelease: onTopItemRemoved,
          onReleased: onTopItemAnimationStatusChanged,
          settings: targetState,
          initialSettings: initialState,
          child: widget.children[index % widget.children.length],
        ),
      );

  List<GestureDetector> _buildItems() {
    final result = <GestureDetector>[];
    var lastItem = selectedItem + MAX_ITEM_COUNT;
    if (!widget.loop) {
      lastItem = min(widget.children.length, lastItem);
    }

    if (selectedItem > 0) {
      result.insert(0, children.last);
    }

    final selectedItems = lastItem - selectedItem;
    for (var globalIndex = selectedItem, localIndex = 0;
        globalIndex < lastItem;
        globalIndex++, localIndex++) {
      DraggableSliderItemSettings? initialState, targetState;

      if (widget.children.length == 1) {
        // there is only one card in the list
        initialState = settings[DraggableSliderstatus.invisible];
        targetState = settings[DraggableSliderstatus.top];
      } else {
        // if there are more than one items
        if (localIndex == 0) {
          // first item will be the top one with out initial animation
          initialState = null;

          if (selectedItems > 0) {
            // - if is not the first time this card is getting created,
            // then it comes from end state
            initialState = settings[DraggableSliderstatus.end];
          }
          targetState = settings[DraggableSliderstatus.top];
        } else if (localIndex == 1) {
          // for the second one
          if (widget.children.length == 2 || selectedItems < MAX_ITEM_COUNT) {
            // - if there are only two items, it starts from invisible
            //
            // - if there are more than two items and this is the first time
            // the second card is getting created, then it comes from invisibility
            initialState = settings[DraggableSliderstatus.invisible];
            targetState = settings[DraggableSliderstatus.end];
          } else {
            initialState = settings[DraggableSliderstatus.start];
            targetState = settings[DraggableSliderstatus.end];
          }
        } else if (localIndex == 2) {
          // for the third item
          initialState = settings[DraggableSliderstatus.invisible];
          targetState = settings[DraggableSliderstatus.start];
        } else {
          // for the last item
          initialState = settings[DraggableSliderstatus.invisible];
          targetState = settings[DraggableSliderstatus.invisible];
        }
      }

      result.add(_buildItem(globalIndex, targetState!, initialState));
    }
    return result.reversed.toList();
  }

  void onTopItemAnimationStatusChanged(Key? key) {
    if (children.any((element) => element.child?.key == lastPopedItem)) {
      children.removeWhere(
        (element) => element.child?.key == lastPopedItem,
      );
      lastPopedItem = null;
      setState(() {});
    }
  }

  void onTopItemRemoved(Key? key, DragDirection direction,) {
    lastPopedItem = key;
    selectedItem += 1;

    children = _buildItems();
    setState(() {});
  }

  void onItemPressed(int index) {
    debugPrint("onItemPressed: $index");

    if (widget.onPressed != null) {
      widget.onPressed!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }
}
