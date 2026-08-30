import 'core/config/app_environment.dart';
import 'main.dart';

void main() async {
  await mainCommon(environment: Environment.dev);
}
