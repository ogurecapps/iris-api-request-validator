/// Simple test API with two methods: GET and POST
/// Dispatch class defined by RESTSpec in SwaggerValidator.Sample.API.spec
Class SwaggerValidator.Sample.API.disp Extends SwaggerValidator.Core.REST [ GeneratedBy = SwaggerValidator.Sample.API.spec.cls, ProcedureBlock ]
{

/// The class containing the RESTSpec which generated this class
Parameter SpecificationClass = "SwaggerValidator.Sample.API.spec";

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 1;

/// Default the Content-Type for this application.
Parameter CONTENTTYPE = "application/json";

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Test GET method -->
  <Route Url="/test" Method="get" Call="TestGet" />
  <!-- Test POST method -->
  <Route Url="/test" Method="post" Call="TestPost" />
</Routes>
}

/// Test GET method
ClassMethod TestGet() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") {
            Try {
                Do ##class(SwaggerValidator.Sample.API.impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            }
            Quit
        }
        Set response=##class(SwaggerValidator.Sample.API.impl).TestGet()
        Do ##class(SwaggerValidator.Sample.API.impl).%WriteResponse(response)
    } Catch (ex) {
        Try {
            Do ##class(SwaggerValidator.Sample.API.impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("SwaggerValidator.Sample.API.impl","ExposeServerExceptions"))
        } Catch {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("SwaggerValidator.Sample.API.impl","ExposeServerExceptions"))
        }
    }
    Quit $$$OK
}

/// Test POST method
ClassMethod TestPost() As %Status
{
    Try {
        If $CASE(%request.ContentType,"application/vnd.validator.sample_api.test_post_req+json":0,:1) {
            Try {
                Do ##class(SwaggerValidator.Sample.API.impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType))
            }
            Quit
        }
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") {
            Try {
                Do ##class(SwaggerValidator.Sample.API.impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            } Catch {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            }
            Quit
        }
        If '$ISOBJECT(%request.Content) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"body")) Quit
        Set pbody=%request.Content
        Set response=##class(SwaggerValidator.Sample.API.impl).TestPost(pbody)
        Do ##class(SwaggerValidator.Sample.API.impl).%WriteResponse(response)
    } Catch (ex) {
        Try {
            Do ##class(SwaggerValidator.Sample.API.impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("SwaggerValidator.Sample.API.impl","ExposeServerExceptions"))
        } Catch {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$PARAMETER("SwaggerValidator.Sample.API.impl","ExposeServerExceptions"))
        }
    }
    Quit $$$OK
}

}
