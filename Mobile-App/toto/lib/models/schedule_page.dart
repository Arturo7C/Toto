import 'package:flutter/material.dart';
import 'package:toto/models/calendar.dart';

import 'package:toto/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toto/models/todo.dart';
import 'package:toto/models/testpage.dart';
import 'dart:async';

/* class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },
        ),
      ),
    );
  }
} */

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Schedule"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}


// test
class HomePageCalendar extends StatefulWidget {
  HomePageCalendar({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePageCalendar> {
  List<Calendar> _calendarList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    _calendarList = new List();
    _todoQuery = _database
        .reference()
        .child("calendar")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _calendarList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _calendarList[_calendarList.indexOf(oldEntry)] =
          Calendar.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _calendarList.add(Calendar.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  //add a new list and items
  addNewTodo(String todoItem) {
    if (todoItem.length > 0) {
      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("calendar").push().set(todo.toJson());
    }
  }

  updateTodo(Calendar calendar) {
    //Toggle completed
    calendar.completed = !calendar.completed;
    if (calendar != null) {
      _database.reference().child("calendar").child(calendar.key).set(calendar.toJson());
    }
  }

  deleteTodo(String todoId, int index) {
    _database.reference().child("calendar").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _calendarList.removeAt(index);
      });
    });
  }

  showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
              

                  //__________________________________

                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add The Day',
                  ),
                )

                

              //__________________________________


                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showTodoList() {
    if (_calendarList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _calendarList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _calendarList[index].key;
            String subject = _calendarList[index].day;
            bool completed = _calendarList[index].completed;
            String userId = _calendarList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                deleteTodo(todoId, index);
              },
              
              child: ListTile(
                
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                            Icons.pets,
                            color: Colors.green,
                            size: 40.0,
                          )
                        : Icon(Icons.pets, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      updateTodo(_calendarList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "No Calendar Events Created",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Toto'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
        showTodoList(),

/*         new RaisedButton(
                child: new Text('Create Schedule',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.cyan[600],
                onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()), //SecondRoute
            );
            
            
          },
                
                ), */
        /* new Image(
          image: new AssetImage("assets/giphy-rick.gif",

          ),
          height: 200.0,
          //width: 80.0,
        ), */
        new RaisedButton(
                child: new Text('Take Picture Now',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: (){
                  showAddTodoDialog(context);
                }),
        new RaisedButton(
                child: new Text('testpage dawg',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.cyan[600],
                onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BasicDateTimeField()), //SecondRoute
            );
            
            
          },
                
                ),


        ],),
        
      

      
          floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTodoDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),          
        ),
        
        );
  }
}