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
    bool useSafeAreaLeft = true,
    bool useSafeAreaTop = true,
    bool useSafeAreaRight = true,
    bool useSafeAreaBottom = true,
    EdgeInsets safeAreaMinimum = const EdgeInsets.fromLTRB(
      16.0, // left
      8.0, // top
      16.0, // right
      48.0, // bottom
    ),
  }) : super(
         body: useSafeArea
             ? SafeArea(
                 minimum: EdgeInsets.fromLTRB(
                   useSafeAreaLeft ? safeAreaMinimum.left : 0.0,
                   useSafeAreaTop ? safeAreaMinimum.top : 0.0,
                   useSafeAreaRight ? safeAreaMinimum.right : 0.0,
                   useSafeAreaBottom ? safeAreaMinimum.bottom : 0.0,
                 ),
                 child: child,
               )
             : child,
       );
}
