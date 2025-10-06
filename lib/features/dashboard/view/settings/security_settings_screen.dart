import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import '../../widgets/home_widgets/settings_widgets.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final List<String> questions = [
    'What was the name of your first pet?',
    'What is your mother\'s maiden name?',
    'What city were you born in?',
    'What was your first car?',
    'What is your favorite color?',
    'What was the name of your elementary school?',
  ];

  String? question1;
  String? question2;
  String? question3;
  String answer1 = '';
  String answer2 = '';
  String answer3 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Set up security questions'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set up security questions to help protect and recover your account',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SecurityQuestionDropdown(
                      label: 'Question 1',
                      value: question1,
                      options: questions,
                      onChanged: (value) {
                        setState(() {
                          question1 = value;
                          if (value == null) answer1 = '';
                        });
                      },
                      onAnswerChanged: (value) {
                        setState(() {
                          answer1 = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SecurityQuestionDropdown(
                      label: 'Question 2',
                      value: question2,
                      options: questions,
                      onChanged: (value) {
                        setState(() {
                          question2 = value;
                          if (value == null) answer2 = '';
                        });
                      },
                      onAnswerChanged: (value) {
                        setState(() {
                          answer2 = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SecurityQuestionDropdown(
                      label: 'Question 3',
                      value: question3,
                      options: questions,
                      onChanged: (value) {
                        setState(() {
                          question3 = value;
                          if (value == null) answer3 = '';
                        });
                      },
                      onAnswerChanged: (value) {
                        setState(() {
                          answer3 = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave() ? _saveSecurityQuestions : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSave() {
    return question1 != null &&
        question2 != null &&
        question3 != null &&
        answer1.isNotEmpty &&
        answer2.isNotEmpty &&
        answer3.isNotEmpty;
  }

  void _saveSecurityQuestions() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Security Questions Saved',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your security questions have been successfully saved and will be used for extra protection',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
