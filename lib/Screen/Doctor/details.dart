// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kodoctor/Widgets/icon_btn.dart';
import 'package:kodoctor/home.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Doctor_Details extends StatefulWidget {
  final String Catagory;
  final String Name;
  final String Rating;
  final String fee;
  final String Experience;
  final String phone;
  final String DP;
  final String Sun;
  final String Mon;
  final String Tue;
  final String Wed;
  final String Thu;
  final String Fri;
  final String Sat;
  final String DID;

  const Doctor_Details({
    super.key,
    required this.Catagory,
    required this.Name,
    required this.Rating,
    required this.fee,
    required this.Experience,
    required this.phone,
    required this.DP, required this.Sun, required this.Mon, required this.Tue, required this.Wed, required this.Thu, required this.Fri, required this.Sat, required this.DID,
  });

  @override
  State<Doctor_Details> createState() => _Doctor_DetailsState();
}

class _Doctor_DetailsState extends State<Doctor_Details> {
  List _dates = [];
  Razorpay _razorpay = Razorpay();

  String SelectedDate = '';
  String SlectedDate = '';
  String Month = '';

  List<String> Slots = [];

  int selectedSlot = 0;

  String bookedDate = '';

  bool isFavorite = false;

  String FIDD = '';

  List<String> BookedSlots = [];

  void fetchDates() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot =
          await firestore.collection('Dates').get();

      _dates =
          querySnapshot.docs.map((docs) {
            return docs.data();
          }).toList();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void fetchbookedslots() async {
    try {
      List tempbookedslots = [];

      QuerySnapshot bookedQuery = await FirebaseFirestore.instance
          .collection('Appointments')
          .where('DID', isEqualTo: widget.DID)
          .where('Date', isEqualTo: '$bookedDate-${DateTime.now().month}-${DateTime.now().year}')
          .get();

      tempbookedslots = bookedQuery.docs.map((SlotsItem){
        return SlotsItem.data();
      }).toList();

      for (int i = 0; i < tempbookedslots.length; i++){

        BookedSlots.add(tempbookedslots[i]['Slot']);


      }

    } catch (e) {
      print('error : $e');
    }
  }

  void setSelectedDate(String date) {
    SelectedDate = date;
    setState(() {});
  }

  void currentMonth() {
    int numMonth = DateTime.now().month;
    Month =
        numMonth == '1'
            ? 'January'
            : numMonth == '2'
            ? 'February'
            : numMonth == '3'
            ? 'March'
            : numMonth == '4'
            ? 'April'
            : numMonth == '5'
            ? 'May'
            : numMonth == '6'
            ? 'June'
            : numMonth == '7'
            ? 'July'
            : numMonth == '8'
            ? 'August'
            : numMonth == '9'
            ? 'September'
            : numMonth == '10'
            ? 'October'
            : numMonth == '11'
            ? 'November'
            : 'December';

    setState(() {});
  }

