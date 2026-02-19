abstract class Readable<T> {
  Future<List<T>> readAll();
}

abstract class Writable<T> {
  Future<void> save(T item);
}

abstract class Deletable<T> {
  Future<void> delete(String id);
}

