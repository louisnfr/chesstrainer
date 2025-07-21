import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends Scaffold {
  DefaultLayout({
    super.key,
    required Widget child,
    super.appBar,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary = true,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.endDrawerEnableOpenDragGesture = true,
    super.restorationId,
    bool useSafeArea = true,
    EdgeInsets safeAreaMinimum = const EdgeInsets.fromLTRB(
      16.0, // left
      8.0, // top
      16.0, // right
      48.0, // bottom
    ),
  }) : super(
         body: useSafeArea
             ? SafeArea(minimum: safeAreaMinimum, child: child)
             : child,
       );
}
