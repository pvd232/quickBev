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
        console.log(await response.json());
        return true;
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
}
export default new Client();
