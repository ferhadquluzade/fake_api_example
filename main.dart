import 'package:flutter_application_1/post.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

void main() {
  try {
    runApp(MyApp());
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int length = 0;
  final _text = TextEditingController();
  late Post _futureText;

  _showAlert({title: ""}) async {
    return showDialog(
      barrierDismissible: true,
      barrierLabel: "Dialog to post",
      context: context,
      builder: (context) => Container(
        child: AlertDialog(
          title: Text("Type to post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                child: TextField(
                  controller: _text,
                  decoration: InputDecoration(
                      hintText: "Name",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ))),
                ),
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton.icon(
                      onPressed: () async {
                        //the text typed by user is passed in 
                        //the _submitPost function to get response from server
                        _futureText = await _submitPost(_text.text);
                        //gotten response is printed
                        print("${_futureText.id},${_futureText.body},${_futureText.title},${_futureText.userId}");
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text("Ok")))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Api Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: size.height * 0.8,
              child: FutureBuilder<List<Post>>(
                  future: getData(),
                  builder: (context, sshot) {
                    if (sshot.hasData) {
                      return Container(
                        width: size.width,
                        height: size.height * 0.6,
                        child: ListView.builder(
                            itemCount: length,
                            itemBuilder: (BuildContext ctext, int indx) {
                              return Card(
                                  child: ListTile(
                                title: Text(
                                  "${sshot.data![indx].title}",
                                ),
                                leading: Text('${sshot.data![indx].id}'),
                                subtitle: Text(
                                  "Content:§${sshot.data![indx].body}\nuser id:${sshot.data![indx].userId}",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ));
                            }),
                      );

                      // );
                    } else if (sshot.hasError) {
                      return Text("${sshot.error}");
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAlert, label: Icon(Icons.add)),
    );
  }

  //gets data and lists them
  Future<List<Post>> getData() async {
    http.Response rpse =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (rpse.statusCode == 200) {
      var list = json.decode(rpse.body);
      length = list.length;
      return list.map<Post>((job) => new Post.fromJson(job)).toList();
    } else {
      throw Exception("Elaqede problem oldu.Kod:${rpse.statusCode}");
    }
  }

  //accpets post that will be posted and returns result
  //attributes apart from title can't be edited by user as
  //they are automatically done
  Future<Post> _submitPost(String postToSubmit) async {
    var response =
        await http.post(Uri.parse("https://jsonplaceholder.typicode.com/posts"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{"title": postToSubmit,
            }));
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else
      throw Exception("Post gonderile bilmedi:${response.statusCode}");
  }
}
