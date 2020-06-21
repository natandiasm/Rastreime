import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  CustomButton({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        height: 60.0,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: child,
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}
