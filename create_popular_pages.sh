curl -X PUT \
-H "X-Parse-Application-Id: Sw86jP5zMknD2Gp52hXMUH6cLoBq5YpzIR5SYWlW" \
-H "X-Parse-REST-API-Key: 6uIdPkGt6Pq691L0ahXJfT15tODjI7o07IWkJ2Kb" \
-H "Content-Type: application/json" \
-d '
{
"Owner": {
"__op":"AddRelation",
"objects": [
{
"__type": "Pointer",
"className": "User",
"objectId": "jIRSKmIYBI"
}
]
}
}
' \
https://api.parse.com/1/classes/Page/oyMtJKzEF8
