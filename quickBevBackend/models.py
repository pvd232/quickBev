# beginning of Models.py
# note that at this point you should have created "quickbev" database (see install_postgres.txt).
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import os
from sqlalchemy.schema import DropTable
from sqlalchemy.ext.compiler import compiles
import uuid
import json
from datetime import date

#   https://stackoverflow.com/questions/38678336/sqlalchemy-how-to-implement-drop-table-cascade
@compiles(DropTable, "postgresql")
def _compile_drop_table(element, compiler, **kwargs):
    return compiler.visit_drop_table(element) + " CASCADE"


app = Flask(__name__)
username = os.environ.get("USER", "")
password = os.environ.get("PASSWORD", "")
connection_string_beginning = "postgres://"
connection_string_end = "@localhost:5432/quickbevdb"
connection_string = connection_string_beginning + \
    username + ":" + password + connection_string_end
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get(
    "DB_STRING", connection_string)


# to suppress a warning message
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
db = SQLAlchemy(app)


class Drink(db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    description = db.Column(db.String(80), nullable=False)
    price = db.Column(db.Float(), nullable=False)
    bar_id = db.Column(db.String(80), db.ForeignKey('bar.id'), nullable=False)
    order_drink = relationship('OrderDrink', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Bar(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    address = db.Column(db.String(80), primary_key=True,
                        unique=True, nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    date_joined = db.Column(db.Date, nullable=False)
    sales_tax_rate = db.Column(db.Float(), nullable=False)
    drink = relationship('Drink', lazy=True)
    administrator = relationship('Administrator', lazy=True)
    order = relationship('Order', lazy=True)
    tab = relationship('Tab', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Administrator(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    email = db.Column(db.String(80), nullable=False)
    bar_id = db.Column(db.String(80), db.ForeignKey('bar.id'), nullable=False)
    birthday = db.Column(db.Date, nullable=False)


class UserTable(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    stripe_id = db.Column(db.String(80), db.ForeignKey('stripe.id'),
                          nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    order = relationship('Order', backref='user_table', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Order(db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    user_id = db.Column(db.String(80), db.ForeignKey(
        'user_table.id'), nullable=False)
    bar_id = db.Column(db.String(80), db.ForeignKey('bar.id'), nullable=False)
    cost = db.Column(db.Float(), nullable=False)
    subtotal = db.Column(db.Float(), nullable=False)
    sales_tax = db.Column(db.Float(), nullable=False)
    tip_percentage = db.Column(db.Float(), nullable=False)
    tip_amount = db.Column(db.Float(), nullable=False)
    date_time = db.Column(db.Date, nullable=False)
    orderDrink = relationship('OrderDrink', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class OrderDrink(db.Model):
    order_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'order.id'), nullable=False, primary_key=True)
    drink_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'drink.id'), nullable=False, primary_key=True)
    quantity = db.Column(db.Integer, nullable=False, primary_key=True)


class Tab (db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    bar_id = db.Column(db.String(80), nullable=False)
    user_id = db.Column(db.String(80), nullable=False)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80),  nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    address = db.Column(db.String(80), db.ForeignKey(
        'bar.address'), nullable=False)
    date_time = db.Column(db.DateTime(), nullable=False)
    description = db.Column(db.String(280), nullable=False)
    minimum_contribution = db.Column(db.Integer, nullable=False)
    fundraising_goal = db.Column(db.Integer, nullable=False)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Stripe(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    user_table = relationship('UserTable', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


def load_json(filename):

    with open(filename) as file:
        jsn = json.load(file)
        file.close()

    return jsn


def create_drink():
    bars = db.session.query(Bar)

    test_drinks = load_json("test_drinks.json")

    for drink in test_drinks:
        id = uuid.uuid4().hex
        name = drink['name']
        description = drink['description']
        price = drink['price']
        bar_id = drink['bar']

        new_drink = Drink(id=id, name=name,
                          description=description, price=price, bar_id=bar_id)

        # After I create the drink, I can then add it to my session.
        db.session.add(new_drink)

    # commit the session to my DB.
    db.session.commit()


def create_bar():

    test_bar = load_json("test_bar.json")

    for bar in test_bar:
        id = bar['id']
        name = bar['name']
        street = bar['street']
        city = bar['city']
        state = bar['state']
        zipcode = bar['zipcode']
        address = f"{street}, {city}, {state}, {zipcode}"
        date_joined = date.today()
        sales_tax_rate = bar["sales_tax_rate"]

        new_bar = Bar(id=id, name=name, street=street, city=city,
                      state=state, zipcode=zipcode, address=address, date_joined=date_joined, sales_tax_rate=sales_tax_rate)

        # After I create the drink, I can then add it to my session.
        db.session.add(new_bar)
    # me = UserTable(id = "a", password= 'a', first_name = 'peter', last_name = 'driscoll')
    # db.session.add(me)
    # commit the session to my DB.
    db.session.commit()


def create_everything():
    db.drop_all()
    db.create_all()
    create_bar()
    create_drink()

# create_everything()
