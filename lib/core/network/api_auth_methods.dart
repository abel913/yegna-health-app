import 'api_auth_credentials.dart';
import 'api_auth_profile.dart';

export 'api_auth_credentials.dart';
export 'api_auth_profile.dart';

/// Combined authentication and profile API methods mixin.
mixin ApiAuthMethods on Object implements ApiAuthCredentials, ApiAuthProfile {}
