class Task{
  final String title;
  final String Category;
  final int progress;
  final int id;

  const Task({
    required this.title,
    required this.id,
    required this.Category,
    required this.progress,
  });

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'id' : id,
      'Category' : Category,
      'progress' : progress,
    };
  }
}