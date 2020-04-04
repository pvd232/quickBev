from flask import Flask
from create_database import fetch_drinks, app
import json

@app.route('/inventory', methods=['GET'])
def inventory():
    drinks = db.session.query(Drink)
    drinks_json = json.loads(drinks)
    return drinks_json

