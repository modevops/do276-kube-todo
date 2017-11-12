#!/bin/sh

# Have to run steps on README before testing!

# Expected output should be a pretty formatted JSON object with two items

curl -s http://api.example.com:30080/todo/api/items | python -m json.tool

