import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kodoctor/Screen/Doctor/details.dart';

class AppointmentDetails extends StatefulWidget {
  final Map DoctorsData;
  final Map AppointmentData;
  final String Data;
  final String Time;
  const AppointmentDetails({super.key, required this.DoctorsData, required this.AppointmentData, required this.Data, required this.Time});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        leading: Icon(CupertinoIcons.back,size: 22,color: Colors.black,),
        title:Text(
          'Appointment Details',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),


      body:
      SingleChildScrollView(
        child: Column(
          children: [

            //------Doctor Card---------
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 25, right: 10),
              child: Row(
                children: [
        
                  // ----Doctor DP---
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          360),
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 2,
                      )
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius
                            .circular(360),
                        child: Image.network(
                            widget.DoctorsData['DP'],
                            height: 75,
                            width: 75,
                            fit: BoxFit.fitHeight
                        )
                    ),
                  ),
        
                  SizedBox(width: 20,),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        widget.DoctorsData['Name'],
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
        
                      SizedBox(height: 4,),
        
                      Text(
                       widget.DoctorsData['Category '] ?? 'Unknown',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Redex',
                          fontSize: 15.0,
                        ),
                      ),
        
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 24,
                              color: Color(0xFFE8D60D),
                            ),
                            Icon(
                              Icons.star_rounded,
                              size: 24,
                              color: Color(0xFFE8D60D),
                            ),
                            Icon(
                              Icons.star_rounded,
                              size: 24,
                              color: Color(0xFFE8D60D),
                            ),
                            Icon(
                              Icons.star_rounded,
                              size: 24,
                              color: Color(0xFFE8D60D),
                            ),
                            Icon(
                              Icons.star_half_rounded,
                              size: 24,
                              color: Color(0xFFE8D60D),
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.DoctorsData['Rating'].toString(),
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontFamily: 'Redex',
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              '(289)',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontFamily: 'Ubuntu',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
        
            //------Divider---------
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 25),
              child: Divider(
                height: 1, color: Colors.grey.shade300,),
            ),
        
            //------Appointment Cart---------
        
            SizedBox(height: 20,),
        
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
               'Appointment Details',
                style: TextStyle(
                 color: Colors.grey.shade900,
                  fontFamily: 'Redex',
                 fontSize: 19.0,
                 ),
                ),
            ],
          ),
        
            SizedBox(height: 20,),
        
            Padding(
              padding: const EdgeInsets.only(left: 40,right: 20,top: 20,bottom: 5),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          360),
                      color: Colors.grey.shade100,
                    ),
                    child: Icon(Icons.calendar_month_outlined,size: 18,color: Colors.grey.shade900,)
                  ),
        
                  SizedBox(width: 20 ,),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Appointment Date',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Ubuntu',
                          fontSize: 15.0,
                        ),
                      ),
        
                      SizedBox(height: 4,),
        
                      Text(
                        widget.Data,
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Redex',
                          fontSize: 13.0,
                        ),
                      )
                    ],
                  )
        
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 40,right: 20,top: 20,bottom: 5),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            360),
                        color: Colors.grey.shade100,
                      ),
                      child: Icon(CupertinoIcons.time,size: 18,color: Colors.grey.shade900,)
                  ),
        
                  SizedBox(width: 20 ,),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Appointment Time',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Ubuntu',
                          fontSize: 15.0,
                        ),
                      ),
        
                      SizedBox(height: 4,),
        
                      Text(
                        widget.Time,
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Redex',
                          fontSize: 13.0,
                        ),
                      )
                    ],
                  )
        
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 40,right: 20,top: 20,bottom: 5),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            360),
                        color: Colors.grey.shade100,
                      ),
                      child: Icon(CupertinoIcons.location,size: 18,color: Colors.grey.shade900,)
                  ),
        
                  SizedBox(width: 20 ,),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Ubuntu',
                          fontSize: 15.0,
                        ),
                      ),
        
                      SizedBox(height: 4,),
        
                      Text(
                        widget.DoctorsData['Location'],
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Redex',
                          fontSize: 13.0,
                        ),
                      )
                    ],
                  )
        
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 40,right: 20,top: 20,bottom: 5),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            360),
                        color: Colors.grey.shade100,
                      ),
                      child: Icon(CupertinoIcons.money_dollar,size: 18,color: Colors.grey.shade900,)
                  ),
        
                  SizedBox(width: 20 ,),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Ubuntu',
                          fontSize: 15.0,
                        ),
                      ),
        
                      SizedBox(height: 4,),
        
                      Text(
                        '${widget.AppointmentData['PaidAmount']/8500} USD',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Redex',
                          fontSize: 13.0,
                        ),
                      )
                    ],
                  )
        
                ],
              ),
            ),
        
            SizedBox(height: 15,),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Text(
                      'Verification Code',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontFamily: 'Redex',
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
                      child: Container(
                        height:100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            Text(
                              'Show the code at Reception',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Redex',
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              widget.AppointmentData['OTP'],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Redex',
                                fontSize: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
        
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50,top: 10,bottom: 25),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call,size: 18,color: Colors.white,),
                    SizedBox(width: 12,),
                    Text(
                      'Call Reception',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Redex',
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
        
              ),
            )
          ],
        ),
      ),


    );
  }
}
