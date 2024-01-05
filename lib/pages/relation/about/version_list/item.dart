import 'package:flutter/material.dart';

class VersionItem extends StatelessWidget {
  final String title;
  final String version;
  final String date;
  final String content;

  const VersionItem(
      {super.key,
      required this.title,
      required this.version,
      required this.date,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.black54)
          ],
        ));
  }
}
