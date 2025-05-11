var service="";
var cost=0;
var accountData;
var billInfo=[];
var mongoDB="mongodb://10.0.2.2:27017/dhobi";
var orders=[];
var services=[
  {
    "name":"Light clothes",
    "description":"Shirts, T-shirts, pant etc.",
    "price":{
      "Wash": 20,
      "Dry Clean": 50,
      "Iron": 10,
      "Iron Wash": 30,
    },
    "cleaning_type":"Wash",
    "count":0,
    "image":"assets/light.png",
  },
  {
    "name":"Heavy clothes",
    "description":"Jeans, blanket, bedsheets etc.",
    "price":{
      "Wash": 30,
      "Dry Clean": 70,
      "Iron": 20,
      "Iron Wash": 50,
    },
    "cleaning_type":"Wash",
    "count":0,
    "image":"assets/heavy.png",
  },
  {
    "name":"Suit",
    "description":"Coat, trouser, saree etc.",
    "price":{
      "Dry Clean": 100,
      "Iron": 30,
    },
    "cleaning_type":"Wash",
    "count":0,
    "image":"assets/suit.png",
  },
  {
    "name":"Footwear",
    "description":"Shoes, sandals etc.",
    "price":{
      "Wash": 40,
      "Dry Clean": 80
    },
    "cleaning_type":"Wash",
    "count":0,
    "image":"assets/sneakers.png",
  },
];