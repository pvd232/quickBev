from models import db, Drink, Bar, app
import uuid
import json
from datetime import date


def load_json(filename):

    with open(filename) as file:
        jsn = json.load(file)
        file.close()

    return jsn

def create_drink():
    bars = db.session.query(Bar)
    bar1 = bars[0]
    test_drinks = load_json("test_drinks.json")

    for drink in test_drinks:
        id = uuid.uuid4().hex
        name = drink['name']
        description = drink['description']
        price = drink['price']
        bar = bar1.id

        new_drink = Drink(id = id, name = name, description = description, price = price, bar_id = bar)

        # After I create the drink, I can then add it to my session.
        db.session.add(new_drink)

    # commit the session to my DB.
    db.session.commit()

def create_bar():

    test_bar = load_json("test_bar.json")

    for bar in test_bar:
        id = uuid.uuid4().hex
        name = bar['name']
        street = bar['street']
        city = bar['city']
        state = bar['state']
        zipcode = bar['zipcode']
        date_joined = date.today()

        new_bar = Bar(id = id, name = name, street = street, city = city, state = state, zipcode = zipcode, date_joined = date_joined)

        # After I create the drink, I can then add it to my session.
        db.session.add(new_bar)

    # commit the session to my DB.
    db.session.commit()

def fetch_drinks():

    drinks = db.session.query(Drink)
    return drinks

create_bar()
create_drink()