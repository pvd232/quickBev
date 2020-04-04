# beginning of models.py
# note that at this point you should have created "statesdb" database (see install_postgres.txt).
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get("DB_STRING", 'postgres://postgres:Iqopaogh23!@localhost:5432/statesdb')


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True # to suppress a warning message
db = SQLAlchemy(app)

class Drink(db.object):
    __table__name = 'drink'
    id = db.Column(db.String, nullable = False, primary_key = True)
    name = db.Column(db.String(80), nullable = False)
    description = db.Column(db.String(80), nullable = False)
    price = db.Column(db.Float(), nullable = False)
    bar_id = db.Column(db.String, db.ForeignKey('bar.id'), nullable = False)
    order_drink = relationship('Order_Drink', lazy = True)

class Bar(db.object):
    __table__name = 'bar'
    id = db.Column(db.Integer, nullable = False, primary_key = True)
    name = db.Column(db.String(80), nullable = False)
    street = db.Column(db.String(80), nullable = False)
    city = db.Column(db.String(80), nullable = False)
    state = db.Column(db.String(80), nullable = False)
    zip_code = db.Column(db.Integer, nullable = False)
    date_joined = db.Column(db.Date(timezone=False), nullable = False)
    drink = relationship('Drink', lazy = True)
    administrator = relationship('Administrator', lazy = True)
    order = relationship('Order', lazy = True)
    

class Administrator(db.object):
    __table__name = 'administrator'
    id = db.Column(db.String, nullable = False, primary_key = True)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    email = db.Column(db.String(80), nullable = False)
    bar_id = db.Column(db.String(80), db.foreign_key('bar.id'), nullable = False)
    birthday = db.Column(db.Date(timezone=False), nullable = False)

class User(db.object):
    __table__name = 'user'
    id = db.Column(db.String, nullable = False, primary_key = True)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    email = db.Column(db.String(80), nullable = False)
    birthday = db.Column(db.Date(timezone=False), nullable = False)
    university = db.Column(db.String(80), nullable = True)
    order = relationship('Order', lazy = True)

class Order(db.object):
    __table__name = 'order'
    id = db.Column(db.String, nullable = False, primary_key = True)
    user_id = db.Column(db.String(80), db.foreign_key('drink.id'), nullable = False)
    bar_id = db.Column(db.String(80), db.foreign_key('bar.id'), nullable = False)
    order_drink = relationship('Order_Drink', lazy = True)

class Order_Drink(db.object):
    __table__name = 'order_drink'
    order_id = db.Column(db.String, db.foreign_key('order.id'), nullable = False, primary_key = True)
    drink_id = db.Column(db.String(80), db.foreign_key('drink.id'), nullable = False, primary_key = True)
    quantity = bar_id = db.Column(db.Integer, nullable = False)
    

db.drop_all()
db.create_all()
# End of models.py