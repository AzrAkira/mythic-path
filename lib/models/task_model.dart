class TaskModel{
  String id;
  String title;
  String difficulty;
  int xpReward;
  bool isCompleted;
  DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.xpReward,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'difficulty': difficulty,
      'xpReward': xpReward,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      difficulty: map['difficulty'],
      xpReward: map['xpReward'],
      isCompleted: map['isCompleted'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
 
}