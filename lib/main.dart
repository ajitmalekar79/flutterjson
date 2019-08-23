import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JsonData',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Home"),
        ),
        body: MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var operation = ["Sort","Filter","Map","Print Keys","Find","Reverse","Add","UI"];
  String name = '';
  int age;
  String gender;
  var updatedData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('load_json/person.json'),
        builder: (context, snapshot){
          var mydata=updatedData = json.decode(snapshot.data.toString());

          return new ListView.builder(
            itemBuilder: (BuildContext context, int index){

              if(index>=updatedData.length){
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: ()
                        {
                          return performOperation(context,index,mydata);
                      },
                      child: new Text("${operation[index-updatedData.length]}"),)
                  ],

                    );
              }else{

                return ListTile(
                  title: new Text(""+updatedData[index]['name']),
                  subtitle: new Text("Age: ${updatedData[index]['age']}"),
                  leading: new Text(""+updatedData[index]['gender']),
                  );}
            },
            itemCount: updatedData == null ? 0 :updatedData.length+8,
          );
        },
      ),

        /*new Card(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text("Index: $index"),
              new Text("Name: "+mydata[index]['name']),
              new Text("Age: ${mydata[index]['age']}"),
              new Text("Gender: "+mydata[index]['gender']),
            ],
          ),
        )*/

    );

  }

  performOperation(BuildContext context,int choice, var mydata){
    switch(choice){

      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sortJson(mydata)),
        );
        break;

      case 9:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => filterJson(mydata)),
        );
        break;

      case 10:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => mapJson(mydata)),
        );
        break;

      case 11:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => printKeys(mydata)),
        );
        break;

      case 12:
        _displayDialog(context,mydata);
        break;

      case 13:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => reverseJson(mydata)),
        );
        break;

      case 14:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => addJson()),
        );
        break;

      case 15:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cardUI(mydata)),
        );
        break;
    }
  }

  _displayDialog(BuildContext context,var mydata) async {
    TextEditingController _textFieldController=TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {


          return AlertDialog(
            title: Text('Enter Name'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Name"),
              onChanged: (value){
                name = value;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => findObject(name,mydata)),
                    );
                  }
              )
            ],
          );

        });

  }

}
class sortJson extends StatelessWidget {

  var mydata;
  var sorted;
  sortJson(var mydata) {this.mydata = mydata;
  sorted = sortJsonArr(mydata);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
          appBar: new AppBar(
            title: Text("Sorted JSON"),
          ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index){

            return new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text("Name: "+sorted[index]['name']),
                    new Text("Age: ${sorted[index]['age']}"),
                    new Text("Gender: "+sorted[index]['gender']),
                  ],
                ),
              );
          },
          itemCount: sorted == null ? 0 :8,
        )
      ),
    );
  }
  sortJsonArr(var ageList){


    var temp;
    for (int i = 0; i < ageList.length; i++)
    {
      for (int j = i + 1; j < ageList.length; j++)
      {
        if (  ageList[i]['age'] > ageList[j]['age'])
        {
          temp = ageList[i];
          ageList[i] = ageList[j];
          ageList[j] = temp;
        }
      }
    }

    return ageList;
  }
}

class filterJson extends StatefulWidget {

  var mydata;
  filterJson(this.mydata);
  @override
  _filterJsonState createState() => _filterJsonState(mydata);
}

class _filterJsonState extends State<filterJson> {

