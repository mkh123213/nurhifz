import 'package:flutter_bloc/flutter_bloc.dart';

mixin PaginationMixin<T> on Cubit<T> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  int get page => _page;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  int get pageSize => 20;

  void resetPagination() {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
  }

  Future<void> loadMore({
    required Future<List<dynamic>> Function(int page, int pageSize) fetcher,
    required void Function(List<dynamic> items, bool hasMore) onSuccess,
    required void Function(String error) onError,
  }) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    try {
      final items = await fetcher(_page, pageSize);
      _hasMore = items.length >= pageSize;
      if (items.isNotEmpty) _page++;
      onSuccess(items, _hasMore);
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoadingMore = false;
    }
  }
}
