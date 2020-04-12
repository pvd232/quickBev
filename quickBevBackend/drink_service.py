from drink_model import Drink_Model
from drink_repository import Drink_Repository

class Drink_Service(object):
    def __init__(self):
        self.drink_repository = Drink_Repository()
        self.drinks = self.get_drinks()
    def get_drinks(self):
        response = []
        drinks = self.drink_repository.get_drinks()
        for drink in drinks:
            drink_Props = drink.serialize
            drink_model = Drink_Model(id = drink_Props['id'], name = drink_Props['name'], description = drink_Props['description'], price = drink_Props['price'], bar_id = drink_Props['bar_id'])
            response.append(drink_model)
        return response
    def get_cheap_drinks(self):
        response = []
        for drink in self.drinks:
            if drink.price < 30:
                response.append(drink)
        return response




