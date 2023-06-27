import 'package:flutter/material.dart';
import 'database_helper.dart';

void showExportDialog(BuildContext context) {
    String email_add = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Export Format', style: TextStyle(color: Colors.white)),
            content: Text(
              'Choose the export format.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 39, 39, 39),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Handle the first option - Export as CSV
                  Navigator.of(context).pop('csv');
                },
                child: Text(
                  'Export as CSV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('xls');
                },
                child: Text(
                  'Export as XLS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_csv');
                },
                child: Text(
                  'Export to email as CSV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the second option - Export as XLS
                  Navigator.of(context).pop('email_xls');
                },
                child: Text(
                  'Export to email as XLS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    ).then((selectedOption) {
      if (selectedOption != null) {
        // Handle the selected option here
        if (selectedOption == 'csv') {
          // Export as CSV
          DatabaseHelper.instance.exportDataAsCSV(false, email_add);
        } else if (selectedOption == 'xls') {
          // Export as XLS
          DatabaseHelper.instance.exportDataAsXLS(false, email_add);
        } else if (selectedOption == 'email_csv') {
          // Email as CSV
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Enter your email',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Export',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsCSV(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              );
            },
          );
        } else if (selectedOption == "email_xls") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Enter your email',
                  style: TextStyle(color: Colors.white),
                ),
                content: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    email_add = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Export',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      DatabaseHelper.instance.exportDataAsXLS(true, email_add);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
              );
            },
          );
        }
      }
    });
  }



  