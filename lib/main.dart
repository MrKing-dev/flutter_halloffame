import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

var photo_displayed = '';
String selectedLetter = '';
String selectedSport = '';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
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
  late List<Map<String, dynamic>> filteredInducteeList;

  final TextEditingController letterController = TextEditingController();
  final TextEditingController sportController = TextEditingController();

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
      filteredInducteeList = List<Map<String, dynamic>>.from(inducteeList);
    });
  }

  void filterByLetter(String letter) {
    setState(() {
      if (selectedSport != '') {
        filteredInducteeList = inducteeList
            .where((inductee) =>
                inductee['last_name'].startsWith(letter) &&
                inductee['sports'].contains(selectedSport))
            .toList();
      } else {
        filteredInducteeList = inducteeList
            .where((inductee) => inductee['last_name'].startsWith(letter))
            .toList();
      }
    });
  }

  void filterBySport(String sport) {
    setState(() {
      if (selectedLetter != '') {
        filteredInducteeList = inducteeList
            .where((inductee) =>
                inductee['last_name'].startsWith(selectedLetter) &&
                inductee['sports'].contains(sport))
            .toList();
      } else {
        filteredInducteeList = inducteeList
            .where((inductee) => inductee['sports'].contains(sport))
            .toList();
      }
    });
  }

  int gridOutput() {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      return 3;
    } else {
      return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 100,
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
        actions: [
          IconButton(
              iconSize: 40,
              onPressed: () {
                _loadInducteeList();
              },
              icon: Icon(Icons.refresh)),
          SizedBox(width: 20),
          DropdownMenu(
            controller: letterController,
            label: Text('Filter by Last Name'),
            initialSelection: "A",
            width: 200,
            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints.tight(
                Size.fromHeight(35),
              ),
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            dropdownMenuEntries: <DropdownMenuEntry>[
              DropdownMenuEntry(value: "A", label: "A"),
              DropdownMenuEntry(value: "B", label: "B"),
              DropdownMenuEntry(value: "C", label: "C"),
              DropdownMenuEntry(value: "D", label: "D"),
              DropdownMenuEntry(value: "E", label: "E"),
              DropdownMenuEntry(value: "F", label: "F"),
              DropdownMenuEntry(value: "G", label: "G"),
              DropdownMenuEntry(value: "H", label: "H"),
              DropdownMenuEntry(value: "I", label: "I"),
              DropdownMenuEntry(value: "J", label: "J"),
              DropdownMenuEntry(value: "K", label: "K"),
              DropdownMenuEntry(value: "L", label: "L"),
              DropdownMenuEntry(value: "M", label: "M"),
              DropdownMenuEntry(value: "N", label: "N"),
              DropdownMenuEntry(value: "O", label: "O"),
              DropdownMenuEntry(value: "P", label: "P"),
              DropdownMenuEntry(value: "Q", label: "Q"),
              DropdownMenuEntry(value: "R", label: "R"),
              DropdownMenuEntry(value: "S", label: "S"),
              DropdownMenuEntry(value: "T", label: "T"),
              DropdownMenuEntry(value: "U", label: "U"),
              DropdownMenuEntry(value: "V", label: "V"),
              DropdownMenuEntry(value: "W", label: "W"),
              DropdownMenuEntry(value: "X", label: "X"),
              DropdownMenuEntry(value: "Y", label: "Y"),
              DropdownMenuEntry(value: "Z", label: "Z"),
            ],
            onSelected: (letter) {
              setState(() {
                selectedLetter = letter;
                filterByLetter(letter);
              });
            },
          ),
          SizedBox(width: 20),
          DropdownMenu(
            controller: sportController,
            label: Text('Filter by Sport'),
            initialSelection: "Football",
            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints.tight(
                Size.fromHeight(35),
              ),
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            width: 200,
            dropdownMenuEntries: <DropdownMenuEntry>[
              DropdownMenuEntry(value: "Football", label: "Football"),
              DropdownMenuEntry(value: "Basketball", label: "Basketball"),
              DropdownMenuEntry(value: "Volleyball", label: "Volleyball"),
              DropdownMenuEntry(
                  value: "Track and Field", label: "Track and Field"),
              DropdownMenuEntry(value: "Baseball", label: "Baseball"),
              DropdownMenuEntry(value: "Cross Country", label: "Cross Country"),
              DropdownMenuEntry(value: "Soccer", label: "Soccer"),
              DropdownMenuEntry(value: "Swimming", label: "Swimming"),
              DropdownMenuEntry(value: "Wrestling", label: "Wrestling"),
              DropdownMenuEntry(value: "Golf", label: "Golf"),
              DropdownMenuEntry(value: "Tennis", label: "Tennis"),
              DropdownMenuEntry(value: "Softball", label: "Softball"),
              DropdownMenuEntry(value: "Field Hockey", label: "Field Hockey"),
              DropdownMenuEntry(value: "Lacrosse", label: "Lacrosse"),
              DropdownMenuEntry(value: "Cheerleading", label: "Cheerleading"),
            ],
            onSelected: (sport) {
              setState(() {
                selectedSport = sport;
                filterBySport(sport);
              });
            },
          ),
          SizedBox(width: 20),
        ],
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Athletics Hall of Fame',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        gridOutput(), // Creates a 5 item wide grid, unless the orientation is vertical.
                  ),
                  itemCount: filteredInducteeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.red[900],
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      elevation: 5,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              filteredInducteeList[index]['profile_photo'],
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
                                    '${filteredInducteeList[index]['first_name']} ${filteredInducteeList[index]['last_name']}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    '${filteredInducteeList[index]['sports'].join(', ')}',
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
                                      inductee: filteredInducteeList[index]);
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
                      style: GoogleFonts.poppins(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
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
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.inductee['description'],
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      'Other Photos',
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
