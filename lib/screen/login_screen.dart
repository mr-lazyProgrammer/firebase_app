import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vController = TextEditingController();
  bool _codeSend = false;
  bool _loading = false;
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (_codeSend)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text(
                    'Login With Phone Number',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: _vController,
                    decoration: const InputDecoration(
                        hintText: 'Enter OTP Code',
                        labelText: 'Enter OTP Code',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_vController.text.length > 4) {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId!,
                                  smsCode: _vController.text);
                          FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) => null)
                              .catchError((e) => null);
                        }
                      },
                      child: const Text('Verification OTP')),
                  (_loading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox()
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text(
                    'Login With Phone Number',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'Enter Phone Number',
                        labelText: 'Enter Phone Number',
                        prefix: Text('+959'),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_phoneController.text.length > 5 &&
                            _phoneController.text.length <= 9) {
                          setState(() {
                            _loading = true;
                          });
                          FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+959${_phoneController.text}',
                              verificationCompleted: (complete) {},
                              verificationFailed: (exception) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed')));
                                setState(() {
                                  _loading = false;
                                });
                              },
                              codeSent: (s, i) {
                                setState(() {
                                  verificationId = s;
                                  _codeSend = true;
                                  _loading = false;
                                });
                              },
                              codeAutoRetrievalTimeout: (str) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Time Out')));
                              });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: (_phoneController.text.length > 9)
                                  ? const Text('Your Phone Number is Wrong')
                                  : const Text(
                                      'Please Enter Your Phone Number')));
                        }
                      },
                      child: const Text('Get OTP')),
                  (_loading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox()
                ],
              ),
      ),
    );
  }
}
