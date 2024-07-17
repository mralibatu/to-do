import 'package:shared_preferences/shared_preferences.dart';

class DataManager<T> {
  late final String Function(List<T>) encode;
  late final List<T> Function(String) decode;
  late final String storageKey;

  void setup({
    required String Function(List<T>) encode,
    required List<T> Function(String) decode,
    required String storageKey,
  }) {
    this.encode = encode;
    this.decode = decode;
    this.storageKey = storageKey;
  }

  Future<void> save(List<T> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = encode(items);
    await prefs.setString(storageKey, encodedData);
  }

  Future<List<T>> get() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedString = prefs.getString(storageKey);
    if (encodedString != null) {
      return decode(encodedString);
    }
    return [];
  }

  Future<void> add(T item) async {
    List<T> items = await get();
    items.add(item);
    await save(items);
  }

  Future<void> remove(T item) async {
    List<T> items = await get();
    items.remove(item);
    await save(items);
  }
}