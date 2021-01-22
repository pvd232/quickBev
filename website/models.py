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
    business_address_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business_address.id'), nullable=False)
    order_drink = relationship('Order_Drink', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Business(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    classification = db.Column(db.String(80), nullable=False)
    date_joined = db.Column(db.Date, nullable=False)
    sales_tax_rate = db.Column(db.Float(), nullable=False)
    merchant_id = db.Column(db.String(80), db.ForeignKey(
        'merchant.id'), nullable=False)
    numberOfLocations = db.Column(db.BigInteger(), nullable=False)
    business_address = relationship("Business_Address", lazy=True)


# TODO: change Bar class to Business, change Administrator to Merchant, create a new associative table BusinessLocation that links busnesses with their different locations
    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Business_Address(db.Model):
    __tablename__ = 'business_address'
    id = db.Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True,  # https://stackoverflow.com/questions/55917056/how-to-prevent-uuid-primary-key-for-new-sqlalchemy-objects-being-created-with-th
                   unique=True, nullable=False)
    business_id = db.Column(db.String(80), db.ForeignKey('business.id'),
                            nullable=False)
    tablet = db.Column(db.Boolean(), nullable=False)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    suite = db.Column(db.String(80), nullable=True)
    address = db.Column(db.String(80), nullable=False)
    drink = relationship('Drink', lazy=True)
    order = relationship('Order', lazy=True)
    tab = relationship('Tab', lazy=True)


class Merchant(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    phone_number = db.Column(db.BigInteger(), nullable=False)
    stripe_id = db.Column(db.String(80), db.ForeignKey(
        'stripe_account.id'), nullable=False)
    business = relationship("Business", lazy=True)


class User_Table(db.Model):
    __tablename__ = 'user_table'
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    stripe_id = db.Column(db.String(80), db.ForeignKey('stripe_customer.id'),
                          nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
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


class Order(db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    user_id = db.Column(db.String(80), db.ForeignKey(
        'user_table.id'), nullable=False)
    business_address_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business_address.id'), nullable=False)
    cost = db.Column(db.Float(), nullable=False)
    subtotal = db.Column(db.Float(), nullable=False)
    sales_tax = db.Column(db.Float(), nullable=False)
    tip_percentage = db.Column(db.Float(), nullable=False)
    tip_amount = db.Column(db.Float(), nullable=False)
    date_time = db.Column(db.Date, nullable=False)
    orderDrink = relationship('Order_Drink', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Order_Drink(db.Model):
    __tablename__ = 'order_drink'
    id = db.Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True,  # https://stackoverflow.com/questions/55917056/how-to-prevent-uuid-primary-key-for-new-sqlalchemy-objects-being-created-with-th
                   unique=True, nullable=False)
    order_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'order.id'), nullable=False, primary_key=True)
    drink_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'drink.id'), nullable=False, primary_key=True)


class Tab (db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    business_address_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business_address.id'), nullable=False)
    user_id = db.Column(db.String(80), db.ForeignKey(
        'user_table.id'), nullable=False)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80),  nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    address = db.Column(db.String(80), nullable=False)
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


class Stripe_Customer(db.Model):
    __tablename__ = 'stripe_customer'

    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    user_table = relationship('User_Table', lazy=True)

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Stripe_Account(db.Model):
    __tablename__ = 'stripe_account'

    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    merchant = relationship('Merchant', lazy=True)

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


def create_business():
    new_stripe_account = Stripe_Account(id="b")
    db.session.add(new_stripe_account)
    new_merchant = Merchant(id="a", password="a", first_name="peter",
                            last_name="driscoll", phone_number=5126456898, stripe_id="b")
    db.session.add(new_merchant)

    test_business = load_json("test_business.json")
    for business in test_business:
        id = business['id']
        merchant_id = business["merchant_id"]
        name = business['name']
        date_joined = date.today()
        sales_tax_rate = business["sales_tax_rate"]
        classification = business["classification"]
        new_business = Business(merchant_id=merchant_id,
                                id=id, name=name, date_joined=date_joined, sales_tax_rate=sales_tax_rate, classification=classification)

        street = business['street']
        city = business['city']
        state = business['state']
        zipcode = business['zipcode']
        address = f"{street}, {city}, {state}, {zipcode}"
        new_business_address = Business_Address(business_id=business['id'], street=street, city=city,
                                                state=state, zipcode=zipcode, address=address)
        # After I create the drink, I can then add it to my session.
        db.session.add(new_business)
        db.session.add(new_business_address)

    # commit the session to my DB.
    db.session.commit()


def create_drink():
    business_addresses = db.session.query(Business_Address)

    test_drinks = load_json("test_drinks.json")

    business_address_counter = 0
    for drink in test_drinks:
        id = uuid.uuid4().hex
        name = drink['name']
        description = drink['description']
        price = drink['price']

        new_drink = Drink(id=id, name=name,
                          description=description, price=price, business_address_id=business_addresses[business_address_counter].id)
        # alternate between the two business address objects when assingning the drinks a business address id
        if business_address_counter == 0:
            business_address_counter = 1
        elif business_address_counter == 1:
            business_address_counter = 0
        # After I create the drink, I can then add it to my session.
        db.session.add(new_drink)

    # commit the session to my DB.
    db.session.commit()


def create_everything():
    db.drop_all()
    db.create_all()
    create_business()
    create_drink()


# create_everything()
