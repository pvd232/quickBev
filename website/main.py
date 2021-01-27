from flask import Flask, jsonify, Response, request, redirect, url_for
import requests
from models import app
from service import *
import json
import time
import uuid
import stripe
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = os.getcwd() + "/files"
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

stripe.api_key = "sk_test_51I0xFxFseFjpsgWvh9b1munh6nIea6f5Z8bYlIDfmKyNq6zzrgg8iqeKEHwmRi5PqIelVkx4XWcYHAYc1omtD7wz00JiwbEKzj"
# publicly accessible local host URL!!! - http://machina-8c11dd2e.localhost.run/
# theme color RGB = rgb(134,130,230), hex = #8682E6
# TODO: need to finish the add_business function by adding the new business address and returning the unique identifier to main.py so i can dynamically set the files path of the new image using the UUID of the business address
# TODO: finish full integration of live stripe business id with a charge created in the front end, while subtracting quick bev fee, calculate order total on the server
# TODO: move stripe ID from merchant to business
# TODO: allow merchant to switch between their stripe accounts/different businesses in the home page dashboard


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


@app.route('/getBusinesss', methods=['GET'])
def get_businesss():
    response = {}
    business_list = []
    business_service = Business_Service()
    businesss = business_service.get_businesss()
    for business in businesss:
        # turn into dictionaries
        businessDTO = {}
        businessDTO['business'] = business.serialize()
        business_list.append(businessDTO)
    response['businesss'] = business_list
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


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/signup', methods=['POST'])
def signup():
    response = {"msg": ""}
    # check if the post request has the file part
    requested_merchant = json.loads(request.form.get("merchant"))

    print('requested_merchant', requested_merchant)

    requested_business = json.loads(request.form.get("business"))

    print('requested_business', requested_business)

    merchant_service = Merchant_Service()
    business_service = Business_Service()

    # requested_business["id"] = "abc"
    # response = {"confirmed_new_business": requested_business}
    # response["msg"] = "wee"
    # return Response(status=200, response=json.dumps(response))
    new_merchant = merchant_service.add_merchant(requested_merchant)
    new_business = business_service.add_business(requested_business)
    if new_merchant and new_business:
        response['confirmed_new_business'] = new_business.serialize()

        if 'file' not in request.files:
            response["msg"] = "No file part in request"
            return Response(status=200, response=json.dumps(response))

        file = request.files['file']
        # if user does not select file
        if file.filename == '':
            response["msg"] = "No file file uploaded"
            return Response(status=200, response=json.dumps(response))
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

            response["msg"] = "File successfully uploaded!"
            return Response(status=200, response=json.dumps(response))
    else:
        response["msg"] = "An unknown internal server error occured"
        return Response(status=500, response=json.dumps(response))


@app.route('/signup-redirect', methods=['POST'])
def signup_redirect():
    response = {"msg": ""}
    business_service = Business_Service()
    request_json = json.loads(request.data)
    business_to_update = request_json["business"]
    print('business_to_update', business_to_update)
    if business_service.update_business(business_to_update):
        response["msg"] = "Business sucessfully updated"
        return Response(status=200, response=json.dumps(response))
    else:
        response["msg"] = "Failed to update business"
        return Response(status=500, response=json.dumps(response))


@app.route('/validate-merchant', methods=['POST'])
def validate_merchant():
    merchant_service = Merchant_Service()
    request_data = json.loads(request.data)
    requested_merchant = request_data['merchant']
    response = merchant_service.validate_merchant(requested_merchant)
    # if the merchant exists it will return False, if it doesn't it will return True
    if response:
        return jsonify(response), 200
    else:
        return jsonify(response), 400


@app.route('/create-stripe-account', methods=['GET'])
def create_stripe_account():
    merchant_service = Merchant_Service()
    new_account = merchant_service.create_stripe_account()
    account_links = stripe.AccountLink.create(
        account=new_account.id,
        refresh_url='http://localhost:3000/payout-setup-callback',
        return_url='http://localhost:3000/home',
        type='account_onboarding',
    )
    header = {}
    header["Access-Control-Expose-Headers"] = "*"
    header["stripe_id"] = new_account.id
    response = Response(status=200, response=json.dumps(
        account_links), headers=header)
    return response


if __name__ == '__main__':
    app.debug = True
    app.run()
