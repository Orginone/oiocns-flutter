import 'package:flutter/material.dart';

class HorizontalScrollableComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton(context, '快捷入口'),
          _buildButton(context, '加好友'),
          _buildButton(context, '创单位'),
          _buildButton(context, '邀请员'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Add button press logic
        },
        child: Text(title),
      ),
    );
  }
}
