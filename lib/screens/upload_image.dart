







// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class CameraWidget extends StatefulWidget{
//   @override
//   State createState() {
//     // TODO: implement createState
//    return CameraWidgetState();
//   }

// }

// class CameraWidgetState extends State{
//    File? _imageFile=null;
// final picker = ImagePicker();

// Future pickImage() async {
//   final pickedFile = await picker.getImage(source: ImageSource.camera);

//   setState(() {
//     _imageFile = File(pickedFile!.path);
//   });
// }


// // Future CameraWidget(BuildContext context) async{
// //    String fileName = basename(_imageFile!.path);
// //    firebase_storage.CollectionReference ProfileDetails =Fire
// // }

//    Future<void>_showChoiceDialog(BuildContext context)
//   {
//     return showDialog(context: context,builder: (BuildContext context){

//       return AlertDialog(
//         title: Text("Choose option",style: TextStyle(color: Colors.blue),),
//         content: SingleChildScrollView(
//         child: ListBody(
//           children: [
//             Divider(height: 1,color: Colors.blue,),
//             ListTile(
//               onTap: (){
//                 _openGallery(context);
//               },
//             title: Text("Gallery"),
//               leading: Icon(Icons.account_box,color: Colors.blue,),
//         ),

//             Divider(height: 1,color: Colors.blue,),
//             ListTile(
//               onTap: (){
//                 _openCamera(context);
//               },
//               title: Text("Camera"),
//               leading: Icon(Icons.camera,color: Colors.blue,),
//             ),
//           ],
//         ),
//       ),);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     return  Scaffold(
//         appBar: AppBar(
//           title: Text("Pick Image Camera"),
//           backgroundColor: Colors.green,
//         ),
//         body: Center(
//           child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Card(
//                   child:( _imageFile==null)?Text("Choose Image"): Image.file( File(  _imageFile!.path)),
//                 ),
//                 MaterialButton(
//                   textColor: Colors.white,
//                   color: Colors.red,
//                   onPressed: (){
//                     _showChoiceDialog(context);
//                   },
//                   child: Text("Select Image"),

//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//   }

//   void _openGallery(BuildContext context) async{
//     final pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery ,
//     );
//     setState(() {
//       _imageFile = File as File?;
//     });

//     Navigator.pop(context);
//   }

//   void _openCamera(BuildContext context)  async{
//       final pickedFile = await ImagePicker().getImage(
//             source: ImageSource.camera ,
//             );
//             setState(() {
//             _imageFile = File as File?;
//       });
//       Navigator.pop(context);
//   }
// }


















import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_timesheet/screens/employee_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UploadImage extends StatefulWidget {
 
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
//  late final User user;
  FirebaseStorage storage = FirebaseStorage.instance;
    User? user = FirebaseAuth.instance.currentUser;
   
  File? imageFile;
  Future<void> _upload(String inputSource)async{
    final picker = ImagePicker();
    XFile? pickedImage;
     try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

          final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              
              
            }));
             setState(() {});
} on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () => _upload('camera'),
                    icon: const Icon(Icons.camera),
                    label: const Text('camera')),
                ElevatedButton.icon(
                    onPressed: () => _upload('gallery'),
                    icon: const Icon(Icons.library_add),
                    label: const Text('Gallery')),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            leading: Image.network(image['url']),
                            title: Text(image['uploaded_by']),
                            subtitle: Text(image['description']),
                            trailing: IconButton(
                              onPressed: () => _delete(image['path']),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
            //       child: ElevatedButton(child: Text('save'),
            //       onPressed: () {
            //          Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => EmployeeProfile( user: user,)),
            // );
            //       },
            //       );

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  



































  // final picker = ImagePicker();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Upload Image',
//           ),
//         ),
//         body: Container(
//           child: imageFile == null
//               ? Container(
//                   alignment: Alignment.center,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: () {
//                           _getFromGallery();
//                         },
//                         child: Text('Select from Gallery'),
//                       ),
//                       SizedBox(height: 15.0),
//                       ElevatedButton(
//                         onPressed: () {
//                           _getFromCamera();
//                         },
//                         child: Text('Upload from Camera'),
//                       ),
//                     ],
//                   ),
//                 )
//               : Container(
//                   child: Image.file(
//                     imageFile!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//         ));
//   }

//   _getFromGallery() async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   _getFromCamera() async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.camera,
//       maxHeight: 1800,
//       maxWidth: 1800,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//       });
//     }
//   }
// }

