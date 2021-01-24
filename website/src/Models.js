export class Merchant {
  constructor(merchantObject = null, merchantStateObject = null) {
    if (merchantObject) {
      this._id = merchantObject.id;
      // will fill in the stripe ID later
      this._stripeId = null;
      this._firstName = merchantObject.firstName;
      this._lastName = merchantObject.lastName;
      this._phoneNumber = merchantObject.phoneNumber;
    } else if (merchantStateObject) {
      console.log("merchantStateObject", merchantStateObject);
      this._id = merchantStateObject._id;
      // will fill in the stripe ID later
      this._stripeId = null;
      this._firstName = merchantStateObject._firstName;
      this._lastName = merchantStateObject._lastName;
      this._phoneNumber = merchantStateObject._phoneNumber;
    } else {
      this._id = null;
      this._stripeId = null;
      this._firstName = null;
      this._lastName = null;
      this._phoneNumber = null;
    }
  }

  get id() {
    return this._id;
  }
  get stripeId() {
    return this._stripeId;
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
  set stripeId(value) {
    this._stripeId = value;
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
      stripe_id: this._stripeId,
      first_name: this._firstName,
      last_name: this._lastName,
      phone_number: this._phoneNumber,
    };
    return data;
  }
  fromJSON(json) {
    const data = JSON.parse(json);
    this._id = data.id;
    this._stripeId = data.stripe_id;
    this._firstName = data.first_name;
    this._lastName = data.last_name;
    this._phoneNumber = data.phone_number;
  }
}
export class Business {
  constructor(businessObject) {
    if (businessObject) {
      this._id = businessObject.id;
      // will fill in the stripe ID later
      this._merchantId = null;
      this._address = businessObject.address;
      this._street = businessObject.street;
      this._city = businessObject.city;
      this._state = businessObject.state;
      this._zipcode = businessObject.zip;
      this._phoneNumber = businessObject.phone_number;
      this._numberOfLocations = businessObject.number_of_locations;
      this._tablet = businessObject.tablet;
      this._menuUrl = businessObject.menu_url;
    } else {
      this._id = null;
      this._merchantId = null;
      this._address = null;
      this._street = null;
      this._city = null;
      this._state = null;
      this._zipcode = null;
      this._phoneNumber = null;
      this._numberOfLocations = null;
      this._tablet = null;
      this._menuUrl = null;
    }
  }

  get id() {
    return this._id;
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
  get tablet() {
    return this._tablet;
  }
  get menuUrl() {
    return this._menuUrl;
  }
  set id(value) {
    this._id = value;
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
  set tablet(value) {
    this._tablet = value;
  }
  set menuUrl(value) {
    this._menuUrl = value;
  }
  toJSON() {
    const data = {
      id: this._id,
      merchantId: this._merchantId,
      address: this._address,
      street: this._street,
      city: this._city,
      state: this._state,
      zipcode: this._zipcode,
      phoneNumber: this._phoneNumber,
      numberOfLocations: this._numberOfLocations,
      tablet: this._tablet,
      menuUrl: this._menuUrl,
    };
    return data;
  }
  fromJSON(json) {
    const data = JSON.parse(json);
    this._id = data.id;
    this._merchantId = data.merchantId;
    this._address = data.address;
    this._street = data.street;
    this._city = data.city;
    this._state = data.state;
    this._phoneNumber = data.phoneNumber;
    this._numberOfLocations = data.numberOfLocations;
    this._tablet = data.tablet;
    this._menuUrl = data.menuUrl;
  }
}
