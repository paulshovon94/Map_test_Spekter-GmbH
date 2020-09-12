import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _controller;
  Set<Marker> allMarkers = Set.from([]);
  Position _position; // for containing geolocator position
  double latitudeData = 0; //for holding my current latitude
  double longitudeData = 0; //for holding my current longitude
  final myController =
      TextEditingController(); // text controller to retrieve the current value

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myController.dispose();
  }

  @override
  //to initially assign my location before anything else
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation(); // to get my current location
  }

  //user defined function
  getCurrentLocation() async {
    _position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData = _position.latitude; //assigning my latitude to latitudeData
      longitudeData =
          _position.longitude; //assigning my longitude to longitudeData
    });
  }

  //my custom button to return to my location
  moveToHome() {
    _controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_position.latitude, _position.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: allMarkers,
        initialCameraPosition: CameraPosition(
          target: LatLng(23.735482, 90.430879),
          zoom: 15,
        ),
        onMapCreated: (controller) => {
          setState(() {
            _controller = controller;
            //placing marker in my location when map loads
            Marker mk = Marker(
                markerId: MarkerId('1'),
                position: LatLng(latitudeData, longitudeData),
                infoWindow: InfoWindow(
                    title: 'SHOVON PAUL', snippet: 'This is my address'),
                onTap: () {
                  //calling Modal when touched my location marker
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          color: Color(0xFF737373),
                          height: 450,
                          child: Container(
                            //Calling _buildBottomNavigationMenu() widget method
                            child: _buildBottomNavigationMenu(),
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(30),
                                  topRight: const Radius.circular(30),
                                )),
                          ),
                        );
                      });
                });
            allMarkers.add(mk);
          }),
        },
        onTap: (coordinates) {
          // tap to move the map
          _controller.animateCamera(CameraUpdate.newLatLng(coordinates));
        },
      ),
      // floating action button to return to my location
      floatingActionButton: Tooltip(
        message: 'Return to my Place',
        child: FloatingActionButton(
          child: Icon(
            Icons.home,
            size: 35,
          ),
          onPressed: () {
            //calling the function to return to my place
            moveToHome();
          },
        ),
      ),
      // bottom notification bar with notch
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Container(
          height: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextField(
            controller: myController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Shovon Paul',
            ),
          ),
          leading: Icon(Icons.person),
          //title: Text('SHOVON PAUL'),
          //subtitle: Text('46/8 Basaboo, Dhaka-1214.'),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Location'),
          subtitle: Text('$latitudeData, $longitudeData'),
        ),
        Tooltip(
          message: 'Send value to console',
          //button to show it to the console
          child: RaisedButton(
            onPressed: () {
              // To check if the textField is empty or not
              if (myController.text == '') {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                            "Empty Field!!!! \nFirst enter Name then press 'SUBMIT'"),
                      );
                    });
              } else {
                print(myController.text);
                print('latitude= $latitudeData\nlongitude= $longitudeData');
                myController.clear();
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Printed in console"),
                      );
                    });
              }
            },
            child: Text('SUBMIT'),
          ),
        )
      ],
    );
  }
}
