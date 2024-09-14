/// <summary>
/// Table Hubspot Company (ID 50100).
/// This table provides a datastore for Hubspot Company data
/// ************************************************************************************
/// History
/// ************************************************************************************
/// 2024-07-22 Initial Creation of Table
/// ************************************************************************************/// </summary>
table 50100 "Hubspot Company"
{
    Caption = 'Hubspot Company';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Hubspot Id"; Text[20])
        {
            Caption = 'Hubspot Id';
            ToolTip = 'The Unique Hubspot Record ID of a Hubspot Company.', Comment = '%';
        }
        field(20; "Company Name"; Text[240])
        {
            Caption = 'Company Name';
            ToolTip = 'The name of the Company as it is on Hubspot.', Comment = '%';
        }
        field(30; Description; Text[1020])
        {
            Caption = 'Description';
            ToolTip = 'A description of the company according to Hubspot.', Comment = '%';
        }
        field(40; "Street Address"; Text[100])
        {
            Caption = 'Street Address';
            ToolTip = 'The main address street of the company according to Hubspot.', Comment = '%';
        }
        field(50; "Street Address 2"; Text[100])
        {
            Caption = 'Street Address 2';
            ToolTip = 'The main address street second line of the company according to Hubspot..', Comment = '%';
        }
        field(60; City; Text[50])
        {
            Caption = 'City';
            ToolTip = 'The main address city of the company according to Hubspot.', Comment = '%';
        }
        field(70; "State / Region"; Text[30])
        {
            Caption = 'State / Region';
            ToolTip = 'The main address state or region of the company according to Hubspot.', Comment = '%';
        }
        field(80; "Postal Code"; Text[20])
        {
            Caption = 'Postal Code';
            ToolTip = 'The main address postal code of the company according to Hubspot.', Comment = '%';
        }
        field(90; Country; Text[20])
        {
            Caption = 'Country';
            ToolTip = 'The main address country of the company according to Hubspot..', Comment = '%';
        }
        field(200; "Website URL"; Text[240])
        {
            Caption = 'Website URL';
            ToolTip = 'The company''s Website URL according to Hubspot.', Comment = '%';
        }
        field(500; "Hubspot Last Modified"; DateTime)
        {
            Caption = 'Hubspot Last Modified';
            ToolTip = 'The last date and time the Hubspot Company was modified on Hubspot.', Comment = '%';
        }
        field(1000; "Business Central Customer No."; Code[20])
        {
            Caption = 'Business Central Customer No.';
            TableRelation = Customer."No.";
            ToolTip = 'The Business Central Customer No. that this Hubspot Company is linked to.', Comment = '%';
        }
    }
    keys
    {
        key(PK; "Hubspot Id")
        {
            Clustered = true;
        }
    }
    //**************************************************************************************************
    //**********************         P U B L I C   C O N S T R U C T O R S        **********************
    //**************************************************************************************************

    //**************************************************************************************************
    //***********************        L O C A L   F U N C T I O N S        ******************************
    //**************************************************************************************************


    //**************************************************************************************************
    //**********************        H E L P E R   F U N C T I O N S        *****************************
    //**************************************************************************************************

    /// <summary>
    /// HubspotCompanyExistsForBCCustomer.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HubspotCompanyExistsForBCCustomer(Customer: Record Customer): Boolean
    var
        HubspotCompany: Record "Hubspot Company";
    begin
        exit(HubspotCompany.GetHubspotCompanyForBCCustomer(Customer, HubspotCompany));
    end;

    /// <summary>
    /// GetHubspotCompanyForBCCustomer.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="HubspotCompany">VAR Record "Hubspot Company".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetHubspotCompanyForBCCustomer(Customer: Record Customer; var HubspotCompany: Record "Hubspot Company"): Boolean
    var
    begin
        HubspotCompany.Reset;
        HubspotCompany.SetRange("Business Central Customer No.", Customer."No.");
        exit(HubspotCompany.FindFirst());
    end;

    /// <summary>
    /// CreateNewBCCustomer.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <returns>Return value of type boolean.</returns>
    procedure CreateNewBCCustomer(var Customer: Record Customer): boolean
    var
        xRecCustomer: Record Customer;
        HubspotSetup: Record "Hubspot Setup";
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        CustomerCard: Page "Customer Card";

        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateNewBCCustomer(Customer, IsHandled);
        if IsHandled then
            exit(Customer."No." <> '');
        HubspotSetup.GetSetup();
        Customer.Name := CopyStr(Rec."Company Name", 1, MaxStrLen(Customer.Name));
        if not CustomerTemplMgt.CreateCustomerFromTemplate(Customer, IsHandled, HubspotSetup."Customer Template") then
            //if not CustomerTemplMgt.InsertCustomerFromTemplate(Customer) then
            Customer.Insert(true)
        else
            if CopyStr(Rec."Company Name", 1, MaxStrLen(Customer.Name)) <> Customer.Name then begin
                Customer.Name := CopyStr(Rec."Company Name", 1, MaxStrLen(Customer.Name));
                Customer.Modify(true);
            end;
        SetBCCustomerDataFromHubspot(Rec, Customer);

        WorkflowEventHandling.RunWorkflowOnCustomerChanged(Customer, xRecCustomer, false);

        Rec."Business Central Customer No." := Customer."No.";
        Rec.Modify(true);

        Commit();
        Exit(true);
    end;

    /// <summary>
    /// ShowBusinessCentralCustomerCard.
    /// </summary>
    procedure ShowBusinessCentralCustomerCard()
    var
        Customer: Record Customer;
        CustomerCard: Page "Customer Card";
    begin
        if Rec."Business Central Customer No." = '' then
            exit;
        Customer.SetRange("No.", Rec."Business Central Customer No.");
        CustomerCard.SetTableView(Customer);
        CustomerCard.Run();
    end;

    /// <summary>
    /// ShowHubspotCardForBCCustomer.
    /// </summary>
    procedure ShowHubspotCardForBCCustomer(Customer: Record Customer)
    var
        HubspotCompany: Record "Hubspot Company";
        HubspotCompanyCard: Page "Hubspot Company";

    begin
        HubspotCompany.Reset();
        HubspotCompany.SetRange("Business Central Customer No.", Customer."No.");
        If FindFirst() then begin
            HubspotCompanyCard.SetTableView(HubspotCompany);
            HubspotCompanyCard.Run();
        end;
    end;

    /// <summary>
    /// BCCustomerHasDifferentAddress.
    /// Will return true if the BC Customer address is a trunkated version of the Hubspot Company Address
    /// </summary>
    /// <returns>Return variable Result of type Boolean.</returns>
    procedure BCCustomerHasDifferentAddress() Result: Boolean
    var
        Customer: Record Customer;
    begin
        if Customer.get(Rec."Business Central Customer No.") then
            Result := (Rec."Street Address" <> Customer.Address) or
                      (Rec."Street Address 2" <> Customer."Address 2") or
                      (Rec.City <> Customer.City) or
                      (Rec."State / Region" <> Customer.County) or
                      (Rec."Postal Code" <> Customer."Post Code") or
                      (Rec.Country <> Customer."Country/Region Code");
        OnAfterBCCustomerHasDifferentAddress(Rec, Customer, Result)
    end;

    /// <summary>
    /// BCCustomerHasTrunkatedAddress.
    /// Will return true if the BC Customer address is a trunkated version of the Hubspot Company Address
    /// </summary>
    /// <returns>Return variable Result of type Boolean.</returns>
    procedure BCCustomerHasTrunkatedAddress() Result: Boolean
    var
        Customer: Record Customer;
    begin
        if Customer.get(Rec."Business Central Customer No.") then
            Result := (CopyStr(Rec."Street Address", 1, MaxStrLen(Customer.Address)) = Customer.Address) and
                      (CopyStr(Rec."Street Address 2", 1, MaxStrLen(Customer."Address 2")) = Customer."Address 2") and
                      (CopyStr(Rec.City, 1, MaxStrLen(Customer.City)) = Customer.City) and
                      (CopyStr(Rec."State / Region", 1, MaxStrLen(Customer.County)) = Customer.County) and
                      (CopyStr(Rec."Postal Code", 1, MaxStrLen(Customer."Post Code")) = Customer."Post Code") and
                      (CopyStr(Rec.Country, 1, MaxStrLen(Customer."Country/Region Code")) = Customer."Country/Region Code") and
                      ((StrLen(Rec."Street Address") > MaxStrLen(Customer.Address)) or
                       (StrLen(Rec."Street Address 2") > MaxStrLen(Customer."Address 2")) or
                       (StrLen(Rec.City) > MaxStrLen(Customer.City)) or
                       (StrLen(Rec."State / Region") > MaxStrLen(Customer.County)) or
                       (StrLen(Rec."Postal Code") > MaxStrLen(Customer."Post Code")) or
                       (StrLen(Rec.Country) > MaxStrLen(Customer."Country/Region Code")));
        OnAfterBCCustomerHasTrunkatedAddress(Rec, Customer, Result)
    end;

    /// <summary>
    /// SetBCCustomerDataFromHubspot.
    /// Will set BC Customer fields from corresponding values in the related Hubspot Company
    /// </summary>
    /// <param name="Rec">Record "Hubspot Company".</param>
    /// <param name="Customer">Record Customer.</param>
    procedure SetBCCustomerDataFromHubspot(Rec: Record "Hubspot Company"; Customer: Record Customer)
    var
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        Customer.Address := CopyStr(Rec."Street Address", 1, MaxStrLen(Customer.Address));
        Customer."Address 2" := CopyStr(Rec."Street Address 2", 1, MaxStrLen(Customer."Address 2"));
        Customer.City := CopyStr(Rec.City, 1, MaxStrLen(Customer.City));
        Customer.County := CopyStr(Rec."State / Region", 1, MaxStrLen(Customer.County));
        Customer."Post Code" := CopyStr(Rec."Postal Code", 1, MaxStrLen(Customer."Post Code"));
        Customer."Country/Region Code" := CopyStr(Rec.Country, 1, MaxStrLen(Customer."Country/Region Code"));
        Customer."Home Page" := CopyStr(Rec."Website URL", 1, MaxStrLen(Customer."Home Page"));
        Customer.AddLink(Rec."Hubspot Id", Rec.Description);

        Customer.Modify(true);
        OnAfterSetBCCustomerDataFromHubspot(Rec, Customer);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateNewBCCustomer(var Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterBCCustomerHasDifferentAddress(Rec: Record "Hubspot Company"; Customer: Record Customer; var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterBCCustomerHasTrunkatedAddress(Rec: Record "Hubspot Company"; Customer: Record Customer; var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetBCCustomerDataFromHubspot(Rec: Record "Hubspot Company"; Customer: Record Customer)
    begin
    end;
}
