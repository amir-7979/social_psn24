import 'dart:async';

class RequestQueue {
  static final RequestQueue _instance = RequestQueue._internal();

  factory RequestQueue() => _instance;

  RequestQueue._internal();

  final List<Function> _queue = [];

  void addRequest(Function request) {
    _queue.add(request);
  }

  Future<void> processQueue() async {
    while (_queue.isNotEmpty) {
      final Function request = _queue.removeAt(0);
      try {
        await request();
      } catch (e) {
        print('Error processing request: $e');
      }
    }
  }
}
