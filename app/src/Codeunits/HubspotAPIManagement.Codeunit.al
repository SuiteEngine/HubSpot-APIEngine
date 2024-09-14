codeunit 50100 "Hubspot API Management"
{
    //**************************************************************************************************
    //***********************       G L O B A L   V A R I A B L E S       ******************************
    //**************************************************************************************************


    //**************************************************************************************************
    //*****************  P U B L I C  I N T E R F A C E   M A I N  F U N C T I O N S   *****************
    //**************************************************************************************************

    /// <summary>
    /// CreateHubspotCompanyFromBCCustomer.
    /// This will make an API Call that creates a Hubspot Company from a Business Central Customer
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    procedure CreateHubspotCompanyFromBCCustomer(Customer: Record Customer)
    var
        SENAPIMessage: Record "SENAPI Message";
        SENAPIMessageManagement: Codeunit SENAPIMessageManagement;
        APISet_Label: Label 'HUBSPOT';
        APIFunction_Label: Label 'CREATECOMPANYFROMBCCUSTOMER';
    begin
        //Create the API Message to do this action
        SENAPIMessage := SENAPIMessageManagement.CreateNewAPIMessage(APISet_Label, APIFunction_Label);
        //Add the Business Central Customer Record to the API Message Parameters
        SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, Customer.RecordId);
        //Execute the API Message to do this action
        SENAPIMessageManagement.ExecuteAPIMessage(SENAPIMessage);
    end;

    procedure UpdateHubspotCompanyBCCustomerNo(HubspotCompany: Record "Hubspot Company"): Boolean
    var
        SENAPIMessage: Record "SENAPI Message";
        SENAPIMessageManagement: Codeunit SENAPIMessageManagement;
        APISet_Label: Label 'HUBSPOT';
        APIFunction_Label: Label 'UPDATECOMPANYWITHBCCUSTNO';
    begin
        //Create the API Message to do this action
        SENAPIMessage := SENAPIMessageManagement.CreateNewAPIMessage(APISet_Label, APIFunction_Label);
        //Add the BC staging Hubspot Company to the API Message Parameters
        SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, HubspotCompany.RecordId);
        //Execute the API Message to do this action
        SENAPIMessageManagement.ExecuteAPIMessage(SENAPIMessage);
        Exit(true);
    end;

    procedure UpdateHubspotCompanyAddressFromBCCustomer(Customer: Record Customer): Boolean
    var
        HubspotCompany: Record "Hubspot Company";
        SENAPIMessage: Record "SENAPI Message";
        SENAPIMessageManagement: Codeunit SENAPIMessageManagement;
        APISet_Label: Label 'HUBSPOT';
        APIFunction_Label: Label 'UPDATECOMPANYADDRESSFROMBCCUST';
    begin
        //Create the API Message to do this action
        If HubspotCompany.GetHubspotCompanyForBCCustomer(Customer, HubspotCompany) then begin
            //Create the API Message to do this action
            SENAPIMessage := SENAPIMessageManagement.CreateNewAPIMessage(APISet_Label, APIFunction_Label);
            //Add the BC staging Hubspot Company and the Business Central Customer Record to the API Message Parameters
            SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, HubspotCompany.RecordId);
            SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, Customer.RecordId);
            //Execute the API Message to do this action
            SENAPIMessageManagement.ExecuteAPIMessage(SENAPIMessage);
            Exit(true);
        end else
            Exit(false);
    end;


    //Procedure to call the Hubspot API to retrieve all companies that have been created or modified since the last API call
    // Note:  The last API call date is stored in the Automation table.
    procedure RetrieveNewCompaniesAndChanges()
    var
        SENAPIAutomation: Record "SENAPI Automation";
        SENAPIMessage: Record "SENAPI Message";
        SENAPIMessageManagement: Codeunit SENAPIMessageManagement;
        ThisAPICallDateTime: DateTime;
        APISet_Label: Label 'HUBSPOT';
        APIFunction_Label: Label 'GETCOMPANIESMODIFIEDAFTER';
    begin
        Clear(SENAPIAutomation);
        SENAPIAutomation.SetRange("API Set Code", APISet_Label);
        SENAPIAutomation.SetRange("API Function Code", APIFunction_Label);
        If SENAPIAutomation.FindFirst() then begin
            //Create the API Message to do this action
            SENAPIMessage := SENAPIMessageManagement.CreateNewAPIMessage(APISet_Label, APIFunction_Label);
            //Add the Last Company Retrival Date to the API Message Parameters
            SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, SENAPIAutomation.RecordId);
            //Execute the API Message to do this action
            ThisAPICallDateTime := CurrentDateTime();
            SENAPIMessageManagement.ExecuteAPIMessageAutoProcessNextMessage(SENAPIMessage);
            //SENAPIMessageManagement.ExecuteAPIMessage(SENAPIMessage);
            //Update the Last Company Retrival Date in the Hubspot Setup Table
            if SENAPIMessage.IsSuccessStatusCode() then begin
                SENAPIAutomation."Last Run Timestamp" := ThisAPICallDateTime;
                SENAPIAutomation.Modify(true);
            end;
        end;
    end;

    procedure DeleteHubspotCompany(HubspotCompany: Record "Hubspot Company"): Boolean
    var
        SENAPIMessage: Record "SENAPI Message";
        SENAPIMessageManagement: Codeunit SENAPIMessageManagement;
        APISet_Label: Label 'HUBSPOT';
        APIFunction_Label: Label 'DELETEHUBSPOTCOMPANY';
    begin
        //Create the API Message to do this action
        SENAPIMessage := SENAPIMessageManagement.CreateNewAPIMessage(APISet_Label, APIFunction_Label);
        //Add the BC staging Hubspot Company to the API Message Parameters
        SENAPIMessageManagement.AddNewRecordParamterToAPIMessage(SENAPIMessage, HubspotCompany.RecordId);
        //Execute the API Message to do this action
        SENAPIMessageManagement.ExecuteAPIMessage(SENAPIMessage);
        Exit(true);
    end;

    //**************************************************************************************************
    //*********  P U B L I C  /  B U I L D   R E Q U E S T   H E L P E R   F U N C T I O N S   *********
    //**************************************************************************************************


    //**************************************************************************************************
    //***********************        L O C A L   F U N C T I O N S        ******************************
    //**************************************************************************************************

    //**************************************************************************************************
    //********************        I N T E R N A L   F U N C T I O N S        ***************************
    //**************************************************************************************************

    //**************************************************************************************************
    //****************                 E V E N T S   P U B L I S H E D               *******************
    //**************************************************************************************************

}
