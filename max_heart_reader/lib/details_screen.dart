import 'package:flutter/material.dart';
import 'package:max_heart_reader/user_preferences.dart';
import 'package:max_heart_reader/button_widget.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String age = '';
  String gender = '';
  String height = '';
  String weight = '';

  @override
  void initState() {
    super.initState();

    name = UserPreferences.getName() ?? '';
    age = UserPreferences.getAge() ?? '';
    gender = UserPreferences.getGender() ?? '';
    height = UserPreferences.getHeight() ?? '';
    weight = UserPreferences.getWeight() ?? '';

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Personal Information")),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              const SizedBox(height: 32),
              buildName(),
              const SizedBox(height: 12),
              buildAge(),
              const SizedBox(height: 12),
              buildGender(),
              const SizedBox(height: 32),
              buildHeight(),
              const SizedBox(height: 32),
              buildWeight(),
              const SizedBox(height: 32),
              buildButton(),
            ],
          ),
        ),
      );

  Widget buildName() => buildTitle(
        title: 'Name',
        child: TextFormField(
          initialValue: name,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Name',
          ),
          onChanged: (name) => setState(() => this.name = name),
        ),
      );

  Widget buildAge() => buildTitle(
        title: 'Age',
        child: TextFormField(
          initialValue: age,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Age',
          ),
          onChanged: (age) => setState(
            () => this.age = age,
          ),
        ),
      );

  Widget buildGender() => buildTitle(
        title: 'Contact Number',
        child: TextFormField(
          initialValue: gender,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Gender: Male/Female',
          ),
          onChanged: (gender) => setState(
            () => this.gender = gender,
          ),
        ),
      );

  Widget buildHeight() => buildTitle(
        title: 'Height',
        child: TextFormField(
          initialValue: height,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Height in cm',
          ),
          onChanged: (height) => setState(
            () => this.height = height,
          ),
        ),
      );

  Widget buildWeight() => buildTitle(
        title: 'Weight',
        child: TextFormField(
          initialValue: weight,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Weight in kg',
          ),
          onChanged: (weight) => setState(
            () => this.weight = weight,
          ),
        ),
      );

  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await UserPreferences.setName(name);
        await UserPreferences.setAge(age);
        await UserPreferences.setGender(gender);
        await UserPreferences.setHeight(height);
        await UserPreferences.setWeight(weight);
      });

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}