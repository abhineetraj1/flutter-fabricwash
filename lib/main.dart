import 'package:fabricwash/db.dart';
import 'package:fabricwash/data.dart';
import 'package:fabricwash/service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Starter(),
    );
  }
}

class Starter extends StatefulWidget {
  const Starter({super.key});

  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {
  session() async {
    if (await verify_account_details()) Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height*0.8,
              child: Center(child: Image.asset("assets/icon.png", height: 100,),),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height*0.2,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 1, 17, 97),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width*0.9,
                      child: ElevatedButton(onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignIn();}));
                      }, child: Text("Sign in"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color.fromARGB(255, 1, 17, 97), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.9,
                    child: ElevatedButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignUp();}));
                    }, child: Text("Sign up"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color.fromARGB(255, 1, 17, 97), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Profile();}));}, icon: Icon(Icons.person)),
              Text("Laundry app"),
              IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) {return OrderHistory();}));}, icon: Icon(Icons.history)),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 1, 17, 97),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          if (bill() > 0) {
            print(bill());
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {return OrderPage();}));
          } else {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("No items selected"),
                content: Text("Please select at least one item to proceed."),
                actions: [
                  TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text("OK"))
                ],
              );
            });
          }
        }, 
          backgroundColor: const Color.fromARGB(255, 1, 17, 97),
          child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
        ),
        body: Column(
          children: [
            for (var i in services) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                    color: const Color.fromARGB(255, 128, 128, 128),
                  )]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(i["image"].toString(), width: 100,),
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(i["name"].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text(i["description"].toString(), style: TextStyle(fontSize: 15),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CleaningType(type: i["name"].toString(),),
                                CategoryIncreaser(type: i["name"].toString(),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var a = TextEditingController();
  var b = TextEditingController();
  var c = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    a.text = accountData["name"].toString();
    b.text = accountData["phone"].toString();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 17, 97),
          title: Row(children: [
            IconButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
            }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
            Text("Back to home", style: TextStyle(color: Colors.white),),
          ],),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i in services) if ((i["count"] as num) > 0) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(i["name"].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text(i["cleaning_type"].toString(), style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ),
                      Text("x"+i["count"].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total bill", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text("₹ "+bill().toString(), style: TextStyle(fontSize: 20,)),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text(accountData["name"].toString(), style: TextStyle(fontSize: 20,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your phone number", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text(accountData["phone"].toString(), style: TextStyle(fontSize: 20,)),
                  ],
                ),
                ElevatedButton(onPressed: () {
                  placeOrder(context) async {
                    if (await place_order()) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Success();}));
                    } else {
                      msg(context, "Error", "Unable to place order. Please try again later.");
                    }
                  }
                  placeOrder(context);
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), child: Text("Schedule"),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 100 ,color: const Color.fromARGB(255, 1, 17, 97),),
                Text("Order successful", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
                }, child: Text("Back to home", style: TextStyle(color: Colors.black),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
              }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)), 
              Text("Profile"),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 1, 17, 97),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          f1() async {
            await delete_account_details();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Starter();}));
          }
          f1();
        }, backgroundColor: const Color.fromARGB(255, 1, 17, 97), child: Icon(Icons.logout, color: Colors.white,),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text("Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Row(
                  children: [
                    Text(accountData["name"], style: TextStyle(fontSize: 20),),
                    IconButton(onPressed: () {
                      update(context, "name");
                    }, icon: Icon(Icons.edit, color: const Color.fromARGB(255, 1, 17, 97),)),
                  ],
                ),
                SizedBox(height: 20,),
                Align(alignment: Alignment.centerLeft, child: Text("Phone", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Row(
                  children: [
                    Text(accountData["phone"], style: TextStyle(fontSize: 20),),
                    IconButton(onPressed: () {
                      update(context, "phone");
                    }, icon: Icon(Icons.edit, color: const Color.fromARGB(255, 1, 17, 97),)),
                  ],
                ),
                SizedBox(height: 20,),
                Align(alignment: Alignment.centerLeft, child: Text("Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Row(
                  children: [
                    Text("*"*(accountData["password"].toString().length), style: TextStyle(fontSize: 20),),
                    IconButton(onPressed: () {
                      update(context, "password");
                    }, icon: Icon(Icons.edit, color: const Color.fromARGB(255, 1, 17, 97),)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatelessWidget {
  var name = TextEditingController();
  var phone = TextEditingController();
  var password = TextEditingController();
  SignUp({super.key});
  _signup(context) async {
    if (await signup(name.text, phone.text, password.text)) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
    } else {
      msg(context,"Sign up", "Phone number is already registered");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 17, 97),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Sign up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter your name",
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter phone number",
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter password",
                          ),
                          obscureText: true,
                        ),
                      ),
                      ElevatedButton(onPressed: () {
                        _signup(context);
                      }, child: Text("Sign up"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),),
                      TextButton(onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignIn();}));
                      }, child: Text("Already have an account?"), style: TextButton.styleFrom(foregroundColor: Colors.black),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  var phone = TextEditingController();
  var password = TextEditingController();
  SignIn({super.key});

  @override
  _signin(context) async {
    if (await signin(phone.text, password.text)) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
    } else {
      msg(context,"Sign in", "Invalid phone number or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 17, 97),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Sign In", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter phone number",
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Enter your password",
                          ),
                          obscureText: true,
                        ),
                      ),
                      ElevatedButton(onPressed: () {
                        _signin(context);
                      }, child: Text("Sign In"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),),
                      TextButton(onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SignUp();}));
                      }, child: Text("Don't have an account?"), style: TextButton.styleFrom(foregroundColor: Colors.black),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var condition = false;
  var parameter;
  fetchOrder()async{
    var orders = await get_order_details();
    setState(() {
      orders = orders;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrder();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
              }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)), 
              Text("Order history"),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 1, 17, 97),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i in ["All","pending", "collected", "processing", "delivered", "cancelled"]) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (i == "All") {
                                condition = false;
                              } else {
                                condition = true;
                              }
                              parameter = i;
                            });    
                          },
                          child: Text(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 1, 17, 97),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                condition ? Column(
                  children: [
                    for (var i in orders) if (i["status"].toString() == parameter.toString()) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: const Color.fromARGB(255, 128, 128, 128),
                          )]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              children: [
                                Align(alignment: Alignment.centerLeft, child: Text(i["datetime"].toString().split(".")[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Status: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        Text(i["status"].toString(), style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                    Row(children: [
                                      Text("Total: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                      Text("₹ "+i["total"].toString(), style: TextStyle(fontSize: 20),),
                                    ],)
                                  ],
                                ),
                                i["status"].toString() == "pending" ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("OTP: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        Text(i["otp"].toString(), style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                    ElevatedButton(onPressed: () {
                                      f1() async {
                                        await cancel_order(i["_id"]);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return OrderHistory();}));
                                      }
                                      f1();
                                    }, child: Text("Cancel"), style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 17, 97), foregroundColor: Colors.white),),
                                  ],
                                ) : Row(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ) : Column(
                  children: [
                    for (var i in orders) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: const Color.fromARGB(255, 128, 128, 128),
                          )]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              children: [
                                Align(alignment: Alignment.centerLeft, child: Text(i["datetime"].toString().split(".")[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Status: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        Text(i["status"].toString(), style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                    Row(children: [
                                      Text("Total: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                      Text("₹ "+i["total"].toString(), style: TextStyle(fontSize: 20),),
                                    ],)
                                  ],
                                ),
                                i["status"].toString() == "pending" ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("OTP: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        Text(i["otp"].toString(), style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                    ElevatedButton(onPressed: () {
                                      f1() async {
                                        await cancel_order(i["_id"]);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {return OrderHistory();}));
                                      }
                                      f1();
                                    }, child: Text("Cancel"), style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 17, 97), foregroundColor: Colors.white),),
                                  ],
                                ) : Row(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}