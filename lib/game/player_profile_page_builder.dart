import 'package:flutter/material.dart';

class PlayerProfilePageBuilder<T> extends PageRouteBuilder<T> {
  PlayerProfilePageBuilder({
    required this.widget,
  })  : super(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            final Widget transition = SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.0, -0.7),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );

            return Container(
              color: Colors.transparent,
              child: transition,
            );
          },
        );

  final Widget widget;
}
