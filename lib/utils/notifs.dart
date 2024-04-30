import 'dart:convert';

import 'package:http/http.dart' as http;

var serverToken =
    "AAAADm79qog:APA91bETxUd4OAUXxCtEfnWL9d3VnQAGIqo7QZpOdgauPmSyfWINlRqleBFlLlWrdqNummKm_PcWk3HlpPWA351JB0uhX1xT4o-oxMXWf85MguIFf2RizoKRXePY29GKmBhUackJ5MuF";
sendNotif(String title, String body, String token) async {
  print(token);
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': body.toString(),
          'title': title.toString(),
          'sound': 'alarm.mp3',
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        "android": {
          "notification": {
            "channel_id":
                "channel_id_1" // NOTIFICATION CHANNEL ID WITH CUSTOM SOUND REFERENCE HERE
          }
        },
        'to': token
      }));
}
