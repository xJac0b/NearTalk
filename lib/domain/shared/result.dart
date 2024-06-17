sealed class Result<S, F> {
  const Result();
}

class Success<S, F> extends Result<S, F> {
  const Success(this.value);
  final S value;

  @override
  String toString() => 'Success($value)';
}

class Failure<S, F> extends Result<S, F> {
  const Failure(this.failure);
  final F failure;

  @override
  String toString() => 'Failure($failure)';
}

class Unit {
  const Unit._();
}

const unit = Unit._();
