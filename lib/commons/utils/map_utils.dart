import 'package:audiodoc/commons/logging/logger.dart';


extension MapUtils on Map<String, dynamic> {

  T? _getValue<T>(String key, {bool allowNull = false}) {
    if (!containsKey(key)) {
      if (!allowNull) {
        logger.e("MapUtils: $key not found");
        throw Exception("MapUtils: $key not found");
      }
      return null;
    }

    final value = this[key];
    if (value == null && !allowNull) {
      logger.e("MapUtils: $key is null");
      throw Exception("MapUtils: $key is null");
    }

    if (value is T || value == null) {
      return value as T?;
    } else {
      logger.e("MapUtils: $key is not of type ${T.runtimeType}, it is of type ${value.runtimeType}");
      throw Exception("MapUtils: $key is not of type ${T.runtimeType}, it is of type ${value.runtimeType}");
    }
  }

  int? getIntNullable(String key) => _getValue<int>(key, allowNull: true);

  int getInt(String key) => _getValue<int>(key)!;

  double getDouble(String key) => _getValue<double>(key)!;

  double? getDoubleNullable(String key) => _getValue<double>(key, allowNull: true);

  String? getStringNullable(String key) => _getValue<String>(key, allowNull: true);

  String getString(String key) => _getValue<String>(key)!;

  DateTime? getDateTimeOrNull(String key) {
    final dateString = _getValue<String>(key, allowNull: true);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        logger.e("MapUtils-getDateTimeOrNull: Failed to parse DateTime from $key, error: $e");
        throw Exception("MapUtils-getDateTimeOrNull: Failed to parse DateTime from $key, error: $e");
      }
    }
    return null;
  }

  DateTime getDateTime(String key) {
    final dateString = getString(key); // This will throw if key is not found or value is null
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      logger.e("MapUtils-getDateTime: Failed to parse DateTime from $key, error: $e");
      throw Exception("MapUtils-getDateTime: Failed to parse DateTime from $key, error: $e");
    }
  }

  List<dynamic>? getListNullable(String key) => _getValue<List<dynamic>>(key, allowNull: true);

  List<dynamic> getList(String key) => _getValue<List<dynamic>>(key)!;

  List<T> getListOf<T>(String key) {
    final list = _getValue<List<dynamic>>(key);
    if (list == null) {
      throw Exception("MapUtils: $key is null or not found");
    }
    try {
      return list.cast<T>();
    } catch (e) {
      logger.e("MapUtils: Failed to cast elements of $key to type ${T.runtimeType}, error: $e");
      throw Exception("MapUtils: Failed to cast elements of $key to type ${T.runtimeType}, error: $e");
    }
  }

  Map<String, dynamic>? getObjectOrNull(String key) => _getValue<Map<String, dynamic>>(key, allowNull: true);

  Map<String, dynamic> getObject(String key) => _getValue<Map<String, dynamic>>(key)!;

  bool? getBoolOrNull(String key) => _getValue<bool>(key, allowNull: true);

  bool getBool(String key) => _getValue<bool>(key)!;

  bool hasKey(String key) => containsKey(key);

  bool hasValue(String key) => containsKey(key) && this[key] != null;



  // add get map
  Map<String, dynamic> getMap(String key) => _getValue<Map<String, dynamic>>(key)!;

  // getMapNullable
  Map<String, dynamic>? getMapNullable(String key) => _getValue<Map<String, dynamic>>(key, allowNull: true);


}