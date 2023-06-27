class DeviceData {
  final int battery;
  final int heartRate;
  final int spo2;
  final double glucose;
  final double cholesterol;
  final double UA_men;
  final double UA_women;

  DeviceData({
    this.battery = 0,
    this.heartRate = 0,
    this.spo2 = 0,
    this.glucose = 0.0,
    this.cholesterol = 0.0,
    this.UA_men = 0.0,
    this.UA_women = 0.0,
  });
}
