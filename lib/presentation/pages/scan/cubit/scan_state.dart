part of 'scan_cubit.dart';

@freezed
class ScanState with _$ScanState {
  const factory ScanState({
    required Map<String, ScanResult> scanResults,
  }) = _ScanState;
  factory ScanState.initial() => const ScanState(
        scanResults: {},
      );
}
