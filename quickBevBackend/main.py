from flask import Flask
from create_database import fetch_drinks, app
import json

@app.route('/inventory', methods=['GET'])
def inventory():
    drinks = fetch_drinks()
    drinks_json = json.loads(drinks)
    return drinks_json

