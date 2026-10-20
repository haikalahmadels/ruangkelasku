/// Respons daftar berpaginasi Laravel: `{ data, links, meta }`.
class Paged<T> {
  const Paged({required this.items, required this.currentPage, required this.lastPage, required this.total});

  factory Paged.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromItem) {
    final meta = json['meta'] as Map<String, dynamic>;
    return Paged(
      items: (json['data'] as List).map((e) => fromItem(e as Map<String, dynamic>)).toList(),
      currentPage: meta['current_page'] as int,
      lastPage: meta['last_page'] as int,
      total: meta['total'] as int,
    );
  }

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;
}

/// Isi daftar berpaginasi yang sudah dimuat; halaman berikutnya lewat "Muat lainnya".
class PagedState<T> {
  const PagedState({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.total,
    this.loadingMore = false,
  });

  PagedState.first(Paged<T> first)
    : this(items: first.items, page: first.currentPage, hasMore: first.hasMore, total: first.total);

  final List<T> items;
  final int page;
  final bool hasMore;
  final int total;
  final bool loadingMore;

  PagedState<T> append(Paged<T> next) =>
      PagedState(items: [...items, ...next.items], page: next.currentPage, hasMore: next.hasMore, total: next.total);

  PagedState<T> copyWith({List<T>? items, int? total, bool? loadingMore}) => PagedState(
    items: items ?? this.items,
    page: page,
    hasMore: hasMore,
    total: total ?? this.total,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}
