from domain import *
from repository import *
from models import db
import uuid
import os
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from contextlib import contextmanager


@contextmanager
def session_scope():
    username = os.environ.get("USER", "")
    password = os.environ.get("PASSWORD", "")
    connection_string_beginning = "postgres://"
    connection_string_end = "@localhost:5432/quickbevdb"
    connection_string = connection_string_beginning + \
        username + ":" + password + connection_string_end
    # an Engine, which the Session will use for connection
    # resources
    drink_engine = create_engine(
        os.environ.get("DB_STRING", connection_string))

    # create a configured "Session" class
    session_factory = sessionmaker(bind=drink_engine)

    # create a Session
    session = scoped_session(session_factory)
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
                # drink_Props = drink.serialize
                drink_domain = Drink_Domain(drink_object=drink)
                response.append(drink_domain)
            return response


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
            for order in self.order_repository.get_orders(session, username):
                order_domain = Order_Domain(order_object=order)
                response.append(order_domain)
            return response

    def get_stripe_ephemeral_key(self, request):
        with session_scope() as session:
            return self.order_repository.get_stripe_ephemeral_key(session, request)

    def stripe_payment_intent(self, request):
        with session_scope() as session:
            return self.order_repository.stripe_payment_intent(session, request)


class User_Service(object):
    def __init__(self):
        self.user_repository = User_Repository()

    def authenticate_user(self, email, password):
        with session_scope() as session:
            user_serialized = self.user_repository.authenticate_user(
                session, email, password)
            if user_serialized:
                user_domain = User_Domain(user_object=user_serialized)
                return user_domain
            else:
                return False

    def register_new_user(self, user):
        with session_scope() as session:
            requested_new_user = User_Domain(user_json=user)
            registered_user_status = self.user_repository.register_new_user(
                session, requested_new_user)
            return registered_user_status


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
            # update the business domain id with the uuid that was created
            business_domain.id = business_database_object.id
            return business_domain

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
