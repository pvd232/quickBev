export const setLocalStorage = (key, object) => {
  localStorage.setItem(key, JSON.stringify(object));
};

export class Drink {
  constructor(drinkObject) {
    console.log("drinkObject", drinkObject);
    this._id = drinkObject.id;
    this._name = drinkObject.name;
    this._price = drinkObject.price;
    this._quantity = drinkObject.quantity;
    this._description = drinkObject.description;
    this._orderDrinkId = drinkObject.order_drink_id;
    this._businessAddressId = drinkObject.business_address_id;
  }
  get id() {
    return this._id;
  }
  get name() {
    return this._name;
  }
  get price() {
    return this._price;
  }
  get quantity() {
    return this._quantity;
  }
  get description() {
    return this._description;
  }
  get orderDrinkId() {
    return this._orderDrinkId;
  }
  get businessAddressId() {
    return this._businessAddressId;
  }
  set id(value) {
    this._id = value;
  }
  set name(value) {
    this._name = value;
  }
  set price(value) {
    this._price = value;
  }
  set quantity(value) {
    this._quantity = value;
  }
  set description(value) {
    this._description = value;
  }
  set orderDrinkId(value) {
    this._orderDrinkId = value;
  }
  set businessAddressId(value) {
    this._businessAddressId = value;
  }
  toJSON() {
    const data = {
      id: this._id,
      name: this._name,
      price: this._price,
      quantity: this._quantity,
      description: this._description,
      orderDrinkId: this._orderDrinkId,
      businessAddressId: this._businessAddressId,
    };
    return data;
  }
}

export class OrderDrink {
  constructor(orderDrinkObject) {
    this._orderDrink = new Array();
    console.log("orderDrinkObject", orderDrinkObject);
    for (var i = 0; i < orderDrinkObject.order_drink.length; i++) {
      console.log(
        "orderDrinkObject.order_drink[i]",
        orderDrinkObject.order_drink[i]
      );
      const newDrink = new Drink(orderDrinkObject.order_drink[i]);
      this._orderDrink.push(newDrink);
    }
  }
}

export class Order {
  constructor(order_object) {
    this._id = order_object.id;
    this._userId = order_object.user_id;
    this._cost = order_object.cost;
    this._subtotal = order_object.subtotal;
    this._tipPercentage = order_object.tip_percentage;
    this._tipAmount = order_object.tip_amount;
    this._salesTax = order_object.sales_tax;
    this._businessAddressId = order_object.business_address_id;
    this._address = order_object.address;
    this._orderDrink = new OrderDrink(order_object.order_drink);
    this._orderDrink.orderId = this._id;
  }
  get id() {
    return this._id;
  }
  get userId() {
    return this._userId;
  }
  get cost() {
    return this._cost;
  }
  get subtotal() {
    return this._subtotal;
  }
  get tipPercentage() {
    return this._tipPercentage;
  }
  get tipAmount() {
    return this._tipAmount;
  }
  get salesTax() {
    return this._salesTax;
  }
  get businessAddressId() {
    return this._businessAddressId;
  }
  get address() {
    return this._address;
  }
  get orderDrink() {
    return this._orderDrink;
  }
  set id(value) {
    this._id = value;
  }
  set userId(value) {
    this._userId = value;
  }
  set cost(value) {
    this._cost = value;
  }
  set subtotal(value) {
    this._subtotal = value;
  }
  set tipPercentage(value) {
    this._tipPercentage = value;
  }
  set tipAmount(value) {
    this._tipAmount = value;
  }
  set salesTax(value) {
    this._salesTax = value;
  }
  set businessAddressId(value) {
    this._businessAddressId = value;
  }
  set address(value) {
    this._address = value;
  }
  set orderDrink(value) {
    this._orderDrink = value;
  }
  toJSON() {
    const data = {
      id: this._id,
      user_id: this._userId,
      cost: this._cost,
      subtotal: this._subtotal,
      tip_percentage: this._tipPercentage,
      tip_amount: this._tipAmount,
      sales_tax: this._salesTax,
      business_address_id: this._businessAddressId,
      address: this._address,
      order_drink: this._orderDrink,
    };
    return data;
  }
}

export class Merchant {
  constructor(objectType, object) {
    if (objectType === "merchantObject") {
      this._id = object.id;
      this._password = object.password;
      this._firstName = object.firstName;
      this._lastName = object.lastName;
      this._phoneNumber = object.phoneNumber;
    } else if (objectType === "merchantStateObject") {
      this._id = object._id;
      this._password = object._password;
      this._firstName = object._firstName;
      this._lastName = object._lastName;
      this._phoneNumber = object._phoneNumber;
    } else if (objectType === "localStorage") {
      const data = JSON.parse(object);
      console.log("object", object);
      console.log("data", data);
      this._id = data.id;
      this._password = data.password;
      this._firstName = data.first_name;
      this._lastName = data.last_name;
      this._phoneNumber = data.phone_number;
    } else {
      this._id = null;
      this._password = null;
      this._firstName = null;
      this._lastName = null;
      this._phoneNumber = null;
    }
  }

