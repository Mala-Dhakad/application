import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/filename.dart';
import 'package:myfirstapp/hometaskscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginExample extends StatefulWidget {
  const LoginExample({super.key});

  @override
  State<LoginExample> createState() => _LoginExampleState();
}

class _LoginExampleState extends State<LoginExample> {
  final TextEditingController _emailController =
  TextEditingController(text: 'eve.holt@reqres.in');
  final TextEditingController _passwordController =
  TextEditingController(text: 'pistol');

  final Dio dio = Dio();
  bool _isLoading = false; // Loading state variable

  void _login() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await dio.post(
        "https://reqres.in/api/login",
        data: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await SharedPreferences.getInstance();

        setState(() {

          pref.setString("loginStatus", "1");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardClass()),
          );

          //  print("---sign in-----" +data.toString());
        });

        // If login successful, navigate to the next screen
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: ${response.data['error']}'),
        ));
      }
    } catch (e) {
      // Handle any errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again.'),
      ));
    } finally {
      // End loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(color: Colors.purpleAccent),
          Center(
            child: Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Image(
                    image: AssetImage("assets/login.png"),
                    width: 400,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.black)),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email ID",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: Text("Forget password?",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue)),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Conditional rendering for the button/loading indicator
                    _isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : ElevatedButton(
                      onPressed: _login, // Call the _login function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: Container(
                        width: 300,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text("Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text("OR", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30, left: 30, right: 30),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Login with Google',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding:
                              const EdgeInsets.only(left: 60, right: 30),
                              child: Image.asset('assets/google.png',
                                  width: 50, height: 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("your login?"),
                          Text(" Register",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
