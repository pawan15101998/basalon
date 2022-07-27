// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:basalon/constant/login_user.dart';
import 'package:basalon/modal/home_data.dart';
import 'package:basalon/network/favorite_network.dart';
import 'package:basalon/screens/event_detail_screen.dart';
import 'package:basalon/services/constant.dart';
import 'package:basalon/services/my_color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../blocs/application_bloc.dart';

class EventCard extends StatefulWidget {
  var datum;
  String? email;
  String? name;

  EventCard({Key? key, this.datum, this.email, this.name}) : super(key: key);

  // EventCard({required this.datum});

  @override
  State<EventCard> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  late double width = MediaQuery.of(context).size.width;
  late double height = MediaQuery.of(context).size.height;

  final FetchFavoriteEvents _fetchFavoriteEvents = FetchFavoriteEvents();
  late final application = Provider.of<ApplicationBloc>(context, listen: false);

  @override
  void initState() {
    super.initState();
    print(
        'EventCard EventCard EventCard EventCard EventCard EventCard EventCard EventCard EventCard ');
  }

  Future share() async {}

  List<Data> data = <Data>[];

  var dio = Dio();

  // Future<List<Datum>> getEventData() async {
  //   try {
  //     var response = await dio.post(
  //       'https://basalon.co.il/wp-json/wp/v2/get_events',
  //       data: {},
  //       options: Options(
  //         headers: {
  //           'Client-Service': 'basalon-client-t1T83YHm60J8yNG5',
  //           'Auth-Key': 'XkCRn9Y4PPmspuqYKolqbyhcDFhID7kl',
  //         },
  //       ),
  //     );
  //     data = HomeData.fromJson(response.data).data;
  //   } catch (e) {
  //     print(e);
  //   }
  //   return data;
  // }

  List<HomeData> homeData = [];

  bool isLiked = false;
  bool showShareMenu = false;

  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: 'Example share',
  //       text: 'Example share text',
  //       // linkUrl: 'https://basalon.co.il/event/סדנת-חקלאות-בסביבה-הביתית/',
  //       linkUrl: '${widget.datum.shareLink}',
  //       chooserTitle: 'Example Chooser Title');
  // }

