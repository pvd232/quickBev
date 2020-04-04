from models import db, Drink, Bar, app
import uuid
from uuid import UUID
import json
from datetime import date
from sqlalchemy.ext.declarative import DeclarativeMeta
from sqlalchemy.orm.collections import InstrumentedList

# https://stackoverflow.com/questions/52939176/json-encoder-different-results-for-json-dump-and-json-dumps
# https://stackoverflow.com/questions/12664385/sqlalchemy-metaclass-confusion
# https://www.w3schools.com/python/ref_func_isinstance.asp
# https://stackoverflow.com/questions/5022066/how-to-serialize-sqlalchemy-result-to-json/7032311


class AlchemyEncoder(json.JSONEncoder):

    def default(self, obj):

        if isinstance(obj.__class__, DeclarativeMeta):
            fields = {}
                
            #https://stackoverflow.com/questions/1958219/convert-sqlalchemy-row-object-to-python-dict
            for column in obj.__table__.columns:
                data = getattr(obj, column.name)
                field = column.name
                # this will fail on non-encodable values, like other classes
                try:
                    json.dumps(data)
                    fields[field] = data
                except TypeError:
                    #https://stackoverflow.com/questions/36588126/uuid-is-not-json-serializable
                    if isinstance(data, UUID):
                        fields[field] = data.hex
                    else:
                        fields[field] = None
            # a json-encodable dict
            return fields

        return json.JSONEncoder.default(self, obj)

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

        new_drink = Drink(id=id, name=name,
                          description=description, price=price, bar_id=bar)

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

        new_bar = Bar(id=id, name=name, street=street, city=city,
                      state=state, zipcode=zipcode, date_joined=date_joined)

        # After I create the drink, I can then add it to my session.
        db.session.add(new_bar)

    # commit the session to my DB.
    db.session.commit()


db.create_all()

create_bar()
create_drink()
