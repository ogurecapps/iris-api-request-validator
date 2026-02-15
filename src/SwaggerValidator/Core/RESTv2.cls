Class SwaggerValidator.Core.RESTv2 Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	Set tSC = ..ValidateRequest()
    
    If $$$ISERR(tSC) {
        Do ..ReportHttpStatusCode(##class(%CSP.REST).#HTTP400BADREQUEST, tSC)
        Set pContinue = 0
    }

    Return $$$OK
}

ClassMethod ValidateRequest() As %Status
{
    Set tSC = ..GetSpec(.swagger) 
    Return:$$$ISERR(tSC)||(swagger="") tSC

    Set canonicalURI = %request.CgiEnvs("REQUEST_SCHEME")_"://"_%request.CgiEnvs("HTTP_HOST")_%request.CgiEnvs("REQUEST_URI")
    Set httpBody = $SELECT($ISOBJECT(%request.Content)&&(%request.Content.Size>0):%request.Content.Read(), 1:"")
    Set httpMethod = %request.CgiEnvs("REQUEST_METHOD")
    Set httpContentType = %request.ContentType

    Try {
        Set tSC = ..ValidateImpl(swagger, canonicalURI, httpMethod, httpBody, httpContentType)
    } Catch ex {
        Set tSC = ex.AsStatus()
    }

    Return tSC
}

/// The class Spec.cls must be located in the same package as the %CSP.REST implementation
/// The class Spec.cls must contain an XData block named 'OpenAPI' with swagger 3.0 specification (in YAML format) 
ClassMethod GetSpec(Output specification As %String, xdataName As %String = "OpenAPI") As %Status
{
    Set specification = ""
    Set specClassName = $CLASSNAME()
    Set $PIECE(specClassName, ".", *) = "Spec"
    Return:'##class(%Dictionary.ClassDefinition).%Exists($LISTBUILD(specClassName)) $$$OK
    
    Set xdata = ##class(%Dictionary.XDataDefinition).%OpenId(specClassName_"||"_xdataName,,.tSC)
    If $$$ISOK(tSC),'$ISOBJECT(xdata)||'$ISOBJECT(xdata.Data)||(xdata.Data.Size=0) {
		Set tSC = $$$ERROR($$$RESTNoRESTSpec, xdataName, specClassName)
	}
    Return:$$$ISERR(tSC) tSC
    
    Set specification = xdata.Data.Read()
    Return tSC
}

ClassMethod ValidateImpl(swagger As %String, url As %String, method As %String, body As %String, contentType As %String) As %Status [ Language = python ]
{
    spec = Spec.from_dict(yaml.safe_load(swagger))
    data = json.loads(body) if (body != "") else None
    headers = {"Content-Type": contentType}
    
    req = requests.Request(method=method, url=url, json=data, headers=headers).prepare()
    openapi_req = RequestsOpenAPIRequest(req)

    try:
        validate_request(openapi_req, spec=spec)
    except Exception as ex:
        return iris.system.Status.Error(5001, f"Request validation failed: {ex.__cause__ if ex.__cause__ else ex}")

    return iris.system.Status.OK()
}

XData %import [ MimeType = application/python ]
{
import iris, json, requests, yaml
from openapi_core import Spec, validate_request
from openapi_core.contrib.requests import RequestsOpenAPIRequest
}

}
