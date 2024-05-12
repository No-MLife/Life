import 'package:flutter/material.dart';

class JobDropdown extends StatelessWidget {
  final String selectedJob;
  final List<String> jobOptions;
  final Function(String?) onChanged;

  JobDropdown({
    required this.selectedJob,
    required this.jobOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedJob.isNotEmpty ? selectedJob : null,
      items: jobOptions.map((job) {
        return DropdownMenuItem(
          value: job,
          child: Text(job),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '직업',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
      ),
    );
  }
}

class CareerDropdown extends StatelessWidget {
  final String selectedCareer;
  final List<String> careerOptions;
  final Function(String?) onChanged;

  CareerDropdown({
    required this.selectedCareer,
    required this.careerOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedCareer.isNotEmpty ? selectedCareer : null,
      items: careerOptions.map((career) {
        return DropdownMenuItem(
          value: career,
          child: Text(career),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '경력',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
      ),
    );
  }
}