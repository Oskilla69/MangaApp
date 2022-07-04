import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Form(
        key: _formKey,
        child: TextFormField(
          controller: commentController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A comment cannot be empty.';
            }
            return null;
          },
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {},
      ),
    );
  }
}
