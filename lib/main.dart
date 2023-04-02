import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}
void main()async {
   
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme:ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.pink,
    ) ,home:MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String studentname="",studentroll="";
  getStudentName(name)
  {
    studentname=name;
  }
  getStudentRoll(roll)
  {
    studentroll=roll;
  }
  createData()
  {
    print("created");

    CollectionReference users = FirebaseFirestore.instance.collection("india");

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            "studentname":studentname,
              "roll": studentroll,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }


  
    readData()
    {
      print("reading");
      GetUserName("india");
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students info"),
      ),
      body: 
      Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom:8.0)),
          
          TextFormField(decoration: const InputDecoration(
            labelText:  "Name",
            fillColor: Colors.cyan,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow,width:2.0)
            )
          ),
          onChanged: (String name){
           getStudentName(name); 
          } ,
          ),
          TextFormField(decoration: const InputDecoration(
            labelText: "Roll No.",
            fillColor: Colors.cyan,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red,width:2.0)
            )
          ),
          onChanged: (String roll){
            getStudentRoll(roll);
          },
          ) ,
          ButtonTheme(child:  FloatingActionButton(focusColor: Colors.pink,
          child: Text("Create"),
          onPressed: (){
            createData();

          })) ,
           ButtonTheme(child:  FloatingActionButton(focusColor: Colors.pink,
          child: Text("Read"),
          onPressed: (){
            readData();

          }))     
        ],
        
      ),
    ) ;
  }
}

