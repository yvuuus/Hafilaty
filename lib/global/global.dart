import 'package:bus_tracking_app/models/direction_details_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

String userDropOffAddress = "";

DirectionDetailsInfo? tripDirectionDetailsInfo;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;
//UserModel? UserModelCurrentInfo;
