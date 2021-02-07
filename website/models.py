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
import stripe

#   https://stackoverflow.com/questions/38678336/sqlalchemy-how-to-implement-drop-table-cascade

stripe.api_key = "sk_test_51I0xFxFseFjpsgWvh9b1munh6nIea6f5Z8bYlIDfmKyNq6zzrgg8iqeKEHwmRi5PqIelVkx4XWcYHAYc1omtD7wz00JiwbEKzj"


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
    business_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business.id'), nullable=False)
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
    __tablename__ = 'business'
    id = db.Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True,  # https://stackoverflow.com/questions/55917056/how-to-prevent-uuid-primary-key-for-new-sqlalchemy-objects-being-created-with-th
                   unique=True, nullable=False)
    name = db.Column(db.String(80),
                     nullable=False)
    classification = db.Column(db.String(80), nullable=False)
    date_joined = db.Column(db.Date, nullable=False)
    sales_tax_rate = db.Column(db.Float(), nullable=False)
    merchant_id = db.Column(db.String(80), db.ForeignKey(  # composite primary key because there might be multiple businesses with the same name
        'merchant.id'), nullable=False)
    tablet = db.Column(db.Boolean(), nullable=False)
    phone_number = db.Column(db.BigInteger(), nullable=False)
    # not all businesses will have a menu URL or file upload, but they could be specific to each business
    menu_url = db.Column(db.String(80), nullable=True)
    menu_file_path = db.Column(db.String(180), nullable=True)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    suite = db.Column(db.String(80), nullable=True)
    address = db.Column(db.String(80), nullable=False)
    drink = relationship('Drink', lazy=True, backref="business")
    order = relationship('Order', lazy=True, backref="business")
    tab = relationship('Tab', lazy=True, backref="business")

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Merchant(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    # stripe_id = db.Column(db.String(80), db.ForeignKey(
    #     'stripe_account.id'), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    phone_number = db.Column(db.BigInteger(), nullable=False)
    number_of_businesses = db.Column(db.Integer(), nullable=False)
    business = relationship(
        "Business", lazy=True, backref="merchant")
    merchant_stripe = relationship(
        "Merchant_Stripe", lazy=True, backref="merchant")

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Merchant_Stripe(db.Model):
    __tablename__ = "merchant_stripe"
    merchant_id = db.Column(db.String(80), db.ForeignKey(
        "merchant.id"),  primary_key=True, nullable=False)
    stripe_id = db.Column(db.String(80), db.ForeignKey(
        "stripe_account.id"),  primary_key=True, nullable=False)


class Customer(db.Model):
    __tablename__ = 'customer'
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    stripe_id = db.Column(db.String(80), db.ForeignKey('stripe_customer.id'),
                          nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    order = relationship('Order', lazy=True, backref="order")
    tab = relationship('Tab', lazy=True, backref="tab")

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
    customer_id = db.Column(db.String(80), db.ForeignKey(
        'customer.id'), nullable=False)
    business_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business.id'), nullable=False)
    merchant_stripe_id = db.Column(
        db.String(80), db.ForeignKey('stripe_account.id'))
    cost = db.Column(db.Float(), nullable=False)
    subtotal = db.Column(db.Float(), nullable=False)
    sales_tax = db.Column(db.Float(), nullable=False)
    tip_percentage = db.Column(db.Float(), nullable=False)
    tip_amount = db.Column(db.Float(), nullable=False)
    date_time = db.Column(db.Date, nullable=False)
    order_drink = relationship('Order_Drink', lazy=True, backref="order")

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
        'order.id'), nullable=False)
    drink_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'drink.id'), nullable=False)
    # did not set foriegn key here because there is no unique constraint on drink name thus i cant identify which drink name i am referecing. however i don't care which drink i am exactly referencing as long as the name exists

    @property
    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Tab (db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    business_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'business.id'), nullable=False)
    customer_id = db.Column(db.String(80), db.ForeignKey(
        'customer.id'), nullable=False)
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
    customer = relationship('Customer', lazy=True)

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
    # merchant = relationship('Merchant', lazy=True, backref="stripe_account")
    merchant_stripe = relationship(
        "Merchant_Stripe", lazy=True, backref="stripe_account")

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
    # new_stripe_account = Stripe_Account(id="b")
    new_account = stripe.Account.create(
        type="express",
        country="US"
    )
    new_stripe_account = Stripe_Account(id=new_account.id)
    db.session.add(new_stripe_account)
    # new_merchant = Merchant(id="a", password="a", first_name="peter",
    #                         last_name="driscoll", phone_number=5126456898, number_of_businesses=2, stripe_id=new_stripe_account.id)
    new_merchant = Merchant(id="a", password="a", first_name="peter",
                            last_name="driscoll", phone_number=5126456898, number_of_businesses=2)
    new_merchant_stripe = Merchant_Stripe(
        merchant_id=new_merchant.id, stripe_id=new_stripe_account.id)

    db.session.add(new_merchant_stripe)
    db.session.add(new_merchant)

    test_business = load_json("test_business.json")
    for business in test_business:
        merchant_id = business["merchant_id"]
        name = business['name']
        date_joined = date.today()
        sales_tax_rate = business["sales_tax_rate"]
        classification = business["classification"]
        phone_number = business["phone_number"]
        tablet = business["tablet"]
        street = business['street']
        city = business['city']
        state = business['state']
        zipcode = business['zipcode']
        address = f"{street}, {city}, {state} {zipcode}"
        new_business = Business(merchant_id=merchant_id,
                                name=name, date_joined=date_joined, sales_tax_rate=sales_tax_rate, classification=classification, street=street, city=city,
                                state=state, zipcode=zipcode, address=address, tablet=tablet, phone_number=phone_number)
        # After I create the drink, I can then add it to my session.
        db.session.add(new_business)

    # commit the session to my DB.
    db.session.commit()


def create_drink():
    businesses = db.session.query(Business)

    test_drinks = load_json("test_drinks.json")

    business_counter = 0
    for drink in test_drinks:
        id = uuid.uuid4().hex
        name = drink['name']
        description = drink['description']
        price = drink['price']

        new_drink = Drink(id=id, name=name,
                          description=description, price=price, business_id=businesses[business_counter].id)
        # alternate between the two business address objects when assingning the drinks a business address id
        if business_counter == 0:
            business_counter = 1
        elif business_counter == 1:
            business_counter = 0
        # After I create the drink, I can then add it to my session.
        db.session.add(new_drink)

    # commit the session to my DB.
    db.session.commit()


def create_everything():
    db.drop_all()
    db.create_all()
    create_business()
    create_drink()


create_everything()
