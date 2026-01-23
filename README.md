# Validator for REST API requests against OpenAPI 2.0 specifications for InterSystems IRIS Data Platform
This validator is based on the `openapi-schema-validator` Python [project](https://github.com/python-openapi/openapi-schema-validator) and can check inbound JSONs for compliance with the OpenAPI (Swagger) specification. It is fully compatible with the recommended InterSystems specification-first way in REST API development.

If you want to integrate request validation in your project, by default, this means that you already have some API developed according to the specification-first way, described [here](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_intro). First, you need to set a vendor-specific content type in the `consumes` property of the OpenAPI specification for your endpoint. Which one must look something like this: `vnd.<company>.<project>.<api>.<request_type>+json`. In the included sample, I use:
```
"paths":{
      "post":{
        "consumes":[
          "application/vnd.validator.sample_api.test_post_req+json"
        ],
...
```

Next steps:
- Import the `SwaggerValidator` package
- Change in your `disp.cls` `Extends` section from `%CSP.REST` to `SwaggerValidator.Core.REST`
- Install the `openapi-schema-validator` Python library as described [here](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GEPYTHON_loadlib)

The project includes a sample API, look at `SwaggerValidator.Sample.API.*` package. To run the sample, you need:
1. Create a web application with the name `/csp/api`, set the dispatch class as `SwaggerValidator.Sample.API.disp` and grand it a `%All` role (don't repeat on productive)
2. Make a request:
```
curl --location 'http://localhost:52773/csp/api/test' \
--header 'Content-Type: application/vnd.validator.sample_api.test_post_req+json' \
--data '{
  "input": "10"
}'
```
3. Try to remove the "input" property or change its type to number

*That's all folks! Thanks for your attention.*