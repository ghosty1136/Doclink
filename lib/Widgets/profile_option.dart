import 'package:flutter/material.dart';

class ProfileOptions extends StatefulWidget {
  final IconData icon;
  final String Name;
  final String subtitle;
  const ProfileOptions({super.key, required this.icon, required this.Name, required this.subtitle});

  @override
  State<ProfileOptions> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends State<ProfileOptions> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 12,left: 20,right: 20),
      child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey.shade500,
                width: 1,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: Row(
              children: [
                Icon (widget.icon,size: 22,color: Colors.grey.shade800,),
                SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.Name,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontFamily: 'Ubuntu',
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
