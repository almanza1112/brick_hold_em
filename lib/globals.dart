// Login type
const String LOGIN_TYPE_FACEBOOK = "facebook";
const String LOGIN_TYPE_GOOGLE = "google";
const String LOGIN_TYPE_EMAIL = "email";

// Settings Shared Prefences keys
String settingsBackgroundSound = "settingsBackgroundSound";
String settingsFXSound = "settingsFXSound";
String settingsVibrate = "settingsVibrate";
String settingsGameLiveChat = "settingsGameLiveChat";

// Flutter Secure Storage keys
// Logged in user info
const String FSS_USERNAME = 'username';
const String FSS_PASSWORD = 'password';

// Logged-in user info
String loggedInUserUsername = "loggedInUserUsername";

// Firebase keys
// (fsk = Firestore Key Name)
String fskUsername = "username";

// Firebase: Realtime Database 
const String RD_KEY_USERNAME = 'username';
const String RD_KEY_PHOTOURL = 'photoURL';
const String RD_KEY_UID = "uid";
const String RD_KEY_CHIPS = 'chips';

// Firebase: Cloud Firestore
String CF_COLLECTION_USERS = 'users';
String CF_KEY_STATUS = 'status';
String CF_KEY_UID = 'uid';
String CF_KEY_PHOTOURL = 'photoURL';
String CF_KEY_USERNAME = 'username';
String CF_VALUE_REQUEST_SENT = 'requestSent';
String CF_VALUE_REQUEST_RECEIVED = 'requestReceived';
String CF_VALUE_FRIENDS = 'friends';
String CF_SUBCOLLECTION_FRIENDS = 'friends';
String CF_DOC_PENDING_FRIEND_REQUESTS = 'pendingFriendRequests';

// End point
//String END_POINT = "https://brick-hold-em-api.onrender.com/";
String END_POINT = "http://192.168.0.118:3000"; // for when local

