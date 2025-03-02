import 'package:flutter/cupertino.dart';

class DiskWidget extends StatelessWidget {
  final int disk;
  final Color color;
  const DiskWidget({super.key, required this.disk, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: disk * 20.0,
      height: 20.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
