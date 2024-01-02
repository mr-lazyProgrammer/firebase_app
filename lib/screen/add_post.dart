import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/image_service/image_service.dart';
import 'package:firebase_app/model/post_model.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final CollectionReference<PostModel> _collectionReference =
      FirebaseFirestore.instance.collection("post").withConverter(
          fromFirestore: (snapshot, _) => PostModel.formMap(snapshot.data()!),
          toFirestore: (postModel, _) => postModel.toMap());
  File? profile;
  String? url;
  bool _loading = false;
  bool _error = false;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Post Title',
                  hintText: 'Enter Post Title',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                maxLines: 5,
                controller: _description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Post Description',
                  hintText: 'Enter Post Description',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          onPressed: _uploadPost,
                          child: const Text('Upload Post'))),
                  Expanded(
                      child: IconButton(
                          onPressed: () async {
                            File? image = await chooseImage();
                            if (image != null) {
                              setState(() {
                                profile = image;
                              });
                            }
                          },
                          icon: const Icon(Icons.image))),
                ],
              ),
              const SizedBox(height: 40,),
              (profile != null) ? (url != 'error') ? Image.file(profile!,height: 300,) : const Icon(Icons.error,size: 50,) : const SizedBox(),
              (_loading) ? const Center(child: CircularProgressIndicator(),) : const SizedBox(),
              (_success) ? const Center(child: Text('Post Upload Success'),) : const SizedBox(),
              (_error) ? const Center(child: Text('Post Upload Error'),) : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPost() async {
    setState(() {
      _loading = true;
      _error = false;
      _success = false;
    });
    if (profile != null) {
      url = await uploadImage(profile!).catchError((e) => 'error');
    }
    _collectionReference
        .add(PostModel(_title.text, _description.text, url,
            DateTime.now().microsecondsSinceEpoch))
        .then((value) {
      setState(() {
        _success = true;
        _error = false;
        _loading = false;
      });
    }).catchError((e) {
      _error = true;
      _loading = false;
      _success = false;
    }).whenComplete(() {
      setState(() {
        _title.text = '';
        _description.text = '';
        url = '';
      });
    });
  }
}
