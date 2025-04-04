import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple, // Header background color set to purple
        ),
      ),
      home: SurveyForm(),
    );
  }
}

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  bool _isGraduating = false;
  double _classesSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Sample',
          style: TextStyle(color: Colors.white), // Text color set to white
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name:',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name:',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isGraduating,
                    onChanged: (value) {
                      setState(() {
                        _isGraduating = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'I am graduating this semester.',
                  ),
                ],
              ),
              Visibility(
                visible: !_isGraduating,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How many classes are you planning to take next semester?'),
                    Slider(
                      value: _classesSliderValue,
                      min: 0,
                      max: 8,
                      divisions: 8,
                      onChanged: (value) {
                        setState(() {
                          _classesSliderValue = value;
                        });
                      },
                      label: _classesSliderValue.round().toString(),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _isGraduating,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    if (!_isGraduating) {
                      // Navigate to ResultScreen if not graduating
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            userName: '$firstName $lastName',
                            numberOfCourses: _classesSliderValue.round(),
                            isGraduating: _isGraduating,
                          ),
                        ),
                      );
                    } else {
                      // Show SnackBar if graduating
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Thanks for submitting the survey!',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String userName;
  final int numberOfCourses;
  final bool isGraduating;

  ResultScreen({
    required this.userName,
    required this.numberOfCourses,
    required this.isGraduating,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    if (numberOfCourses == 0) {
      message = 'Good luck with your semester off, $userName!';
    } else if (numberOfCourses == 1) {
      message = 'Good luck with your course, $userName!';
    } else {
      message = 'Good luck with your $numberOfCourses courses, $userName!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Message', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen (form)
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
