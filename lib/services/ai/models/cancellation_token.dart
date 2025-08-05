import 'dart:async';

/// Token for cancelling AI operations
class CancellationToken {
  bool _isCancelled = false;
  final Completer<void> _completer = Completer<void>();

  /// Whether this token has been cancelled
  bool get isCancelled => _isCancelled;

  /// Future that completes when the token is cancelled
  Future<void> get cancelled => _completer.future;

  /// Cancel the operation
  void cancel() {
    if (!_isCancelled) {
      _isCancelled = true;
      _completer.complete();
    }
  }

  /// Throw [OperationCancelledException] if cancelled
  void throwIfCancelled() {
    if (_isCancelled) {
      throw OperationCancelledException();
    }
  }

  /// Create a combined token that cancels when any of the input tokens cancel
  static CancellationToken combine(List<CancellationToken> tokens) {
    final combined = CancellationToken();

    for (final token in tokens) {
      if (token.isCancelled) {
        combined.cancel();
        break;
      }
      token.cancelled.then((_) => combined.cancel());
    }

    return combined;
  }

  /// Create a token that cancels after a timeout
  static CancellationToken timeout(Duration duration) {
    final token = CancellationToken();
    Timer(duration, () => token.cancel());
    return token;
  }

  /// Create a token that never cancels
  static CancellationToken none() {
    return CancellationToken();
  }
}

/// Exception thrown when an operation is cancelled
class OperationCancelledException implements Exception {
  final String message;

  const OperationCancelledException([this.message = 'Operation was cancelled']);

  @override
  String toString() => 'OperationCancelledException: $message';
}

/// Helper extensions for Stream operations with cancellation
extension CancellableStream<T> on Stream<T> {
  /// Transform stream to support cancellation
  Stream<T> cancellable(CancellationToken cancellationToken) async* {
    final subscription = listen(null);

    // Cancel subscription when token is cancelled
    cancellationToken.cancelled.then((_) {
      subscription.cancel();
    });

    try {
      await for (final value in this) {
        cancellationToken.throwIfCancelled();
        yield value;
      }
    } finally {
      await subscription.cancel();
    }
  }
}

/// Helper extensions for Future operations with cancellation
extension CancellableFuture<T> on Future<T> {
  /// Transform future to support cancellation
  Future<T> cancellable(CancellationToken cancellationToken) async {
    if (cancellationToken.isCancelled) {
      throw OperationCancelledException();
    }

    return await Future.any([
      this,
      cancellationToken.cancelled.then<T>(
        (_) => throw OperationCancelledException(),
      ),
    ]);
  }
}
