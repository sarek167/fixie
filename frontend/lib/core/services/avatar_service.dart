
import 'package:frontend/core/constants/api_endpoints.dart';
import 'package:frontend/core/services/token_service.dart';
import 'package:frontend/features/avatar/data/avatar_option_item.dart';

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
}