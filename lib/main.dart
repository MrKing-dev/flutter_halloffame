import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Global Variables

var photo_displayed = '';
String selectedLetter = '';
String selectedSport = '';

void main() => runApp(MyApp());

//Main app declaration
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
  //Local Variables
  late List<Map<String, dynamic>> inducteeList;
  late List<Map<String, dynamic>> filteredInducteeList;
  final _letterKey = GlobalKey<FormState>();
  final _sportKey = GlobalKey<FormState>();
  Timer? _timer;
  bool _showScreensaver = false;
  int _currentIndex = 0;

  final TextEditingController letterController = TextEditingController();
  final TextEditingController sportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInducteeList();
    _startTimer();
  }

  //Load json list into inducteeList and filteredInducteeList
  Future<void> _loadInducteeList() async {
    final jsonString = await rootBundle.loadString('assets/inductee_list.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      _letterKey.currentState?.reset();
      _sportKey.currentState?.reset();
      letterController.clear();
      sportController.clear();
      selectedLetter = '';
      selectedSport = '';
      inducteeList = List<Map<String, dynamic>>.from(jsonData);
      inducteeList.sort((a, b) => a['last_name'].compareTo(b['last_name']));
      filteredInducteeList = List<Map<String, dynamic>>.from(inducteeList);
    });
  }

  //Filter inducteeList by letter
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

  //Filter inducteeList by sport
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

  //Determine grid output based on screen orientation
  int gridOutput() {
    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      return 3;
    } else {
      return 5;
    }
  }

  //Dispose of timer
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //Start timer for screensaver
  void _startTimer() {
    const Duration screensaverDuration = Duration(minutes: 1);
    _timer = Timer(screensaverDuration, () {
      setState(() {
        _showScreensaver = true;
        Timer timerPeriodic =
            Timer.periodic(const Duration(seconds: 15), (timer) {
          if (_showScreensaver == false) {
            timer.cancel();
          }
          setState(() {
            //_currentIndex = Random().nextInt(filteredInducteeList.length);
            _currentIndex = (_currentIndex + 1) % filteredInducteeList.length;
          });
        });
      });
    });
  }

  //Reset timer for screensaver
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _showScreensaver = false;
    });
    _startTimer();
  }

  bool isMobile() {
    return MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //GestureDetector to reset timer on tap
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      child: _showScreensaver //If screensaver is active, display screensaver
          ? Center(
              child: AnimatedSwitcher(
                  duration: Duration(seconds: 5),
                  child: CardWidget(
                      inducteeData: filteredInducteeList[_currentIndex])))
          : Scaffold(
              //If screensaver is not active, display main app
              appBar: AppBar(
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
                      //Refresh button
                      iconSize: 40,
                      onPressed: () {
                        _loadInducteeList();
                      },
                      icon: Icon(Icons.refresh)),
                  SizedBox(width: 20),
                  DropdownMenu(
                    //Dropdown menu for filtering by letter
                    controller: letterController,
                    key: _letterKey,
                    label:
                        isMobile() ? Text('Name') : Text('Filter by Last Name'),
                    width: isMobile() ? 75 : 250,
                    initialSelection: "A",
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
                    //Dropdown menu for filtering by sport
                    controller: sportController,
                    key: _sportKey,
                    label: isMobile() ? Text('Sport') : Text('Filter by Sport'),
                    width: isMobile() ? 75 : 250,
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

                    dropdownMenuEntries: <DropdownMenuEntry>[
                      DropdownMenuEntry(value: "Football", label: "Football"),
                      DropdownMenuEntry(
                          value: "Basketball", label: "Basketball"),
                      DropdownMenuEntry(
                          value: "Volleyball", label: "Volleyball"),
                      DropdownMenuEntry(
                          value: "Track and Field", label: "Track and Field"),
                      DropdownMenuEntry(value: "Baseball", label: "Baseball"),
                      DropdownMenuEntry(
                          value: "Cross Country", label: "Cross Country"),
                      DropdownMenuEntry(value: "Soccer", label: "Soccer"),
                      DropdownMenuEntry(value: "Swimming", label: "Swimming"),
                      DropdownMenuEntry(value: "Wrestling", label: "Wrestling"),
                      DropdownMenuEntry(value: "Golf", label: "Golf"),
                      DropdownMenuEntry(value: "Tennis", label: "Tennis"),
                      DropdownMenuEntry(value: "Softball", label: "Softball"),
                      DropdownMenuEntry(
                          value: "Field Hockey", label: "Field Hockey"),
                      DropdownMenuEntry(value: "Lacrosse", label: "Lacrosse"),
                      DropdownMenuEntry(
                          value: "Cheerleading", label: "Cheerleading"),
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
                  //Background image
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
                        //Title
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Athletics Hall of Fame',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          //Grid of inductees
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                    // Profile Image
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Image.asset(
                                      filteredInducteeList[index]
                                          ['profile_photo'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                      // Gradient overlay
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
                                      // Info
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          // Name
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            '${filteredInducteeList[index]['first_name']} ${filteredInducteeList[index]['last_name']}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 32,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          // Sports
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            '${filteredInducteeList[index]['sports'].join(', ')}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    // Manage card tap
                                    onTap: () {
                                      showModalBottomSheet<dynamic>(
                                        isScrollControlled: true,
                                        elevation: 8,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CardDetail(
                                              inductee:
                                                  filteredInducteeList[index]);
                                        },
                                        constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
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

// Card for inductee details
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
                iconSize: 55,
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
                // Profile Image
                child: Image.asset(
                  photo_gallery
                      ? photo_displayed
                      : widget.inductee['profile_photo'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      // Name
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${widget.inductee['first_name']} ${widget.inductee['last_name']}',
                        style: GoogleFonts.poppins(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      // Info
                      'Induction Year: ${widget.inductee['induction_year']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    Divider(),
                    Text(
                      'Sports: ${widget.inductee['sports'].join(', ')}',
                      style: TextStyle(fontSize: 24),
                    ),
                    Divider(),
                    Text(
                      widget.inductee['grad_year'] == null
                          ? 'Coach'
                          : 'Graduation Year: ${widget.inductee['grad_year']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    FittedBox(
                      // Description Title
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.inductee['description'], // Description
                        style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                    /*Text(
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
                    ),*/
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}

//Card for screensaver
class CardWidget extends StatelessWidget {
  final Map<String, dynamic> inducteeData;

  CardWidget({Key? key, required this.inducteeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.red[900],
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      elevation: 5,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              inducteeData['profile_photo'],
              fit: BoxFit.contain,
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
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${inducteeData['first_name']} ${inducteeData['last_name']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 75,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${inducteeData['sports'].join(', ')}',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Tap Anywhere to Proceed",
                  style: TextStyle(color: Colors.white, fontSize: 35)),
            ),
          ),
        ],
      ),
    );
  }
}
