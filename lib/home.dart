import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final Function changeTheme;
  Home(this.changeTheme);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todoList = [];
  Map<String, dynamic> todoItem;
  final textController = TextEditingController();

  Query queryReference = FirebaseFirestore.instance
      .collection("data")
      .orderBy("date", descending: true);

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("data");

  addData() {
    if (textController.text.isNotEmpty) {
      todoItem = {
        "name": textController.text,
        "date": DateTime.now(),
      };
      collectionReference.add(todoItem);
      textController.clear();
    }
  }

  fetchData() {
    queryReference.snapshots().listen((event) {
      setState(() {
        todoList = event.docs.map((e) => e.data()).toList();
        print(todoList);
      });
    });
  }

  deleteData(i) async {
    QuerySnapshot querySnapshot = await queryReference.get();
    querySnapshot.docs[i].reference.delete();
  }

  updateData() async {
    QuerySnapshot querySnapshot = await queryReference.get();
    querySnapshot.docs.first.reference.update({"name": "pazar"});
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    //fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Text('toolr'),
        actions: [
          IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () => widget.changeTheme()),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'To do item',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              controller: textController,
            ),
            todoList.length > 0
                ? buildListView()
                : Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Text("Your list is empty!"),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addData,
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: todoList.length,
      padding: EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(todoList[index]['name']),
          onDismissed: (direction) => deleteData(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              tileColor: Colors.amber,
              title: Text(
                "${todoList[index]['name']}",
              ),
            ),
          ),
        );
      },
    );
  }
}
