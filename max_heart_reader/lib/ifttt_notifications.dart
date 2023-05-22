// ignore_for_file: non_constant_identifier_names, library_prefixes

// Flutter/Dart
import 'package:flutter/material.dart';

// Project Files
import 'globals.dart' as globals;
import 'find_devices.dart' as findDevicesWidget;

// Email notification
// https://www.youtube.com/watch?v=YkA4TUgCmRA&ab_channel=StechiezDIY
// https://ifttt.com/my_applets
// https://pub.dev/packages/http
import 'package:http/http.dart' as http;


/*
IFTTT Notification Architecture
---------------------------------------------------------------------------------------------------------------------------

SmartWearable #1 → → → → → → → → → → ↴
				                              ↓
				                              ↓
SmartWearable #2 → → → → → → → → → → ↴
				                              ↓
				                              ↓
SmartWearable #3 → → → → → → → Mobile Phone #1 → → → → → → → → IFTTT Account #1 → → → → → → → → Email Account
				                                ↑		      	                  ↑       ↓
				                                ↑		                          ↑       ↓
		                 ↱ → → → → → → → → ⬏		      		                ↑       ↳ → → → → → → → → Telegram Group/Channel
		                ↑		      				                                ↑
		                ↑	         Mobile Phone #2 → → → → → → → → → → → ⬏
                    ↑                 ↑
		                ↑		              ↑
SmartWearable #4 → ⬏ → → → → → → → → ⬏
		    		                          ↑
		    		                          ↑
SmartWearable #5 → → → → → → → → → → ⬏
				                              ↑
...				                            ↑
				                              ↑
...				                            ↑
				                              ↑
...				                            ↑
				                              ↑
SmartWearable #X → → → → → → → → → → ⬏

---------------------------------------------------------------------------------------------------------------------------
*/


void iftttNotifications(deviceName, sosBytes, fallBytes){

  // Deal with uninitialized devices (connecting for the first time)
  if (globals.EMAIL_SENT[deviceName] == null){
    globals.EMAIL_SENT[deviceName] = false;
  }
  if (globals.TELEGRAM_SENT[deviceName] == null){
    globals.TELEGRAM_SENT[deviceName] = false;
  }


  if(sosBytes == '1' || fallBytes == '1'){
    String errorMessage = "";
    if(sosBytes == '1' && fallBytes == '1'){errorMessage = "SOS AND FALL WARNING";}
    if(sosBytes == '1' && fallBytes == '0'){errorMessage = "SOS WARNING";}
    if(sosBytes == '0' && fallBytes == '1'){errorMessage = "FALL WARNING";}

    //debugPrint('createInfluxPoint: [$errorMessage] EMAIL_SENT[$deviceName]:${globals.EMAIL_SENT[deviceName]}, TELEGRAM_SENT[$deviceName]:${globals.TELEGRAM_SENT[deviceName]}');
    if(globals.EMAIL_SENT[deviceName] == false){
      debugPrint('createInfluxPoint: [$errorMessage] Sending email notification!');
      sendEmail(deviceName, sosBytes, fallBytes, errorMessage);
    }
    if(globals.TELEGRAM_SENT[deviceName] == false){
      debugPrint('createInfluxPoint: [$errorMessage] Sending telegram notification!');
      sendTelegram(deviceName, sosBytes, fallBytes, errorMessage);
    }
  }

  if(sosBytes == '0' && fallBytes == '0'){
    // System has been reset!
    // Prepare global variables to send another IFTTT notification in the future...
    globals.EMAIL_SENT[deviceName] = false;
    globals.TELEGRAM_SENT[deviceName] = false;
  }


}

Future<void> sendEmail(deviceName, sosBytes, fallBytes, errorMessage) async {
  
  debugPrint('sendEmail: deviceName:$deviceName, sos:$sosBytes, fall:$fallBytes');

  String ifttt_event = "alarm_triggered_email";     // email event
  String ifttt_key = "jPTn1vue2LnvP5g8gQw0GKt8m-jvh_-cLRcQPV83O1S";
  String value1 = deviceName;                       // deviceName
  String value2 = "undefined";                      // SOS undefined by default
  String value3 = "undefined";                      // Fall undefined by default

  if(sosBytes == '1'){
    // SOS Alarm via alarm_triggered_email
    value2 = "SOS:true";                            // SOS Activated
  } else {
    value2 = "SOS:false";
  }

  if (fallBytes == '1'){
    // Fall Alarm via alarm_triggered_email
    value3 = "Fall:true";                           // Fall Activated
  } else {
    value3 = "Fall:false";
  }


  // e.g. https://maker.ifttt.com/trigger/alarm_triggered_email/with/key/jPTn1vue2LnvP5g8gQw0GKt8m-jvh_-cLRcQPV83O1S?value1=3LOGY-Watch001&value2=SOS:true&value3=Fall:false  
  Uri ifttt_url = Uri.parse("https://maker.ifttt.com/trigger/$ifttt_event/with/key/$ifttt_key?value1=$value1&value2=$value2&value3=$value3");

  var response = await http.get(ifttt_url);
  if(response.statusCode == 200){
    debugPrint("sendEmail: Success! Response body: ${response.body}");
    globals.EMAIL_SENT[deviceName] = true;

    globals.toastMessage = '[$deviceName: $errorMessage] \nEmail Notification Sent';
    findDevicesWidget.showToast();
  } else {
    debugPrint('sendEmail: Request failed with status: ${response.statusCode}.');
    globals.toastMessage = '[$deviceName: $errorMessage] \nError Sending Email';
    findDevicesWidget.showToast();
  }
 
}



Future<void> sendTelegram(deviceName, sosBytes, fallBytes, errorMessage) async {

  debugPrint('sendTelegram: deviceName:$deviceName, sos:$sosBytes, fall:$fallBytes');

  String ifttt_event = "alarm_triggered_telegram";  // Telegram event
  String ifttt_key = "jPTn1vue2LnvP5g8gQw0GKt8m-jvh_-cLRcQPV83O1S";
  String value1 = deviceName;                       // deviceName
  String value2 = "undefined";                      // SOS undefined by default
  String value3= "undefined";                       // Fall undefined by default

  if(sosBytes == '1'){
    // SOS Alarm via alarm_triggered_telegram
    value2 = "SOS:true";                            // SOS Activated
  } else {
    value2 = "SOS:false";
  }

  if (fallBytes == '1'){
    // Fall Alarm via alarm_triggered_telegram
    value3 = "Fall:true";                           // Fall Activated
  } else {
    value3 = "Fall:false";
  }

  // e.g. https://maker.ifttt.com/trigger/alarm_triggered_telegram/with/key/jPTn1vue2LnvP5g8gQw0GKt8m-jvh_-cLRcQPV83O1S?value1=3LOGY-Watch001&value2=SOS:true&value3=Fall:false
  Uri ifttt_url = Uri.parse("https://maker.ifttt.com/trigger/$ifttt_event/with/key/$ifttt_key?value1=$value1&value2=$value2&value3=$value3");

  var response = await http.get(ifttt_url);
  if(response.statusCode == 200){
    debugPrint("sendTelegram: Success! Response body: ${response.body}");
    globals.TELEGRAM_SENT[deviceName] = true;

    globals.toastMessage = '[$deviceName: $errorMessage] \nTelegram Notification Sent';
    findDevicesWidget.showToast();
  } else {
    debugPrint('sendTelegram: Request failed with status: ${response.statusCode}.');
    globals.toastMessage = '[$deviceName: $errorMessage] \nError Sending Telegram';
    findDevicesWidget.showToast();
  }

}