  var mydata,modifydata;
  _filterJsonState(var mydata){
    this.mydata=mydata;
    this.modifydata= mydata;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
          appBar: new AppBar(
            title: Text("Filter JSON"),
          ),
      body: new Container(
        child: new ListView.builder(
            itemBuilder: (BuildContext context, int index){

              if(index==0){
                return Column(
                  children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                         height: 100,
                          width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: RaisedButton(onPressed: (){

                    males();
                  },child: Text("Only Males"),),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  height: 100,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: RaisedButton(onPressed: (){

                    females();
                  },child: Text("Only Females"),),
                ),
              ),

            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  height: 80,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: RaisedButton(onPressed: (){

                    aboveAge();
                  },child: Text("Age above 20"),
              color: Color(0xFFFF33)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: RaisedButton(onPressed: (){

                    belowAge();
                  },child: Text("Age below 20"),
                  color: Color(0xFF5533)
                ),
              ),

          ),])]);
              }else{
              return new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text("Name: "+modifydata[index-1]['name']),
                    new Text("Age: ${modifydata[index-1]['age']}"),
                    new Text("Gender: "+modifydata[index-1]['gender']),
                  ],
                ),
              );}
            },
            itemCount: modifydata == null ? 0 :modifydata.length+1,
          ),
      )
      )
    );
  }

  males(){
    var malelist=List();
    setState(() {
      for(var data in mydata){
        if(data['gender']=="Male"){
          malelist.add(data);
        }
      }
      modifydata=malelist;
    });
  }
  females(){
    var femalelist=List();
    setState(() {
      for(var data in mydata){
        if(data['gender']=="Female"){
          femalelist.add(data);
        }
      }
      modifydata=femalelist;
    });
  }
  aboveAge(){
    var agelist=List();
    setState(() {
      for(var data in mydata){
        if(data['age']>=20){
          agelist.add(data);
        }
      }
      modifydata=agelist;
    });
  }
  belowAge(){
    var agelist=List();
    setState(() {
      for(var data in mydata){
        if(data['age']<20){
          agelist.add(data);
        }
      }
      modifydata=agelist;
    });
  }
}


class mapJson extends StatelessWidget {

  var mydata;
  mapJson(var mydata){ this.mydata=mydata; }
  @override
  Widget build(BuildContext context) {

    var person1 = person.fromJson(mydata[0]);
    return Container(
      child: new Card(
        child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text("Name: ${person1.name}"),
          new Text("Age: ${person1.age}"),
          new Text("Gender: ${person1.gender}"),
    ],
    ),
    ),
    );
  }
}

class printKeys extends StatelessWidget {

  var mydata;
  printKeys(var mydata){ this.mydata= mydata; }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Print Keys"),
        ),
        body: Text("Keys Are: "+mydata[0].keys.toString()),
      ),
    );
  }
}

class findObject extends StatelessWidget {

  var mydata;
  String name='';
  List<String> nameList=new List(8);
  findObject(String name,var mydata){
    this.mydata=mydata;
    this.name=name;
    for(int i=0;i<8;i++){
      nameList[i] = mydata[i]['name'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(nameList.contains(name)) {
      int index=nameList.indexOf(name);
      return Container(
        child: new Scaffold(
          appBar: new AppBar(
            title: Text("Search Result"),
          ),
          body: new Card(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text("Name: "+mydata[index]['name']),
                new Text("Age: ${mydata[index]['age']}"),
                new Text("Gender: "+mydata[index]['gender']),
              ],
            ),
      ),
        ),
      );
    }else{
      return Container(
        child: new Scaffold(
            appBar: new AppBar(
              title: Text("Search result"),
            ),
          body: new Text("Please Enter Valid Name")
        ),
      );
    }
  }
}

class reverseJson extends StatelessWidget {

  var mydata;
  var rmydata=new List(8);
  reverseJson(var mydata) {
    this.mydata=mydata;
    reverse();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: new AppBar(
          title: Text("Reverse JSON"),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index){

              return new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text("Name: "+rmydata[index]['name']),
                    new Text("Age: ${rmydata[index]['age']}"),
                    new Text("Gender: "+rmydata[index]['gender']),
                  ],
                ),
              );
              },
          itemCount: mydata == null ? 0 :rmydata.length,
        ),
      ),
    );
  }

  reverse()
  {
    int j= mydata.length;
    int n = j;
    for (int i = 0; i < n; i++) {
    rmydata[j - 1] = mydata[i];
    j = j - 1;
    }
  }
}

