var totalBill = 0;
var toBeCollected = 0;
var TotalCollected = 0;
var Loss = 0;
var totalOrders = document.getElementsByClassName('total').length;
for (var i = document.getElementsByClassName('total').length - 1; i >= 0; i--) {
	var a = parseInt(document.getElementsByClassName('total')[i].innerHTML.replace("₹",""))
	if (document.getElementsByClassName("status")[i].innerHTML != "cancelled") {
		totalBill = totalBill + a;
	}
}
for (var i = document.getElementsByClassName('total').length - 1; i >= 0; i--) {
	var a = parseInt(document.getElementsByClassName('total')[i].innerHTML.replace("₹",""))
	if (document.getElementsByClassName("status")[i].innerHTML == "processing") {
		toBeCollected = toBeCollected + a;
	}
}
for (var i = document.getElementsByClassName('total').length - 1; i >= 0; i--) {
	var a = parseInt(document.getElementsByClassName('total')[i].innerHTML.replace("₹",""))
	if (document.getElementsByClassName("status")[i].innerHTML == "delivered") {
		TotalCollected = TotalCollected + a;
	}
}
for (var i = document.getElementsByClassName('total').length - 1; i >= 0; i--) {
	var a = parseInt(document.getElementsByClassName('total')[i].innerHTML.replace("₹",""))
	if (document.getElementsByClassName("status")[i].innerHTML == "cancelled") {
		Loss = Loss + a;
	}
}

var commission = totalBill*0.1;
document.getElementsByClassName('dashboard-result')[0].innerHTML = "₹" + totalBill;
document.getElementsByClassName('dashboard-result')[1].innerHTML = totalOrders;
document.getElementsByClassName('dashboard-result')[2].innerHTML = "₹" + commission;
document.getElementsByClassName('dashboard-result')[3].innerHTML = "₹" + toBeCollected;
document.getElementsByClassName('dashboard-result')[4].innerHTML = "₹" + TotalCollected;
document.getElementsByClassName('dashboard-result')[5].innerHTML = "₹" + Loss;

function showAll() {
	for (var i = document.getElementsByClassName("trx").length - 1; i >= 0; i--) {
		document.getElementsByClassName("trx")[i].style.display="";
	}
}
function show(arg) {
	showAll();
	for (var i = document.getElementsByClassName("status").length - 1; i >= 0; i--) {
		if (document.getElementsByClassName("status")[i].innerHTML != arg) {
			document.getElementsByClassName("trx")[i].style.display = "none";
		}
	}
}