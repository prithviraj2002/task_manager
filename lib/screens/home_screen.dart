import 'package:flutter/material.dart';
import 'package:task_manager/database/sql_database.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screens/add_task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IIT Roorkee'),
        actions: const [
          Icon(Icons.warning, color: Colors.black,),
          SizedBox(width: 20,),
          Icon(Icons.message, color: Colors.black,),
          SizedBox(width: 20,),
          Icon(Icons.person)
        ],
      ),
      body: FutureBuilder(
          future: Db.getTasks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<Task> tasks = snapshot.data;
              if(tasks.isEmpty){
                return const Center(child: Text('No tasks added yet!'),);
              }
              else{
                return ListView.separated(
                    itemBuilder: (ctx, index){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 35),
                              child: Text(
                                tasks[index].Category,
                                style: const TextStyle(fontSize: 15, color: Colors.black54),
                              )
                          ),
                          ListTile(
                            onLongPress: (){
                              showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // false = user must tap button, true = tap outside dialog
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Delete?'),
                                  content: const Text('Want to delete this task?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                      Db.delTask(tasks[index].id).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false)); // Dismiss alert dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                              );
                            },
                            title: Text(
                                "${index+1}. " + tasks[index].title,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  margin: const EdgeInsets.only(left: 20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                      '${tasks[index].progress}%',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xff004e98),),
                                  ),
                                    onPressed: () {
                                      //ToDo: Add task update function
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddTask(task: tasks[index])));
                                    },
                                    child: const Text('Update', style: TextStyle(color: Color(0xff004e98),),)
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (ctx, index){
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(),
                      );
                    },
                    itemCount: tasks.length
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: const Color(0xff004e98),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed(AddTask.routeName);
        }, child: const Icon(Icons.add, color: Colors.white,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff004e98),
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState((){
               _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_page_rounded),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_add_check),
              label: 'Site plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Team',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fire_truck),
              label: 'Material',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_people),
              label: 'Attendance',
            ),
          ]
      ),
    );
  }
}
