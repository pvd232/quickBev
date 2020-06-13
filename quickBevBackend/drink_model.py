import uuid

class Drink_Model(object):
    def __init__(self, id = None, name = None, description = None, price = None, bar_id = None):
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.bar_id = bar_id
        
    def serialize(self):
        return {'name': self.name, 'id': self.id, 'image': 'mango', 'description': self.description, 'price': str(self.price), 'bar_id': self.bar_id}

class Order_Model(object):
    def __init__(self, id = None, user_id = None, bar_id = None, price = None):
        self.id = id
        self.user_id = user_id
        self.price = price
        self.bar_id = bar_id

    def serialize(self):
        return {'id': self.id, 'user_id': self.user_id, 'price': str(self.price), 'bar_id': self.bar_id}

class Order_Drink_Model(object):
    def __init__(self, order_id = None, drink_id = None, quantity = None):
        self.order_id = order_id
        self.drink_id = drink_id
        self.quantity = quantity

    def serialize(self):
        return {'order_id': self.order_id, 'drink_id': self.drink_id, 'quantity': self.quantity}

class User_Model(object):
    def __init__(self, email = None, password = None, first_name = None, last_name = None):
        self.email = email
        self.password = password
        self.first_name = first_name
        self.last_name = last_name

    def serialize(self):
        return {'email': self.email, 'password': self.password, 'first_name': self.first_name, 'last_name': self.last_name}

class Bar_Model(object):
    def __init__(self, id = None, name = None, street = None, city = None, state = None, zipcode = None, country = None):
        self.id = id
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.country = country

    def serialize(self):
        return {'id': self.id, 'name': self.name, 'street': self.street, 'city': self.city, 'state': self.state, 'zipcode': self.zipcode, 'country': self.country}