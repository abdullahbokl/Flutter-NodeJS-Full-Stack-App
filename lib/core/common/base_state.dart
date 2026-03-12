/// Sealed state class used by all Cubits.
sealed class BaseState<T> {
  const BaseState();
}

class InitialState<T> extends BaseState<T> {
  const InitialState();
}

class LoadingState<T> extends BaseState<T> {
  const LoadingState();
}

class SuccessState<T> extends BaseState<T> {
  final T data;
  const SuccessState(this.data);
}

class ErrorState<T> extends BaseState<T> {
  final String message;
  const ErrorState(this.message);
}

class EmptyState<T> extends BaseState<T> {
  const EmptyState();
}

