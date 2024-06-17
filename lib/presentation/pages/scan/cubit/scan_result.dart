import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';

enum DeviceState { idle, requested, rejected, connected, error }

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({required String name, required DeviceState state}) =
      _ScanResult;
}