class addJson extends StatefulWidget {

  @override
  _addJsonState createState() => _addJsonState();
}

class _addJsonState extends State<addJson> {


  File jsonfile;
  Directory dir;
  String filename = 'person.json';
  bool fileexists = false;
  Map<String, dynamic> filecontent;

  TextEditingController valueInputController = new TextEditingController();
  TextEditingController valueInputController1 = new TextEditingController();
  TextEditingController valueInputController2 = new TextEditingController();


  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;

      jsonfile = new File(dir.path + "/" + filename);
      print("Directory=" + jsonfile.path);
      fileexists = jsonfile.existsSync();
      if (fileexists) this.setState(() => filecontent = json.decode(jsonfile.readAsStringSync()));
     else{
       print("File not Exists First Time");
     }
    });
  }


  addObj(String pname, String page, String pgender){

    print("Writing in File");
    Map<String,dynamic> content={
      "name": pname,
      "age" : page,
      "gender" : pgender
    };
    if(fileexists) {
      print("File Exists");
      Map<String, dynamic> jsonfilecontent=json.decode(jsonfile.readAsStringSync());
      jsonfilecontent.addAll(content);
      jsonfile.writeAsStringSync(json.encode(jsonfilecontent));
      print("Added Successfully");

      filecontent = json.decode(jsonfile.readAsStringSync());
    } else{

      getApplicationDocumentsDirectory().then((Directory directory){
        dir = directory;

        print("Directory1="+dir.path);
        createFile(content, dir, filename);
      });

    }
    this.setState(() => filecontent = json.decode(jsonfile.readAsStringSync()));
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileexists = true;
    file.writeAsStringSync(json.encode(content));
    print("Its Done");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    valueInputController.dispose();
    valueInputController1.dispose();
    valueInputController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    int age=0;
    String gender = '';

    return Container(
      child: new Scaffold(
          appBar: new AppBar(
            title: Text("Add JSON Data"),
          ),
        body: new Card(
            child:Column(
              children: <Widget>[
                new TextField(
                  controller: valueInputController,
                ),
                new TextField(
                  controller: valueInputController1,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                new TextField(
                  controller: valueInputController2,
                ),
                new RaisedButton(onPressed: ()=>addObj(valueInputController.text,valueInputController1.text,valueInputController2.text), child: new Text("Add")),
                new Text("File content: ", style: new TextStyle(fontWeight: FontWeight.bold),),
                new Text(filecontent.toString())
              ],

            )
        )
      ),
    );
  }

}

class cardUI extends StatelessWidget {

  var mydata;
  int i;
  cardUI(var mydata) { this.mydata=mydata;
  i = mydata.length~/2;}
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView.builder(
            itemBuilder: (BuildContext context, int index){
                return new Row(
                  children: <Widget>[
                    new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: new Container(
                          height: 100.0,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Color(0xFFFD7384)),
                            child:new Card(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new Center(
                                    child: Column(
                                      children: <Widget>[
                                        new Text(""),
                                        new Text("Name: "+mydata[index*2]['name']),
                                        new Text("Age: ${mydata[index*2]['age']}"),
                                        new Text("Gender: "+mydata[index*2]['gender']),
                                      ],
                                    ),
                                  )

                                ]
                                ),),))),
                    new Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: new Container(
                              height: 100.0,
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  color: Color(0xFFFD7384)),
                              child:new Card(
                                child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(""),
                                      new Text("Name: "+mydata[index*2+1]['name']),
                                      new Text("Age: ${mydata[index*2+1]['age']}"),
                                      new Text("Gender: "+mydata[index*2+1]['gender']),
                                    ]
                                ),),)))
                ]);
            },
            itemCount: mydata == null ? 0 :i,
          ));
  }
}

class person{
  String name;
  int age;
  String gender;

  person({this.name,this.age, this.gender});

  person.fromJson(Map<String,dynamic> data)
        : name = data['name'],
          age = data['age'],
          gender= data['gender'];
}
