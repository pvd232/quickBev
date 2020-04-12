from create_database import app, db
from models import Drink

class Drink_Repository(object):
    def __init__(self):
        self.database = db
    def get_drinks(self):
        drinks = self.database.session.query(Drink)
        return drinks
