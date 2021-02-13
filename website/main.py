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
import base64
import asyncio
import websockets
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

app = Flask(__name__)

merchant_menu_upload_folder = os.getcwd() + "/files"
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = merchant_menu_upload_folder

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


def send_confirmation_email(self, customer):
    mail_header = '<!DOCTYPE html><html lang="en" style="height: 100%;"><head><meta charset="utf-8" /><meta http-equiv="X-UA-Compatible" content="IE=edge" /><meta name="viewport" content="width=device-width, initial-scale=1" /><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script><style>p{margin-top: 15px; margin-bottom: 15px;}</style><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script></head>'
    mail_body_text = f'<p>Hey {customer.first_name},</p><p>Welcome to QuickBev!</p><p>Please click the link below to verify your account</p><br /><p>Let the good times begin,</p><p>—The QuickBev Team</p></div><div className = "row" style="display:flex; justify-content: center;"><button type="button" class="btn btn-outline-*" style="background-color:white; border-color:#8682E6; font-weight:bold; align-self:center;">VERIFY EMAIL</button>'
    mail_body = f'<body style="height: 100%;"><divstyle="width: 100%;height: 100%;display: flex;justify-content: center;background-color: #e8e8e8;"><divclassName="container-fluid"style="width: 100%;max-width: 500px;margin-top: 3%;margin-bottom: 10%;background-color: white;"><div className="row" style="width: 100%; padding:30px 30px 30px 30px"><div className="row" style="display: flex; width:100%; justify-content: center"><img src="src/static/landscape-logo-purple.png" style="width:50%; height:12%" /></div><div className="row" style="margin-top: 30px;">{mail_body_text}</div></div></div></div></body></html>'

    logo = os.path.join(os.getcwd(), "src/static/landscape-logo-purple.png")

    sender_address = 'confirmation@crepenshake.com'
    email = 'crepenshake@yahoo.com'

    # Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = email

    message['Subject'] = 'Order From'  # The subject line

    mail_content = mail_header + mail_body
    # The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'html'))
    # Create SMTP session for sending the mail
    s = smtplib.SMTP('localhost')

    # s = smtplib.SMTP('smtp.mailgun.org', 587)
    s.starttls()
    # s.login('postmaster@crepenshake.com',
    #         '6695313d8a619bc44dce00ad7184960a-ba042922-f2a8cfbb')
    s.sendmail(message['From'], message['To'], message.as_string())
    s.quit()


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


async def hello(websocket, path):
    remote_ip = websocket.remote_address[0]
    remote_ip_list = websocket.remote_address
    print('remote_ip_list', remote_ip_list)

    print('remote_ip', remote_ip)

    name = await websocket.recv()
    # print(f"< {name}")
    print("data recieved", name)

    greeting = f"Hello {name}!"

    await websocket.send(greeting)
    print(f"> {greeting}")


if __name__ == '__main__':
    app.run(debug=True)
    start_server = websockets.serve(hello, "localhost", 8765)
    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()
