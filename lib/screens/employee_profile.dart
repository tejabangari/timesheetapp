// import 'dart:html';
import 'dart:io';

import 'package:employee_timesheet/provider/luser_provider.dart';
import 'package:employee_timesheet/screens/home_page.dart';
import 'package:employee_timesheet/screens/login_page.dart';
import 'package:employee_timesheet/screens/time_sheet.dart';
import 'package:employee_timesheet/screens/upload_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({
    super.key,
  });
  // final User user;

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  var selectGender;
  final List<String> gender = ['Male', 'Female', 'Other'];
  var selectDepartment;
  final List<String> _department = ['Development', 'Management', 'CXO'];
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool _isProcessing = false;
  final _detailFormKey = GlobalKey<FormState>();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _load = false;
  String? _imageUrl;
  @override
  void initState() {
    Provider.of<ProviderState>(context, listen: false).getData();
    // Provider.of<UserProvider>(context,listen: false).storeData();

    super.initState();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
  }
  @override
Widget build(BuildContext context) {
  
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    },
    child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Consumer<ProviderState>(
          builder: (context, providerState, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 100, left: 30, right: 30, bottom: 550),
                child: Column(
                  children: <Widget>[
                    logoWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _detailFormKey,
                      child: Column(
                        children: <Widget>[
                          reusableTextField(
                            "Name",
                            Icons.person_outlined,
                            false,
                            false,
                            true,
                            false,
                            providerState.nameController,
                            "name",
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          reusableTextField(
                            "Age",
                            Icons.person_outlined,
                            false,
                            false,
                            false,
                            true,
                            providerState.ageController,
                            "age",
                          ),
                          const SizedBox(height: 18.0),
                          dropDown(
                            context,
                            "Gender",
                            gender,
                            Icons.person_outline,
                            providerState.selectGender,
                            (newValue) {
                              setState(() {
                                providerState.selectGender = newValue;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          dropDown(
                            context,
                            "Department",
                            _department,
                            Icons.work,
                            providerState.selectDepartment,
                            (newValue) {
                              setState(() {
                                providerState.selectDepartment = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 24.0),
                          button(context, "Save", () async {
                            await providerState.storeData(
                              providerState.nameController.text,
                              providerState.ageController.text,
                              providerState.selectGender,
                              providerState.selectDepartment,
                            );

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TimeTrackerScreen(),
                            ));
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    
                  ],
                ),
              ),
            );
          },
        ),
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

  profileImage(onPressed) {
    return Stack(
      children: [
        _imageUrl == null || _imageUrl!.isEmpty
            ? (_imageFile == null
                ? const CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage(
                      'assets/employee_image.png',
                    ))
                : CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey.shade200,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(File(_imageFile!.path)),
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
     final providerState = Provider.of<ProviderState>(context);

    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
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
    );
  }
}



 // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       FocusScope.of(context).requestFocus(FocusNode());
  //     },
  //     child: Scaffold(
  //       extendBodyBehindAppBar: true,
  //       appBar: AppBar(
  //         backgroundColor: Colors.blue,
  //         elevation: 0,
  //         title: const Text(
  //           "Profile",
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       body: Container(
  //         child: Consumer<ProviderState>(
  //           builder: (context, providerstate, child) {
  //             User? user = providerstate.user;

  //             String? name;
  //             return SingleChildScrollView(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(
  //                     top: 100, left: 30, right: 30, bottom: 550),
  //                 child: Column(
  //                   children: <Widget>[
  //                     logoWidget(),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     // profileImage(() {
  //                     //   showModalBottomSheet(
  //                     //       context: context,
  //                     //       builder: ((builder) => bottomSheet()));
  //                     // }),

  //                     const SizedBox(
  //                       height: 30,
  //                     ),

  //                     Form(
  //                       key: _detailFormKey,
  //                       child: Column(
  //                         children: <Widget>[
  //                           TextFormField(
  //                             decoration: InputDecoration(labelText: 'Name'),
  //                             validator: (input) {
  //                               if (input!.isEmpty) {
  //                                 return 'Please enter your name';
  //                               }
  //                               return null;
  //                             },
  //                             onSaved: (input) => name = input,
  //                           ),
  //                           reusableTextField(
  //                             "Full Name",
  //                             Icons.person_outlined,
  //                             false,
  //                             false,
  //                             true,
  //                             false,
  //                             providerstate.nameController,
  //                             "name",
  //                           ),
  //                           const SizedBox(
  //                             height: 16,
  //                           ),
  //                           reusableTextField(
  //                               "Age",
  //                               Icons.person_outlined,
  //                               false,
  //                               false,
  //                               false,
  //                               true,
  //                               providerstate.ageController,
  //                               "age"),
  //                           const SizedBox(height: 18.0),
  //                           dropDown(context, "Gender", gender,
  //                               Icons.person_outline, selectGender, (newValue) {
  //                             setState(() {
  //                               selectGender = newValue;
  //                             });
  //                           }),
  //                           const SizedBox(
  //                             height: 16,
  //                           ),
  //                           dropDown(context, "Department", _department,
  //                               Icons.work, selectDepartment, (newValue) {
  //                             setState(() {
  //                               selectDepartment = newValue;
  //                             });
  //                           }),
  //                           const SizedBox(height: 24.0),
  //                           button(context, "Save", () async {
  //                             Provider.of<ProviderState>(context, listen: false)
  //                                 .storeData(
  //                                     providerstate.nameController.text,
  //                                     providerstate.ageController.text,
  //                                     providerstate.selectGender,
  //                                     providerstate.selectDepartment);

  //                             Navigator.of(context).push(MaterialPageRoute(
  //                                 builder: (context) =>  TimeTrackerScreen ()));
  //                             // print(ref);
  //                             // }
  //                           }),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }


