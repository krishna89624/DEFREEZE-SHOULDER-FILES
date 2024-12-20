import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart'; // Import the file_picker package
import 'config.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<List<String>> _csvData = [];
  TextEditingController _fileNameController = TextEditingController();

  // Function to fetch CSV data from the server
  Future<void> fetchCsvData() async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/download.php'));

    if (response.statusCode == 200) {
      // Convert the CSV string to a List of Lists (rows and columns)
      final data = response.body;
      List<List<String>> parsedData = parseCsv(data);
      setState(() {
        _csvData = parsedData;
      });
    } else {
      // Handle errors
      print('Failed to load CSV');
    }
  }

  // Function to parse the CSV string into a List of Lists (rows and columns)
  List<List<String>> parseCsv(String data) {
    List<List<String>> rows = [];
    List<String> lines = LineSplitter.split(data).toList();

    for (var line in lines) {
      rows.add(line.split(',').map((e) => e.trim()).toList());
    }

    return rows;
  }

  // Function to request permission and save CSV to the selected folder
  Future<void> saveCsvToFile() async {
    // Request storage permissions for Android 10+
    var status = await Permission.storage.request();

    // For Android 11 and above, request additional permission
    if (status.isGranted || await Permission.manageExternalStorage.request().isGranted||true) {
      if (_csvData.isNotEmpty) {
        // Use File Picker to open folder selection dialog
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory != null) {
          // Ask the user to input a file name after selecting the folder
          String? fileName = await _showFileNameDialog();

          if (fileName != null && fileName.isNotEmpty) {
            // Convert the CSV data to a string
            String csvContent = _csvData.map((row) => row.join(',')).join('\n');

            // Define the file path for CSV in the selected directory with the user-provided name
            final file = File('$selectedDirectory/$fileName.csv');

            // Write the CSV content to the file
            await file.writeAsString(csvContent);

            // Notify the user that the file has been saved
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('CSV file saved to ${file.path}')),
            );
          } else {
            // Handle case when user doesn't provide a name
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No file name provided.')),
            );
          }
        } else {
          // Handle case when the user cancels the folder selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No folder selected.')),
          );
        }
      }
    } else {
      // Handle permission denial
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied! Unable to save CSV file.')),
      );
    }
  }

  // Function to show a dialog for the user to input the file name
  Future<String?> _showFileNameDialog() async {
    String? fileName = '';
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter File Name'),
          content: TextField(
            onChanged: (value) {
              fileName = value;
            },
            decoration: InputDecoration(hintText: "Enter file name here"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(fileName);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel the operation
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCsvData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Data'),
        backgroundColor: Color(0xFF2DC2D7), // Set the app bar color
      ),
      body: _csvData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Display the CSV data in a DataTable for a better presentation
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20.0, // Add space between columns
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2DC2D7), // Set the button color
                  fontSize: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF2DC2D7)),
                  borderRadius: BorderRadius.circular(10),
                ),
                columns: _csvData.isNotEmpty
                    ? _csvData[0]
                    .map((col) => DataColumn(label: Text(col)))
                    .toList()
                    : [],
                rows: _csvData.isNotEmpty
                    ? _csvData
                    .sublist(1)
                    .map(
                      (row) => DataRow(
                    cells: row
                        .map((cell) => DataCell(Text(cell)))
                        .toList(),
                  ),
                )
                    .toList()
                    : [],
              ),
            ),
          ),
          // Button to save the CSV to selected folder
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: saveCsvToFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DC2D7), // Set the button color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save CSV to Selected Folder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
