/// Simple test API with two methods: GET and POST<br/>
/// Business logic class defined by OpenAPI in SwaggerValidator.Sample.API.spec<br/>
/// Updated Jan 23, 2026 04:48:47
Class SwaggerValidator.Sample.API.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Returns a simple message
ClassMethod TestGet() As %DynamicObject
{
    Return {"message": "It works!"}
}

/// It takes a typified JSON as input<br/>
/// The method arguments hold values for:<br/>
///     body, Inbound data<br/>
ClassMethod TestPost(body As %Stream.Object) As %DynamicObject
{
    Return {"message": ("Received input: "_{}.%FromJSON(body).input)}
}

}
