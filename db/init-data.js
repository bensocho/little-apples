var conn = new Mongo();
var db = conn.getDB("admin");

var adminUser = db.system.users.findOne({ user: "admin" });
if (adminUser == null) {
  db.createUser({
    user: "admin",
    pwd: "password",
    roles: [{ role: "readWrite", db: "my_flask_db" }]
  });
}

db = conn.getDB("my_flask_db")
var collectionNames = db.getCollectionNames();
if (!collectionNames.includes("fruits")) {
  db.createCollection("fruits");
  db.fruits.insertMany([
    { "_id": 1, "name": "apples", "qty": 5, "rating": 3 },
    { "_id": 2, "name": "bananas", "qty": 7, "rating": 1, "microsieverts": 0.1 },
    { "_id": 3, "name": "oranges", "qty": 6, "rating": 2 },
    { "_id": 4, "name": "avocados", "qty": 3, "rating": 5 },
  ]);
}
print("Initialized database 'my_flask_db' with collection 'fruits'.");

