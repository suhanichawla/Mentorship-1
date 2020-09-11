// import 'package:chatApp/common/widgets.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  //final String chatRoomID;
  final String userID;
  final String peerID;
  final String peerName;
  final String profPic;
  ConversationScreen(this.userID,this.peerID,this.peerName,this.profPic);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController =new TextEditingController();
  DataBaseService databaseMethods=new DataBaseService();
  Stream chatMessageStream;
  String chatRoomId;
  var peerData;
  @override
  void initState(){
    
    initialise();
     super.initState();
    
  }

  void initialise() async{
    List<String> users=[widget.userID,widget.peerID];
    String chatRoomID=getChatRoomId(widget.userID,widget.peerID);
    setState(() {
      chatRoomId=chatRoomID;
    });
    Map<String, dynamic> chatRoomMap={
      "users":users,
      "ChatRoomID":chatRoomID
    };
    await databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
    var messageList= await databaseMethods.getConversationMessages(chatRoomID);
    print(messageList);
    setState(() {
      chatMessageStream=messageList;
    });
     
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.documents[index].data["message"],snapshot.data.documents[index].data["sentBy"]==widget.userID);
          }
          ): Container();
      },
      );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap={
      "message":messageController.text,
      "sentBy": widget.userID,
      "time":DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(chatRoomId, messageMap);
      messageController.text='';
    }
    
  }

  @override
  Widget build(BuildContext context) {

    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag=_themeNotifier.darkTheme;

    return Scaffold(
      appBar: new AppBar(
          backgroundColor: themeFlag ? null: AppColors.COLOR_TEAL_LIGHT,
            title:  Container(
                child:Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 20,
                      child: ClipOval(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.network(widget.profPic)
                        ))),
                        SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PeerProfile(widget.peerID)));
                      },
                      child: Container(child: Text(widget.peerName))
                      )
                  ],
                )
              )
            ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 72, top: 8),
              child: ChatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: themeFlag? Colors.grey[700]: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal:24,vertical:8),
                child: Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller:messageController,
                        style: TextStyle(
                          color: themeFlag? Colors.white : Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter message..",
                          hintStyle: TextStyle(
                            color: themeFlag? Colors.white : Colors.black87,
                            fontFamily: 'GoogleSans'
                            ),
                          border: InputBorder.none
                        ),
                      )
                      ),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   colors: [
                        //     const Color(0x0FFFFFFF),
                        //     const Color(0x0FFFFFFF)
                        //   ]
                        //   ),
                          borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.send)),
                  )
                ],),
              ),
            )
          ],
          
          ),
      )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message,this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag=_themeNotifier.darkTheme;

    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 0:24, right:isSentByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical:2),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight:Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical:6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: isSentByMe? AppColors.PROTEGE_CYAN : themeFlag? Colors.grey[700] : AppColors.PROTEGE_GREY,
              // gradient: LinearGradient(
              //   colors: isSentByMe ?  [
              //      const Color(0xff96ECE7),
              //      const Color(0xff96ECE7)
              //   ]:[
              //     const Color(0xff565656),
              //     const Color(0xff565656)
              //   ]
              // )
            ),
        child:Text(message,style:TextStyle(
          color: isSentByMe? Colors.black : Colors.white,
          fontSize:17,
          fontFamily: 'GoogleSans'
        ) 
        )
      ),
    );
  }
}