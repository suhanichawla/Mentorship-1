import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/ResourceCenter/resource.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ResourceList extends StatefulWidget {
  final String resourceField;
  final String collectionName;
  ResourceList(this.resourceField, this.collectionName);
  @override
  _ResourceListState createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final _formKey = GlobalKey<FormState>();
  List<DocumentSnapshot> resourcesList = [];

  @override
  void initState() {
    DataBaseService()
        .getCurrentCollectionData(widget.collectionName)
        .then((value) {
      print(value.documents[0].data.runtimeType);
      setState(() {
        resourcesList = value.documents;
        //print(resourcesList.length);
      });
    });
    super.initState();
  }

  Widget resourceList() {
    return resourcesList.length == 0
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text("No resources available yet"),
                ),
              )
            : Expanded(
                child: SizedBox(
                  height: 20.0,
                  child: new ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: resourcesList.length,
                    itemBuilder: (context, index) {
                      return ResourceTile(resourcesList[index].data["Title"],
                          resourcesList[index].data["Link"]);
                    },
                  ),
                ),
              )
        // Align(
        //     alignment: Alignment.center,
        //     child: ListView.builder(
        //         itemCount: resourcesList.length,
        //         itemBuilder: (context, index) {
        //           return ResourceTile(resourcesList[index].data["Title"],
        //               resourcesList[index].data["Link"]);
        //         }),
        //   )

        // ))
        // )
        ;
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return new Scaffold(
        // appBar: new AppBar(
        //     title: new Text(widget.resourceField),
        //     backgroundColor: AppColors.COLOR_TEAL_LIGHT),
        backgroundColor: AppColors.COLOR_TEAL_LIGHT,
        // backgroundColor: Hexcolor("#d6a495"),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 7,
                child: Container(
                    decoration: BoxDecoration(
                        color: themeFlag ? Color(0xFF303030) : Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100))),
                    child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 32),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(height: 25),
                            new Text(widget.resourceField,
                                style: TextStyle(
                                    fontFamily: 'GoogleSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32)),
                            resourceList()
                          ],
                        )))),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(15))),
                  // child: resourceList()
                )),
          ],
        ));
  }
}
