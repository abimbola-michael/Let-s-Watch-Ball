import 'package:watchball/models/user.dart';

final userOne = User(
  id: "0",
  name: "Abimbola Ezekiel",
  email: "abimbolaezekiel@gmail.com",
  phone: "07038916545",
  timeJoined: DateTime.now().toString(),
  bio: "My Goat is C.Ronaldo",
  photo: "profile",
);

List<User> allFriends = [
  User(
    id: "0",
    name: "Omodesire Shindara",
    email: "omodesireabimbola@gmail.com",
    phone: "08033189804",
    timeJoined: DateTime.now().millisecondsSinceEpoch.toString(),
    bio: "I support Barca",
    photo: "profile",
  ),
  User(
    id: "1",
    name: "Abimbola Ezekiel",
    email: "abimbolaezekiel@gmail.com",
    phone: "07038916545",
    timeJoined: DateTime.now().toString(),
    bio: "My Goat is C.Ronaldo",
    photo: "profile",
  )
];
