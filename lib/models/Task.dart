import 'dart:math';
import 'package:intl/intl.dart';

class Task {
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  bool? isCompleted;
  Priority? priority;
  static List<Task> tasks = [];

  Task(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.priority,
      this.isCompleted = false});

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

    DateTime startDate = DateTime.now();
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

    return Task(
        title: titles[0],
        description: taskDescriptions[0],
        startDate: startDate,
        endDate: endDate,
        priority: p1,
        isCompleted: isComp);
  }

  static List<Task> getTasks() {
    return tasks;
  }

  static void createTasks(int count) {
    for (int i = 0; i < count; i++) {
      tasks.add(create());
    }
  }

  static Task getRandomTask() {
    List<Task> tempTask = new List.from(tasks);
    tempTask.shuffle(Random());
    return tempTask[0];
  }

  String toString() {
    return "${this.title}\n${this.description}\n${this.startDate}\n${this.endDate}\n${this.isCompleted}\n${this.priority}";
  }

  static List<Task> getBasics() {
    List<Task> result = [];
    for (Task task in tasks) {
      if (task.priority == Priority.basic) result.add(task);
    }

    return result;
  }

  static List<Task> getUrgents() {
    List<Task> result = [];
    for (Task task in tasks) {
      if (task.priority == Priority.urgent) result.add(task);
    }

    return result;
  }

  static List<Task> getImportants() {
    List<Task> result = [];
    for (Task task in tasks) {
      if (task.priority == Priority.important) result.add(task);
    }

    return result;
  }

  static List<Task> getUrgentImportant() {
    List<Task> result = [];
    for (Task task in tasks) {
      if (task.priority == Priority.urgentImportant) result.add(task);
    }

    return result;
  }

  static List<Task> sortByPriority() {
    List<Task> result = [];
    List<Task> basic = getBasics();
    List<Task> urgent = getUrgents();
    List<Task> important = getImportants();
    List<Task> urimpor = getUrgentImportant();
    List<List<Task>> lists = [urimpor, urgent, important, basic];

    for (List<Task> list in lists) {
      for (Task task in list) {
        result.add(task);
      }
    }

    return result;
  }

  static List<Task> sortByDate()
  {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => a.startDate!.compareTo(b.startDate!));
    return sortedTasks;

  }

  static List<Task> sortByCompleted() {
    List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => a.isCompleted! == b.isCompleted!
        ? 0
        : (a.isCompleted! ? 1 : -1));
    return sortedTasks;
  }

  static List<Task> getByDate(DateTime dateTime) {
    List<Task> result = [];
    for (Task task in tasks) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String d1 = formatter.format(task.startDate!);
      final String d2 = formatter.format(dateTime);
      if (d1 == d2) {
        result.add(task);
      }
    }
    return result;
  }
}

enum Priority { basic, urgent, important, urgentImportant }
