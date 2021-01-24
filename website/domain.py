from datetime import datetime


class Drink_Domain(object):
    def __init__(self, drink_object=None, drink_json=None):
        self.quantity = 1
        if drink_object:
            self.id = drink_object.id
            self.name = drink_object.name
            self.description = drink_object.description
            self.price = drink_object.price
            self.business_address_id = drink_object.business_address_id
        elif drink_json:
            print('drink_json', drink_json)
            self.id = drink_json["id"]
            self.name = drink_json["name"]
            self.description = drink_json["description"]
            self.price = drink_json["price"]
            self.business_address_id = drink_json["business_address_id"]
            self.quantity = drink_json["quantity"]

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Order_Domain(object):
    def __init__(self, order_object=None, order_json=None):
        print('order_json', order_json)
        self.id = ''
        self.user_id = ''
        self.cost = 0
        self.subtotal = 0
        self.tip_percentage = 0
        self.tip_amount = 0
        self.sales_tax = 0
        self.business_address_id = ''
        self.order_drink = ''
        self.date_time = ''
        if order_object:
            # TODO: write method to create order when pulling it from the database for bartenders to view
            pass
        elif order_json:
            self.id = order_json["id"]
            self.user_id = order_json["user"]["id"]
            self.cost = order_json["cost"]
            self.subtotal = order_json["subtotal"]
            self.tip_percentage = order_json["tip_percentage"]
            self.tip_amount = order_json["tip_amount"]
            self.sales_tax = order_json["sales_tax"]
            self.business_address_id = order_json["business_address_id"]
            self.date_time = datetime.fromtimestamp(order_json["date_time"])
            self.order_drink = Order_Drink_Domain(
                order_id=self.id, order_drink_json=order_json['order_drink'])

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Order_Drink_Domain(object):
    def __init__(self, order_id=None, order_drink_object=None, order_drink_json=None):
        self.order_id = order_id
        self.order_drink = list()
        if order_drink_object:
            # TODO: write method to create order drink when pulling it from the database for bartenders to view
            pass
        elif order_drink_json:
            drink_id_list = list()
            for user_drink in order_drink_json:
                drink_domain = Drink_Domain(drink_json=user_drink["drink"])
                if drink_domain.id not in drink_id_list:
                    drink_id_list.append(drink_domain.id)
                    print('drink_domain', drink_domain.serialize())
                    self.order_drink.append(drink_domain)
                else:
                    for drink in self.order_drink:
                        if drink.id == drink_domain.id:
                            drink.quantity += drink_domain.quantity

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class User_Domain(object):
    def __init__(self, user_object=None, user_json=None):
        if user_object:
            self.id = user_object.id
            self.password = user_object.password
            self.first_name = user_object.first_name
            self.last_name = user_object.last_name
            self.stripe_id = user_object.stripe_id
        elif user_json:
            print('user_json', user_json)

            self.id = user_json["id"]
            self.password = user_json["password"]
            self.first_name = user_json["first_name"]
            self.last_name = user_json["last_name"]
            self.stripe_id = user_json["stripe_id"]

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Merchant_Domain(object):
    def __init__(self, merchant_object=None, merchant_json=None):
        if merchant_object:
            self.id = merchant_object.id
            self.password = merchant_object.password
            self.first_name = merchant_object.first_name
            self.last_name = merchant_object.last_name
            self.phone_number = merchant_object.phone_number
            self.stripe_id = merchant_object.stripe_id
        elif merchant_json:
            print('merchant_json', merchant_json)
            self.id = merchant_json["id"]
            self.password = merchant_json["password"]
            self.first_name = merchant_json["first_name"]
            self.last_name = merchant_json["last_name"]
            self.phone_number = merchant_json["phone_number"]
            self.stripe_id = merchant_json["stripe_id"]

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Business_Domain(object):
    def __init__(self, business_object=None, business_json=None):
        if business_object:
            self.id = business_object.id
            self.business_address_id = business_object.business_address_id
            self.name = business_object.name
            self.address = f"{business_object.street}, {business_object.city}, {business_object.state}, {business_object.zipcode}"
            self.sales_tax_rate = business_object.sales_tax_rate
        if business_json:
            self.id = business_json["id"]
            self.name = business_json["name"]
            self.business_address_id = business_json["business_address_id"]
            address_list = business_json["address"].split(",")
            self.street = address_list[0]
            self.city = address_list[1]
            self.state = address_list[2]
            self.zipcode = address_list[3]
            self.sales_tax_rate = business_json["sales_tax_rate"]

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes


class Tab_Domain(object):
    def __init__(self, tab_object=None, tab_json=None):
        if tab_object:
            self.id = tab_object.id
            self.name = tab_object.name
            self.business_address_id = tab_object.business_address_id
            self.user_id = tab_object.user_id
            self.address = tab_object.address
            self.date_time = tab_object.date_time
            self.description = tab_object.description
            self.minimum_contribution = tab_object.minimum_contribution
            self.fundraising_goal = tab_object.fundraising_goal
        if tab_json:
            self.id = tab_json["id"]
            self.name = tab_json["name"]
            self.business_address_id = tab_json["business_address_id"]
            self.user_id = tab_json["user_id"]
            self.address = tab_json["address"]

            address_list = tab_json["address"].split(",")
            self.street = address_list[0]
            self.city = address_list[1]
            self.state = address_list[2]
            self.zipcode = address_list[3]

            self.date_time = datetime.fromtimestamp(tab_json["date_time"])

            self.description = tab_json["description"]
            self.minimum_contribution = tab_json["minimum_contribution"]
            self.fundraising_goal = tab_json["fundraising_goal"]

    def serialize(self):
        attribute_names = list(self.__dict__.keys())
        attributes = list(self.__dict__.values())
        serialized_attributes = {}
        for i in range(len(attributes)):
            serialized_attributes[attribute_names[i]] = attributes[i]
        return serialized_attributes
