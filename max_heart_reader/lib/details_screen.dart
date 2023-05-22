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
  String gender = 'Select Gender';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Information")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const SizedBox(height: 32),
            buildName(),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: buildAge()),
                const SizedBox(width: 16),
                Expanded(child: buildGender()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(child: buildHeight()),
                const SizedBox(width: 16),
                Expanded(child: buildWeight()),
              ],
            ),
            const SizedBox(height: 32),
            buildButton(),
          ],
        ),
      ),
    );
  }

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
          keyboardType: TextInputType.number,
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
        title: 'Gender',
        child: DropdownButtonFormField<String>(
          value: gender,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select Gender',
          ),
          items: <DropdownMenuItem<String>>[
            const DropdownMenuItem<String>(
              value: '',
              child: Text('Select Gender'),
            ),
            DropdownMenuItem<String>(
              value: 'Male',
              child: const Text('Male'),
            ),
            DropdownMenuItem<String>(
              value: 'Female',
              child: const Text('Female'),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              gender = newValue!;
            });
          },
        ),
      );

  Widget buildHeight() => buildTitle(
        title: 'Height (cm)',
        child: TextFormField(
          initialValue: height,
          keyboardType: TextInputType.number,
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
        title: 'Weight (kg)',
        child: TextFormField(
          initialValue: weight,
          keyboardType: TextInputType.number,
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
