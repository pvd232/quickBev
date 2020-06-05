# set up a scoped_session
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
import uuid
import os
from models import Drink, Order, OrderDrink, UserTable, Bar


class Drink_Repository(object):
    def __init__(self):
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        connection_string_beginning = "postgres://"
        connection_string_end = "@localhost:5432/quickbevdb"
        connection_string = connection_string_beginning + \
            username + ":" + password + connection_string_end

        # an Engine, which the Session will use for connection
        # resources
        drink_engine = create_engine(connection_string)

        # create a configured "Session" class
        session_factory = sessionmaker(bind=drink_engine)

        # create a Session
        self.Session = scoped_session(session_factory)

        # now all calls to Session() will create a thread-local session

    def get_drinks(self):
        get_drink_session = self.Session()
        drinks = get_drink_session.query(Drink)

        # you can now use some_session to run multiple queries, etc.
        # remember to close it when you're finished!
        self.Session.remove()
        return drinks


class Order_Repository(object):
    def __init__(self):
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        connection_string_beginning = "postgres://"
        connection_string_end = "@localhost:5432/quickbevdb"
        connection_string = connection_string_beginning + \
            username + ":" + password + connection_string_end
        patient_request_engine = create_engine(connection_string)
        session_factory = sessionmaker(bind=patient_request_engine)
        self.Session = scoped_session(session_factory)

    def post_order(self, order, order_drink_list):
        post_order_session = self.Session()
        new_order = Order(id=order.id, user_id=order.user_id,
                          bar_id=order.bar_id, price=order.price)
        post_order_session.add(new_order)

        for each_order_drink in order_drink_list:
            new_order_drink = OrderDrink(
                order_id=new_order.id, drink_id=each_order_drink.drink_id, quantity=each_order_drink.quantity)
            post_order_session.add(new_order_drink)
        post_order_session.commit()
        self.Session.remove()

    def get_orders(self):
        get_order_session = self.Session()
        orders = get_order_session.query(Order)
        self.Session.remove()
        return orders


class User_Repository(object):
    def __init__(self):
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        connection_string_beginning = "postgres://"
        connection_string_end = "@localhost:5432/quickbevdb"
        connection_string = connection_string_beginning + \
            username + ":" + password + connection_string_end
        user_engine = create_engine(connection_string)
        session_factory = sessionmaker(bind=user_engine)
        self.Session = scoped_session(session_factory)

    def authenticate_user(self, email, password):
        get_user_session = self.Session()

      # check to see if the user exists in the database by querying the User_Info table for the giver username and password
      # if they don't exist this will return a null value for user which i check for in line 80
        user = get_user_session.query(UserTable).filter(
            UserTable.id == email, UserTable.password == password).first()

        if user:
            user = user.serialize
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

    def register_new_user(self, user):
        add_user_session = self.Session()
        test_user = add_user_session.query(UserTable).filter(
            UserTable.id == user["email"]).first()
        if test_user == None:
            new_user = UserTable(id=user["email"], password=user["password"],
                                 first_name=user["first_name"], last_name=user["last_name"])
            add_user_session.add(new_user)
            add_user_session.commit()
            self.Session.remove()
            return True

        else:
            return False


class Bar_Repository(object):
    def __init__(self):
        super().__init__()
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        connection_string_beginning = "postgres://"
        connection_string_end = "@localhost:5432/quickbevdb"
        connection_string = connection_string_beginning + username + ":" + password + connection_string_end
        user_engine = create_engine(connection_string)
        session_factory = sessionmaker(bind=user_engine)
        self.Session = scoped_session(session_factory)

    def get_bars(self):
        get_bars_session = self.Session()
        bars = get_bars_session.query(Bar)
        self.Session.remove()
        return bars
