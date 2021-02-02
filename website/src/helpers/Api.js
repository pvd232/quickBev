import { Merchant } from "../Models.js";

class Client {
  async makeRequest(method, url, data, isForm = false) {
    let requestData = data || {};
    try {
      const response = await fetch(url, {
        method: method,
        body:
          method === "POST" && !isForm
            ? JSON.stringify(requestData)
            : method === "POST" && isForm
            ? requestData
            : null,
      });

      if (response.ok) {
        let responseContent = await response.json();
        console.log("responseContent", responseContent);
        return [responseContent, response];
      } else {
        let body = await response.text();
        console.log(
          "APIclient.makeRequest.response.notOkay",
          response.statusText,
          body
        );
        return false;
      }
    } catch (err) {
      console.log("APIclient.makeRequest.error", err);
    }
  }
  getOrders = async () => {
    var headers = new Headers();
    const currentMerchant = new Merchant(
      "localStorage",
      localStorage.getItem("merchant")
    );
    console.log("currentMerchant", currentMerchant);
    // headers.set(
    //   "Authorization",
    //   "Basic " + btoa(currentMerchant.id + ":" + currentMerchant.password)
    // );
    headers.set(
      "Authorization",
      "Basic " + btoa("a:" + currentMerchant.password)
    );
    return fetch("http://127.0.0.1:5000/order", {
      credentials: "include",
      headers: headers,
    }).then((data) => data.json());
  };
  getCustomers = async () => {
    var headers = new Headers();
    const currentMerchant = new Merchant(
      "localStorage",
      localStorage.getItem("merchant")
    );
    // will uncomment this when i have added menu for new businesses
    // headers.set("Authorization", "Basic " + btoa(currentMerchant.id));
    headers.set("Authorization", "Basic " + btoa("a"));

    return fetch("http://127.0.0.1:5000/customer", {
      credentials: "include",
      headers: headers,
    }).then((data) => data.json());
  };
}
export default new Client();
