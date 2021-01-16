// import { v4 as uuidv4 } from "uuid";
export const makeApiRequest = (url, requestType, payload, cfunc) => {
  // code for IE7+, Firefox, Chrome, Opera, Safari
  const xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = cfunc;
  xmlhttp.open(requestType, url, true);
  xmlhttp.send(payload);
};
export class Merchant {
  constructor(merchantObject) {
    if (merchantObject) {
      this._id = merchantObject.id;
      // will fill in the stripe ID later
      this._stripeId = null;
      this._firstName = merchantObject.firstName;
      this._lastName = merchantObject.lastName;
      this._phoneNumber = merchantObject.phoneNumber;
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
      stripeId: this._stripeId,
      firstName: this._firstName,
      lastName: this._lastName,
      phoneNumber: this._phoneNumber,
    };
    return data;
  }
  fromJSON(json) {
    const data = json;
    this._id = data.id;
    this.stripeId = data.stripeId;
    this._firstName = data.firstName;
    this._lastName = data.lastName;
    this._phoneNumber = data.phoneNumber;
  }
}
export class Business {
  constructor(businessObject) {
    if (businessObject) {
      this._id = businessObject.id;
      // will fill in the stripe ID later
      this._merchantId = null;
      this._street = businessObject.address;
      this._city = businessObject.city;
      this._state = businessObject.state;
      this._zipcode = businessObject.zip;
      this._phoneNumber = businessObject.phoneNumber;
    } else {
      this._id = null;
      this._merchantId = null;
      this._street = null;
      this._city = null;
      this._state = null;
      this._zipcode = null;
      this._phoneNumber = null;
    }
  }

  get id() {
    return this._id;
  }
  get merchantId() {
    return this._merchantId;
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
  set id(value) {
    this._id = value;
  }
  set merchantId(value) {
    this._merchantId = value;
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
  toJSON() {
    const data = {
      id: this._id,
      merchantId: this._merchantId,
      street: this._street,
      city: this._city,
      state: this._state,
      zipcode: this._zipcode,
      phoneNumber: this._phoneNumber,
    };
    return data;
  }
  fromJSON(json) {
    const data = json;
    this._id = data.id;
    this.merchantId = data.merchantId;
    this._street = data.street;
    this._city = data.city;
    this._state = data.state;
    this._phoneNumber = data.phoneNumber;
  }
}
