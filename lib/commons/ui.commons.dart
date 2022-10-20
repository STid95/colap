import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  const RoundButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Material(
            color: Colors.deepPurple,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  )),
            ),
          ),
        ));
  }
}
