codeunit 50102 "Hubspot Value Processing" implements SENAPIValueProcessing
{
    //**************************************************************************************************
    //***********************  R E Q U I R E D   B Y   I N T E R F A C E  ******************************
    //**************************************************************************************************

    /// <summary>
    /// Required By Interface: GetValueProcessing (Mapping Overload)
    /// This implements the Mapping Get Value Processing Requirement
    /// </summary>
    /// <param name="SENAPIMapping">VAR Record "SENAPI Mapping".</param>
    /// <param name="SENAPIDataBufferToProcess">Record "SENAPI Data Buffer".</param>
    /// <param name="RecordToProcess">RecordId.</param>
    /// <param name="ParameterKey">Text[100].</param>
    /// <param name="ParameterKeyIndex">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueProcessing(var SENAPIMapping: Record "SENAPI Mapping"; SENAPIDataBufferToProcess: Record "SENAPI Data Buffer"; RecordToProcess: RecordId; ParameterKey: Text[100]; ParameterKeyIndex: Integer): Text
    begin
    end;

    /// <summary>
    /// Required By Interface: GetValueProcessing (Variable Overload)
    /// This implements the API Variable Get Value Processing Requirement
    /// </summary>
    /// <param name="SENAPIVariable">VAR Record "SENAPI Variable".</param>
    /// <param name="SENAPIMessage">Record "SENAPI Message".</param>
    /// <param name="ProcessNameElement">Boolean.</param>
    /// <param name="ParameterKey">Text[100].</param>
    /// <param name="ParameterKeyIndex">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueProcessing(var SENAPIVariable: Record "SENAPI Variable"; SENAPIMessage: Record "SENAPI Message"; ProcessNameElement: Boolean; ParameterKey: Text[100]; ParameterKeyIndex: Integer): Text
    begin
        if ProcessNameElement then
            //not implementing any name value processing in this codeunit
            exit('')
        else
            //Variable Value Processing Additions
            case SENAPIVariable."Value Processing Function Name" of
                'PERSONALIZEDHELLOWORLD':
                    exit(PersonalizedHelloWorld(SENAPIVariable, SENAPIMessage, ParameterKeyIndex));
            end;

    end;

    /// <summary>
    /// Required by Interface: RegisterValueProcessingMethods.
    /// This implements the requirement to populate the Value Processing Function Method Table with new
    /// methods defined by this codeunit.  This allows the API Engine UI to present a pick list of available
    /// Methods available for this Value Processing Type implementation.
    /// </summary>
    procedure RegisterValueProcessingMethods()
    var
        SENAPIValueProcFuncMethod: Record "SENAPI ValueProcFuncMethod";
        SENAPIValueProcessingType: Enum "SENAPI Value Processing Type";

    begin
        SENAPIValueProcFuncMethod.RegisterFunctionMethod(SENAPIValueProcessingType::Hubspot, 'PERSONALIZEDHELLOWORLD', 'Returns a personalized Hello World message. (Hello World from <Parameter Value>).', true, false);
    end;


    //**************************************************************************************************
    //********************  I M P L E M E N T A T I O N   P R O C E D U R E S   ************************
    //**************************************************************************************************
    local procedure PersonalizedHelloWorld(var SENAPIVariable: Record "SENAPI Variable"; SENAPIMessage: Record "SENAPI Message"; ParameterKeyIndex: Integer): Text
    var
        SENAPIParameter: Record "SENAPI Parameter";
        ValueInParameter: text;
    begin
        if SENAPIParameter.GET(SENAPIParameter."Parameter Type"::Record, SENAPIMessage.RecordId(), SENAPIVariable."Value Table No.", ParameterKeyIndex) then
            ValueInParameter := SENAPIParameter.GetRecordFieldDataAsText(SENAPIVariable."Value Field No.");
        exit('Hello World from ' + ValueInParameter);
    end;
}