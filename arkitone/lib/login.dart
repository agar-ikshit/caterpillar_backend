import 'package:flutter/material.dart';

class AuthPages extends StatefulWidget {
  @override
  _AuthPagesState createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          // Parallax background
          AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -100 * _currentPage),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[900]!, Colors.yellow[600]!],
                    ),
                  ),
                ),
              );
            },
          ),
          // PageView
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              LoginScreen(currentPage: _currentPage),
              SignUpScreen(currentPage: _currentPage),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final double currentPage;

  LoginScreen({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 430 - (currentPage * 50),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(150),
                bottomLeft: Radius.circular(150),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 50, left: 15, bottom: 5),
                  child: Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 15, bottom: 5),
                  child: Text(
                    'HOMELAND',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 15, bottom: 25),
                  child: Text(
                    'Please Login to Continue',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                Login_TextField(
                  text: 'Email/Username',
                  backGround: Colors.yellow,
                  color: Colors.yellow,
                ),
                Login_TextField(
                  text: '************',
                  backGround: Colors.yellow,
                  color: Colors.yellow,
                ),
                Login_Button(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'FORGOT PASSWORD ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Swipe up to Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final double currentPage;

  SignUpScreen({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedOpacity(
        opacity: currentPage,
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Swipe down to Login',
                    style: TextStyle(
                      color: Colors.yellow[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 450 + (currentPage * 50),
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(150 * currentPage),
                  topLeft: Radius.circular(150 * currentPage),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      'HOMELAND',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 15, bottom: 25),
                    child: Text(
                      'Please Sign Up to Continue',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Login_TextField(
                    text: 'Enter Email/Username',
                    backGround: Colors.black12,
                    color: Colors.black45,
                  ),
                  Login_TextField(
                    text: 'Password',
                    backGround: Colors.black12,
                    color: Colors.black45,
                  ),
                  Login_TextField(
                    text: 'Re-Enter Password',
                    backGround: Colors.black12,
                    color: Colors.black45,
                  ),
                  SignUp_Button(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Login_Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 5,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: double.infinity,
          //height: 45,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            elevation: 15,
            shadowColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: () {},
          child: Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 16,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
class Login_TextField extends StatelessWidget {
  final String text;
  final Color backGround;
  final Color color;

   Login_TextField({required this.text,required this.backGround,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backGround,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class SignUp_Button extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
        left: 30,
        top: 15,
        bottom: 5
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: double.infinity,
          //height: 45,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[600],
            shadowColor: Colors.yellow[600],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: (){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: Text(
            'SIGN UP',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow[600],
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 50, left: 15),
                    child: Text(
                      'Existing User ?',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Login_Button(),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 177,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 85, left: 15),
                          child: Text(
                            'Sign Up With',
                            style: TextStyle(
                              color: Colors.yellow[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 5, left: 15),
                          child: Text(
                            'HOMELAND',
                            style: TextStyle(
                                color: Colors.yellow[600],
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Login_TextField(
                          text: 'Enter Email/Username',
                          backGround: Colors.white12,
                          color: Color(0xFF4C4939),
                        ),
                        Login_TextField(
                          text: 'Password',
                          backGround: Colors.white12,
                          color: Color(0xFF4C4939),
                        ),
                        Login_TextField(
                          text: 'Re-Enter Password',
                          backGround: Colors.white12,
                          color: Color(0xFF4C4939),
                        ),
                        SignUp_Button(),
                        SizedBox(height: 5),
                        Text(
                          'Or Signup with',
                          style: TextStyle(
                              color: Colors.yellow[600],
                              fontSize: 16,
                              ),
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              child: Text(
                                'f',
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.yellow[600],
                            ),
                            SizedBox(width: 25),
                            CircleAvatar(
                              radius: 15,

                              child: Text(
                                'G',
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.yellow[600],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
