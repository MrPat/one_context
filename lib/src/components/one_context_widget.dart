import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:one_context/src/controllers/one_context.dart';

class OneContextWidget extends StatefulWidget {
  final Widget? child;
  final MediaQueryData? mediaQueryData;
  final String? initialRoute;
  final List<NavigatorObserver> observers;
  final ChildWrapper? childWrapper;

  OneContextWidget({
    Key? key,
    this.child,
    this.mediaQueryData,
    this.initialRoute,
    this.observers = const <NavigatorObserver>[],
    this.childWrapper
  }) : super(key: key);
  _OneContextWidgetState createState() => _OneContextWidgetState();
}

class _OneContextWidgetState extends State<OneContextWidget> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (OneContext().hasDialogVisible) {
      OneContext().popDialog();
      return true;
    }
    return false;
  }

  Widget _defaultChildWrapper({required Widget child}) => child;

  @override
  Widget build(BuildContext context) {
    final ChildWrapper childWrapper = widget.childWrapper ?? _defaultChildWrapper;

    return Navigator(
      initialRoute: widget.initialRoute ?? '/',
      observers: [...widget.observers, OneContext().heroController],
      onGenerateRoute: (_) => MaterialPageRoute(
          builder: (context) => childWrapper(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                key: OneContext().scaffoldKey,
                body: widget.child!,
              ))),
    );
  }
}
