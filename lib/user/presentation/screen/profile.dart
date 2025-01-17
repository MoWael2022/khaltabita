
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khaltabita/user/presentation/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../core/global_resources/color_manager.dart';
import '../component/dialogs_component.dart';
import '../controller/app_cubit.dart';
import '../controller/app_state.dart';
import '../controller/auth_cubit/auth_cubit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Future<String>>? data ;


  Future<String> getFirstName()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstName") as String;
  }
  Future<String> getLastName()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastName") as String;
  }
  Future<String> getEmail()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("email") as String);
    return prefs.getString("email") as String;
  }
  // Future<String> getName()async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("firstName") as String;
  // }


  @override
  void initState() {
    String fName,email,lName;
    print(BlocProvider.of<AuthCubit>(context).isAdmin);

    getFirstName().then((value) => fName = value);
    getEmail().then((value) => email = value);
    getLastName().then((value) => lName = value);
    data=[getFirstName(),getLastName(),getEmail()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit,AppState>(
      listener: (context , state) {
        if(state is ConnectivityLoading){
          Dialogs.loadingAwesomeDialog(context);
        }else if (state is ConnectivityFailure){
          Dialogs.errorAwesomeDialog(context, state.message.toString());
        }else if(state is ConnectivitySuccess){
          Dialogs.successAwesomeDialog(context);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.h),
          child: AppBar(
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [

                Container(
                  //height: 35.h,
                  decoration:const BoxDecoration(
                    color: Color(0xFF964F24),
                    borderRadius:  BorderRadius.only(
                      bottomRight: Radius.circular(170),
                      bottomLeft: Radius.circular(170),
                    ),

                  ),
                ),
                Positioned(
                  top: 15.h,
                  child:const CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/book test.png'),

                  )
                ),
                Center(
                  child:  Text(
                    'Profile',
                    style: TextStyle(color: Colors.white,fontSize: 7.w),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding:  EdgeInsets.only(right: 10.w ,left: 10.w),
            child: Stack(
              children: [
                Container(
                  height: 47.h,
                  padding: const EdgeInsets.all(35.0),
                  alignment: Alignment.bottomCenter,
                  //margin: const EdgeInsets.symmetric(vertical: 175.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 192, 168),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: FutureBuilder<List<String?>>(
                    future: Future.wait(data!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/test.png"),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(color: ColorManager.white, fontSize: 4.w),
                            ),
                          ],
                        );
                      }else if (snapshot.hasError) {
                        return Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/test.png"),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "Error",
                              style: TextStyle(color: ColorManager.white, fontSize: 4.w),
                            ),
                          ],
                        );
                      }else{
                        return Column(
                          children: [

                            ProfileInfoRow(
                              label: 'Name',
                              value: "${snapshot.data![0]!} ${snapshot.data![1]!}",
                            ),
                            const SizedBox(height: 20),
                            ProfileInfoRow(
                              label: 'Email',
                              value: snapshot.data![2]!,
                            ),
                            const SizedBox(height: 20),
                            const ProfileInfoRow(
                              label: 'Phone Number',
                              value: '122334454',
                            ),
                            const SizedBox(height: 20),


                          ],
                        );
                      }

                    }
                  ),
                ),
                Positioned(
                  bottom: 2.h,
                  right: 5.w,
                  child: Padding(
                  padding:  EdgeInsets.only(left: 50.w,top: 3.h),
                  child: ClipOval(
                    child: FloatingActionButton(
                      onPressed: () {

                      },
                      backgroundColor: const Color(0xFFB97F5A),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HalfCircleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;
  final Widget? leading;

  const HalfCircleAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HalfCircleAppBarPainter(backgroundColor),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: preferredSize.height,
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(child: Center(child: title)),
            const SizedBox(width: kToolbarHeight),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HalfCircleAppBarPainter extends CustomPainter {
  final Color color;

  HalfCircleAppBarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    double circleCenterX = size.width * 0.5;
    double circleCenterY = size.height * (-0.9);
    double radius = size.width * 0.7;

    canvas.drawCircle(Offset(circleCenterX, circleCenterY), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.color = const Color(0xFF5C3E2B),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }
}

class EditableProfileInfoRow extends StatefulWidget {
  final String label;
  final String initialValue;
  final Color color;
  final void Function(String) onChanged;

  const EditableProfileInfoRow({
    super.key,
    required this.label,
    required this.initialValue,
    this.color = const Color(0xFF5C3E2B),
    required this.onChanged,
  });

  @override
  _EditableProfileInfoRowState createState() => _EditableProfileInfoRowState();
}

class _EditableProfileInfoRowState extends State<EditableProfileInfoRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _controller,
          style: TextStyle(
            fontSize: 15,
            color: widget.color,
          ),
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
// PreferredSize(
// preferredSize: const Size.fromHeight(kToolbarHeight),
// child: HalfCircleAppBar(
// title: const Text(
// 'Profile',
// style: TextStyle(color: Colors.white),
// ),
// backgroundColor: const Color(0xFF964F24),
// leading: IconButton(
// icon: const Icon(
// Icons.chevron_left,
// color: Colors.white,
// ),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ),
// ),