  void arrangeSlots(String currentDay) {
    String tempSlots = currentDay == 'Mon'
        ? widget.Mon
        : currentDay == 'Tue'
            ? widget.Tue
            : currentDay == 'Wed'
                ? widget.Wed
                : currentDay == 'Thu'
                    ? widget.Thu
                    : currentDay == 'Fri'
                        ? widget.Fri
                        : currentDay == 'Sat'
                            ? widget.Sat
                            : widget.Sun;

    Slots = tempSlots.split(',').map((s) => s.trim()).toList();

    setState(() {

    });

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('Payment Successful');

    try {
      String UID = FirebaseAuth.instance.currentUser!.uid;

      math.Random  random = math.Random();

      String OTPCode = (000000 + random.nextInt(999999)).toString();

      if (selectedSlot <= 0 || selectedSlot > Slots.length) {
        print('Error: Invalid selectedSlot value: $selectedSlot');
        return;
      }

      if (bookedDate.isEmpty) {
        print('Error: bookedDate is not set');
        return;
      }

      String DocID = '${DateTime.now().microsecondsSinceEpoch}-$UID';

      Map<String, dynamic> Data = {
        'UID': UID,
        'DID': widget.DID,
        'Slot': Slots[selectedSlot - 1],
        'Date': '$bookedDate-${DateTime.now().month}-${DateTime.now().year}',
        'isPaid': 1,
        'PaidAmount': int.parse(widget.fee) * 85 * 100,
        'OTP' : OTPCode,

      };

      print('Storing data: $Data');

      FirebaseFirestore.instance
          .collection('Appointments')
          .doc(DocID)
          .set(Data)
          .then((_) {
        print('Appointment stored successfully');
      }).catchError((error) {
        print('Error storing appointment: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Payment Successful');

    try {
      String UID = FirebaseAuth.instance.currentUser!.uid;

      if (selectedSlot <= 0 || selectedSlot > Slots.length) {
        print('Error: Invalid selectedSlot value: $selectedSlot');
        return;
      }

      if (bookedDate.isEmpty) {
        print('Error: bookedDate is not set');
        return;
      }

      String DocID = '${DateTime.now().microsecondsSinceEpoch}-$UID';

      Map<String, dynamic> Data = {
        'UID': UID,
        'DID': widget.DID,
        'Slot': Slots[selectedSlot - 1],
        'Date': '$bookedDate-${DateTime.now().month}-${DateTime.now().year}',
        'isPaid': 1,
        'PaidAmount': int.parse(widget.fee) * 85 * 100,
      };

      print('Storing data: $Data');

      FirebaseFirestore.instance
          .collection('Appointments')
          .doc(DocID)
          .set(Data)
          .then((_) {
        print('Appointment stored successfully');
      }).catchError((error) {
        print('Error storing appointment: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void checkout() {
    var options = {
      'key': 'rzp_test_DvcHLgOENgqh6F',
      'amount': int.parse(widget.fee)*85*100,
      'name': 'Doclink',
      'description': 'Doctor Booking Slots',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      }
    };
    _razorpay.open(options);
  }

  void addToFavourite() async {
    try {
      String UID = FirebaseAuth.instance.currentUser!.uid;

      // Check if the doctor is already in favourites
      if (isFavorite) {
        print('Doctor is already in favourites');
        return; // If already favourited, do nothing
      }

      // Add to favourites only if not already in the favourites collection
      String DocID = '${DateTime.now().microsecondsSinceEpoch}-$UID';
      Map<String, dynamic> Data = {
        'UID': UID,
        'DID': widget.DID,
        'FID': DocID,
      };

      print('Adding doctor to favourites: $Data');

      // Store the new favourite doctor in Firestore
      await FirebaseFirestore.instance
          .collection('Favourite')
          .doc(DocID)
          .set(Data)
          .then((_) {
        print('Doctor added to favourites');
        isFavorite = true;  // Update the favourite state to true
        setState(() {});  // Refresh the UI immediately
      }).catchError((error) {
        print('Error adding doctor to favourites: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void removeFavourite(String FID) async {
    try {
      // Delete the doctor's favourite entry from Firestore
      await FirebaseFirestore.instance.collection('Favourite').doc(FID).delete().then((_) {
        print('Doctor removed from favourites');
        isFavorite = false;  // Update the favourite state to false
        setState(() {});  // Refresh the UI immediately
      }).catchError((error) {
        print('Error removing doctor from favourites: $error');
      });
    } catch (e) {
      print('Error: $e');
    }
  }




  void checkFavourite() async {
    String UID = FirebaseAuth.instance.currentUser!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch the favourite entries for the current user and doctor
      final QuerySnapshot querySnapshot = await firestore.collection('Favourite')
          .where('UID', isEqualTo: UID)
          .where('DID', isEqualTo: widget.DID)
          .get();

      // Check if the doctor is already in the favourites collection
      List _favourites = querySnapshot.docs.map((docs) {
        return docs.data();
      }).toList();

      if (_favourites.isNotEmpty) {
        // Doctor is in the favourites
        isFavorite = true;
        FIDD = _favourites[0]['FID'];  // Store the favourite document ID
      } else {
        // Doctor is not in the favourites
        isFavorite = false;
      }

      // Rebuild the UI to reflect the state
      setState(() {});
    } catch (e) {
      print('Error checking favourites: $e');
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      fetchDates();
      setSelectedDate(DateTime.now().day.toString());
      currentMonth();
      checkFavourite();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      // arrangeSlots(currentDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0x5A486AE4)),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [

                    SizedBox(width: 20),

                    IconBtn(icons: CupertinoIcons.back,clr: Colors.grey.shade900,),

                    Spacer(),

                    InkWell(
                      onTap: () {
                        if (isFavorite) {
                          // If doctor is already a favourite, remove it
                          removeFavourite(FIDD);  // Pass the FID to remove the doctor from favourites
                        } else {
                          // Otherwise, add the doctor to favourites
                          addToFavourite();
                        }
                      },
                      child: IconBtn(
                        clr: isFavorite ? Colors.red : Colors.grey.shade900,
                        icons: isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      ),
                    ),
                    SizedBox(width: 20),

                    IconBtn(icons: Icons.share,
                      clr: Colors.grey.shade900,),

                    SizedBox(width: 20),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: Image.network(
                            widget.DP ??
                                'https://res.cloudinary.com/dmmkgdyyq/image/upload/v1746130437/Doctor_hdmaar.png',
                            width: double.infinity,
                            height: 282.48,
                            fit: BoxFit.contain,
                            alignment: Alignment(1.0, 0.0),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              20.0,
                              30.0,
                              0.0,
                              0.0,
                            ),
                            child: Text(
                              widget.Catagory,
                              style: TextStyle(
                                fontFamily: 'ubuntu',
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.grey.shade900,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              20.0,
                              15.0,
                              0.0,
                              0.0,
                            ),
                            child: Builder(
                              builder: (context) {
                                String fullName = widget.Name;
                                List<String> parts = fullName.split(' ');

                                String line1 =
                                    parts.length >= 2
                                        ? '${parts[0]} ${parts[1]}'
                                        : fullName;
                                String line2 =
                                    parts.length > 2
                                        ? parts.sublist(2).join(' ')
                                        : '';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line1,
                                      style: TextStyle(
                                        fontFamily: 'ubuntu',
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.grey.shade900,
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    if (line2.isNotEmpty)
                                      Text(
                                        line2,
                                        style: TextStyle(
                                          fontFamily: 'ubuntu',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.grey.shade900,
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
                            padding: const EdgeInsets.only(left: 18, top: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 24,
                                  color: Color(0xFFE8D60D),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.Rating,
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
                          Spacer(),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              20.0,
                              5.0,
                              0.0,
                              20.0,
                            ),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$${widget.fee}',
                                    style: TextStyle(
                                      color: CupertinoColors.systemBlue,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' /session',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: primary,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,

                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  // height: MediaQuery.sizeOf(context).height-370,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(19),
                      topLeft: Radius.circular(19),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12),

                      //Second action bar
                      Row(
                        children: [
                          SizedBox(width: 20),

                          Container(
                            height: 37,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(360),
                              border: Border.all(
                                color: Colors.grey.shade900,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.Experience} Years Experience',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Redex',
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Spacer(),

                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(360),
                              border: Border.all(
                                color: Colors.blue.shade700,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: Colors.blue.shade700,
                            ),
                          ),

                          SizedBox(width: 20),

                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              border: Border.all(
                                color: Colors.grey.shade700,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.call,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          SizedBox(width: 20),
                        ],
                      ),

                      SizedBox(height: 12),

                      //available dates
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              '$Month ${DateTime.now().year}',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Redex',
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),

                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              '7 slots',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Ubuntu',
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 18,
                            color: Colors.grey.shade800,
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey.shade800,
                          ),

                          SizedBox(width: 20),
                        ],
                      ),

                      //----------------Dates
                      _dates.isEmpty
                          ? SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              color: CupertinoColors.systemBlue,
                            ),
                          )
                          : SizedBox(
                            height: 90,
                            width: MediaQuery.sizeOf(context).width,
                            child: ListView.builder(
                              primary: false,
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 10,
                              ),
                              itemCount: _dates.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                  final listItem = _dates[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      selectedSlot = 0;
                                      bookedDate = listItem['Date'];
                                      setSelectedDate(listItem['Date']);
                                      arrangeSlots(listItem['Day']);
                                      fetchbookedslots();
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          360,
                                        ),
                                        border: Border.all(
                                          color:
                                              SelectedDate == listItem['Date']
                                                  ? CupertinoColors.systemBlue
                                                  : Colors.grey.shade300,
                                          width: 1.6,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            listItem['Day'],
                                            style: TextStyle(
                                              color:
                                                  SelectedDate !=
                                                          listItem['Day']
                                                      ? Colors.grey.shade700
                                                      : CupertinoColors
                                                          .systemBlue,
                                              fontSize: 13,
                                              fontFamily: 'Ubuntu',
                                            ),
                                          ),

                                          SizedBox(height: 5),

                                          Text(
                                            listItem['Date'],
                                            style: TextStyle(
                                              color:
                                                  SelectedDate !=
                                                          listItem['Day']
                                                      ? Colors.grey.shade900
                                                      : CupertinoColors
                                                          .systemBlue,
                                              fontSize: 17,
                                              fontFamily: 'Ubuntu',
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

                      //------------------Slots booking
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0x5A486AE4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 15),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 3,
                                    ),
                                    child: Text(
                                      'Available Times Only',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Redex',
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
                                  ),

                                  Spacer(),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Text(
                                      '6 slots',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Ubuntu',
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),

                                  Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 18,
                                    color: Colors.grey.shade800,
                                  ),
                                  SizedBox(width: 16),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.grey.shade800,
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),

                              SizedBox(height: 15),

                              Row(
                                children: [
                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 1;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                        color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 0 ? Slots[0] : 'N/A') ? Colors.grey.shade300 : Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                         border: Border.all(
                                          color:BookedSlots.contains(Slots.isNotEmpty && Slots.length > 0 ? Slots[0] : 'N/A') ? Colors.grey.shade300 : selectedSlot == 1
                                              ? CupertinoColors.systemBlue
                                              : Colors.white,
                                          width: 1.5,
                                         )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 0 ? Slots[0] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 0 ? Slots[0] : 'N/A') ? Colors.grey.shade900:selectedSlot == 1
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900
                                            ,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 2;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                        color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 1 ? Slots[1] : 'N/A') ? Colors.grey.shade300 : Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                          border: Border.all(
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 1 ? Slots[1] : 'N/A') ? Colors.grey.shade300 : selectedSlot == 2
                                                ? CupertinoColors.systemBlue
                                                : Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 1 ? Slots[1] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 1 ? Slots[1] : 'N/A') ? Colors.grey.shade900:selectedSlot == 2
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 3;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                          color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 2 ? Slots[2] : 'N/A') ? Colors.grey.shade300 : Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                          border: Border.all(
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 2 ? Slots[2] : 'N/A') ? Colors.grey.shade300 : selectedSlot == 3
                                                ? CupertinoColors.systemBlue
                                                : Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 2 ? Slots[2] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 2 ? Slots[2] : 'N/A') ? Colors.grey.shade900:selectedSlot == 3
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),
                                ],
                              ),

                              SizedBox(height: 15),

                              Row(
                                children: [
                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 4;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                        color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 3 ? Slots[3] : 'N/A') ? Colors.grey.shade300:Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                          border: Border.all(
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 3 ? Slots[3] : 'N/A') ? Colors.grey.shade300:selectedSlot == 4
                                                ? CupertinoColors.systemBlue
                                                : Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 3 ? Slots[3] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 3 ? Slots[3] : 'N/A') ? Colors.grey.shade900:selectedSlot == 4
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 5;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                        color:BookedSlots.contains(Slots.isNotEmpty && Slots.length > 4 ? Slots[4] : 'N/A') ? Colors.grey.shade300: Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                          border: Border.all(
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 4 ? Slots[4] : 'N/A') ? Colors.grey.shade300:selectedSlot == 5
                                                ? CupertinoColors.systemBlue
                                                : Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 4 ? Slots[4] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 4 ? Slots[4] : 'N/A') ? Colors.grey.shade900:selectedSlot == 5
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  InkWell(
                                    onTap: () {
                                      selectedSlot = 6;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          (MediaQuery.sizeOf(context).width -
                                              78) /
                                          3,
                                      decoration: BoxDecoration(
                                        color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 5 ? Slots[5] : 'N/A') ? Colors.grey.shade300:Colors.white,
                                        borderRadius: BorderRadius.circular(360),
                                          border: Border.all(
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 5 ? Slots[5] : 'N/A') ? Colors.grey.shade300:selectedSlot == 6
                                                ? CupertinoColors.systemBlue
                                                : Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                      child: Center(
                                        child: Text(
                                          Slots.isNotEmpty && Slots.length > 5 ? Slots[5] : 'N/A',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Redex',
                                            color: BookedSlots.contains(Slots.isNotEmpty && Slots.length > 5 ? Slots[5] : 'N/A') ? Colors.grey.shade900:selectedSlot == 6
                                                ? CupertinoColors.activeBlue
                                                : Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),
                                ],
                              ),

                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),

                      //Next btn

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: InkWell(
                          onTap: () {
                            checkout();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: 'Redex',
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
