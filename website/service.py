from domain import *
from repository import *
from models import db
import uuid
import os
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from contextlib import contextmanager


username = os.environ.get("USER", "")
password = os.environ.get("PASSWORD", "")
connection_string_beginning = "postgres://"
connection_string_end = "@localhost:5432/quickbevdb"
connection_string = connection_string_beginning + \
    username + ":" + password + connection_string_end

# an Engine, which the Session will use for connection
# resources
drink_engine = create_engine(
    os.environ.get("DB_STRING", connection_string), pool_size=100, max_overflow=10)

# create a configured "Session" class
session_factory = sessionmaker(bind=drink_engine)

# create a Session
Session = scoped_session(session_factory)


@contextmanager
def session_scope():
    session = Session()
    try:
        yield session
        session.commit()
    except Exception as e:
        print("service exception", e)
        session.rollback()
        raise e
    finally:
        session.close()

    # now all calls to Session() will create a thread-local session


class Drink_Service(object):
    def __init__(self):
        self.drink_repository = Drink_Repository()
        self.drinks = self.get_drinks()

    def get_drinks(self):
        response = []
        with session_scope() as session:
            for drink in self.drink_repository.get_drinks(session):
                drink_domain = Drink_Domain(drink_object=drink)
                response.append(drink_domain)
            return response

    def add_drinks(self, business_id, drinks):
        with session_scope() as session:
            new_drink_list = [Drink_Domain(
                drink_json=x, init=True) for x in drinks]
            for drink in new_drink_list:
                drink.business_id = business_id
            return self.drink_repository.add_drinks(session, new_drink_list)

    def get_drinks_etag(self):
        with session_scope() as session:
            return ETag_Domain(etag_object=ETag_Repository().get_etag(session, "drink"))

    def validate_etag(self, etag):
        return ETag_Repository().validate_etag(etag)


class Order_Service(object):
    def __init__(self):
        self.order_repository = Order_Repository()

    def create_order(self, order):
        with session_scope() as session:
            print('order JSON', order)
            new_order_domain = Order_Domain(order_json=order)
            self.order_repository.post_order(session, new_order_domain)
            return

    def get_orders(self, username):
        response = []
        with session_scope() as session:
            orders, drinks = self.order_repository.get_orders(
                session, username)
            for order in orders:
                order_domain = Order_Domain(order_object=order, drinks=drinks)
                order_dto = order_domain.dto_serialize()
                response.append(order_dto)
            return response

    def get_stripe_ephemeral_key(self, request):
        with session_scope() as session:
            return self.order_repository.get_stripe_ephemeral_key(session, request)

    def stripe_payment_intent(self, request):
        with session_scope() as session:
            new_order_domain = Order_Domain(order_json=request["order"])
            return self.order_repository.stripe_payment_intent(session, new_order_domain)


class Customer_Service(object):
    def __init__(self):
        self.customer_repository = Customer_Repository()

    def authenticate_customer(self, email, password):
        with session_scope() as session:
            customer_object = self.customer_repository.authenticate_customer(
                session, email, password)
            if customer_object:
                customer_domain = Customer_Domain(
                    customer_object=customer_object)
                return customer_domain
            else:
                return False

    def authenticate_username(self, username=None, hashed_username=None):
        with session_scope() as session:
            customer_object = self.customer_repository.authenticate_username(
                session, username, hashed_username)
            if customer_object:
                return True
            else:
                return False

    def register_new_customer(self, customer):
        with session_scope() as session:
            requested_new_customer = Customer_Domain(customer_json=customer)
            registered_new_customer = self.customer_repository.register_new_customer(
                session, requested_new_customer)
            return registered_new_customer

    def get_customers(self, merchant_id):
        with session_scope() as session:
            # pheew this is sexy. list comprehension while creating a customer dto
            customers = [Customer_Domain(customer_object=x).dto_serialize() for x in self.customer_repository.get_customers(
                session, merchant_id)]
            return customers

    def update_device_token(self, device_token, customer_id):
        with session_scope() as session:
            return Customer_Repository().update_device_token(session, device_token, customer_id)

    def get_device_token(self, customer_id):
        with session_scope() as session:
            return Customer_Repository().get_device_token(session, customer_id)


class Merchant_Service(object):
    def __init__(self):
        self.merchant_repository = Merchant_Repository()

    def create_stripe_account(self):
        with session_scope() as session:
            return self.merchant_repository.create_stripe_account(session)

    def validate_merchant(self, merchant):
        with session_scope() as session:
            requested_new_merchant = Merchant_Domain(merchant_json=merchant)
            registered_merchant_status = self.merchant_repository.validate_merchant(
                session, requested_new_merchant)
            return registered_merchant_status

    def add_merchant(self, merchant):
        with session_scope() as session:
            requested_new_merchant = Merchant_Domain(merchant_json=merchant)
            return self.merchant_repository.add_merchant(
                session, requested_new_merchant)


class Business_Service(object):
    def __init__(self):
        self.business_repository = Business_Repository()

    def get_businesss(self):
        with session_scope() as session:
            response = []
            for business in self.business_repository.get_businesss(session):
                business_domain = Business_Domain(business_object=business)
                response.append(business_domain)
            return response

    def add_business(self, business):
        with session_scope() as session:
            business_domain = Business_Domain(business_json=business)
            business_database_object = self.business_repository.add_business(
                session, business_domain)
            if business_database_object:
                # the new business domain has a UUID that was created during initialization
                return business_domain
            else:
                return False

    def update_business(self, business):
        with session_scope() as session:
            business_domain = Business_Domain(business_json=business)
            return self.business_repository.update_business(session, business_domain)


class Tab_Service(object):
    def __init__(self):
        self.tab_repository = Tab_Repository()

    def post_tab(self, tab):
        with session_scope() as session:
            new_tab_domain = Tab_Domain(tab_json=tab)
            return self.tab_repository.post_tab(session, new_tab_domain)


class ETag_Service(object):
    def get_etag(self, category):
        with session_scope() as session:
            return ETag_Domain(etag_object=ETag_Repository().get_etag(session, category))

    def validate_etag(self, etag):
        with session_scope() as session:
            return ETag_Repository().validate_etag(session, etag)

    def update_etag(self, category):
        with session_scope() as session:
            ETag_Repository().update_etag(session, category)
