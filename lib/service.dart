import 'package:fabricwash/data.dart';
import 'package:fabricwash/db.dart';
import 'package:fabricwash/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  var loc = await Geolocator.getCurrentPosition();
  return loc.latitude.toString() +","+loc.longitude.toString();
}

class CategoryIncreaser extends StatefulWidget {
  final type;
  const CategoryIncreaser({super.key, required this.type});

  @override
  State<CategoryIncreaser> createState() => _CategoryIncreaserState();
}

class _CategoryIncreaserState extends State<CategoryIncreaser> {
  var count=0;
  @override
  void initState() {
    super.initState();
    for (var i in services) if (i["name"] == widget.type) count = (i["count"] as int? ?? 0);   
  }
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {
            setState(() {
              count++;
              for (var i in services) if (i["name"] == widget.type) i["count"] = count;
            });
          }, icon: Icon(Icons.add_circle_outline, size: 30,)),
          Text("$count", style: TextStyle(fontSize: 15),),
          IconButton(onPressed: () {
            setState(() {
              if (count > 0) count--;
              for (var i in services) if (i["name"] == widget.type) i["count"] = count;
            });
          }, icon: Icon(Icons.remove_circle_outline, size: 30)),
        ],
      ),
    );
  }
}

class CleaningType extends StatefulWidget {
  final type;
  const CleaningType({super.key, required this.type});

  @override
  State<CleaningType> createState() => _CleaningTypeState();
}

class _CleaningTypeState extends State<CleaningType> {
  var cleaning_type = "Wash";
  var itemlist;
  var val;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var x in services) if (x["name"] == widget.type) itemlist = (x["price"] as Map<String, dynamic>).keys.toList();
    for (var i in services) if (i["name"] == widget.type) cleaning_type = i["cleaning_type"] as String?? "Wash";
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: val == null ? itemlist[0] : val,
      onChanged: (value) {
        setState(() {
          val = value.toString();
          cleaning_type = value.toString();
          for (var i in services) if (i["name"] == widget.type) i["cleaning_type"] = cleaning_type;
        });
      },
      items: [
        for (var i in itemlist) DropdownMenuItem(value: i,child: Text(i),)
      ],
    );
  }
}

bill() {
  var totalCost = 0;
  billInfo = [];
  for (var i in services) {
    if ((i["count"] as num? ?? 0) > 0) {
      num? cost = 0;
      if (i.containsKey("price") && i["price"] is Map && i.containsKey("cleaning_type") && i["cleaning_type"] != null && (i["price"] as Map).containsKey(i["cleaning_type"])) {
        cost = (i["price"] as Map)[i["cleaning_type"]] * (i["count"] as num);
      } else {
        cost = 0;
      }
      totalCost += (cost ?? 0).toInt();
      if (i["count"] as num > 0) billInfo.add({"name": i["name"],"count": i["count"],"cleaning_type": i["cleaning_type"],"cost": cost,});
    }
  }
  return totalCost;
}

msg(context, title, message) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Ok"))
      ],
    );
  });
}

update(context, type) {
  var a = new TextEditingController();
  a.text = accountData[type]??"";
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text("Edit "+type),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: a,
            decoration: InputDecoration(
              hintText: "Enter new "+ type,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(onPressed: () {
          f1() async {
            await update_account_details(type, a.text);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Profile();}));
          }
          f1();
        }, child: Text("Save"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 1, 17, 97)),),
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Cancel"))
      ],
    );
  });
}