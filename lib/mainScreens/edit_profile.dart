import 'dart:io';
import 'package:canteen_management_user/global/global.dart';
import 'package:canteen_management_user/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _usernameController;
  TextEditingController? _emailController;
  File? _imageFile;
  String? _currentProfilePhotoUrl;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users')
        .child('$userId.jpg');

    final metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
    );

    final uploadTask = ref.putFile(_imageFile!, metadata);
    final snapshot = await uploadTask.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userData.exists) {
      final data = userData.data();
      _usernameController?.text = data?['name'];
      _emailController?.text = data?['email'];
      _currentProfilePhotoUrl = data?['photoUrl'];
    }
  }

  void _saveChanges() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final name = _usernameController?.text;
    final email = _emailController?.text;

    if (name!.isEmpty || email!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      String? photoUrl=_currentProfilePhotoUrl;
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("email", _emailController!.text);
      await sharedPreferences!.setString("name",_usernameController!.text );
      await sharedPreferences!.setString("photoUrl", _currentProfilePhotoUrl!);


      if (_imageFile != null) {
        photoUrl = await _uploadImage();
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Updated'),
            content: Text('Your profile has been successfully updated.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update profile.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectImage,
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : null,
                child: _imageFile == null
                    ? CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      sharedPreferences!.getString("photoUrl")!),
                )
                    : null,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
