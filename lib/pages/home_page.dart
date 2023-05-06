import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page/model/todo.dart';
import 'package:login_page/pages/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    readTodoes();
  }

  Stream<QuerySnapshot> readTodoes() {
    final db = FirebaseFirestore.instance;
    return db.collection("todoes").snapshots();
  }

  Future<void> updateTodo(Todo todo) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("todoes")
        .doc(todo.id)
        .update({'isselect': !todo.isselect});
  }

  Future<void> deleteTodo(Todo todo) async {
    final db = FirebaseFirestore.instance;
    await db.collection("todoes").doc(todo.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: StreamBuilder(
        stream: readTodoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final List<Todo> todoes = snapshot.data!.docs
                .map(
                  (e) => Todo.fromJson(
                    e.data() as Map<String, dynamic>,
                  )..id = e.id,
                )
                .toList();
            return ListView.builder(
              itemCount: todoes.length,
              itemBuilder: (context, index) {
                final todo = todoes[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.isselect,
                          onChanged: (value) async {
                            await updateTodo(todo);
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await deleteTodo(todo);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.description ?? ""),
                        Text(todo.author),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Unknown error!!!"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_box),
      ),
    );
  }
}
