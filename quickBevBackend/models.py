# beginning of Models.py
# note that at this point you should have created "statesdb" database (see install_postgres.txt).
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
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get("DB_STRING", 'postgres://machina:Iqopaogh23!@localhost:5432/quickbev')


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True # to suppress a warning message
db = SQLAlchemy(app)

class Drink(db.Model):
    __table__name = 'drink'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    name = db.Column(db.String(80), nullable = False)
    description = db.Column(db.String(80), nullable = False)
    price = db.Column(db.Float(), nullable = False)
    bar_id = db.Column(UUID(as_uuid=True), db.ForeignKey('bar.id'), nullable = False)
    order_drink = relationship('OrderDrink', lazy = True)

    @property
    def serialize(self):
        return {'name': self.name, 'image': "mango", 'id': self.id, 'description': self.description, 'price': self.price, 'bar_id': self.bar_id}

class Bar(db.Model):
    __table__name = 'bar'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    name = db.Column(db.String(80), nullable = False)
    street = db.Column(db.String(80), nullable = False)
    city = db.Column(db.String(80), nullable = False)
    state = db.Column(db.String(80), nullable = False)
    zipcode = db.Column(db.Integer, nullable = False)
    date_joined = db.Column(db.Date, nullable = False)
    drink = relationship('Drink', lazy = True)
    administrator = relationship('Administrator', lazy = True)
    order = relationship('Order', lazy = True)
    

class Administrator(db.Model):
    __table__name = 'administrator'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    email = db.Column(db.String(80), nullable = False)
    bar_id = db.Column(UUID(as_uuid=True), db.ForeignKey('bar.id'), nullable = False)
    birthday = db.Column(db.Date, nullable = False)

class User(db.Model):
    __table__name = 'user'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    email = db.Column(db.String(80), nullable = False)
    birthday = db.Column(db.Date, nullable = False)
    university = db.Column(db.String(80), nullable = True)
    order = relationship('Order', lazy = True)

class Order(db.Model):
    __table__name = 'order'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.id'), nullable = False)
    bar_id = db.Column(UUID(as_uuid=True), db.ForeignKey('bar.id'), nullable = False)
    orderDrink = relationship('OrderDrink', lazy = True)

class OrderDrink(db.Model):
    __table__name = 'order_drink'
    order_id = db.Column(UUID(as_uuid=True), db.ForeignKey('order.id'), nullable = False, primary_key = True)
    drink_id = db.Column(UUID(as_uuid=True), db.ForeignKey('drink.id'), nullable = False, primary_key = True)
    quantity = db.Column(db.Integer, nullable = False, primary_key = True)
    

db.drop_all()
db.create_all()
# End of Models.py