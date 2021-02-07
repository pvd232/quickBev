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
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
import base64

app = Flask(__name__)
auth = HTTPBasicAuth()

users = {
    "john": generate_password_hash("hello"),
    "susan": generate_password_hash("bye")
}


@auth.verify_password
def verify_password(username, password):
    if username in users and \
            check_password_hash(users.get(username), password):
        return username


UPLOAD_FOLDER = os.getcwd() + "/files"
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

stripe.api_key = "sk_test_51I0xFxFseFjpsgWvh9b1munh6nIea6f5Z8bYlIDfmKyNq6zzrgg8iqeKEHwmRi5PqIelVkx4XWcYHAYc1omtD7wz00JiwbEKzj"
# publicly accessible local host URL!!! - http://machina-8c11dd2e.localhost.run/
# theme color RGB = rgb(134,130,230), hex = #8682E6
# TODO: need to finish the add_business function by adding the new business address and returning the unique identifier to main.py so i can dynamically set the files path of the new image using the UUID of the business address
# TODO: finish full integration of live stripe business id with a charge created in the front end, while subtracting quick bev fee, calculate order total on the server
# TODO: allow merchant to switch between their stripe accounts/different businesses in the home page dashboard


@app.route('/login', methods=['GET'])
def login():
    # grab the username and password values from a custom header that was sent as a part of the request from the frontend
    email = request.headers.get('email')
    password = request.headers.get('password')
    response = {"msg": "customer not found"}
    customer_service = Customer_Service()
    customer = customer_service.authenticate_customer(email, password)

    if customer:
        # serialize the python object into a python dictionary
        customer = customer.serialize()
        print('customer', customer)
        return Response(status=200, response=json.dumps(customer))
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


@app.route('/order', methods=['POST', 'GET', 'OPTIONS'])
def orders():
    response = {}
    order_service = Order_Service()
    if request.method == 'POST':
        new_order = request.json
        order_service = Order_Service()
        order_service.create_order(new_order)
        response['msg'] = 'you good bruh'
        return Response(status=200, response=json.dumps(response))
    if request.method == 'OPTIONS':
        header = {}
        header["Access-Control-Allow-Credentials"] = 'true'
        return Response(status=200, headers=header)
    if request.method == "GET":
        header = {}
        header["Access-Control-Expose-Headers"] = "authorization"
        # header["Access-Control-Allow-Origin"] = "http://localhost:3000"
        header["Access-Control-Allow-Credentials"] = 'true'
        username = base64.b64decode(
            request.headers.get(
                "Authorization").split(" ")[1]).decode("utf-8").split(":")[0]
        merchant_orders = order_service.get_orders(username=username)
        print('customer_orders', merchant_orders)
        response = {"orders": merchant_orders}
        return Response(status=200, response=json.dumps(response), headers=header)


@app.route('/customer', methods=['POST', 'GET', 'OPTIONS'])
def customer():
    response = {}
    customer_service = Customer_Service()
    print("request", request)
    print("request.method", request.method)
    print('request.data', request.data)
    print("request.headers", request.headers)
    print(json.loads(request.data))
    if request.method == 'POST':
        new_customer = json.loads(request.data)  # load JSON data from request
        response = customer_service.register_new_customer(new_customer)
        print('response', response)
        if response:
            return jsonify(response), 200
        else:
            return jsonify(response), 400
    if request.method == 'OPTIONS':
        header = {}
        header["Access-Control-Allow-Credentials"] = 'true'
        return Response(status=200, headers=header)
    if request.method == "GET":
        header = {}
        header["Access-Control-Expose-Headers"] = "authorization"
        # header["Access-Control-Allow-Origin"] = "http://localhost:3000"
        header["Access-Control-Allow-Credentials"] = 'true'
        merchant_id = base64.b64decode(
            request.headers.get(
                "Authorization").split(" ")[1]).decode("utf-8")
        customers = customer_service.get_customers(merchant_id=merchant_id)
        print('customer', customers)
        response = {"customers": customers}
        return Response(status=200, response=json.dumps(response), headers=header)


@app.route('/business', methods=['GET'])
def get_businesss():
    response = {}
    business_list = []
    business_service = Business_Service()
    businesss = business_service.get_businesss()
    for business in businesss:
        # turn into dictionaries
        businessDTO = {}
        businessDTO['business'] = business.serialize()
        print('business.serialize()', business.serialize())
        business_list.append(businessDTO)
    response['businesses'] = business_list
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
    key, header = order_service.get_stripe_ephemeral_key(request_data)
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

    new_merchant = merchant_service.add_merchant(requested_merchant)
    new_business = business_service.add_business(requested_business)
    if new_merchant and new_business:
        response['confirmed_new_business'] = new_business.serialize()

        if 'file' not in request.files:
            response["msg"] = "No file part in request"
            return Response(status=200, response=json.dumps(response))

        file = request.files['file']
        # merchant does not select file
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


@app.route('/add-menu', methods=['POST'])
def add_menu():
    drink_service = Drink_Service()
    menu = json.loads(request.data)
    print('menu', menu)
    business_id = request.headers.get("business_id")
    print('business_id', business_id)
    response = Response(status=200, response=json.dumps(
        drink_service.add_drinks(business_id, menu)))
    return response


if __name__ == '__main__':
    app.debug = True
    app.run()
