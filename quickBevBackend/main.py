from flask import Flask, jsonify, Response
from create_database import app, db, AlchemyEncoder
from models import Drink, Bar
from drink_service import Drink_Service
import json
import time
# class Drink_Controller(object):
#     self.drink_service = Drink_Service()

@app.route('/inventory', methods=['GET'])
def inventory():
    # start_time = time.time()
    drink_list = []
    response = {'drinks':''}
    drink_service = Drink_Service()
    drinks = drink_service.get_drinks()
    for drink in drinks:
        drink_list.append(drink.serialize())
    response['drinks'] = drink_list
    # print("My program took", time.time() - start_time, "to run")
    return jsonify(response['drinks'])

@app.route('/cheapDrinks', methods=['GET'])
def cheap_drinks():
    drink_list = []
    response = {'drinks':''}
    drink_service = Drink_Service()
    drinks = drink_service.get_cheap_drinks()
    for drink in drinks:
        drink_list.append(drink.serialize())
    response['drinks'] = drink_list
    return jsonify(response['drinks'])
# def inventory():
#     drinks = db.session.query(Drink)
#     for drink in drinks:
#         drinka = drink.serialize
#         print(drinka)
#     response = []
#     test_re = {}
#     i = 0
#     for drink in drinks:
#         i += 1
#         alchy = AlchemyEncoder()
#         drinks_json = alchy.default(drink)
#         drinks_json['image'] = "image" + str(i)
#         response.append(drinks_json)
#     #https://stackoverflow.com/questions/47464211/what-does-the-x-for-x-in-syntax-mean
#     test_re['data'] = response
#     return jsonify(test_re['data'])

if __name__ == '__main__':
    app.debug = True
    app.run()
 
