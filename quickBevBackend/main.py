from flask import Flask, jsonify, Response, request
from create_database import app
from models import Drink, Bar
from drink_service import Drink_Service, Order_Service, User_Service, Bar_Service
from drink_model import Drink_Model
import json
import time
import uuid

@app.route('/login', methods=['GET'])
def login():
    #grab the username and password values from a custom header that was sent as a part of the request from the frontend
    email = request.headers.get('email')
    password = request.headers.get('password')
    response = {}
    user_service = User_Service()
    user = user_service.authenticate_user(email, password)

    if user:
        user = user.serialize()
        response['user'] = user
        return jsonify(response)
    else:
        return jsonify(response), 404

@app.route('/inventory', methods=['GET'])
def inventory():
    drink_list = []
    response = {'drinks': ''}
    drink_service = Drink_Service()
    drinks = drink_service.get_drinks()
    for drink in drinks:
        drink_list.append(drink.serialize())
    response['drinks'] = drink_list
    return jsonify(response['drinks'])


@app.route('/cheapDrinks', methods=['GET'])
def cheap_drinks():
    drink_list = []
    response = {'drinks': ''}
    drink_service = Drink_Service()
    drinks = drink_service.get_cheap_drinks()
    for drink in drinks:
        drink_list.append(drink.serialize())
    response['drinks'] = drink_list
    return jsonify(response['drinks'])


@app.route('/orders', methods=['POST', 'GET'])
def orders():
    if request.method == 'POST':
        response = {}
        new_order = request.json
        order_service = Order_Service()
        order_service.create_order(new_order)
        response['msg'] = 'you good bruh'
        return Response(status=200, response=json.dumps(response))
    if request.method == 'GET':
        order_list = []
        response = {'orders':''}
        order_service = Order_Service()
        orders = order_service.get_orders()
        for order in orders:
            order_list.append(order.serialize())
        response['orders'] = order_list
        return jsonify(response['orders'])


@app.route('/registerNewUser', methods=['POST'])
def register_new_user():
    response = {}
    user_service = User_Service()
    new_user = json.loads(request.data)['user']  # load JSON data from request
    if user_service.register_new_user(new_user):
        return jsonify(response), 200
    else:
        return jsonify(response), 400

@app.route('/getBars', methods=['GET'])
def get_bars():
    response = {}
    bar_service = Bar_Service()
    bars = bar_service.get_bars()
    response['bars'] = bars
    return jsonify(response), 200

if __name__ == '__main__':
    app.debug = True
    app.run()
 
