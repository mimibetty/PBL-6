import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  void _resetForm() {
    setState(() {
      currentPassword = '';
      newPassword = '';
      confirmPassword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        // color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 54.0),
                _buildPasswordInput(
                    'Current Password', (value) => currentPassword = value),
                SizedBox(height: 16.0),
                _buildPasswordInput(
                    'New Password', (value) => newPassword = value),
                SizedBox(height: 16.0),
                _buildPasswordInput(
                    'Confirm New Password', (value) => confirmPassword = value),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildElevatedButton('Reset', _resetForm),
                    SizedBox(width: 16),
                    _buildElevatedButton('Update', () {
                      if (_formKey.currentState!.validate()) {
                        // Xử lý thay đổi mật khẩu
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordInput(String label, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        obscureText: true, // Ẩn mật khẩu
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == 'Confirm New Password' && value != newPassword) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}
