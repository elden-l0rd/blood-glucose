import 'package:flutter/material.dart';
import 'package:max_heart_reader/Client/src/LandingPage/user_preferences.dart';
import 'package:max_heart_reader/Client/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../l10n/l10n.dart';
import '../../../l10n/change_language.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
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
    name = await UserPreferences.getName() ?? '';
    age = await UserPreferences.getAge() ?? '';
    gender = await UserPreferences.getGender() ?? '';
    height = await UserPreferences.getHeight() ?? '';
    weight = await UserPreferences.getWeight() ?? '';

    nameController.text = name;
    ageController.text = age;
    heightController.text = height;
    weightController.text = weight;

    setState(() {});
    debugPrint(nameController.text);
    debugPrint(name);
  }

  String get nameControllerText {
    return nameController.text;
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
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(top: 25),
            child: Row(
              children: [
                Text(
                  L10n.translation(context).personalInformation,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: LanguageButton(),
                )),
              ],
            )),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
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
      ),
    );
  }

  Widget buildName() => buildTitle(
        title: L10n.translation(context).name,
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: L10n.translation(context).yName,
            hintStyle: TextStyle(
                color: const Color.fromARGB(255, 88, 86, 86),
                fontSize: 13), // Set hint text color to white
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: (name) => setState(() => this.name = name),
          style:
              TextStyle(color: Colors.black), // Set input text color to white
        ),
      );

  Widget buildAge() => buildTitle(
      title: L10n.translation(context).age,
      child: TextFormField(
        controller: ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: L10n.translation(context).age,
          hintStyle: TextStyle(
              color: const Color.fromARGB(255, 88, 86, 86),
              fontSize: 13), // Set hint text color to white
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (age) {
          int? parsedAge = int.tryParse(age);
          if (parsedAge != null &&
              parsedAge > 0 &&
              parsedAge < 120) {
                setState(() => this.age = parsedAge.toString());
              }
          else {
            // Auto clear the input field if entered age is invalid
            setState(() => ageController.clear());
          }
        },
        style: TextStyle(
            color: Colors.black),
      ),
    );

  Widget buildGender() => buildTitle(
        title: L10n.translation(context).gender,
        child: DropdownButtonFormField<String>(
          value: gender.isEmpty ? null : gender,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: gender.isEmpty ? L10n.translation(context).sGender : '',
            hintStyle: TextStyle(
                color: const Color.fromARGB(255, 88, 86, 86),
                fontSize: 13), // Set hint text color to white
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          items: <DropdownMenuItem<String>>[
            if (gender.isEmpty)
              DropdownMenuItem<String>(
                value: '',
                child: Text(L10n.translation(context).sGender),
              ),
            DropdownMenuItem<String>(
              value: L10n.translation(context).male,
              child: Text(L10n.translation(context).male,
                  style: TextStyle(
                      color: Colors.black)), // Set dropdown item color to white
            ),
            DropdownMenuItem<String>(
              value: L10n.translation(context).female,
              child: Text(L10n.translation(context).female,
                  style: TextStyle(
                      color: Colors.black)), // Set dropdown item color to white
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
        title: L10n.translation(context).height,
        child: TextFormField(
          controller: heightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: L10n.translation(context).height,
            hintStyle: TextStyle(
                color: const Color.fromARGB(255, 88, 86, 86),
                fontSize: 13), // Set hint text color to white
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: (height) {
            int? parsedHeight = int.tryParse(height);
            if (parsedHeight != null &&
                parsedHeight > 0 &&
                parsedHeight < 210) {
              setState(() => this.height = parsedHeight.toString());
            } else {
              // Auto clear the input field if the entered height is invalid
              setState(() => heightController.clear());
            }
          },
          style:
              TextStyle(color: Colors.black), // Set input text color to white
        ),
      );

  Widget buildWeight() => buildTitle(
        title: L10n.translation(context).weight,
        child: TextFormField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: L10n.translation(context).weight,
            hintStyle: TextStyle(
                color: const Color.fromARGB(255, 88, 86, 86),
                fontSize: 13), // Set hint text color to white
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 7),
          ),
          // onChanged: (weight) => setState(() => this.weight = weight),
          onChanged: (weight) {
            int? parsedWeight = int.tryParse(weight);
            if (parsedWeight!= null &&
                parsedWeight > 0 &&
                parsedWeight < 400) {
                  setState(() => this.weight = parsedWeight.toString());
                }
            else {
              // Auto clear input field if entered weight is invalid
              setState(() => weightController.clear());
            }
          },
          style:
              TextStyle(color: Colors.black), // Set input text color to white
        ),
      );

  Widget buildButton() => ButtonWidget(
        text: L10n.translation(context).save,
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
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white), // Set title text color to white
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
