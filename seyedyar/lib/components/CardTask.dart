import 'package:flutter/material.dart';

class CardTask extends StatelessWidget {
  final String title;
  final String time;

  const CardTask({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
          )
        ]),
        padding: const EdgeInsets.all(3),
        width: widthOfScreen * 0.8,
        height: heightOfScreen * 0.055,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Color.fromARGB(212, 212, 212, 1),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 26),
                    Image.asset('lib/images/tik.png', width: 24, height: 24),
                    const SizedBox(width: 16),
                    Image.asset('lib/images/delete.png', width: 24, height: 24),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
