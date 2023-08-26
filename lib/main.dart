
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_db/teacher.dart';
Future<Database>? database;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  log('open data base');
   database= openDatabase(
 
  join(await getDatabasesPath(), 'teacher_database.db'),
  onCreate: (db, version) {
    log('table creation');
    return db.execute(
      'CREATE TABLE IF NOT EXISTS teachers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sallary TEXT)',
    );
    
  },
  
  version: 1

);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(title: 'Teachers Record'),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title});
  final String title;
 @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
 Future<void> insertTeacher(Teacher teacher) async {
  log('before inserted');
  // Get a reference to the database.
  final db = await database;

  await db!.insert(
    'teachers',
    teacher.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  log('data inserted');
}

Future<List<Teacher>> teacher() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db!.query('teachers');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Teacher(
      name: maps[i]['name'],
      sallary: maps[i]['sallary'],
    );
  });
}
Future<void> updateTeacherRecord(Teacher teacher,int id) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db!.update(
    'teachers',
    teacher.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}


 late TextEditingController nameController;
 late TextEditingController sallaryController;
 late TextEditingController idController;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController=TextEditingController();
    sallaryController=TextEditingController();
    idController=TextEditingController();
  }
  @override
  void dispose() {
    nameController.dispose();
    sallaryController.dispose();
    idController.dispose();
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter name'
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: sallaryController,
              decoration: InputDecoration(
                hintText: 'Enter Salary'
              ),
            ),
          ),
           Expanded(
            flex: 1,
            child: TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: 'Enter Id for update'
              ),
            ),
          ),
           Expanded(
            flex: 2,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 ElevatedButton(
                  onPressed: () {
                    try {
               insertTeacher(Teacher( name:nameController.text, sallary:sallaryController.text));
                      
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                    
                  },
                   child: Text(
                    'Insert',
                             ),
                 ),
                 ElevatedButton(onPressed:()async{
              
              
                
                setState(() {
                  
                });
                 ;},
              child: Text(
                'fetch',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
                     ),
                     ElevatedButton(onPressed: () {
                      try {
              updateTeacherRecord(Teacher( name:nameController.text, sallary: sallaryController.text),int.parse(idController.text));
                        
                      } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        
                      }
                     },child: Text('update'),),
               ],
             ),
           ),
          
          
      
      
         Expanded(
          flex: 5,
          child: FutureBuilder(
            future: teacher(),
            builder: (context,AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                 return 
             ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder:(context, index) {
              
             return ListTile(
              title: Text('Teacher name = ${snapshot.data![index].name.toString()}',),
              subtitle: Text('Salary = ${snapshot.data![index].sallary}'),
             );
           },);
          
              } else {
                return CircularProgressIndicator();
              }
           
          //  child: ListView.builder(
          //   itemCount: listTeacher?.length,
          //   itemBuilder:(context, index) {
            
          //    return ListTile(
          //     leading: Text(listTeacher![index].id.toString()),
          //     title: Text(listTeacher![index].name.toString()),
          //     subtitle: Text(listTeacher![index].sallary),
          //    );
          //  },),
         
  }))],
      ));
  }
}
