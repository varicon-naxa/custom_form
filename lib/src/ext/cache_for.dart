import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

extension CacheFor on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);

    onDispose(timer.cancel);
  }
}
