pageextension 50100 "<ObjectNameShort>.PageExt.al" extends "Customer Card"
{
    actions
    {
        addLast(processing)
        {
            action(CreateHubspotCompany)
            {
                ApplicationArea = All;
                Visible = ShowCreateHubspotCompany;
                Caption = 'Create Hubspot Company';
                ToolTip = 'Creates a company on Hubspot for this Business Central Customer.';
                Image = NewCustomer;
                trigger OnAction()
                var
                    HubspotAPIManagement: Codeunit "Hubspot API Management";
                begin
                    HubspotAPIManagement.CreateHubspotCompanyFromBCCustomer(Rec);
                end;
            }
            action(UpdateHubspotCompanyAddress)
            {
                ApplicationArea = All;
                Visible = HubspotAddressDifferent;
                Caption = 'Update Hubspot Company Address';
                ToolTip = 'Updates the Companies address on Hubspot for this Business Central Customer.';
                Image = ChangeCustomer;
                trigger OnAction()
                var
                    HubspotAPIManagement: Codeunit "Hubspot API Management";
                begin
                    HubspotAPIManagement.UpdateHubspotCompanyAddressFromBCCustomer(Rec);
                end;
            }
        }

        addlast(navigation)
        {
            action(ShowHubspotCompanyCard)
            {
                ApplicationArea = All;
                Visible = HubspotCompanyExists;
                Caption = 'Show Hubspot Company Card';
                ToolTip = 'Navigates to the related Hubspot Company Card in Business Central.';
                Image = Customer;
                trigger OnAction()
                var
                    HubspotCompany: Record "Hubspot Company";
                begin
                    HubspotCompany.ShowHubspotCardForBCCustomer(Rec);
                end;
            }
        }
    }
    var
        HubspotCompanyExists: Boolean;
        HubspotAddressDifferent: Boolean;
        ShowCreateHubspotCompany: Boolean;


    trigger OnAfterGetRecord()
    var
        HubspotCompany: Record "Hubspot Company";
    begin
        if HubspotCompany.GetHubspotCompanyForBCCustomer(Rec, HubspotCompany) then begin
            HubspotCompanyExists := true;
            HubspotAddressDifferent := HubspotCompany.BCCustomerHasDifferentAddress();
        end else begin
            HubspotCompanyExists := false;
            HubspotAddressDifferent := false;
            ShowCreateHubspotCompany := not HubspotCompanyExists;
        end;
    end;

}
