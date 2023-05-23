// ignore_for_file: constant_identifier_names

// These constants are used across all scanning functions to have consistent BLE scanning times and intervals
const int BLE_SCAN_TIMEOUT = 5;
const int BLE_SCAN_INTERVAL = 15;

// to keep track of BLE scanning
bool isScanning = false;


// These variables keep track of when the SOS/Fall is activated, and cleared, so that the email/telegram isn't sent more than once per activation
Map<String, bool> EMAIL_SENT = {};
Map<String, bool> TELEGRAM_SENT = {};

// This is a toast notification message
// It will be used to indicate whether Email and Telegram notifications are successful/unsuccessful
String toastMessage = "";

// Every _ interval, remind the patient to take a reading using the oximeter.
const int REMINDER_MINUTES = 480; // thrice daily

// timestamp format
String timeFormat = 'dd/MM/yyyy HH:mm:ss';