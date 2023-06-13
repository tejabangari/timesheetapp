// import 'dart:html';
import 'dart:io';

import 'package:employee_timesheet/screens/login_page.dart';
import 'package:employee_timesheet/screens/upload_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({super.key, required this.user});
  final User user;

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  final _detailsFormKey = GlobalKey<FormState>();
  final List<String> _Gender = ['male', 'Female', 'Other'];
  final List<String> _Department = ['Development', 'Management', 'CXO Team'];
  final _nameTextController = TextEditingController();
  final _ageController = TextEditingController();
  final _departmentController = TextEditingController();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _load = false;
  String? _imageUrl;

  var _selectGender;
  var _selectDepartment;

  @override
  void initState() {
    getProfileDetails();
    _uploadImage();
  
    super.initState();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      //  var pickedFile;
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final data = await storageRef.getData();

      setState(() {
        _imageUrl = downloadUrl;
      });
    }
  }

  void getProfileDetails() async {
    CollectionReference ProfileDetails =
        FirebaseFirestore.instance.collection('profileDetails');
    final result = await ProfileDetails.doc(widget.user.uid).get();
    if (result.data() != null) {
      Map<String, dynamic> details = result.data() as Map<String, dynamic>;
      _nameTextController.text = details['name'];
      _ageController.text = details['age'].toString();
      _selectGender = details['gender'];
      _selectDepartment = details['department'];
      _imageUrl = details['imageLink'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Employee Profile'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: _detailsFormKey,
                    child: Column(
                      children: <Widget>[
                        // CircleAvatar(
                        //   radius: 70,

                        //   backgroundImage: AssetImage(
                        //     'assets/employee image.png',
                        //   ),
                        // ),
                        // Positioned( bottom: 1,right: 2,
                        //     child: Container(
                        //   decoration: BoxDecoration(
                        //       border: Border.all(width: 3),
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(50))),
                        //   child: Padding(
                        //     padding: EdgeInsets.all(2),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => UploadImage()),
                        //         );
                        //       },
                        //       child: Icon(Icons.camera,),
                        //     ),
                        //   ),
                        // )),

                        // ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => UploadImage()),
                        //       );
                        //     },
                        //     child: Text('Upload Image')),

                        // Image.asset('assets/employee image.png',
                        //  width: 100,
                        // height: 100,
                        // ),

                        profileImage(() {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheet());
                        }),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          controller: _nameTextController,
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                )),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Age',
                              errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  )),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter name';
                              }
                              return null;
                            }),
                        const SizedBox(height: 15.0),
                        FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                hintText: 'Gender',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                            child: DropdownButton(
                              hint: const Text('Gender '),
                              value: _selectGender,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectGender = newValue;
                                });
                              },
                              items: _Gender.map((location) {
                                return DropdownMenuItem(
                                  child: Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          );
                        }),
                        const SizedBox(height: 15.0),
                        FormField<String>(
                            builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                hintText: 'Department',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18.0))),
                            child: DropdownButton(
                              hint: const Text('Department'),
                              value: _selectDepartment,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectDepartment = newValue;
                                });
                              },
                              items: _Department.map((location) {
                                return DropdownMenuItem(
                                  child: Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          );
                        }),
                        const SizedBox(height: 15.0),
                        Row(
                          // Column(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_detailsFormKey.currentState!
                                        .validate()) {
                                      User? user = await FirebaseAuth
                                          .instance.currentUser;
                                      DocumentReference ref = FirebaseFirestore
                                          .instance
                                          .collection('profileDetails')
                                          .doc(user!.uid);
                                      await ref.set({
                                        'name': _nameTextController.text,
                                        'age': int.parse(_ageController.text),
                                        'gender': _selectGender,
                                        'department': _selectDepartment,
                                        'uid': user.uid,
                                        'imageLink': _imageUrl,
                                      });
                                      print(ref);
                                    }
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 61, 47, 47)),
                                  )),
                              //   SizedBox(height: 15.0),
                              // ElevatedButton(onPressed: () {  },
                              //  child: Text('Save and Exit',
                              //   style: TextStyle(
                              //         color: Color.fromARGB(255, 61, 47, 47)),

                              //  ))
                            ),
                          ],
                          // )
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }

  profileImage(onPressed) {
    return Stack(
      children: [
        _imageUrl == null || _imageUrl!.isEmpty
            ? (_imageFile == null
                ? const CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage(
                      "assets/employee image.png",
                    ))
                : CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey.shade200,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          FileImage(File(_imageFile!.path) as File),
                    ),
                  ))
            : CircleAvatar(
                radius: 75, backgroundImage: NetworkImage(_imageUrl!)),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: onPressed,
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0),
                onPressed: () async {
                  takePhoto(ImageSource.camera);
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Reference ref = FirebaseStorage.instance.ref();
                  Reference refDirImages = ref.child('profileImages');
                  Reference refImageToUpload =
                      refDirImages.child(uniqueFileName);
                  try {
                    await refImageToUpload.putFile(File(_imageFile!.path));
                    _imageUrl = await refImageToUpload.getDownloadURL();
                  } catch (error) {
                    error.toString();
                  }
                },
                icon: const Icon(Icons.camera, size: 45),
                label: const Text("Camera"),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image, size: 45),
                  label: const Text("Gallery")),
            ],
          )
        ],
      ),
      ),
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile!;
      _load = false;
    });
  }
}
