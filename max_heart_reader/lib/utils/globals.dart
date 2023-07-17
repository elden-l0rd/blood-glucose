// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

// These constants are used across all scanning functions to have consistent BLE scanning times and intervals
const int BLE_SCAN_TIMEOUT = 5;
const int BLE_SCAN_INTERVAL = 15;

// to keep track of BLE scanning
bool isScanning = false;

// This is a toast notification message
String toastMessage = "";

// Every _ interval, remind the patient to take a reading using the oximeter.
const int REMINDER_MINUTES = 480; // thrice daily

// timestamp format
String timeFormat = 'MM-dd-yyyy HH:mm:ss';

// Language
Locale currentLocale = const Locale('en');