import 'package:flutter/material.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: const [
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Post a Job'),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Create Application'),
          ),
        ],
      ),
    );
  }
}
