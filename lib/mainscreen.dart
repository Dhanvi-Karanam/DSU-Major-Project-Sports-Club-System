import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'clubdetails.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  double value = 3.5;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Sportsclubs> sportclublist = [];
  List<Sportsclubs> selectedsportclublist = [];
  int isSelected = 1;
  String? _currentAddress;
  Position? _currentPosition;
  List sorted_distance = [];

  FutureOr<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _handleLocationPermission();
    get_position();
    super.initState();
  }

  get_position() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      getData();
    });
    print(
        "this is lat long of getposition ${_currentPosition!.latitude},${_currentPosition!.longitude}");
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((value) {
      print("this is placemark ${value[0].subLocality}");
      setState(() {
        _currentAddress = value[0].subLocality;
      });
    });
  }

  calculatedistance(lat1, long1) {
    print("this is lat long here for all ${lat1}   ,${long1}");
    print(
        'this is original latlong ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((_currentPosition!.latitude - lat1) * p) / 2 +
        c(lat1 * p) *
            c(_currentPosition!.latitude * p) *
            (1 - c((_currentPosition!.longitude - long1) * p)) /
            2;
    print(" this is calculated distance ${(12742 * asin(sqrt(a)))}");
    return 12742 * asin(sqrt(a));
  }

  getData() async {
    CollectionReference sportclubs =
        FirebaseFirestore.instance.collection('sport-club');
    QuerySnapshot snapshot = await sportclubs.get();
    var documents = snapshot.docs;
    List<DocumentSnapshot> docs = documents;
    docs.forEach((data) {
      print("init output ${data.get('name')}");
      setState(() {
        sportclublist.add(Sportsclubs(
            id: data.id,
            name: data.get('name'),
            image: data.get('image'),
            ratings: data.get('ratings'),
            address: data.get('address'),
            sportstype: data.get('sporttype'),
            lat: data.get('lat'),
            long: data.get('long'),
            distance: calculatedistance(data.get('lat'), data.get('long'))));
        selectedsportclublist = sportclublist;
      });
      print("this is lenght of sewlect list  ${selectedsportclublist.length}");
    });
    print(
        "this is sportsclublist data ${sportclublist[0].name},${sportclublist[0].id}, ${sportclublist[0].image}, ${sportclublist[0].ratings}");

    for (int i = 0; i < sportclublist.length; i++) {
      for (int j = i + 1; j < sportclublist.length; j++) {
        if (sportclublist[i].distance > sportclublist[j].distance) {
          setState(() {
            Sportsclubs temp = sportclublist[i];
            sportclublist[i] = sportclublist[j];
            sportclublist[j] = temp;
          });
        }
      }
    }
    print(
        "this is sportsclublist data sorted ${sportclublist[0].name},${sportclublist[0].id}, ${sportclublist[0].image}, ${sportclublist[0].ratings}");
    print('this is the sports club lenght ${sportclublist.length} ');
  }

  Widget build(BuildContext context) {
    print("Baber");
    CollectionReference sportclubs =
        FirebaseFirestore.instance.collection('sport-club');
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(10, 100),
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: AppBar(
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                ),
                SizedBox(
                  width: 20,
                )
              ],
              flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 34, left: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 35,
                      ),
                      Text(
                        '${_currentAddress ?? 'Bangalore'}',
                        style: TextStyle(
                            fontSize: 25,
                            decorationColor: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                      ),
                    ],
                  )),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    //suffixIcon: Icon(Icons.),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              print('inside all');
                              setState(() {
                                isSelected = 1;
                                selectedsportclublist = sportclublist;
                              });
                              print(
                                  "this is selected list -> ${selectedsportclublist.length} ");
                            },
                            child: Container(
                              height: 4,
                              width: 80,
                              child: Center(
                                  child: Text(
                                'All',
                                style: TextStyle(
                                    color: isSelected == 1
                                        ? Colors.white
                                        : Colors.black),
                              )),
                              decoration: BoxDecoration(
                                color: isSelected == 1
                                    ? Colors.blue.shade200
                                    : Colors.grey.shade200,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 2;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('table tennis') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 90,
                            child: Center(
                                child: Text(
                              'Table Tennis',
                              style: TextStyle(
                                  color: isSelected == 2
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 2
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 3;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('chess') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Chess',
                              style: TextStyle(
                                  color: isSelected == 3
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 3
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 4;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('cricket') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Cricket',
                              style: TextStyle(
                                  color: isSelected == 4
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 4
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 5;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('carrom') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Carrom',
                              style: TextStyle(
                                  color: isSelected == 5
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 5
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 6;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('badminton') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 85,
                            child: Center(
                                child: Text(
                              'Badminton',
                              style: TextStyle(
                                  color: isSelected == 6
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 6
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 7;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('billiards') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Billiards',
                              style: TextStyle(
                                  color: isSelected == 7
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 7
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 8;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('swimming') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 85,
                            child: Center(
                                child: Text(
                              'Swimming',
                              style: TextStyle(
                                  color: isSelected == 8
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 8
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 9;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('foosball') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Foosball',
                              style: TextStyle(
                                  color: isSelected == 9
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 9
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 10;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('football') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Football',
                              style: TextStyle(
                                  color: isSelected == 10
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 10
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = 11;
                            });
                            selectedsportclublist = [];
                            for (int i = 0; i < sportclublist.length; i++) {
                              print(
                                  "this is the length of each index sporttype ${sportclublist[i].sportstype.length} ");
                              for (int j = 0;
                                  j < sportclublist[i].sportstype.length;
                                  j++) {
                                print(
                                    "this is the valueof sporttype in $j index ${sportclublist[i].sportstype[j]}");
                                if (sportclublist[i]
                                        .sportstype[j]
                                        .toLowerCase()
                                        .compareTo('hockey') ==
                                    0) {
                                  print("these sportsclub have tt ");
                                  selectedsportclublist.add(Sportsclubs(
                                      id: sportclublist[i].id,
                                      name: sportclublist[i].name,
                                      image: sportclublist[i].image,
                                      ratings: sportclublist[i].ratings,
                                      address: sportclublist[i].address,
                                      sportstype: sportclublist[i].sportstype,
                                      lat: sportclublist[i].lat,
                                      long: sportclublist[i].long,
                                      distance: calculatedistance(
                                          sportclublist[i].lat,
                                          sportclublist[i].long)));
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 80,
                            child: Center(
                                child: Text(
                              'Hockey',
                              style: TextStyle(
                                  color: isSelected == 11
                                      ? Colors.white
                                      : Colors.black),
                            )),
                            decoration: BoxDecoration(
                              color: isSelected == 11
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: selectedsportclublist.length,
                      itemBuilder: (BuildContext context, int i) {
                        return selectedsportclublist.length == 0
                            ? Center(
                                child: Text(
                                    "Oops no data avaiable of your selection"),
                              )
                            : GestureDetector(
                                onTap: () {
                                  goToDetailScreen(selectedsportclublist[i]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2.0,
                                            color: Colors.black12,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 200,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //Text("qwerttt",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
                                                    Text(
                                                      "${selectedsportclublist[i].name}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0),
                                                      child: RatingStars(
                                                        value:
                                                            selectedsportclublist[
                                                                    i]
                                                                .ratings,
                                                        onValueChanged: (v) {
                                                          //
                                                          setState(() {
                                                            value = v;
                                                          });
                                                        },
                                                        starBuilder:
                                                            (index, color) =>
                                                                Icon(
                                                          Icons.sports_cricket,
                                                          color: color,
                                                        ),
                                                        starCount: 5,
                                                        starSize: 20,
                                                        valueLabelColor:
                                                            const Color(
                                                                0xff9b9b9b),
                                                        valueLabelTextStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.0),
                                                        valueLabelRadius: 10,
                                                        maxValue: 5,
                                                        starSpacing: 2,
                                                        maxValueVisibility:
                                                            true,
                                                        valueLabelVisibility:
                                                            true,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        valueLabelPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 1,
                                                                horizontal: 8),
                                                        valueLabelMargin:
                                                            const EdgeInsets
                                                                .only(right: 8),
                                                        starOffColor:
                                                            const Color(
                                                                0xffe7e8ea),
                                                        starColor:
                                                            Colors.yellow,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Open',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        '${double.parse((selectedsportclublist[i].distance).toStringAsFixed(2))} km',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 14))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  color: Colors.blue,
                                                  width: 100,
                                                  child: Image.network(
                                                      "${selectedsportclublist[i].image}") //Image.asset('assets/logo_list.jpeg'),
                                                  )
                                            ],
                                          ))),
                                ),
                              );
                      }))
            ],
          ),
        ));
  }

  goToDetailScreen(data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ClubdetailsScreen(data: data)));
  }

  Widget ListviewBuilder() {
    return ListView.builder(
        itemCount: 12,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
                height: 103,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Whitefieild Sports Club",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: RatingStars(
                                  value: value,
                                  onValueChanged: (v) {
                                    //
                                    setState(() {
                                      value = v;
                                    });
                                  },
                                  starBuilder: (index, color) => Icon(
                                    Icons.sports_cricket,
                                    color: color,
                                  ),
                                  starCount: 5,
                                  starSize: 20,
                                  valueLabelColor: const Color(0xff9b9b9b),
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: true,
                                  animationDuration:
                                      Duration(milliseconds: 1000),
                                  valueLabelPadding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 8),
                                  valueLabelMargin:
                                      const EdgeInsets.only(right: 8),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: Colors.yellow,
                                ),
                              ),
                              Text(
                                'Open',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.blue,
                          width: 100,
                          child: Image.asset('assets/logo_list.jpeg'),
                        )
                      ],
                    ))),
          );
        });
  }

  Widget ListviewWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 20),
        child: ListView(
          children: [
            Container(
                height: 103,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Whitefieild Sports Club",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: RatingStars(
                                  value: value,
                                  onValueChanged: (v) {
                                    //
                                    setState(() {
                                      value = v;
                                    });
                                  },
                                  starBuilder: (index, color) => Icon(
                                    Icons.sports_cricket,
                                    color: color,
                                  ),
                                  starCount: 5,
                                  starSize: 20,
                                  valueLabelColor: const Color(0xff9b9b9b),
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: true,
                                  animationDuration:
                                      Duration(milliseconds: 1000),
                                  valueLabelPadding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 8),
                                  valueLabelMargin:
                                      const EdgeInsets.only(right: 8),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: Colors.yellow,
                                ),
                              ),
                              Text(
                                'Open',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.blue,
                          width: 100,
                          child: Image.asset('assets/logo_list.jpeg'),
                        )
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                  title: Text('whitefeild sports club'),
                  trailing: Container(
                    height: 120,
                    width: 100,
                    child: Image.asset('assets/logo_list.jpeg'),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black12,
                        )
                      ],
                    ),
                  )),
            ),
            Divider(
              color: Colors.black,
              thickness: 0.7,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                  title: Text('whitefeild sports club'),
                  trailing: Image.asset('assets/logo_list.jpeg')),
            ),
          ],
        ),
      ),
    );
  }
}

class Sportsclubs {
  String id, name, image, address;
  double lat, long;
  double distance;
  double ratings;
  List sportstype;

  Sportsclubs(
      {required this.id,
      required this.name,
      required this.image,
      required this.ratings,
      required this.address,
      required this.sportstype,
      required this.lat,
      required this.long,
      required this.distance});
}
