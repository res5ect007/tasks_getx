import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasks_getx/views/widgets/gradient_text.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/task_controller.dart';
import '../widgets/bottom_logo.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userName = '';
  final TaskController taskController = Get.put(TaskController());
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  static final GetStorage box = GetStorage();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    loginController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
      _userName = await box.read('userName') ?? '';
      userNameController.text = _userName.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundSignIn(),
        child: Form(
          key: formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  const Header(),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            labelText: 'login'.tr,
                            suffixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              //Get.snackbar('Oшибка', 'не верное имя пользователя');
                              return 'login_error'.tr;
                            }
                            return null;
                          },),
                        const SizedBox(height: 15),
                        Obx(() {
                          return TextFormField(
                              controller: passwordController,
                              obscureText: loginController.passwordVisible.value,
                              decoration: InputDecoration(
                                labelText: 'password'.tr,
                                suffixIcon: IconButton(icon: loginController.passwordVisible.value
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () => loginController.passwordVisible.toggle(),
                                ),
                              ));
                        }),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('enter'.tr,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
                        GestureDetector(
                          onTap: () async {
                            final isValid = formKey.currentState!.validate();
                            if (isValid) {
                              await box.write('userName', userNameController.text.trim());
                              await box.write('password', passwordController.text.trim());
                              taskController.fetchTasks();
                              Get.toNamed('/home');
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blue[600],
                            radius: 30,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.lightBlue,
                    highlightColor: Colors.indigoAccent,
                    child: const Bottom(),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 3,
      child: Container(
        width: Get.width * 0.8,
        alignment: Alignment.bottomLeft,
        child: 
        AnimatedOpacity(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          opacity: 1,
          child: GradientText(
            fontFamily: 'Staatliches',
            fontSize: 70.0,
            text: 'Adamax\nTasks'),
        ),
      ),
    );
  }
}

class BackgroundSignIn extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    //Used theme background
    // Path mainBackground = Path();
    // mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    // paint.color = Colors.white;
    // canvas.drawPath(mainBackground, paint);

    // blue
    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.65, sw * 0.2, sh * 0.4);
    blueWave.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(blueWave, paint);

    // grey
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(sw * 0.75, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.55, sw * 0.2, sh * 0.45, 0, sh * 0.45);
    greyWave.close();

    paint.color = Colors.grey.shade700;
    canvas.drawPath(greyWave, paint);

    // orange
    Path orangeWave = Path();
    orangeWave.lineTo(sw * 0.9, 0);
    orangeWave.cubicTo(sw * 0.7, sh * 0.1, sw * 0.3, sh * 0.01, sw * 0.27, sh * 0.12);
    orangeWave.quadraticBezierTo(sw * 0.22, sh * 0.3, 0, sh * 0.3);
    orangeWave.close();

    paint.color = Colors.orange.shade500;
    canvas.drawPath(orangeWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}