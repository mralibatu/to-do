import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:to_do/DataManager.dart';
import 'package:uuid/uuid.dart';

List<Task> tasks = [];

class Task {
  String id;
  String? title;
  String? description;
  DateTime? startDate;
  bool? isCompleted;
  Priority? priority;
  DataManager<Task> taskManager = new DataManager<Task>();

  Task({
    required this.id,
    this.title,
    this.description,
    this.startDate,
    this.priority,
    this.isCompleted = false,
  });

  void complete() {
    this.isCompleted = true;
  }

  void unComplete() {
    this.isCompleted = false;
  }

  static Task create() {
    List<String> titles = [
      'Günlük Stand-up Toplantısı',
      'Proje Planını Güncelle',
      'Müşteri Görüşmesi',
      'Haftalık Rapor Hazırlığı',
      'Kod İncelemesi',
      'Veritabanı Yedeklemesi',
      'Yeni Özellik Tasarımı',
      'Hata Düzeltme',
      'Eğitim Oturumu',
      'Pazar Araştırması'
    ];
    List<String> taskDescriptions = [
      'Takım üyeleriyle güncel durumu paylaş ve günlük hedefleri belirle.',
      'Proje planındaki değişiklikleri yansıt ve yeni görevleri ekle.',
      'Müşteriyle yeni özellikler hakkında toplantı yap ve geri bildirimleri al.',
      'Haftalık ilerleme ve performans raporunu hazırla ve yönetime sun.',
      'Takım arkadaşının kodunu gözden geçir ve iyileştirme önerileri yap.',
      'Veritabanının tam yedeğini al ve güvenli bir şekilde sakla.',
      'Yeni bir özelliğin kullanıcı arayüzü ve işlevselliği üzerinde çalış.',
      'Uygulamada tespit edilen hataları düzelt ve ilgili testleri gerçekleştir.',
      'Yeni teknolojiler veya araçlar hakkında takım için bir eğitim oturumu düzenle.',
      'Rakip ürünleri ve pazar trendlerini analiz ederek stratejik içgörüler oluştur.'
    ];

    DateTime now = DateTime.now();
    DateTime lastDayofMonth = DateTime(now.year, now.month + 1, 0);

    DateTime startDate = DateTime(now.year, now.month - 1, 0);
    ;
    DateTime endDate =
        DateTime.now().add(Duration(days: lastDayofMonth.day - now.day));
    int differenceInDays = endDate.difference(startDate).inDays;
    int randomDays = Random().nextInt(differenceInDays + 1);
    startDate = startDate.add(Duration(days: randomDays));
    randomDays = Random().nextInt(differenceInDays + 1);
    endDate = endDate.subtract(Duration(days: randomDays));

    bool isComp = (Random().nextInt(2) % 2 == 0) ? true : false;
    Priority p1 = Priority.values[Random().nextInt(Priority.values.length)];
    titles.shuffle(Random());
    taskDescriptions.shuffle(Random());

    var uuid = Uuid();
    String newId = uuid.v4();

    return Task(
        id: newId,
        title: titles[0],
        description: taskDescriptions[0],
        startDate: startDate,
        priority: p1,
        isCompleted: isComp);
  }

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'].toString(),
      title: jsonData['title'],
      description: jsonData['desc'],
      startDate: DateTime.parse(jsonData['startDate']),
      priority: Priority.values
          .firstWhere((e) => e.toString() == jsonData['priority']),
      isCompleted: jsonData['isCompleted'],
    );
  }

  static Map<String, dynamic> toMap(Task task) => {
        'id': task.id,
        'title': task.title,
        'desc': task.description,
        'startDate': task.startDate?.toIso8601String(),
        'priority': task.priority?.toString(),
        'isCompleted': task.isCompleted,
      };

  static String encode(List<Task> tasks) => json.encode(
        tasks.map<Map<String, dynamic>>((task) => Task.toMap(task)).toList(),
      );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();

  void getTasks() async {}

  static void createTasks(int count) {
    for (int i = 0; i < count; i++) {
      tasks.add(create());
    }
  }

  static Task getRandomTask() {
    List<Task> tempTask = List.from(tasks);
    tempTask.shuffle(Random());
    return tempTask[0];
  }

  static int getTaskCountByDate(
      DateTime date, bool isLimited, List<Task> tasks) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String d1 = "";
    String d2 = "";
    int count = 0;
    for (Task task in tasks) {
      d1 = formatter.format(date);
      d2 = formatter.format(task.startDate!);
      if (d1 == d2) {
        count++;
      }
    }
    if (isLimited) {
      if (count > 3) return 3;
    }
    return count;
  }

  String toString() {
    return "${this.title}\n${this.description}\n${this.startDate}\n${this.isCompleted}\n${this.priority}";
  }

  static List<Task> getBasics(List<Task> parTasks) {
    List<Task> result = [];
    for (Task task in parTasks) {
      if (task.priority == Priority.basic) result.add(task);
    }

    return result;
  }

  static List<Task> getUrgents(List<Task> parTasks) {
    List<Task> result = [];
    for (Task task in parTasks) {
      if (task.priority == Priority.urgent) result.add(task);
    }

    return result;
  }

  static List<Task> getImportants(List<Task> parTasks) {
    List<Task> result = [];
    for (Task task in parTasks) {
      if (task.priority == Priority.important) result.add(task);
    }

    return result;
  }

  static List<Task> getUrgentImportant(List<Task> parTasks) {
    List<Task> result = [];
    for (Task task in parTasks) {
      if (task.priority == Priority.urgentImportant) result.add(task);
    }

    return result;
  }

  static List<Task> sortByPriority(List<Task> tasks, {List<Task>? parTasks}) {
    parTasks ??= tasks;
    print(parTasks.length);
    List<Task> result = [];
    List<Task> basic = getBasics(parTasks);
    List<Task> urgent = getUrgents(parTasks);
    List<Task> important = getImportants(parTasks);
    List<Task> urimpor = getUrgentImportant(parTasks);
    List<List<Task>> lists = [urimpor, urgent, important, basic];

    for (List<Task> list in lists) {
      for (Task task in list) {
        result.add(task);
      }
    }

    return result;
  }

  static List<Task> sortByDate(List<Task> tasks, {List<Task>? parTasks}) {
    parTasks ??= tasks;
    List<Task> sortedTasks = List.from(parTasks);
    sortedTasks.sort((a, b) => a.startDate!.compareTo(b.startDate!));
    return sortedTasks;
  }

  static List<Task> getCompleted(List<Task> tasks, {List<Task>? parTasks}) {
    parTasks ??= tasks;
    List<Task> completedTasks = parTasks.where((task) => task.isCompleted!).toList();
    return sortByDate(completedTasks);
  }

  static List<Task> getByDate(List<Task> tasks, int selected, DateTime dateTime,{List<Task>? parTasks}) {
    parTasks ??= tasks;
    List<Task> result = [];
    for (Task task in parTasks) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String d1 = formatter.format(task.startDate!);
      final String d2 = formatter.format(dateTime);
      if (d1 == d2) {
        result.add(task);
      }
    }
    switch(selected)
    {
      case -1:
        return result;
      case 0:
        return sortByPriority(result);
      case 1:
        return getCompleted(result);
    }
    return result;
  }
}

enum Priority { basic, urgent, important, urgentImportant }
