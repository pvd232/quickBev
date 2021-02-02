# set up a scoped_session

import uuid
import os
# from models import Drink, Order, Order_Drink, User_Table, Business, Tab, Stripe_Customer, Stripe_Account
from models import *
import stripe
from datetime import date
import requests
import base64
from sqlalchemy.sql import text
from sqlalchemy.inspection import inspect


class Drink_Repository(object):
    def get_drinks(self, session):
        drinks = session.query(Drink)
        return drinks


class Order_Repository(object):
    def post_order(self, session, order):
        new_order = Order(id=order.id, user_id=order.user_id,
                          business_id=order.business_id, cost=order.cost, subtotal=order.subtotal, tip_percentage=order.tip_percentage, tip_amount=order.tip_amount, sales_tax=order.sales_tax, date_time=order.date_time)
        session.add(new_order)

        for each_order_drink in order.order_drink.order_drink:
            print()
            print('each_order_drink', each_order_drink.serialize())
            print()
            # create a unique instance of Order_Drink for the number of each type of drink that were ordered. the UUID for the Order_Drink is generated in the database
            for i in range(each_order_drink.quantity):
                new_order_drink = Order_Drink(
                    order_id=new_order.id, drink_id=each_order_drink.id)
                session.add(new_order_drink)
        return True

    def get_orders(self, session, username):
        orders = session.query(Order, Business.id.label("business_id"),  # select from allows me to pull the entire Order from the database so I can get the Order_Drink relationship values
                               Business.address.label("business_address"), Business.name.label("business_name")).select_from(Order).join(Business, Order.business_id == Business.id).filter(Order.user_id == username).all()
        drinks = session.query(Drink)
        return orders, drinks

    def get_stripe_ephemeral_key(self, session, request):
        customer = request['stripe_id']
        customer_bool = False
        print('request', request)
        if customer:
            confirm_customer_existence = session.query(Stripe_Customer).filter(
                Stripe_Customer.id == customer).first()
            # Lookup the customer in the database so that if they exist we can attach their stripe id to the Ephermeral key such that later when they create the payment intent it will include their payment methods
            if confirm_customer_existence:
                customer_bool = True
                key = stripe.EphemeralKey.create(
                    customer=customer, stripe_version=request['api_version'])
                header = None
                return key, header

        if not customer_bool:
            new_customer = stripe.Customer.create()
            new_stripe = Stripe_Customer(id=new_customer.id)
            session.add(new_stripe)
            stripe_header = {"stripe_id": new_customer.id}
            key = stripe.EphemeralKey.create(
                customer=new_customer.id, stripe_version=request['api_version'])
            return key, stripe_header

    def stripe_payment_intent(self, session, request):
        amount = int(round(request["order"]["cost"], 2) * 100)
        # when the user lands on the checkout page we create a payment intent for them and send it back. this includes their payment methods
        payment_intent = stripe.PaymentIntent.create(
            amount=amount,
            customer=request["order"]["user"]["stripe_id"],
            setup_future_usage='on_session',
            currency='usd'
        )
        return payment_intent["client_secret"]


class User_Repository(object):
    def authenticate_user(self, session, email, password):
      # check to see if the user exists in the database by querying the User_Info table for the giver username and password
      # if they don't exist this will return a null value for user which i check for in line 80
        user = session.query(User_Table).filter(
            User_Table.id == email, User_Table.password == password).first()
        if user:
            return user
        else:
            return False

    def register_new_user(self, session, user):
        test_user = session.query(User_Table).filter(
            User_Table.id == user.id).first()
        test_stripe_id = session.query(Stripe_Customer).filter(
            Stripe_Customer.id == user.stripe_id).first()
        print('test_stripe_id', test_stripe_id)
        print('test_user', test_user)

        if not test_user and test_stripe_id:
            new_user = User_Table(id=user.id, password=user.password,
                                  first_name=user.first_name, last_name=user.last_name, stripe_id=test_stripe_id.id)
            session.add(new_user)
            return True
        elif not test_user and not test_stripe_id:
            new_customer = stripe.Customer.create()
            new_stripe = Stripe_Customer(id=new_customer.id)
            session.add(new_stripe)
            new_user = User_Table(id=user.id, password=user.password,
                                  first_name=user.first_name, last_name=user.last_name, stripe_id=new_stripe.id)
            session.add(new_user)
            return {"stripe_id": new_stripe.id}
        else:
            return False


class Business_Repository(object):
    def get_businesss(self, session):
        businesses = session.query(Business).all()
        print('businesses', businesses)
        return businesses

    def add_business(self, session, business):
        # will have to plug in an API here to dynamically pull information (avalara probs if i can get the freaking credentials to work)
        new_business = Business(name=business.name, classification=business.classification, date_joined=date.today(
        ), sales_tax_rate=business.sales_tax_rate, merchant_id=business.merchant_id, stripe_id=business.stripe_id, street=business.street, city=business.city,
            state=business.state, zipcode=business.zipcode, address=business.address, tablet=business.tablet, phone_number=business.phone_number)
        session.add(new_business)
        return new_business

    def update_business(self, session, business):
        print('requested business to update', business.serialize())
        business_database_object_to_update = session.query(
            Business).filter(Business.id == business.id).first()
        if business_database_object_to_update:
            print('business_database_object_to_update.stripe_id',
                  business_database_object_to_update.stripe_id)
            business_database_object_to_update.stripe_id = business.stripe_id
            print('business_database_object_to_update.stripe_id',
                  business_database_object_to_update.stripe_id)
            return True
        else:
            return False


class Tab_Repository(object):
    def post_tab(self, session, tab):
        new_tab = Tab(id=tab.id, name=tab.name, business_id=tab.business_id, user_id=tab.user_id, address=tab.address, street=tab.street, city=tab.city, state=tab.state,
                      zipcode=tab.zipcode, suite=tab.suite, date_time=tab.date_time, description=tab.description, minimum_contribution=tab.minimum_contribution, fundraising_goal=tab.fundraising_goal)
        session.add(new_tab)
        return True


class Merchant_Repository(object):
    def create_stripe_account(self, session):
        new_account = stripe.Account.create(
            type="express",
            country="US"
        )
        new_stripe_account_id = Stripe_Account(id=new_account.id)
        session.add(new_stripe_account_id)
        return new_account

    def validate_merchant(self, session, requested_merchant):
        merchant = session.query(Merchant).filter(
            Merchant.id == requested_merchant.id).first()
        if merchant:
            return False
        else:
            return True

    def add_merchant(self, session, requested_merchant):
        new_merchant = Merchant(id=requested_merchant.id, password=requested_merchant.password, first_name=requested_merchant.first_name,
                                last_name=requested_merchant.last_name, phone_number=requested_merchant.phone_number, number_of_businesses=requested_merchant.number_of_businesses)
        session.add(new_merchant)
        return True


class Customer_Repository(object):
    def get_customers(self, session, merchantId):
        customers = session.query(User_Table).join().filter(User_Table)
