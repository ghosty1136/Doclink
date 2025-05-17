import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kodoctor/Screen/Doctor/details.dart';
import 'package:kodoctor/Widgets/profile_option.dart';
import 'package:kodoctor/login.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:intl/intl.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:get/get.dart';

import 'Screen/Appointments/details.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Color primary = Color(0xFF343341);

class _HomeState extends State<Home> with TickerProviderStateMixin {

  List categories = [];
  List Doctors = [];
  bool isDoctorerrored = false;

  bool isfavouriterrored = false;

  bool isMyAppointmentfetched = false;

  List MyAppointments = [];

  List<String> DoctorsUIDList = [];

  List DoctorsDetails = [];

  List FavouriteDIDList = [];

  List MyFavourite = [];

  late MotionTabBarController tabBarController;

  void fetchCatagory() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore.collection(
          'Categories ').get();

      categories = querySnapshot.docs.map((docs) {
        return docs.data();
      }).toList();

      setState(() {

      });
    } catch (e) {
      print(e);
     }
  }

  void fetchDoctors() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore.collection(
          'Doctors').get();

      Doctors = querySnapshot.docs.map((docs) {
        return docs.data();
      }).toList();
      isDoctorerrored = false;

      setState(() {

      });
    } catch (e) {
      isDoctorerrored = true;
      setState(() {

      });
      print(e);
    }
  }

  void fetchDoctorsDetails(String DID) async {
    DoctorsDetails.clear();
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('Doctors')
          .where('UID', isEqualTo: DID.trim()) // 🧠 Trim to avoid mismatch due to spaces
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 🔐 Only map if docs exist
        DoctorsDetails.addAll(
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList()
        );
      } else {
        print("⚠️No doctor found with UID: $DID");
      }

      setState(() {});
    } catch (e) {
      print("❌ Error in fetchDoctorsDetails: $e");
      setState(() {});
    }
  }


  void fetchMyAppointments() async {
    String UID = FirebaseAuth.instance.currentUser!.uid;
    print(UID);

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshotAppointments = await firestore
          .collection('Appointments')
          .where('UID', isEqualTo: UID)
          .get();

      MyAppointments = querySnapshotAppointments.docs.map((docs) {
        return docs.data();
      }).toList();

      DoctorsUIDList.clear();
      DoctorsDetails.clear();

      for (int i = 0; i < MyAppointments.length; i++) {
        String did = MyAppointments[i]['DID'].toString().trim();
        if (!DoctorsUIDList.contains(did)) {
          DoctorsUIDList.add(did);
          fetchDoctorsDetails(did);
        }
      }

      isMyAppointmentfetched = true;
      setState(() {});
      print(MyAppointments);
    }
    catch (e) {
      print('eer : $e');
      isMyAppointmentfetched = false;
      setState(() {});
    }
  }

  void fetchFavourite() async {
    String UID = FirebaseAuth.instance.currentUser!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore.collection('Favourite')
          .where('UID', isEqualTo: UID)
          .get();

     MyFavourite = querySnapshot.docs.map((docs) {
        return docs.data();
      }).toList();

      for (int i = 0; i < MyFavourite.length; i++) {
        String did = MyFavourite[i]['DID'].toString().trim();
        if (!FavouriteDIDList.contains(did)) {
          FavouriteDIDList.add(did);
          fetchDoctorsDetails(did);
        }
      }




      setState(() {});

      isfavouriterrored = false;

    } catch (e) {
      isfavouriterrored = true;
      print('Error checking favourite: $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCatagory();
      fetchDoctors();
      tabBarController = MotionTabBarController(length: 5, vsync: this);
      fetchMyAppointments();
      });
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            //Action Bar
            Visibility(
              visible: tabBarController.index != 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 10, right: 10, bottom: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 0.0, 0.0),
                        child: Text(
                          tabBarController.index == 0 ? 'Doclink' : tabBarController.index == 1 ? 'Appointments' : tabBarController.index == 2 ?  'My Favourite' :tabBarController.index == 3 ?  'Chat':'',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                            fontSize: 30.0,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 20.0, 0.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0x121B1414),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade900,
                          size: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 20.0, 0.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0x121B1414),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_rounded,
                          color: Colors.grey.shade900,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // -------HOME page -------


            tabBarController.index == 0
                ? SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .height - 200,
              child: Column(
                children: [
                  // Category List
                  categories.isNotEmpty ? Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10.0, 20.0, 0.0, 0.0),
                      child: ListView.builder(
                        itemCount: categories.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Map CatagoryData = categories[index];
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Image.network(
                                    CatagoryData['IMG'],
                                    width: 55.0,
                                    height: 55.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 6.0, 0.0, 0.0),
                                  child: Text(
                                    CatagoryData['Name'],
                                    style: TextStyle(
                                      fontFamily: 'Redex',
                                      color: primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ) :
                  SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator()),

                  // Title Bar
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        5.0, 20.0, 5.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Top Doctors',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 0.0),
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: CupertinoColors.systemBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Doctors List
                  Doctors.isNotEmpty
                      ? Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: Doctors.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                Map DoctorData = Doctors[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25.0, 5.0, 25.0, 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          Doctor_Details(
                                            DID: DoctorData['UID'],
                                            Catagory: DoctorData['Category '],
                                            Name: DoctorData['Name'],
                                            Rating: DoctorData['Rating']
                                                .toString(),
                                            fee: DoctorData['Fee'].toString(),
                                            Experience: DoctorData['Experience']
                                                .toString(),
                                            phone: DoctorData['Phone']
                                                .toString(),
                                            DP: DoctorData['DP'].toString(),
                                            Mon: DoctorData['Mon'].toString(),
                                            Tue: DoctorData['Tue'].toString(),
                                            Wed: DoctorData['Wed'].toString(),
                                            Thu: DoctorData['Thu'].toString(),
                                            Fri: DoctorData['Fri'].toString(),
                                            Sat: DoctorData['Sat'].toString(),
                                            Sun: DoctorData['Sun'].toString(),
                                          ));
                                    },
                                    child: Container(
                                      width: 100.0,
                                      height: 251.2,
                                      decoration: BoxDecoration(
                                        color: Color(0x5A486AE4),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(24.0),
                                          bottomRight: Radius.circular(24.0),
                                          topLeft: Radius.circular(24.0),
                                          topRight: Radius.circular(24.0),
                                        ),
                                        border: Border.all(
                                          color: Color(0x621F2022),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(24.0),
                                                child: Image.network(
                                                  DoctorData['DP'],
                                                  width: double.infinity,
                                                  height: 282.48,
                                                  fit: BoxFit.fitHeight,
                                                  alignment: Alignment(
                                                      1.0, 0.0),
                                                ),
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize: MainAxisSize
                                                      .max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          15.0, 10.0, 15.0,
                                                          0.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .max,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 90.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  24.0),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .star_rounded,
                                                                  color: Color(
                                                                      0xFFE8D60D),
                                                                  size: 24.0,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      6.0, 0.0,
                                                                      0.0, 0.0),
                                                                  child: Text(
                                                                    DoctorData['Rating']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontFamily: 'Ubuntu',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 40.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  24.0),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color: primary,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 20.0, 0.0, 0.0),
                                                      child: Text(
                                                        DoctorData['Category '],
                                                        style: TextStyle(
                                                          fontFamily: 'ubuntu',
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontStyle: FontStyle
                                                              .normal,
                                                          color: Color(
                                                              0xA615141B),
                                                          letterSpacing: 0.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 4.0,
                                                          0.0, 0.0),
                                                      child: Builder(
                                                        builder: (context) {
                                                          String fullName = DoctorData['Name'];
                                                          List<
                                                              String> parts = fullName
                                                              .split(' ');

                                                          String line1 = parts
                                                              .length >= 2
                                                              ? '${parts[0]} ${parts[1]}'
                                                              : fullName;
                                                          String line2 = parts
                                                              .length > 2
                                                              ? parts
                                                              .sublist(2)
                                                              .join(' ')
                                                              : '';

                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                line1,
                                                                style: TextStyle(
                                                                  fontFamily: 'ubuntu',
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                  fontSize: 22.0,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                              ),
                                                              if (line2
                                                                  .isNotEmpty)
                                                                Text(
                                                                  line2,
                                                                  style: TextStyle(
                                                                    fontFamily: 'ubuntu',
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontStyle: FontStyle
                                                                        .normal,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade900,
                                                                    fontSize: 22.0,
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 5.0, 0.0, 0.0),
                                                      child: RichText(
                                                        textScaler: MediaQuery
                                                            .of(context)
                                                            .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '\$${DoctorData['Fee']}',
                                                              style: TextStyle(
                                                                color: primary,
                                                                fontFamily: 'Ubuntu',
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                fontStyle:
                                                                FontStyle
                                                                    .normal,
                                                                letterSpacing: 0.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: '/ session',
                                                              style: TextStyle(
                                                                fontFamily: 'Ubuntu',
                                                                color: primary,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontStyle:
                                                                FontStyle
                                                                    .normal,

                                                                letterSpacing: 0.0,
                                                              ),
                                                            )
                                                          ],
                                                          style: TextStyle(
                                                            fontFamily: 'Ubuntu',
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            letterSpacing: 0.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 10.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 60.07,
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                              0x88E0E3E7),
                                                          borderRadius: BorderRadius
                                                              .only(
                                                            bottomLeft: Radius
                                                                .circular(24.0),
                                                            bottomRight: Radius
                                                                .circular(24.0),
                                                            topLeft: Radius
                                                                .circular(24.0),
                                                            topRight: Radius
                                                                .circular(24.0),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize
                                                              .max,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20.0, 5.0,
                                                                    0.0, 0.0),
                                                                child: RichText(
                                                                  textScaler:
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .textScaler,
                                                                  text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text: 'Availability : ',
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily:
                                                                          'Ubuntu',
                                                                          color: primary,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                          fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: '4 Slots ',
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily: 'Ubuntu',
                                                                          color: primary,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                          fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: TextStyle(
                                                                      fontFamily: 'Ubuntu',
                                                                      fontWeight: FontWeight
                                                                          .w600,
                                                                      fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0, 0.0,
                                                                  15.0, 0.0),
                                                              child: Container(
                                                                width: 120.0,
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      24.0),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize
                                                                      .max,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      '15  MAY',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Ubuntu',
                                                                        fontWeight: FontWeight
                                                                            .w600,
                                                                        fontStyle:
                                                                        FontStyle
                                                                            .normal,

                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          15.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: Icon(
                                                                        Icons
                                                                            .arrow_forward_ios_rounded,
                                                                        color:
                                                                        Colors
                                                                            .grey,
                                                                        size: 18.0,
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
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : isDoctorerrored ? Expanded(
                    child: Center(
                      child: Text(
                        'No Doctor !',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 20
                        ),
                      ),
                    ),
                  )
                      : SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator()),

                ],
              ),
            )


            // -----Appointment Page----


             : tabBarController.index == 1 ?

                SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .height - 200,
              child: Column(
                children: [

                  SizedBox(height: 5,),
                  MyAppointments.isNotEmpty
                      ? Container(
                    width: double.infinity,
                    height: MediaQuery
                        .sizeOf(context)
                        .height - 205,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10.0, 20.0, 0.0, 0.0),
                      child: ListView.builder(
                        itemCount: MyAppointments.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Map AppointmentData = MyAppointments[index];
                          Map DoctorsData = {};
                          List<String> DataSaprate = [];
                          DataSaprate = AppointmentData['Date'].split('-');
                          int Day = int.parse(DataSaprate[0]);
                          int Month = int.parse(DataSaprate[1]);
                          int Year = int.parse(DataSaprate[2]);


                          final Date = DateTime(Year,Month,Day);
                          String DayName = DateFormat('EEEE').format(Date);
                          String MonthName = DateFormat('MMMM').format(Date);

                          final Timeformate = DateFormat('hh:mm a');

                          // var timeParse = Timeformate.parse(AppointmentData['Slot']);
                          DateTime timeParse;

                          try {
                            timeParse = Timeformate.parse(AppointmentData['Slot']);
                          } catch (e) {
                            print("Error parsing time: ${AppointmentData['Slot']}");
                            timeParse = DateTime.now(); // Default time or any fallback
                          }

                          DateTime newTime = timeParse.add(Duration(minutes: 30));

                          final SasionEnd = Timeformate.format(newTime);


                          for (int i = 0; i < DoctorsDetails.length; i++) {
                            Map DoctorItem = DoctorsDetails[i];
                            if (DoctorItem['UID'] == AppointmentData['DID']) {
                              DoctorsData = DoctorItem;
                            }
                          }


                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: InkWell(
                              onTap: (){
                                Get.to(AppointmentDetails(DoctorsData: DoctorsData,AppointmentData: AppointmentData,Time: '${AppointmentData['Slot']}-$SasionEnd',Data: '$DayName, $Day $MonthName $Year'));
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey.shade900,
                                      width: 1,
                                    )
                                ),


                                child: Column(
                                  children: [

                                    //Doctor Card
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 10, right: 10),
                                      child: Row(
                                        children: [

                                          // ----Doctor DP---
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  360),
                                              color: Colors.grey.shade300,
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(360),
                                                child: Image.network(
                                                    DoctorsData['DP'],
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.fitHeight
                                                )
                                            ),
                                          ),

                                          SizedBox(width: 16,),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                DoctorsData['Name'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontFamily: 'Redex',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.0,
                                                ),
                                              ),

                                              SizedBox(height: 4,),

                                              Text(
                                                DoctorsData['Category '] ?? 'Unknown',
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 14.0,
                                                ),
                                              )
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

                                    //------Booking Slot --------
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.grey.shade600,
                                            size: 18,
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            '$DayName, $Day $MonthName',
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontFamily: 'Ubuntu',
                                              fontSize: 12.0,
                                            ),
                                          ),

                                          Spacer(),

                                          Icon(
                                            Icons.watch_later_outlined,
                                            color: Colors.grey.shade600,
                                            size: 18,
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            '${AppointmentData['Slot']}-$SasionEnd',
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontFamily: 'Ubuntu',
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 25, horizontal: 10),
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.14),
                                            borderRadius: BorderRadius.circular(360)
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Appointment details',
                                            style: TextStyle(
                                              color: CupertinoColors.systemBlue,
                                              fontFamily: 'Redex',
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ) :
                  SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator()),
                ],
              ),
            )


                // -- Favourite Page ----

            : tabBarController.index == 2 ?

            SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .height - 200,
              child: Column(
                children: [
                  MyFavourite.isNotEmpty
                      ? Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: MyFavourite.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                Map DoctorData = DoctorsDetails[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25.0, 5.0, 25.0, 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          Doctor_Details(
                                            DID: DoctorData['UID'],
                                            Catagory: DoctorData['Category '],
                                            Name: DoctorData['Name'],
                                            Rating: DoctorData['Rating']
                                                .toString(),
                                            fee: DoctorData['Fee'].toString(),
                                            Experience: DoctorData['Experience']
                                                .toString(),
                                            phone: DoctorData['Phone']
                                                .toString(),
                                            DP: DoctorData['DP'].toString(),
                                            Mon: DoctorData['Mon'].toString(),
                                            Tue: DoctorData['Tue'].toString(),
                                            Wed: DoctorData['Wed'].toString(),
                                            Thu: DoctorData['Thu'].toString(),
                                            Fri: DoctorData['Fri'].toString(),
                                            Sat: DoctorData['Sat'].toString(),
                                            Sun: DoctorData['Sun'].toString(),
                                          ));
                                    },
                                    child: Container(
                                      width: 100.0,
                                      height: 251.2,
                                      decoration: BoxDecoration(
                                        color: Color(0x5A486AE4),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(24.0),
                                          bottomRight: Radius.circular(24.0),
                                          topLeft: Radius.circular(24.0),
                                          topRight: Radius.circular(24.0),
                                        ),
                                        border: Border.all(
                                          color: Color(0x621F2022),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(24.0),
                                                child: Image.network(
                                                  DoctorData['DP'],
                                                  width: double.infinity,
                                                  height: 282.48,
                                                  fit: BoxFit.fitHeight,
                                                  alignment: Alignment(
                                                      1.0, 0.0),
                                                ),
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize: MainAxisSize
                                                      .max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          15.0, 10.0, 15.0,
                                                          0.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize
                                                            .max,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 90.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  24.0),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .star_rounded,
                                                                  color: Color(
                                                                      0xFFE8D60D),
                                                                  size: 24.0,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      6.0, 0.0,
                                                                      0.0, 0.0),
                                                                  child: Text(
                                                                    DoctorData['Rating']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontFamily: 'Ubuntu',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 40.0,
                                                            height: 40.0,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  24.0),
                                                            ),
                                                            child: Icon(
                                                              Icons.favorite_rounded,
                                                              color: Colors.red,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 20.0, 0.0, 0.0),
                                                      child: Text(
                                                        DoctorData['Category '],
                                                        style: TextStyle(
                                                          fontFamily: 'ubuntu',
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontStyle: FontStyle
                                                              .normal,
                                                          color: Color(
                                                              0xA615141B),
                                                          letterSpacing: 0.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(20.0, 4.0,
                                                          0.0, 0.0),
                                                      child: Builder(
                                                        builder: (context) {
                                                          String fullName = DoctorData['Name'];
                                                          List<
                                                              String> parts = fullName
                                                              .split(' ');

                                                          String line1 = parts
                                                              .length >= 2
                                                              ? '${parts[0]} ${parts[1]}'
                                                              : fullName;
                                                          String line2 = parts
                                                              .length > 2
                                                              ? parts
                                                              .sublist(2)
                                                              .join(' ')
                                                              : '';

                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                line1,
                                                                style: TextStyle(
                                                                  fontFamily: 'ubuntu',
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                  fontSize: 22.0,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                              ),
                                                              if (line2
                                                                  .isNotEmpty)
                                                                Text(
                                                                  line2,
                                                                  style: TextStyle(
                                                                    fontFamily: 'ubuntu',
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontStyle: FontStyle
                                                                        .normal,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade900,
                                                                    fontSize: 22.0,
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20.0, 5.0, 0.0, 0.0),
                                                      child: RichText(
                                                        textScaler: MediaQuery
                                                            .of(context)
                                                            .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: '\$${DoctorData['Fee']}',
                                                              style: TextStyle(
                                                                color: primary,
                                                                fontFamily: 'Ubuntu',
                                                                fontWeight: FontWeight
                                                                    .w600,
                                                                fontStyle:
                                                                FontStyle
                                                                    .normal,
                                                                letterSpacing: 0.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: '/ session',
                                                              style: TextStyle(
                                                                fontFamily: 'Ubuntu',
                                                                color: primary,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                fontStyle:
                                                                FontStyle
                                                                    .normal,

                                                                letterSpacing: 0.0,
                                                              ),
                                                            )
                                                          ],
                                                          style: TextStyle(
                                                            fontFamily: 'Ubuntu',
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            letterSpacing: 0.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 10.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 60.07,
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                              0x88E0E3E7),
                                                          borderRadius: BorderRadius
                                                              .only(
                                                            bottomLeft: Radius
                                                                .circular(24.0),
                                                            bottomRight: Radius
                                                                .circular(24.0),
                                                            topLeft: Radius
                                                                .circular(24.0),
                                                            topRight: Radius
                                                                .circular(24.0),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize
                                                              .max,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .center,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    20.0, 5.0,
                                                                    0.0, 0.0),
                                                                child: RichText(
                                                                  textScaler:
                                                                  MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .textScaler,
                                                                  text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text: 'Availability : ',
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily:
                                                                          'Ubuntu',
                                                                          color: primary,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                          fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: '4 Slots ',
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily: 'Ubuntu',
                                                                          color: primary,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                          fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                          letterSpacing: 0.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    style: TextStyle(
                                                                      fontFamily: 'Ubuntu',
                                                                      fontWeight: FontWeight
                                                                          .w600,
                                                                      fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0, 0.0,
                                                                  15.0, 0.0),
                                                              child: Container(
                                                                width: 120.0,
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      24.0),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize
                                                                      .max,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text(
                                                                      '15  MAY',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Ubuntu',
                                                                        fontWeight: FontWeight
                                                                            .w600,
                                                                        fontStyle:
                                                                        FontStyle
                                                                            .normal,

                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          15.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child: Icon(
                                                                        Icons
                                                                            .arrow_forward_ios_rounded,
                                                                        color:
                                                                        Colors
                                                                            .grey,
                                                                        size: 18.0,
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
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : isfavouriterrored ? Expanded(
                    child: Center(
                      child: Text(
                        'No Favourite !',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 20
                        ),
                      ),
                    ),
                  )
                      : SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator()),
                ],
              ),
            )

                : tabBarController.index == 3 ?

                SizedBox()

            //profile --------

                : Column(
              children: [
                Container(
                  height:250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )
                  ),
                  child: Column(
                    children: [

                      SizedBox(height: 70,),
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
                            child: Image.asset(
                                ('assets/images/User.png'),
                                height: 90,
                                width: 90,
                                fit: BoxFit.fitWidth
                            )
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        ('Himanshu Arora'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Ubuntu',
                          fontSize: 15,
                        ),
                      ),

                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.info,size: 19,color: Colors.grey.shade800,),
                      SizedBox(width: 10,),
                      Text(
                        'Menu Options',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontFamily: 'Redex',
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                ProfileOptions(Name: 'About Us', subtitle: 'Read about Doclink', icon: CupertinoIcons.info_circle),

                ProfileOptions(Name: 'Help & Support', subtitle: 'Hello, How can i help you?', icon: Icons.support_agent_rounded),

                ProfileOptions(Name: 'Terms & Conditions', subtitle: 'Read our terms and conditions', icon: CupertinoIcons.doc),

                ProfileOptions(Name: 'Privacy Policy', subtitle: 'Read our privacy policy', icon: CupertinoIcons.lock),

                InkWell(
                  onTap: (){
                    FirebaseAuth.instance.signOut();
                    Get.to(Login());
                  },
                    child:
                    ProfileOptions(
                        Name: 'Logout',
                        subtitle: 'Logout from your account',
                        icon: CupertinoIcons.arrow_right_circle
                    )
                ),







              ],

            )



          ],
        ),
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: 'Home',
        onTabItemSelected: (tab) {
          tabBarController.index = tab;
          if(tabBarController.index == 1){
            fetchMyAppointments();
          }else if (tabBarController.index == 2){
            fetchFavourite();
          }
          setState(() {

          });
        },
        controller: tabBarController,
        labels: [
          'Home',
          'Appointment',
          'Favourite',
          'Chats',
          'Profile'
        ],
        icons: [
          Icons.home_filled,
          Icons.calendar_month,
          CupertinoIcons.heart,
          CupertinoIcons.chat_bubble,
          CupertinoIcons.profile_circled
        ],

        tabIconSize: 29,
        textStyle: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 15
        ),

      ),
    );
  }
}



 
