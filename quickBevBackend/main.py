from flask import Flask, jsonify, Response, request
from models import app
from service import *
import json
import time
import uuid
import stripe

stripe.api_key = "sk_test_51I0xFxFseFjpsgWvh9b1munh6nIea6f5Z8bYlIDfmKyNq6zzrgg8iqeKEHwmRi5PqIelVkx4XWcYHAYc1omtD7wz00JiwbEKzj"
@app.route('/login', methods=['GET'])
def login():
    # grab the username and password values from a custom header that was sent as a part of the request from the frontend
    email = request.headers.get('email')
    password = request.headers.get('password')
    response = {"msg": "user not found"}
    user_service = User_Service()
    user = user_service.authenticate_user(email, password)

    if user:
        # serialize the python object into a python dictionary
        user = user.serialize()
        return Response(status=200, response=json.dumps(user))
    else:
        return Response(status=404, response=json.dumps(response))


@app.route('/inventory', methods=['GET'])
def inventory():
    drink_list = []
    response = {}
    drink_service = Drink_Service()
    drinks = drink_service.get_drinks()
    for drink in drinks:
        drinkDTO = {}
        drinkDTO['drink'] = drink.serialize()
        drink_list.append(drinkDTO)
    print('drinkList', drink_list)
    response['drinks'] = drink_list
    return jsonify(response)


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
        response = {}
        order_service = Order_Service()
        orders = order_service.get_orders()
        for order in orders:
            order_list.append(order.serialize())
        response['orders'] = order_list
        return jsonify(response['orders'])


@app.route('/registerNewUser', methods=['POST'])
def register_new_user():
    user_service = User_Service()
    new_user = json.loads(request.data)  # load JSON data from request
    response = user_service.register_new_user(new_user)
    print('response', response)
    if response:
        return jsonify(response), 200
    else:
        return jsonify(response), 400


@app.route('/getBars', methods=['GET'])
def get_bars():
    response = {}
    bar_list = []
    bar_service = Bar_Service()
    bars = bar_service.get_bars()
    for bar in bars:
        # turn into dictionaries
        barDTO = {}
        barDTO['bar'] = bar.serialize()
        bar_list.append(barDTO)
    response['bars'] = bar_list
    return jsonify(response)


@app.route('/tabs', methods=['POST', 'GET'])
def tabs():
    if request.method == 'POST':
        response = {}
        new_tab = request.json['tab']
        tab_service = Tab_Service()
        if tab_service.post_tab(new_tab):
            response['msg'] = 'tab posted'
            return Response(status=200, response=json.dumps(response))
        else:
            response['msg'] = 'something broke'
            return Response(status=500, response=json.dumps(response))


@app.route('/create-ephemeral-keys', methods=['POST'])
def ephemeral_keys():
    request_data = json.loads(request.data)
    print('request_data', request_data)
    order_service = Order_Service()
    key, header = order_service.stripe_ephemeral_key(request_data)
    if key and header:
        return Response(status=200, response=json.dumps(key), headers=header)
    else:
        return Response(status=200, response=json.dumps(key))


@app.route('/create-payment-intent', methods=['POST'])
def create_payment_intent():
    response = {}
    request_data = json.loads(request.data)
    print('request_data payment intent', request_data)
    order_service = Order_Service()
    client_secret = order_service.stripe_payment_intent(request_data)
    print('client_secret', client_secret)
    response["secret"] = client_secret
    print("r", response)
    return Response(status=200, response=json.dumps(response))


@app.route('/signup', methods=['POST'])
def signup():
    response = {"msg": "booyah bitch"}
    request_json = json.loads(request.data)
    print('request_json', request_json)
    return Response(status=200, response=json.dumps(response))


if __name__ == '__main__':
    app.debug = True
    app.run()
