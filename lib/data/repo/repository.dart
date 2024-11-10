import 'package:flutter/material.dart';
import 'package:todo_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;

  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) async {
    final T item = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return item;
  }

  @override
  Future<void> delete(T data) async {
    localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async{
   await localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String serachkeyword = ''}) {
    return localDataSource.getAll(serachkeyword: serachkeyword);
  }
}
