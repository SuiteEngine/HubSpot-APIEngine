codeunit 50101 HubspotDemoUtilities
{
    trigger OnRun()
    begin
        DeleteNonDemoBCCustomers();
        DeleteDemoBCCustomersOnHubspot();
        //    InitBCCustomerNumbersOnHubspot(); //The two above called procedures should have already done this.
        DeleteHubspotCompanies(); //This will delete the remaining Hubspot Companies that were created but did not have a corresponding BC Customer.
        initHubspotSetup(); //This will set the Hubspot Setup to the demo values.
    end;

    /// <summary>
    /// Will Delete the corresponding BC Customer record for Hubspot Companies that created those BC Customers.
    /// this is used when starting a demo of this application to clean up the BC Customers that were
    /// created on from a Hubspot Company.
    /// </summary>
    local procedure DeleteNonDemoBCCustomers()
    var
        HubspotCompany: Record "Hubspot Company";
        Customer: Record Customer;
        HubspotAPIManagement: Codeunit "Hubspot API Management";

    begin
        Clear(HubspotCompany);
        if HubspotCompany.FindSet() then
            repeat
                if (HubspotCompany."Business Central Customer No." <> '') and not IsBCDemoCustomer(HubspotCompany."Business Central Customer No.") then begin
                    if Customer.Get(HubspotCompany."Business Central Customer No.") then
                        Customer.Delete();
                    HubspotCompany."Business Central Customer No." := '';
                    HubspotCompany.Modify();
                    HubspotAPIManagement.UpdateHubspotCompanyBCCustomerNo(HubspotCompany);
                    HubspotCompany.Get(HubspotCompany."Hubspot Id");
                    HubspotCompany.Delete();
                end;
            until HubspotCompany.Next() = 0;
    end;

    /// <summary>
    /// Deletes a company on Hubspot when the Customer in BC is one of the standard BC demo customers.
    /// this is used when starting a demo of this application to clean up the Companies that were
    /// created on Hubspot from BC Customer data.  After successful api deletion on hubspot, the Hubspot Company record
    /// is deleted from BC.
    /// </summary>
    local procedure DeleteDemoBCCustomersOnHubspot()
    var
        HubspotCompany: Record "Hubspot Company";
        HubspotAPIManagement: Codeunit "Hubspot API Management";
    begin
        Clear(HubspotCompany);
        if HubspotCompany.FindSet() then
            repeat
                if (HubspotCompany."Business Central Customer No." <> '') and IsBCDemoCustomer(HubspotCompany."Business Central Customer No.") then begin
                    if HubspotAPIManagement.DeleteHubspotCompany(HubspotCompany) then
                        HubspotCompany.Delete();
                end;
            until HubspotCompany.Next() = 0;
    end;

    /// <summary>
    /// Will Change the Hubspot Company Business Central Customer No. to an empty string and update the Hubspot Company on Hubspot.
    /// Note that by the time we get here, there should not be anything to do since it should have been done in the DeleteNonDemoBCCustomers.
    /// </summary>
    // local procedure InitBCCustomerNumbersOnHubspot()
    // var
    //     HubspotCompany: Record "Hubspot Company";
    //     HubspotAPIManagement: Codeunit "Hubspot API Management";

    // begin
    //     clear(HubspotCompany);
    //     if HubspotCompany.FindSet() then
    //         repeat
    //             if (HubspotCompany."Business Central Customer No." <> '') then begin
    //                 HubspotCompany."Business Central Customer No." := '';
    //                 HubspotCompany.Modify();
    //                 HubspotAPIManagement.UpdateHubspotCompanyBCCustomerNo(HubspotCompany);
    //             end;
    //         until HubspotCompany.Next() = 0;
    // end;


    local procedure DeleteHubspotCompanies()
    var
        HubspotCompany: Record "Hubspot Company";
    begin
        Clear(HubspotCompany);
        if HubspotCompany.FindSet() then
            repeat
                HubspotCompany.Delete();
            until HubspotCompany.Next() = 0;
    end;

    local procedure initHubspotSetup()
    var
        HubspotSetup: Record "Hubspot Setup";
    begin
        HubspotSetup.GetSetup();
        HubspotSetup."Customer Template" := 'CUSTOMER COMPANY';
        HubspotSetup."Std Hubspot Company Properties" := 'name,city,description,country,address,address2,zip,state,website,hubspot_owner_id,annualrevenue,hs_lastmodifieddate';
    end;


    local procedure IsBCDemoCustomer(CustomerNo: Code[20]): Boolean
    var
        Customer: Record Customer;
        BCDemoCustomerList: List of [Code[20]];
    begin
        if Customer.Get(CustomerNo) then
            BCDemoCustomerList := GetBCDemoCustomerList();
        exit(BCDemoCustomerList.Contains(CustomerNo));
        exit(false);
    end;

    local procedure GetBCDemoCustomerList(): List of [Code[20]]
    var
        BCDemoCustomerList: List of [Code[20]];
    begin
        clear(BCDemoCustomerList);
        BCDemoCustomerList.Add('10000');
        BCDemoCustomerList.Add('20000');
        BCDemoCustomerList.Add('30000');
        BCDemoCustomerList.Add('40000');
        BCDemoCustomerList.Add('50000');
        exit(BCDemoCustomerList);
    end;
}
