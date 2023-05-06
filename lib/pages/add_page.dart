import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page/model/todo.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  bool isselect = false;
  final title = TextEditingController();
  final description = TextEditingController();
  final author = TextEditingController();

  Future<void> addTodo() async {
    final db = FirebaseFirestore.instance;
    final todo = Todo(
      title: title.text,
      description: description.text,
      isselect: isselect,
      author: author.text,
    );
    await db.collection("todoes").add(todo.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text("Add Page"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(13.0),
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  hintText: "title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please fill in the field";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: description,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: "description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 60),
              CheckboxListTile(
                title: Text("select"),
                value: isselect,
                onChanged: (v) {
                  setState(() {
                    isselect = v ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: author,
                decoration: InputDecoration(
                  hintText: "author",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please fill in the field";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("wait"),
                          content: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CupertinoActivityIndicator(
                              radius: 30,
                              color: Colors.teal,
                            ),
                          ),
                        );
                      },
                    );
                    await addTodo();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                icon: Icon(Icons.publish),
                label: Text("Add todo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
