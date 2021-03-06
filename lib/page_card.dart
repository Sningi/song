import 'dart:async';
import 'package:flutter/material.dart';
import 'util_db.dart';
import 'global_config.dart';

class CardPage extends StatefulWidget {
  CardPage({@required this.ptheme,@required this.initdata,@required this.color});
  final ptheme;
  final initdata;
  final color;
  @override
  _CardPageState createState() => new _CardPageState();
}

class _CardPageState extends State<CardPage>{


  // RefreshIndicator requires key to implement state
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();
  Map data;
  var backimg;

  Future<Null> _refresh() {
    return getData(widget.ptheme,0).then((resultdata) {
      setState(() {
        if(resultdata!=null){
          data =resultdata;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    backimg=ExactAssetImage(GlobalConfig.backimg[widget.ptheme]);
    // 初始数据
    data=widget.initdata;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.ptheme.toString()+" page build");
    return Scaffold(
      backgroundColor:GlobalConfig.appBackgroundColor,
      body: RefreshIndicator(
        key: _refreshKey,
        // child is typically ListView or CustomScrollView
        child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:5.0,left: 15.0,right: 15.0),
                child:Row(
                    children: <Widget>[
                        RaisedButton(
                          onPressed:(){speech(data);},
                          color: Colors.blue,
                          child: Row(children: <Widget>[
                            Icon(Icons.audiotrack,size: 23.0),
                            Text("朗读",
                                style: TextStyle(
                                color: widget.color,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 5.0,
                                fontFamily: GlobalConfig.font
                                ),
                            )
                          ],
                          ),
                          ),
                        Padding(padding: EdgeInsets.only(left: 10.0),),
                        RaisedButton(
                            onPressed:stopspeech,
                            color: Colors.blue,
                            child: Row(children: <Widget>[
                              Icon(Icons.stop,size: 23.0),
                              Text("停止",
                                style: TextStyle(
                                    color: widget.color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 5.0,
                                    fontFamily: GlobalConfig.font
                                ),
                              )
                            ],
                            )
                        ),
//                        Padding(padding: EdgeInsets.only(left: 10.0),),
//                        RaisedButton(
//                            onPressed:_continuespeech,
//                            color: Colors.blue,
//                            child: Row(children: <Widget>[
//                              Icon(Icons.last_page,size: 23.0),
//                              Text("继续",
//                                style: TextStyle(
//                                    color: widget.color,
//                                    fontSize: 16.0,
//                                    fontWeight: FontWeight.bold,
//                                    letterSpacing: 5.0,
//                                    fontFamily: GlobalConfig.fonts
//                                ),
//                              )
//                            ],
//                            )
//                        ),
                    ]
                   ),
//                    decoration: BoxDecoration(
//                      border: Border.all(width: 1.0, color: Colors.blue),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      color:Colors.blue,
//                    ),
                 ),
//              Padding(padding: new EdgeInsets.only(top: 10,bottom: 10.0),),
              Container(
                margin: const EdgeInsets.only(left:15.0,right: 15.0,bottom: 15.0,top: 10.0),
                decoration: new BoxDecoration(
                  border: new Border.all(width: 2.0, color: Colors.purple),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                  image: new DecorationImage(
                      image:backimg,
                      fit: BoxFit.cover
                  ),
                ),
                child: _buildpoem()
              ),
            ]
        ),
        onRefresh: _refresh,
      ),
    );
  }


  Widget _buildpoem(){
    if(GlobalConfig.backfromlove){
//      print("重新确定");
    getData(widget.ptheme, data["id"]).then((resultdata) {
        if(resultdata!=null){
          if(resultdata["love"]!=data["love"]){
            setState(() {
              data["love"]=resultdata["love"];
            });
          }
        }
      });
    if(widget.ptheme==3)
      GlobalConfig.backfromlove=false;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Container(
            margin: EdgeInsets.only(right:15.0),
            child:new Align(
              alignment:FractionalOffset.topRight,
              child: FloatingActionButton(
                child: Icon(Icons.favorite,size: 30,color:  data["love"]==0?Color(0xFFB0B0B0):Colors.red,),
                onPressed: () {
                  setState(() {
                    data["love"]==0?data["love"]=1:data["love"]=0;
                    dbUpdateLove(data["id"],data["love"],widget.ptheme);
                  });
                },
                elevation: 0.0,
                backgroundColor: Color(0x00000000),
              ),
            ),
          ),
          Text(
            data["title"],
            style: TextStyle(
                color: widget.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
                fontFamily: GlobalConfig.font
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 3.0),
            child:Text(
              data["author"],
              style: TextStyle(
                  color: widget.color,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 5.0,
                  fontFamily: GlobalConfig.font
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0,left: 10.0,bottom: 20.0,top: 4.0),
            child:Text(
              data["content"],
              style: TextStyle(
                  color: widget.color,
                  fontSize: 18.0,
                  height: 1.2,
                  fontWeight: FontWeight.normal,
                  fontFamily: GlobalConfig.font
              ),
            )
            ,)

        ]
    );
  }

}
