import 'package:flutter/material.dart';
import 'package:sports_management_updated/payment.dart';

import 'MapUtils.dart';
import 'mainscreen.dart';

class ClubdetailsScreen extends StatefulWidget {
  Sportsclubs data;

  ClubdetailsScreen({required this.data});

  @override
  State<ClubdetailsScreen> createState() => _ClubdetailsScreenState();
}

class _ClubdetailsScreenState extends State<ClubdetailsScreen> {
  List changeColor = [];
  List<ExtraItems> extraItemslist = [];
  List changecolorExtraBox = [false, false, false, false];
  bool isSelected = false;
  bool isselectedtime = false;
  String _dropDownValue = '-----00:00-----';
  List<ExtraItems> extraItemslistSelected = [];

  @override
  void initState() {
    // TODO: implement initState
    extraItemslist.add(ExtraItems(
        name: 'Hoodie',
        image:
            'https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/10167307/2022/4/18/3afd98da-3278-4179-827f-647bbac0e9511650284917884TheRoadsterLifestyleCoMenBlackSolidHoodedSweatshirt1.jpg',
        price: '2099'));
    extraItemslist.add(ExtraItems(
        name: 'Face Towel',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbRXCLqoHhZJZ9BC_On-QgmJpDJl36zIcpGCLO11fEacT_0YH06vIE4fN21xM0-Nsy2lI&usqp=CAU',
        price: '599'));
    extraItemslist.add(ExtraItems(
        name: 'Sport Shoes',
        image:
            'https://rukminim1.flixcart.com/image/332/398/ktizdzk0/shoe/y/b/x/7-ws-9310-tying-grey-original-imag6ut3hzm2zyqm.jpeg?q=50',
        price: '5999'));
    extraItemslist.add(ExtraItems(
        name: 'Sports Band',
        image: 'https://m.media-amazon.com/images/I/51KVto9upnL._SL1240_.jpg',
        price: '299'));

    changeColor.length = widget.data.sportstype.length;
    print('widget.data.sportstype.length -> ${changeColor.length}');

    for (int i = 0; i < changeColor.length; i++) {
      setState(() {
        changeColor[i] = false;
      });
      print("this is changecolor array ${changeColor}");
    }
    // for(int i=0;i<4;i++){
    //  setState(() {
    //    changecolorExtraBox[i]=false;
    //  });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Image.network(
                    widget.data.image,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 250,
                      child: Text(
                        '${widget.data.name}',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        color: Colors.grey.shade300),
                    child: Center(child: Text('${widget.data.ratings}/5')),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: IconButton(
                        onPressed: () {
                          print("this is lat long");
                          MapUtils.openMap(widget.data.lat, widget.data.long);
                        },
                        icon: Icon(Icons.launch_sharp)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                '${widget.data.address}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Select Sports Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.data.sportstype.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                        ),
                        child: Card(
                          elevation: 0,
                          child: ListTile(
                            onTap: () {
                              isSelected = true;
                              for (int it = 0; it < changeColor.length; it++) {
                                if (it == i) {
                                  print("this is i->$i and it$it in iff --> ");
                                  setState(() {
                                    changeColor[it] = true;
                                  });
                                } else {
                                  print("this is i->$i and it$it in else --> ");
                                  setState(() {
                                    changeColor[it] = false;
                                  });
                                }
                              }
                              print(
                                  "now this i sthe changecolor array ${changeColor}");
                            },
                            // selected:changeColor[i] ,
                            tileColor: changeColor[i] == true
                                ? Colors.green.shade200
                                : Colors.white,
                            selectedColor: changeColor[i] == true
                                ? Colors.white
                                : Colors.black,
                            title: Text(
                              "${widget.data.sportstype[i]}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Slot time',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      hint: Text('$_dropDownValue'),
                      items: <String>['8AM - 12PM', '2PM - 6PM', '7PM - 10PM']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _dropDownValue = val!;
                          isselectedtime = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 160,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: extraItemslist.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                    onTap: () {
                      print("clicking in tap");
                      extraItemslistSelected.add(ExtraItems(
                          name: extraItemslist[index].name,
                          image: extraItemslist[index].image,
                          price: extraItemslist[index].price));
                      for (int it = 0; it < extraItemslist.length; it++) {
                        print("this i si->$index and this is it -> $it");
                        if (it == index) {
                          setState(() {
                            changecolorExtraBox[it] = !changecolorExtraBox[it];
                          });
                        }
                        // else{
                        //  setState(() {
                        //    changecolorExtraBox[it]=false;
                        //  });
                        // }
                      }
                      print(" this is changecolor box $changecolorExtraBox");
                    },
                    child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: changecolorExtraBox[index] == true
                              ? Colors.green.shade200
                              : Colors.white,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image.network(
                                extraItemslist[index].image,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                extraItemslist[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Rs.${extraItemslist[index].price}',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 20,
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isSelected && isselectedtime
                  ? () {
                      goTocheckout();
                    }
                  : null,
              child: Text('Proceed to Book'),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(isSelected && isselectedtime ? Colors.green : Colors.grey))
            ),
          ),
        ));
  }

  goTocheckout() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(extraItemslistSelected)));
  }
}

class ExtraItems {
  String name, image, price;

  ExtraItems({required this.name, required this.image, required this.price});
}
