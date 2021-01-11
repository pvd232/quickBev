# set up a scoped_session

import uuid
import os
from models import Drink, Order, OrderDrink, UserTable, Bar, Tab, Stripe
import stripe


class Drink_Repository(object):
    def get_drinks(self, session):
        drinks = session.query(Drink)
        return drinks


class Order_Repository(object):
    def post_order(self, session, order):
        print("order_repository, order.serialize()", order.serialize())
        new_order = Order(id=order.id, user_id=order.user_id,
                          bar_id=order.bar_id, cost=order.cost, subtotal = order.subtotal, tip_percentage = order.tip_percentage, tip_amount = order.tip_amount, sales_tax = order.sales_tax, date_time = order.date_time)
        session.add(new_order)

        for each_order_drink in order.order_drink.order_drink:
            print()
            print('each_order_drink',each_order_drink.serialize())
            print()
            new_order_drink = OrderDrink(
            order_id=new_order.id, drink_id=each_order_drink.id, quantity=each_order_drink.quantity)
            session.add(new_order_drink)
        return True

    def get_orders(self, session):
        orders = session.query(Order)
        return orders

    def stripe_ephemeral_key(self, session, request):
        customer = request['stripe_id']
        print('request',request)
        if customer:
            confirm_customer_existence = session.query(Stripe).filter(                
                Stripe.id == customer).first()
            # Lookup the saved card (you can store multiple PaymentMethods on a Customer)
            if confirm_customer_existence:
                key = stripe.EphemeralKey.create(customer=customer, stripe_version=request['api_version'])
                header = None
                return key, header
        else:
            new_customer = stripe.Customer.create()
            new_stripe = Stripe(id=new_customer.id)
            session.add(new_stripe)
            stripe_header = {"stripe_id": new_customer.id}
            key = stripe.EphemeralKey.create(customer=new_customer.id, stripe_version=request['api_version'])
            return key, stripe_header

    def stripe_payment_intent(self, session, request):
        amount = int(round(request["order"]["cost"], 2) *100)
        payment_methods = stripe.PaymentMethod.list(                    
                    customer=request["order"]["user"]["stripe_id"],
                    type='card'
                )
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
        user = session.query(UserTable).filter(
            UserTable.id == email, UserTable.password == password).first()
        if user:
            # user = user.serialize
            return user
            # TODO add authentication of administrator
            # check to see if the user exists in the database by querying the Administrator table for the giver username and password
            # if they don't exist this will throw an error which if caught by the except block on line 28
            # try:
            #     administrator = db.session.query(Administrator).filter(
            #         Administrator.id == username,
            #         Administrator.password == password).first().serialize
            #     response['administrator'] = administrator
            #     return jsonify(response)

        else:
            return False

    def register_new_user(self, session, user):
        test_user = session.query(UserTable).filter(
            UserTable.id == user.id).first()
        test_stripe_id = session.query(Stripe).filter(
            Stripe.id == user.stripe_id).first()
        print('test_stripe_id',test_stripe_id)
        print('test_user',test_user)

        if not test_user and test_stripe_id:
            new_user = UserTable(id=user.id, password=user.password,
                                 first_name=user.first_name, last_name=user.last_name, stripe_id = test_stripe_id.id)
            session.add(new_user)
            return True
        elif not test_user and not test_stripe_id:
            new_customer = stripe.Customer.create()
            new_stripe = Stripe(id=new_customer.id)
            session.add(new_stripe)
            new_user = UserTable(id=user.id, password=user.password,
                                 first_name=user.first_name, last_name=user.last_name, stripe_id = new_stripe.id)
            session.add(new_user)
            return {"stripe_id": new_stripe.id}
        else:
            return False


class Bar_Repository(object):
    def get_bars(self, session):
        bars = session.query(Bar)
        return bars

class Tab_Repository(object):
    def post_tab(self, session, tab):
        new_tab = Tab(id=tab.id, name=tab.name, bar_id=tab.bar_id, user_id=tab.user_id, address=tab.address, street = tab.street, city = tab.city, state=tab.state, zipcode = tab.zipcode, date_time = tab.date_time, description = tab.description, minimum_contribution = tab.minimum_contribution, fundraising_goal = tab.fundraising_goal )
        session.add(new_tab)
        return True
