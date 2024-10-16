import 'package:audiodoc/commons/utils/pair.dart';

class PaginationUtil {
  PaginationUtil._();

  static int totalPages({required int itemCount, required int pageSize}) {
    return (itemCount / pageSize).ceil();
  }

  static bool isFirstPage({required int page}) {
    return page == 1;
  }

  static bool isLastPage({required int page, required int totalPages}) {
    return page == totalPages;
  }

  static bool hasPreviousPage({required int page}) {
    return page > 1;
  }

  static bool hasNextPage({required int page, required int totalPages}) {
    return page < totalPages;
  }

  static Pair<int, int> getShowingRange({required int page, required int pageSize, required int itemCount}) {
    final int start = (page - 1) * pageSize + 1;
    final int end = (page * pageSize) > itemCount ? itemCount : (page * pageSize);
    return Pair(start, end);
  }
}
