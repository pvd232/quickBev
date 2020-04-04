from flask import Flask, jsonify, Response
from create_database import app, db, AlchemyEncoder
from models import Drink, Bar
import json


@app.route('/inventory', methods=['GET'])
def inventory():
    drinks = db.session.query(Drink)
    response = []
    test_re = {}
    i = 0
    for drink in drinks:
        i += 1
        alchy = AlchemyEncoder()
        drinks_json = alchy.default(drink)
        drinks_json['image'] = "image" + str(i)
        response.append(drinks_json)
    #https://stackoverflow.com/questions/47464211/what-does-the-x-for-x-in-syntax-mean
    test_re['data'] = response
    return jsonify(test_re['data'])
