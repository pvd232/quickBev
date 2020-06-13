from drink_model import Drink_Model, Order_Model, Order_Drink_Model, User_Model, Bar_Model
from drink_repository import Drink_Repository, Order_Repository, User_Repository, Bar_Repository
from models import UserTable, Bar
from create_database import db
import uuid

class Drink_Service(object):
    def __init__(self):
        self.drink_repository = Drink_Repository()
        self.drinks = self.get_drinks()

    def get_drinks(self):
        response = []
        for drink in self.drink_repository.get_drinks():
            drink_Props = drink.serialize
            drink_model = Drink_Model(id=drink_Props['id'], name=drink_Props['name'],
                                      description=drink_Props['description'], price=drink_Props['price'], bar_id=drink_Props['bar_id'])
            response.append(drink_model)
        return response

    def get_cheap_drinks(self):
        response = []
        for drink in self.drinks:
            if drink.price < 30:
                response.append(drink)
        return response


class Order_Service(object):
    def __init__(self):
        self.order_repository = Order_Repository()

    def create_order(self, order):
    
        users = db.session.query(UserTable)
        me = users[0].serialize
        my_id = me['id']
        bars = db.session.query(Bar)
        aBar = bars[0].serialize
        aBarId = aBar['id']

        new_order_model = Order_Model(
            id=order['id'], user_id=my_id, bar_id=aBarId, price=float(order['price']))
        drinks = order['order_drink']
        id_list = []
        price = 0
        for drink in drinks:
            drink_id = drink['id']
            price += float(drink['price'])
            if drink_id not in id_list:
                id_list.append(drink_id)

        order_drink_list = []
        for aDrink_id in id_list:
            order_drink_model = Order_Drink_Model(
                order_id = new_order_model.id, drink_id = aDrink_id, quantity=0)
            for drink in drinks:
                drink_id = drink['id']
                if drink_id == aDrink_id:
                    order_drink_model.quantity += 1
            order_drink_list.append(order_drink_model)
        # pass in the order drink list as a list to the order_drink repository because I think making a new DB connection for every order drink would be too expensive and lead to poor performance 
        self.order_repository.post_order(new_order_model, order_drink_list)

    def get_orders(self):
        response = []
        for order in self.order_repository.get_orders():
            order_Props = order.serialize
            order_model = Order_Model(id=order_Props['id'], user_id=order_Props['user_id'],
                                        bar_id=order_Props['bar_id'], price=order_Props['price'])
            response.append(order_model)
        return response

class User_Service(object):
    def __init__(self):
        self.user_repository = User_Repository()

    def authenticate_user(self, email, password):
        user_serialized = self.user_repository.authenticate_user(email, password)
        if user_serialized:
            user_model = User_Model(email=user_serialized['id'], password=user_serialized['password'], first_name=user_serialized['first_name'], last_name=user_serialized['last_name'])
            return user_model
        else:
            return False

    def register_new_user(self, user):
        user_status = self.user_repository.register_new_user(user)
        if user_status:
            return True
        else:
            return False

class Bar_Service(object):
        def __init__(self):
            self.bar_repository = Bar_Repository()

        def get_bars(self):
            response = []
            for bar in self.bar_repository.get_bars():
                bar_serialized = bar.serialize
                bar_model = Bar_Model(id=bar_serialized['id'], name=bar_serialized['name'], street=bar_serialized['street'], city=bar_serialized['city'], state=bar_serialized['state'], zipcode=str(bar_serialized['zipcode']), country=bar_serialized['country'])
                response.append(bar_model)
            return response
