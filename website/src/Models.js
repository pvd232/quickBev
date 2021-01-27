export const setLocalStorage = (key, object) => {
  localStorage.setItem(key, JSON.stringify(object));
};
export class Merchant {
  constructor(merchantObject = null, merchantStateObject = null) {
    if (merchantObject) {
      this._id = merchantObject.id;
      this._password = merchantObject.password;
      this._firstName = merchantObject.firstName;
      this._lastName = merchantObject.lastName;
      this._phoneNumber = merchantObject.phoneNumber;
    } else if (merchantStateObject) {
      this._id = merchantStateObject._id;
      this._password = merchantStateObject._password;
      this._firstName = merchantStateObject._firstName;
      this._lastName = merchantStateObject._lastName;
      this._phoneNumber = merchantStateObject._phoneNumber;
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
    return this.password;
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
  fromJSON(json) {
    const data = JSON.parse(json);
    this._id = data.id;
    this._password = data.password;
    this._firstName = data.first_name;
    this._lastName = data.last_name;
    this._phoneNumber = data.phone_number;
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
