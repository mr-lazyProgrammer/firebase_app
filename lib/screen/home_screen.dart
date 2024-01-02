import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/model/post_model.dart';
import 'package:firebase_app/screen/add_post.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot<PostModel>> _postDoc = FirebaseFirestore.instance
      .collection('post')
      .withConverter(
      fromFirestore: (snapshot, _) => PostModel.formMap(snapshot.data()!),
      toFirestore: (postModel, _) => postModel.toMap())
      .orderBy('time', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Home Screen',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 20,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        backgroundColor: Colors.white,
        elevation: 20,
        child: const Icon(
          Icons.post_add,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<PostModel>>(
        stream: _postDoc,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<PostModel>>? _postList = snapshot.data
                ?.docs;
            if (_postList != null) {
              return ListView.builder(
                  itemCount: _postList.length,
                  itemBuilder: (context, position) {
                    QueryDocumentSnapshot<
                        PostModel> docsList = _postList[position];
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Card(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                ),child: const Icon(Icons.flutter_dash,size: 50,)),
                                const SizedBox(width: 10,),
                                 Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(docsList.data().title ?? 'No Data',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    const Text('Suggested for you . 18h')
                                  ],
                                )
                              ],),
                              const SizedBox(height: 8,),
                              Text(docsList.data().description ?? ' No Data',style: const TextStyle(fontSize: 15),),
                              const SizedBox(height: 8,),
                              (docsList.data().image != null) ? Image.network(docsList.data().image!) : const Icon(Icons.error,size: 100,)
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text('Empty Data'),);
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something Wrong'));
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
