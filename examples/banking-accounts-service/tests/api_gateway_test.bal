import ballerina/test;
import ballerina/http;

http:Client testClient = check new ("https://localhost:9090",
    secureSocket= {
        cert: "/home/runner/work/module-ballerina-auth/module-ballerina-auth/examples/banking-accounts-service/resources/public.crt"
    }
);

@test:Config {}
public function testGet() returns error? {
    //Request without authorization header
    http:Response response = check testClient->get("/accounts/account");
    test:assertEquals(response.statusCode, http:STATUS_UNAUTHORIZED);

    //Request with invalid authorization header
    map<string|string[]> headers = {
        "Authorization": "Basic random"
    };
    response = check testClient->get("/accounts/account");
    test:assertEquals(response.statusCode, http:STATUS_UNAUTHORIZED);
    
    //Request with correct authorization header
    //User has Authorization for scope get-account
    headers = {
        "Authorization": "Basic YWxpY2U6YWxpY2VAMTIz"
    };
    response = check testClient->get("/accounts/account", headers);
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertEquals(response.getTextPayload(), "Hello, World!");
}
