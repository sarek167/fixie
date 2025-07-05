
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/avatar/data/avatar_option_item.dart';
import 'package:frontend/features/avatar/data/avatar_state.dart';

class AvatarService {
  static Future<Map<String, List<AvatarOptionItem>>> getAvatarOptions() async {
    final response = await TokenClient.client.get(EndpointConstants.getUserAvatarOptionsEndpoint);
    final data = response.data as Map<String, dynamic>;
    print("W AVATAR SERVICE");
    print(data);
    return data.map((key, value) {
      return MapEntry(
          key,
          (value as List).map((e) => AvatarOptionItem.fromSingleJson(e)).toList(),
      );
    });
  }

  static Future<AvatarState> getAvatarState() async {
    final response = await TokenClient.client.get(EndpointConstants.getAvatarStateEndpoint);

    if (response.statusCode == 200) {
      final avatar = AvatarState.fromJson(response.data as Map<String, dynamic>);
      return avatar;
    } else {
      throw Exception("Error while getting AvatarState");
    }
  }

  static Future<void> updateAvatarState(AvatarState state) async {
    final response = await TokenClient.client.put(
      EndpointConstants.putAvatarStateEndpoint,
      data: state.toJson()
    );
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202) {
      throw Exception("Error while updating AvatarState");
    }
  }
}