  //
  // Future<void> shareFile() async {
  //   final docs = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //   );
  //   if (docs == null || docs.files.isEmpty) return null;
  //
  //   await FlutterShare.shareFile(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     filePath: docs as String,
  //   );
  // }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GestureDetector(
            //   onTap: share,
            //   child: Image.asset(
            //     'assets/icons/messenger-icon.png',
            //     width: 30,
            //     height: 30,
            //   ),
            // ),
            Link(
              uri: Uri.parse(
                  'fb-messenger://share/?link=${widget.datum.shareLink}&app_id=604143361013658'),
              target: LinkTarget.defaultTarget,
              builder:
                  (BuildContext context, Future<void> Function()? followLink) =>
                      GestureDetector(
                onTap: followLink,
                child: Image.asset(
                  'assets/icons/messenger-icon.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            Link(
              uri: Uri.parse(
                  'mailto:${widget.email}?body=${widget.datum.shareLink}'),
              target: LinkTarget.defaultTarget,
              builder:
                  (BuildContext context, Future<void> Function()? followLink) =>
                      GestureDetector(
                onTap: followLink,
                child: Image.asset(
                  'assets/icons/email-icon.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            Link(
              uri: Uri.parse(
                  'https://api.whatsapp.com/send/?text=${widget.datum.shareLink}&app_absent=0'),
              target: LinkTarget.defaultTarget,
              builder:
                  (BuildContext context, Future<void> Function()? followLink) =>
                      GestureDetector(
                          onTap: followLink,
                          child: Image.asset(
                            'assets/icons/whatsapp-icon.png',
                            width: 30,
                            height: 30,
                          )),
            ),

            Link(
              uri: Uri.parse(
                  'https://www.facebook.com/sharer/sharer.php?u=${widget.datum.shareLink}'),
              target: LinkTarget.defaultTarget,
              builder:
                  (BuildContext context, Future<void> Function()? followLink) =>
                      GestureDetector(
                          onTap: () async {
                            // try {
                            //   var succeeded = await FacebookShare.shareContent(url: "https://www.facebook.com/sharer/sharer.php?u=${widget.datum.shareLink}", quote: "Dapatkan Promo");
                            //
                            //   if (succeeded) {
                            //     succeeded = await FacebookShare.sendMessage(
                            //         urlActionTitle: "Visit",
                            //         url: "https://www.facebook.com/sharer/sharer.php?u=${widget.datum.shareLink}",
                            //         title: "Promotion",
                            //         subtitle: "Get your promotion now!",
                            //         imageUrl:
                            //         "https://www.facebook.com/sharer/sharer.php?u=${widget.datum.shareLink}");
                            //     if (succeeded) {
                            //       var message = "Shared successfully";
                            //     } else {
                            //       var message = "Failed to share";
                            //     }
                            //   } else {
                            //     var message = "Failed to share";
                            //   }
                            // } on PlatformException catch (e) {
                            //   print(e);
                            // }
                            // FlutterSocialContentShare.share(
                            //     type: ShareType.facebookWithoutImage,
                            //     url: "${widget.datum.shareLink}",
                            //     quote: "Basalon");
                          },
                          child: Image.asset(
                            'assets/icons/fb-icon.png',
                            width: 30,
                            height: 30,
                          )),
            ),
            // IconButton(
            //     onPressed: () {
            //       print('messenger clicked.');
            //     },
            //     icon: Image.asset(
            //       'assets/icons/messenger-icon.png',
            //       width: 30,
            //       height: 30,
            //     )),
            // IconButton(
            //     onPressed: () {
            //       print('email clicked.');
            //     },
            //     icon: Image.asset(
            //       'assets/icons/email-icon.png',
            //       width: 30,
            //       height: 30,
            //     )),
            // IconButton(
            //     onPressed: () {
            //       print(
            //         'whatsapp clicked.',
            //       );
            //     },
            //     icon: Image.asset(
            //       'assets/icons/whatsapp-icon.png',
            //       width: 30,
            //       height: 30,
            //     )),
            // IconButton(
            //     onPressed: () {
            //       print('facebook clicked.');
            //     },
            //     icon: Image.asset(
            //       'assets/icons/fb-icon.png',
            //       width: 30,
            //       height: 30,
            //     )),
            // Text(
            //   'שתפו פעילות',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      );
    };
  }

  // ignore: unused_element
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          // content: SingleChildScrollView(
          //   child: ListBody(
          //     children: const <Widget>[
          //       Text('This is a demo alert dialog.'),
          //       Text('Would you like to approve of this message?'),
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // late String stringColor = widget.datum.categoryColor;
  late var dateSplit = widget.datum.date;
  late String removeIsrael = widget.datum.address;

  // getText() {
  //   var toReplace =dateSplit.split(' ')[0] !=''? dateSplit.replaceAll(dateSplit.split(' ')[0], ''): dateSplit.replaceAll(dateSplit.split(' ')[1], '');
  //   return toReplace;
  // }

  @override
  Widget build(BuildContext context) {
    print("jksjnsd");
    print(widget.datum.ticketRest);
    print('dateSplit dateSplit dateSplit');

    print(dateSplit);
    return FutureBuilder(builder: (context, snapshot) {
      print(snapshot.connectionState);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: const EdgeInsets.all(1),
        // height: 350,
        child: Column(
          children: [
            Stack(
              textDirection: TextDirection.rtl,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          id: widget.datum.id!.toInt(),
                          email: widget.email,
                          name: widget.name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 230,
                    width: double.infinity,
                    // color: Colors.red,
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7)),
                      child: Image.network('${widget.datum.thumbnailEvent}',
                          height: 170.0, width: 100.0, fit: BoxFit.fill),
                    ),
                  ),
                ),
                // const Positioned(
                //   right: 10,
                //   top: 10,
                //   child: CircleAvatar(
                //     radius: 28,
                //     backgroundColor: Colors.white,
                //     child: CircleAvatar(
                //       backgroundImage: AssetImage('assets/top-image.jpg'),
                //       radius: 25,
                //     ),
                //   ),
                // ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: InkWell(
                    onTap: () {
                      if (!isLiked) {
                        _fetchFavoriteEvents.addToFavorite(
                            application.idFromLocalProvider != null
                                ? application.idFromLocalProvider
                                : LoginUser.shared?.userId,
                            widget.datum.id);
                      }

                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          // backgroundImage: AssetImage('assets/icons/fav card.png'),
                          child: isLiked
                              ? Icon(
                                  Icons.favorite_sharp,
                                  color: Colors.pink,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                )),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 20,
                  child: Row(
                    children: [
                      for (var item in widget.datum.categoryData)
                        //   for (int i = 0;
                        //       i < widget.datum.categoryData.length;
                        //       i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Color(int.parse('0xff${item.color}'))
                                  .withOpacity(1),
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Text('${item.name}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  left: 65,
                  bottom: 20,
                  child: InkWell(
                    // onTap: share,
                    onTap: () {
                      setState(() {
                        showShareMenu = !showShareMenu;
                      });
                    },
                    //last
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        // backgroundImage: AssetImage('assets/icons/Share.png'),
                        child: Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.black,
                        ),
                        radius: 15,
                      ),
                    ),
                  ),
                ),
                if (showShareMenu)
                  Positioned(
                    left: 100,
                    bottom: 20,
                    child: _localDialogBuilder(context),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 10),
                              child: SizedBox(
                                child: Text('${widget.datum.title}',
                                    // maxLines: 2,
                                    // overflow: TextOverflow.ellipsis,
                                    // 'name',

                                    // textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: ktextStyleBoldMedium),
                              ),
                            ),
                            if (widget.datum.numberComment != 0 &&
                                widget.datum.averageRating != 0)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '(${widget.datum.numberComment})',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        // fontFamily: 'Alef',
                                        fontSize: 12,
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating: widget.datum.averageRating!
                                          .toDouble(),
                                      minRating: 1,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        // color: MyColors.topOrange,
                                        color: Colors.amber.shade700,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    )
                                  ],
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                        text: dateSplit.day,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: " | ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: dateSplit.startTime,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " | ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${dateSplit.dayNo} ב${dateSplit.month}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  // Icon(
                                  //   Icons.calendar_today,
                                  //   color: MyColors.topOrange,
                                  // )
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Image.asset(
                                    'assets/icons/calendar.jpeg',
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (removeIsrael != '')
                              Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                                textDirection:
                                                    TextDirection.rtl,
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                                    text: removeIsrael != null
                                                        ? removeIsrael
                                                            .replaceAll(
                                                                ', ישראל', '')
                                                        : "",
                                                    children: [
                                                      TextSpan(
                                                          text: widget.datum
                                                                      .distance !=
                                                                  null
                                                              ? ' | '
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      TextSpan(
                                                          text: (widget.datum
                                                                          .distance !=
                                                                      null &&
                                                                  widget.datum
                                                                          .distance !=
                                                                      0 && application.filterAnywhereProvider != 'עיר מסויימת') 
                                                              ? 'במרחק ${widget.datum.distance < 1 ? (widget.datum.distance * 1000).round() : widget.datum.distance.toStringAsFixed(2)} ${widget.datum.distance < 1 ? 'מטרים' : 'ק"מ'}'
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ])),
                                          ),
                                          // Expanded(
                                          //   child: Text(
                                          //     removeIsrael.replaceAll(
                                          //         ', ישראל', ''),
                                          //     // 'שיינקין , גבעתיים',
                                          //     style: TextStyle(
                                          //       fontSize: 14,
                                          //       // fontWeight: FontWeight.bold,
                                          //     ),
                                          //     textDirection: TextDirection.rtl,
                                          //   ),
                                          // ),
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: MyColors.topOrange,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                            if( widget.datum.ticketRest != '' && int.parse(widget.datum.ticketRest.replaceAll(new RegExp(r'[^0-9]'), '')) < 10)
                                  Container(
                                    height: 35,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColors.topOrange,
                                            width: 2)),

                                    child: Center(
                                      child: RichText(
                                          text: TextSpan(
                                              style: ktextStyleBoldSmall,
                                              text: '  נותרו ',
                                              children: [
                                            // TextSpan(text: widget.datum.ticketRest),
                                        // if( widget.datum.ticketRest != '' && int.parse(widget.datum.ticketRest.replaceAll(new RegExp(r'[^0-9]'), '')) < 10)
                                       TextSpan(
                                                text:
                                                    '${widget.datum.ticketRest.replaceAll(new RegExp(r'[^0-9]'), '')}'),
                                            TextSpan(text: ' מקומות  '),
                                          ])
                                          ),

                                      // Text(
                                      //   'נותרו${widget.datum.noOfTicket[0].numberTotalTicket}מקומות',
                                      //   style: ktextStyleBoldSmall,
                                      // ),
                                    ),
                                  ),
                                  //  SizedBox(),
                                  SizedBox(
                                    width: 14.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      print('lecture clicked.');
                                    },
                                    child: Text(
                                      widget.datum.markerPrice
                                          .toString()
                                          .replaceAll(' ', ''),

                                      // '₪${ widget.datum.noOfTicket[0].priceTicket}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(25),
                                              topLeft: Radius.circular(25)),
                                        ),
                                        elevation: 0.0,
                                        primary: MyColors.topOrange),
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   'נשארו רק עוד  8  כרטיסים',
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     // fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
      );
    });
  }
}