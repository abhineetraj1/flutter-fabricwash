from flask import*
from flask_cors import CORS
import pymongo,os

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["dhobi"]
orders = mydb["orders"]

app = Flask(__name__, template_folder=os.getcwd())
CORS(app)

@app.route("/", methods=["GET","POST"])
def index():
    if request.method == "POST":
        a = [i for i in orders.find() if str(i["_id"]) == request.form["id"]][0]
        orders.update_one(a, {"$set": {"status": request.form["action"]}})
        return render_template("admin.html", orders=[i for i in orders.find()])
    return render_template("admin.html", orders=[i for i in orders.find()])

if "__main__" == __name__:
    app.run(debug=True, host="0.0.0.0")