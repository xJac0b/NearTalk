part of 'home_cubit.dart';

@freezed
class HomeAction with _$HomeAction {
  const factory HomeAction.connectionRequest(String id, ConnectionInfo info) =
      ConnectionRequest;
}
