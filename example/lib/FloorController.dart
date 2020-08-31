import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapwize/mapwize.dart';

typedef void OnFloorTapCallback(Floor floor);

class FloorControllerWidget extends StatefulWidget {

  FloorControllerWidget({Key key, this.floors, this.floor, this.onFloorTapCallback});

  List<Floor> floors = List();
  Floor floor = null;
  OnFloorTapCallback onFloorTapCallback;

  @override
  State<StatefulWidget> createState() {
    return _FloorControllerWidgetState();
  }

}

class _FloorControllerWidgetState extends State<FloorControllerWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 50),
      //color: Color(0xFFFFFFFF),
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: widget.floors.length,
          itemBuilder: (BuildContext context, int index) {
            if (widget.floors[index].number == widget.floor.number) {
              return Padding(
                  padding: EdgeInsets.all(2),
                  child: GestureDetector(
                      onTap: () => widget.onFloorTapCallback(widget.floors[index]),
                      child: Container(
                          decoration: new BoxDecoration(
                            color: Color(0xFFC51586),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          //color: Color(0xFFC51586),
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Text(
                                '${widget.floors[index].name}',
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF)
                                ),)
                          )
                      )
                  )
              );
            }
            else {
              return Padding(
                padding: EdgeInsets.all(2),
                child: GestureDetector(
                    onTap: () => widget.onFloorTapCallback(widget.floors[index]),
                    child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 40,
                        width: 40,
                        child: Center(child: Text('${widget.floors[index].name}'),)
                    )
                )
              );
            }
          }
      ),
    );
  }

}