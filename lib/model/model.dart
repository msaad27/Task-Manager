enum TaskStatus { pending, started, completed, }



class Task {
  final String id;
  final String title;
  final String description;  
  final TaskStatus status;
  
  DateTime? deadline;
  Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
   
    this.deadline,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
  
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
     
      deadline: deadline ?? this.deadline,
    );
  }
}
