# beginning of Models.py
# note that at this point you should have created "quickbev" database (see install_postgres.txt).
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import os

from sqlalchemy.schema import DropTable
from sqlalchemy.ext.compiler import compiles

#   https://stackoverflow.com/questions/38678336/sqlalchemy-how-to-implement-drop-table-cascade
@compiles(DropTable, "postgresql")
def _compile_drop_table(element, compiler, **kwargs):
    return compiler.visit_drop_table(element) + " CASCADE"


app = Flask(__name__)
username = os.environ.get("USER", "")
password = os.environ.get("PASSWORD", "")
connection_string_beginning = "postgres://"
connection_string_end = "@localhost:5432/quickbevdb"
connection_string = connection_string_beginning + username + ":" + password + connection_string_end
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
        return {'name': self.name, 'id': self.id, 'description': self.description, 'price': self.price, 'bar_id': self.bar_id}


class Bar(db.Model):
    id = db.Column(db.String(80), primary_key=True,
                   unique=True, nullable=False)
    name = db.Column(db.String(80), nullable=False)
    street = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    zipcode = db.Column(db.Integer, nullable=False)
    country = db.Column(db.String(80), nullable=False)
    date_joined = db.Column(db.Date, nullable=False)
    drink = relationship('Drink', lazy=True)
    administrator = relationship('Administrator', lazy=True)
    order = relationship('Order', lazy=True)

    @property
    def serialize(self):
        return {'id': self.id, 'name': self.name, 'city': self.city, 'state': self.state, 'zipcode': self.zipcode, 'country' : self.country, 'date_joined': self.date_joined}


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
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable=False)
    last_name = db.Column(db.String(80), nullable=False)
    order = relationship('Order', backref='user_table', lazy=True)

    @property
    def serialize(self):
        return {'id': self.id, 'password': self.password, 'first_name': self.first_name, 'last_name': self.last_name}


class Order(db.Model):
    id = db.Column(UUID(as_uuid=True), primary_key=True,
                   unique=True, nullable=False)
    user_id = db.Column(db.String(80), db.ForeignKey(
        'user_table.id'), nullable=False)
    bar_id = db.Column(db.String(80), db.ForeignKey('bar.id'), nullable=False)
    price = db.Column(db.Float(), nullable=False)
    orderDrink = relationship('OrderDrink', lazy=True)

    @property
    def serialize(self):
        return {'id': self.id, 'user_id': self.user_id, 'bar_id': self.bar_id, 'price': self.price}


class OrderDrink(db.Model):
    order_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'order.id'), nullable=False, primary_key=True)
    drink_id = db.Column(UUID(as_uuid=True), db.ForeignKey(
        'drink.id'), nullable=False, primary_key=True)
    quantity = db.Column(db.Integer, nullable=False, primary_key=True)


# 2000-12-31
db.drop_all()
db.create_all()
# End of Models.py
