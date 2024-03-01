import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var photo_displayed = 'profile_photo';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text('Hamburg Area School District',
            style: TextStyle(color: Colors.white, fontSize: 55)),
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
                'Hall of Fame',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: inducteeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            context: context,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            builder: (BuildContext context) {
                              return CardDetail(inductee: inducteeList[index]);
                            },
                          );
                        },
                        child: Card(
                          color: Colors.red[900],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                inducteeList[index]['profile_photo'],
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${inducteeList[index]['first_name']} ${inducteeList[index]['last_name']}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                              SizedBox(height: 5),
                              Text(
                                inducteeList[index]['sports'].join(', '),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.inductee['first_name']} ${widget.inductee['last_name']}',
                  style: TextStyle(fontSize: 24),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  widget.inductee[photo_displayed],
                  width: 500,
                  height: 700,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Induction Year: ${widget.inductee['induction_year']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Divider(
                        endIndent: 1000,
                      ),
                      Text(
                        'Sports: ${widget.inductee['sports'].join(', ')}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Divider(
                        endIndent: 1000,
                      ),
                      Text(
                        'Graduation Year: ${widget.inductee['grad_year']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Divider(
                        endIndent: 1000,
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Description',
                        style: TextStyle(fontSize: 35),
                      ),
                      SizedBox(height: 10),
                      Text(widget.inductee['description'],
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 50),
                      Text(
                        'Other Photos',
                        style: TextStyle(fontSize: 35),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var photo in widget.inductee['other_photos'])
                            GestureDetector(
                              onTap: () {
                                print(photo);

                                setState(() {
                                  //photo_displayed = photo;
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
