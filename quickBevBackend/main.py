from flask import Flask, jsonify
from create_database import fetch_drinks, app, db
from models import Drink, Bar
import json

@app.route('/inventory', methods=['GET'])
def inventory():
    drinks = db.session.query(Drink)
    drinks_json = jsonify(drinks_json)
    print(drinks_json)
    # return drinks_json

