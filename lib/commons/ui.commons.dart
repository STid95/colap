import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            color: Theme.of(context).colorScheme.primary,
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

class ColapButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const ColapButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        onPressed: onPressed,
        child: Padding(padding: const EdgeInsets.all(10), child: Text(text)));
  }
}

class ColapIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onPressed;
  const ColapIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: Icon(icon),
        style: ElevatedButton.styleFrom(
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        onPressed: onPressed,
        label: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(text),
        ));
  }
}

class ColapSvg extends StatelessWidget {
  final String asset;
  final double size;
  const ColapSvg({
    Key? key,
    required this.asset,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetName = 'assets/$asset.svg';
    final Widget svg = SvgPicture.asset(assetName);
    return SizedBox(
      height: size,
      width: size,
      child: svg,
    );
  }
}
