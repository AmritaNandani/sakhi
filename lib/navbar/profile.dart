import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _isChangingPassword = false;
  bool _isPasswordVisible = false;

  TextEditingController _nameController = TextEditingController(
    text: "Priyanshu Raj",
  );
  TextEditingController _emailController = TextEditingController(
    text: "priyanshu@example.com",
  );
  TextEditingController _phoneController = TextEditingController(
    text: "+91 9876543210",
  );
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  String userType = "Citizen";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: GoogleFonts.instrumentSans(
            fontSize: screenWidth * 0.06,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          if (!_isEditing && !_isChangingPassword)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing || _isChangingPassword)
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _isChangingPassword = false;
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D84D6), Color(0xFF3A59D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: screenHeight * 0.12),
              // Avatar
              CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundColor: Colors.white,
                child: Text(
                  _nameController.text[0],
                  style: GoogleFonts.instrumentSans(
                    fontSize: screenWidth * 0.15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A59D1),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                _nameController.text,
                style: GoogleFonts.instrumentSans(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userType,
                  style: GoogleFonts.instrumentSans(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

              // Main container
              Expanded(
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.07),
                      topRight: Radius.circular(screenWidth * 0.07),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isChangingPassword)
                          Column(
                            children: [
                              _buildProfileField(
                                icon: Icons.person,
                                label: "Name",
                                controller: _nameController,
                                isEditable: _isEditing,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              _buildProfileField(
                                icon: Icons.email,
                                label: "Email",
                                controller: _emailController,
                                isEditable: _isEditing,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              _buildProfileField(
                                icon: Icons.phone,
                                label: "Phone",
                                controller: _phoneController,
                                isEditable: _isEditing,
                              ),
                            ],
                          ),
                        if (_isChangingPassword)
                          Column(
                            children: [
                              _buildPasswordField(
                                label: "Current Password",
                                controller: _currentPasswordController,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              _buildPasswordField(
                                label: "New Password",
                                controller: _newPasswordController,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF3A59D1)),
          SizedBox(width: 16),
          Expanded(
            child: isEditable
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: label,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    controller.text,
                    style: GoogleFonts.instrumentSans(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Color(0xFF3A59D1)),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF3A59D1),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ],
      ),
    );
  }
}
