import 'package:flutter/material.dart';
import 'package:max_heart_reader/user_preferences.dart';
import 'package:max_heart_reader/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDataFromPreferences();
  }

  Future<void> loadDataFromPreferences() async {
    name = UserPreferences.getName() ?? '';
    age = UserPreferences.getAge() ?? '';
    gender = UserPreferences.getGender() ?? '';
    height = UserPreferences.getHeight() ?? '';
    weight = UserPreferences.getWeight() ?? '';

    nameController.text = name;
    ageController.text = age;
    heightController.text = height;
    weightController.text = weight;

    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
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
          controller: nameController,
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
          controller: ageController,
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
          value: gender.isEmpty ? null : gender,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: gender.isEmpty ? 'Select Gender' : '',
          ),
          items: <DropdownMenuItem<String>>[
            if (gender.isEmpty)
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
              gender = newValue ?? '';
            });
          },
        ),
      );

  Widget buildHeight() => buildTitle(
        title: 'Height (cm)',
        child: TextFormField(
          controller: heightController,
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
          controller: weightController,
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
          name = nameController.text;
          age = ageController.text;
          height = heightController.text;
          weight = weightController.text;

          await UserPreferences.setName(name);
          await UserPreferences.setAge(age);
          await UserPreferences.setGender(gender);
          await UserPreferences.setHeight(height);
          await UserPreferences.setWeight(weight);

          // Update TextEditingControllers after saving the data
          nameController.text = name;
          ageController.text = age;
          heightController.text = height;
          weightController.text = weight;

          // Call this after we're sure all data is saved.
          await loadDataFromPreferences();

          Fluttertoast.showToast(
            msg: "Data saved successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      );

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
