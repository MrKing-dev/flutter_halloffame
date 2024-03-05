import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

var photo_displayed = '';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> inducteeList;

  @override
  void initState() {
    super.initState();
    _loadInducteeList();
  }

  Future<void> _loadInducteeList() async {
    final jsonString = await rootBundle.loadString('assets/inductee_list.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      inducteeList = List<Map<String, dynamic>>.from(jsonData);
      inducteeList.sort((a, b) => a['last_name'].compareTo(b['last_name']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text(
          'Hamburg Area School District',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./photos/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Athletics Hall of Fame',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: inducteeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.red[900],
                      margin: EdgeInsets.all(40),
                      elevation: 5,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              inducteeList[index]['profile_photo'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black87,
                              ],
                            ),
                          )),
                          Positioned(
                            bottom: 5,
                            left: 5,
                            right: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    '${inducteeList[index]['first_name']} ${inducteeList[index]['last_name']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    '${inducteeList[index]['sports'].join(', ')}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet<dynamic>(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return CardDetail(
                                      inductee: inducteeList[index]);
                                },
                                constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width *
                                            0.8),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetail extends StatefulWidget {
  final Map<String, dynamic> inductee;

  const CardDetail({Key? key, required this.inductee}) : super(key: key);

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  var photo_gallery = false;

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  photo_gallery
                      ? photo_displayed
                      : widget.inductee['profile_photo'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.inductee['first_name']} ${widget.inductee['last_name']}',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Induction Year: ${widget.inductee['induction_year']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(),
                    Text(
                      'Sports: ${widget.inductee['sports'].join(', ')}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(),
                    Text(
                      'Graduation Year: ${widget.inductee['grad_year']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(widget.inductee['description'],
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      'Other Photos',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var photo in widget.inductee['other_photos'])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                photo_gallery = true;
                                photo_displayed = photo;
                              });
                            },
                            child: Image.asset(
                              photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }
}
