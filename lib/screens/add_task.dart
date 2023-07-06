import 'package:flutter/material.dart';
import 'package:task_manager/database/sql_database.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/screens/home_screen.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add-task';
  Task? task;
  AddTask({this.task, Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController title = TextEditingController();

  double _currentSliderValue = 0.0;

  String _value = 'General';
  static const List<String> categories = ['General', 'Plumbing', 'Services', 'Brick Work', 'Civil'];

  @override
  void dispose() {
    // TODO: implement dispose
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add / Update Work"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel_outlined)
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Task Name', style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              TextFormField(
                controller: title,
                maxLines: 1,
                validator: (value){
                  if(value == null){
                    return 'Cannot have an empty value';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: widget.task != null ? widget.task!.title : 'E.g - Civil, Electrical, Painting etc.',
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30,),
              const Text('Work Categories', style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87)
                ),
                width: MediaQuery.of(context).size.width*0.9,
                alignment: Alignment.center,
                height: 70,
                child: DropdownButton<String>(
                  isExpanded: true,
                    value: widget.task != null ? widget.task!.Category : _value,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Color(0xff004e98),),
                    items: categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState((){
                        _value = value!;
                      });
                    }
                ),
              ),
              const SizedBox(height: 20,),
              Slider(
                value: widget.task != null? double.parse(widget.task!.progress.toString()) : _currentSliderValue,
                max: 100,
                divisions: 4,
                label: _currentSliderValue.round().toString(),
                activeColor: const Color(0xff004e98),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              const Text('Add Photos (Optional)', style: TextStyle(color: Colors.black54, fontSize: 20),),
              const SizedBox(height: 20,),
              Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                color: const Color(0xffbfdbf7),
                child: const Icon(Icons.add_circle_outlined, color: Color(0xff004e98),),
              ),
              const SizedBox(height: 20,),
              const Row(
                children: <Widget>[
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                      label: Row(
                      children: <Widget>[
                        Icon(Icons.person_add_alt_1_rounded, color: Color(0xff004e98),),
                        Text('Update', style: TextStyle(color: Color(0xff004e98)),)
                      ]
                    ),
                  ),
                  SizedBox(width: 5,),
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    label: Row(
                        children: <Widget>[
                          Icon(Icons.person_add_alt_1_rounded, color: Color(0xff004e98),),
                          Text('Assign', style: TextStyle(color: Color(0xff004e98)),)
                        ]
                    ),
                  ),
                  SizedBox(width: 5,),
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    label: Row(
                        children: <Widget>[
                          Icon(Icons.date_range, color: Color(0xff004e98),),
                          Text('Start Date', style: TextStyle(color: Color(0xff004e98)),)
                        ]
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  label: Row(
                      children: <Widget>[
                        Icon(Icons.date_range, color: Color(0xff004e98),),
                        Text('End Date', style: TextStyle(color: Color(0xff004e98)),)
                      ]
                  ),
                ),
                  SizedBox(width: 5,),
                  Chip(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      label: Text('Tags')
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff004e98)
                      ),
                        onPressed: () {
                        if(title.text.isNotEmpty && widget.task == null){
                          Db.addTask(
                              Task(title: title.text,
                                  Category: _value,
                                  progress: _currentSliderValue.toInt(),
                                  id: DateTime.now().millisecond)
                            ).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false));
                          }
                        else if(widget.task != null && title.text.isNotEmpty){
                            Db.updateTask(
                                Task(title: title.text,
                                    Category: _value,
                                    progress: _currentSliderValue.toInt(),
                                    id: widget.task!.id,
                                )
                            ).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false));
                          }
                        },
                        child: const Text('Done', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// floatingActionButton: SizedBox(
// width: MediaQuery.of(context).size.width*0.8,
// child: FloatingActionButton(
// backgroundColor: const Color(0xff004e98),
// onPressed: () {},
// child: const Text('Done', style: TextStyle(color: Colors.white),),
// ),
// ),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


// TextFormField(
// controller: desc,
// maxLines: null,
// validator: (value){
// if(value == null){
// return 'Cannot have an empty value';
// }
// return null;
// },
// decoration: const InputDecoration(
// hintText: 'Description',
// hintStyle: TextStyle(fontWeight: FontWeight.bold),
// border: OutlineInputBorder(),
// ),
// ),