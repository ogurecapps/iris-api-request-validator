Class SwaggerValidator.Core.REST Extends %CSP.REST
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
    Set tSC = ##class(%REST.API).GetApplication($REPLACE($CLASSNAME(),".disp",""), .spec)
    Return:$$$ISERR(tSC) tSC

    Set defName = $PIECE($PIECE(%request.ContentType, "+", 1), ".", *)
    Return:defName="" $$$ERROR($$$GeneralError, $$$FormatText("No definition name found in Content-Type = %1", %request.ContentType))
    
    Set type = spec.definitions.%Get(defName)
    Return:type="" $$$ERROR($$$GeneralError, $$$FormatText("No definition found in specification by name = %1", defName))
    
    Set schema = type.%ToJSON() 
    Set body = %request.Content.Read()

    Try {Set tSC = ..ValidateImpl(schema, body)} Catch ex {Set tSC = ex.AsStatus()}

    Return tSC
}

ClassMethod ValidateImpl(schema As %String, body As %String) As %Status [ Language = python ]
{
    try:
        validate(json.loads(body), json.loads(schema))
    except Exception as e:
        return iris.system.Status.Error(5001, f"Request body is invalid: {e}")

    return iris.system.Status.OK()
}

XData %import [ MimeType = application/python ]
{
import iris, json
from openapi_schema_validator import validate
}

}
