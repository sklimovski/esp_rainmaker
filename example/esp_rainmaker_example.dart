import 'package:esp_rainmaker/esp_rainmaker.dart';

Future<void> main() async {
  final user = User();

  //Create new user
  await user.createUser('email@email.com', 'password12345');

  //Login and extend session
  final login = await user.login('email@email.com', 'password12345');
  await user.extendSession('email@email.com', login.refreshToken);

  //Add node mapping and check status
  final nodeAssociation = NodeAssociation(login.accessToken);
  final reqId = await nodeAssociation.addNodeMapping('nodeid1234', 'very_secret_key');
  print(await nodeAssociation.getMappingStatus(reqId));
}
