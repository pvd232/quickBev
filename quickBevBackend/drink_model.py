class Drink_Model(object):
    def __init__(self, id = None, name = None, description = None, price = None, bar_id = None):
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.bar_id = bar_id
    def serialize(self):
        return {'name': self.name, 'id': self.id, 'image': 'mango', 'description': self.description, 'price': self.price, 'bar_id': self.bar_id}