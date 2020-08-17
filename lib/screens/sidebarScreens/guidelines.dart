import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/styles.dart';


class Guidelines extends StatelessWidget {
  final List guidelineListMentors=SidebarConstants.guidelinesMentors;
  final List guidelineListMentees=SidebarConstants.guidelinesMentees;

  Widget guidelineList(){
      return Center(
        child: Container(
            child:ListView.builder(
            itemCount: guidelineListMentors.length+1,
            itemBuilder: (context,index){
              if(index==0){
                return Container(
                  padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                  child:Text("Guildelines for Mentors",style: headingDecoration,textAlign: TextAlign.center, )
                );
              }
              else if(index<11){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal:15.0,vertical:8.0),
                  child:Text((index).toString()+". "+guidelineListMentors[index-1])
                );
              }
              else if(index==11){
                return Container(
                  padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                  child:Text("Guildelines for Mentees",style: headingDecoration,textAlign: TextAlign.center, )
                );
              }
              else{
                return Container(
                  padding: EdgeInsets.symmetric(horizontal:15.0,vertical:8.0),
                  child:Text((index-11).toString()+". "+guidelineListMentors[index-1])
                );
              }
            }
            ),
        )
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Code of Conduct"), backgroundColor: AppColors.COLOR_TEAL_LIGHT),
      body: guidelineList()
    );
  }
}