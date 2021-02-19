abstract class ILocalStorage{
  Future recieve(String key);
  Future clear();
  Future delete(String key);
  Future put(String key, dynamic value);
}