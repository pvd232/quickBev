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
from flask import Flask
import pusher
from pusher_push_notifications import PushNotifications


app = Flask(__name__)
# app.config['SECRET_KEY'] = 'secret!'
# socketio = SocketIO(app)

merchant_menu_upload_folder = os.getcwd() + "/files"
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = merchant_menu_upload_folder

stripe.api_key = "sk_test_51I0xFxFseFjpsgWvh9b1munh6nIea6f5Z8bYlIDfmKyNq6zzrgg8iqeKEHwmRi5PqIelVkx4XWcYHAYc1omtD7wz00JiwbEKzj"

beams_client = PushNotifications(
    instance_id='YOUR_INSTANCE_ID_HERE',
    secret_key='4f53e118637f02042caa',
)

pusher_client = pusher.Pusher(
    app_id='1155759',
    key='7b5e34392e1404447668',
    secret='4f53e118637f02042caa',
    cluster='us2',
    ssl=True
)
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


def send_confirmation_email(customer, url):
    # gmail left pad = 20px, right pad = 16px
    host = request.headers.get('Host')
    button_url = f"http://{host}/verify-email/{customer.id}"

    logo = os.path.join(os.path.dirname(os.path.abspath(
        __file__)), "./src/static/landscape-logo-purple.png")

    with open(logo, "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read())

    mail_body_text = f'<p style="margin-top: 15px;margin-bottom: 15px;">Hey {customer.first_name},</p><p style="margin-top: 15px;margin-bottom: 15px;">Welcome to QuickBev!</p><p style="margin-top: 15px;margin-bottom: 15px;">Please click the link below to verify your account</p><br /><p style="margin-top: 15px;margin-bottom: 15px;">Let the good times begin,</p><p style="margin-top: 15px;margin-bottom: 15px;">—The QuickBev Team</p></div><div style="display:flex; justify-content: center;"><a style="background-color:white; border-color:#8682E6; font-weight:bold; align-self:center;" href="{button_url}"><button type="button" class="btn btn-outline-*" style="background-color:white; border-color:#8682E6; font-weight:bold; align-self:center;">VERIFY EMAIL</button></a>'
    mail_body = f'<div style="height: 100%;"><div style="width: 100%;height: 100%;display: flex;justify-content: center;background-color: #e8e8e8;"><div style="width: 100%;max-width: 500px;margin-top: 3%;margin-bottom: 10%; margin-right:auto; margin-left:auto; background-color: white;"><div  style="width: 100%; padding:30px 30px 30px 30px"><div  style="display: flex; width:100%; justify-content: center; text-align:center;"><img src="data:image/png;base64,f{encoded_string} style="width:50%; height:12%" alt="img" /></div><div  style="margin-top: 30px;">{mail_body_text}</div></div></div></div>'

    sender_address = 'patardriscoll@gmail.com'
    email = 'patardriscoll@gmail.com'

    # Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = email

    message['Subject'] = 'Order From'  # The subject line

    mail_content = mail_body
    # The body and the attachments for the mail
    message.attach(MIMEText(mail_content, 'html'))
    # Create SMTP session for sending the mail
    s = smtplib.SMTP('smtp.gmail.com', 587)
    # s.connect('smtp.gmail.com', 587)
    s.starttls()

    s.login(user="patardriscoll@gmail.com", password="Iqopaogh23!")
    # s = smtplib.SMTP('smtp.mailgun.org', 587)
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
        print('response', response.serialize())
        if response:
            # send the hashed user ID as a crypted key embedded in the activation link for security
            print('request.url', request.url)

            send_confirmation_email(response, request.url)
            return jsonify(response.serialize()), 200
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


# strongly typed url argument ;)
@app.route("/verify-email/<string:username>")
def verify_email(username):
    print('username', username)
    status = Customer_Service().authenticate_username(
        username=None, hashed_username=username)
    print('status', status)
    response = {"status": status}
    pusher_client.trigger(
        'email-verificatin-channel', 'account-status', json.dumps(response)
    )  # trigger `new-request` event on `patientRequests` channel
    return Response(response=json.dumps(response), status=200)


@app.route('/pusher/beams-auth', methods=['GET'])
def beams_auth():
    # Do your normal auth checks here 🔒
    user_id = ''  # get it from your auth system
    user_id_in_query_param = request.args.get('user_id')
    if user_id != user_id_in_query_param:
        return 'Inconsistent request', 401

    beams_token = beams_client.generate_token(user_id)
    return jsonify(beams_token)


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


# @socketio.on_error_default
# def default_error_handler(e):
#     print(request.event["message"])  # "my error event"
#     print(request.event["args"])    # (data,)


# @socketio.on('connect')
# def test_connect():
#     print(request)
#     emit('my response', {'data': 'Connected'})


# @socketio.on('disconnect')
# def test_disconnect():
#     print('Client disconnected')


# @socketio.on('json')
# def handle_json(json):
#     print('received json: ' + str(json))

# async def hello(websocket, path):
#     remote_ip = websocket.remote_address[0]
#     remote_ip_list = websocket.remote_address
#     print('remote_ip_list', remote_ip_list)

#     print('remote_ip', remote_ip)

#     name = await websocket.recv()
#     # print(f"< {name}")
#     print("data recieved", name)

#     greeting = f"Hello {name}!"

#     await websocket.send(greeting)
#     print(f"> {greeting}")


# app = Flask(__name__)
# ws = WebSocket(app)


# @ws.on('click')
# def click(data):
#     print(data)
# def run_websocket():
#     start_server = websockets.serve(hello, "localhost", 8765)
#     asyncio.get_event_loop().run_until_complete(start_server)
#     asyncio.get_event_loop().run_forever()


# def run_flask_app():
#     app.run(debug=True)


# p_flask = multiprocessing.Process(target=run_flask_app)
# p_ws = multiprocessing.Process(target=run_websocket)


# def run_everything():
#     p_ws.start()
#     p_flask.start()
#     p_ws.join()

#     p_flask.join()


if __name__ == '__main__':
    app.run(debug=True)
