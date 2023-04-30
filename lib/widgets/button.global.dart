import 'package:chatgpt_course/utils/global.colors.dart';
import 'package:flutter/material.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Login');
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


// class ButtonGlobal extends StatelessWidget (
//   const ButtonGlobal 1((Key? key1) : super(key: key);
//   @override
//   Widget build(BuildContext context)
//     return InkWell
//        onTap: ()
//         print('Login');
//        child: Container(
//          alignment: Alignment.center,
//          height: 55,
//          decoration: BoxDecoration(
//            color: GlobalColors.mainColor,
//            borderRadius: BorderRadius.circular(6),
//            boxShadow: [
//              BoxShadow(
//                color:
//                         Colors.black.withOpacity(0.1),
//                blurRadius: 10,
//                    BoxShadow
//            J.
//             // BoxDecoration
//          child: const Text(
//            'Sign In',
//            style: TextStyle(
//              color:
//                       Colors.white,
