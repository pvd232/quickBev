export class Client {
  // constructor() {
  //   this.token = "";
  //   this.context = null;
  //   this.protocol = "http:";
  //   this.port = null;
  // }

  // detectContext() {
  //   if (window) {
  //     this.host = window.location.hostname;
  //     this.protocol = window.location.protocol;
  //     this.port = window.location.port;
  //   }
  // }

  async makeRequest(method, url, data) {
    let requestData = data || {};
    // let baseUrl = this.getBaseUrl();
    // let requestUrl = baseUrl + url;

    // console.log("APIclient.makeRequest.requestUrl", requestUrl);
    try {
      const response = await fetch(url, {
        credentials: "include",
        headers: {
          "content-type": method === "post" ? "application/json" : "",
        },
        method: method,
        body: method === "post" ? JSON.stringify(requestData) : null,
      });

      if (response.ok) {
        return await response.json();
      } else {
        let body = await response.text();
        console.log(
          "APIclient.makeRequest.response.notOkay",
          response.statusText,
          body
        );
        throw new Error(response.statusText);
      }
    } catch (err) {
      console.log("APIclient.makeRequest.error", err);
      // throw new Error(err);
    }
  }

  // getBaseUrl() {
  //   return `${this.protocol}//${this.host}${this.port ? ":" + this.port : ""}`;
  // }
}