  get id() {
    return this._id;
  }
  get password() {
    return this._password;
  }

  get firstName() {
    return this._firstName;
  }
  get lastName() {
    return this._lastName;
  }
  get phoneNumber() {
    return this._phoneNumber;
  }
  set id(value) {
    this._id = value;
  }
  set password(value) {
    this._password = value;
  }

  set firstName(value) {
    this._firstName = value;
  }
  set lastName(value) {
    this._lastName = value;
  }
  set phoneNumber(value) {
    this._phoneNumber = value;
  }
  toJSON() {
    const data = {
      id: this._id,
      password: this._password,
      first_name: this._firstName,
      last_name: this._lastName,
      phone_number: this._phoneNumber,
    };
    return data;
  }
}
export class Business {
  constructor(businessObject, isLocalStorage = false) {
    if (businessObject && !isLocalStorage) {
      this._id = businessObject.id;
      this._name = businessObject.name;
      this._stripeId = businessObject.stripe_id;
      this._merchantId = businessObject.merchant_id;
      this._address = businessObject.address;
      this._street = businessObject.street;
      this._city = businessObject.city;
      this._state = businessObject.state;
      this._zipcode = businessObject.zip;
      this._phoneNumber = businessObject.phone_number;
      this._numberOfLocations = businessObject.number_of_locations;
      this._tablet = businessObject.tablet;
      this._menuUrl = businessObject.menu_url;
      this._classification = businessObject.classification;
    } else if (businessObject && isLocalStorage) {
      const businessJson = JSON.parse(businessObject);
      this._id = businessJson.id;
      this._name = businessJson.name;
      this._stripeId = businessJson.stripe_id;
      this._merchantId = businessJson.merchant_id;
      this._address = businessJson.address;
      this._street = businessJson.street;
      this._city = businessJson.city;
      this._state = businessJson.state;
      this._zipcode = businessJson.zip;
      this._phoneNumber = businessJson.phone_number;
      this._numberOfLocations = businessJson.number_of_locations;
      this._tablet = businessJson.tablet;
      this._menuUrl = businessJson.menu_url;
      this._classification = businessJson.classification;
    } else {
      this._id = null;
      this._name = null;
      this._merchantId = null;
      this._stripeId = null;
      this._address = null;
      this._street = null;
      this._city = null;
      this._state = null;
      this._zipcode = null;
      this._phoneNumber = null;
      this._numberOfLocations = null;
      this._tablet = null;
      this._menuUrl = null;
      this._classification = null;
    }
  }

  get id() {
    return this._id;
  }
  get name() {
    return this._name;
  }
  get merchantId() {
    return this._merchantId;
  }
  get address() {
    return this._address;
  }
  get street() {
    return this._street;
  }
  get city() {
    return this._city;
  }
  get state() {
    return this._state;
  }
  get zipcode() {
    return this._zipcode;
  }
  get phoneNumber() {
    return this._phoneNumber;
  }
  get numberOfLocations() {
    return this._numberOfLocations;
  }
  get stripeId() {
    return this._stripeId;
  }
  get tablet() {
    return this._tablet;
  }
  get menuUrl() {
    return this._menuUrl;
  }
  get classification() {
    return this._classification;
  }
  set id(value) {
    this._id = value;
  }
  set name(value) {
    this._name = value;
  }
  set merchantId(value) {
    this._merchantId = value;
  }
  set address(value) {
    this._address = value;
  }
  set street(value) {
    this._street = value;
  }
  set city(value) {
    this._city = value;
  }
  set state(value) {
    this._state = value;
  }
  set zipcode(value) {
    this._zipcode = value;
  }
  set phoneNumber(value) {
    this._phoneNumber = value;
  }
  set numberOfLocations(value) {
    this._numberOfLocations = value;
  }
  set stripeId(value) {
    this._stripeId = value;
  }
  set tablet(value) {
    this._tablet = value;
  }
  set menuUrl(value) {
    this._menuUrl = value;
  }
  set classification(value) {
    this._classification = value;
  }

  toJSON() {
    const data = {
      id: this._id,
      name: this._name,
      merchant_id: this._merchantId,
      stripe_id: this._stripeId,
      address: this._address,
      street: this._street,
      city: this._city,
      state: this._state,
      zipcode: this._zipcode,
      phone_number: this._phoneNumber,
      number_of_locations: this._numberOfLocations,
      tablet: this._tablet,
      menu_url: this._menuUrl,
      classification: this._classification,
    };
    return data;
  }
}
