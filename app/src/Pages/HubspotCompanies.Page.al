page 50100 "Hubspot Companies"
{
    ApplicationArea = All;
    Caption = 'Hubspot Companies';
    PageType = List;
    SourceTable = "Hubspot Company";
    UsageCategory = Lists;
    InsertAllowed = false;
    CardPageId = "Hubspot Company";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Hubspot Id"; Rec."Hubspot Id")
                {
                    ToolTip = 'Specifies the value of the Hubspot Id field.', Comment = '%';
                }
                field("Business Central Customer No."; Rec."Business Central Customer No.")
                {
                    ToolTip = 'Specifies the value of the Business Central Customer No. field.', Comment = '%';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field("Hubspot Last Modified"; Rec."Hubspot Last Modified")
                {
                    ToolTip = 'Shows the last timestamp that this Company''s information changed on Hubspot.  Note that the value of this field is only as valid as the last time chenges were retrieved from Hubspot via APIs.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                }
                field("Website URL"; Rec."Website URL")
                {
                    ToolTip = 'Specifies the value of the Website URL field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(RetrieveHubspotCompanyChanges)
            {
                ApplicationArea = All;
                Caption = 'Retrieve Hubspot Company Changes';
                ToolTip = 'Retrieves Hubspot Company changes since the last retrieval date.  Companies are created or updated in Business Central as needed.';
                Image = CustomerGroup;
                trigger OnAction()
                var
                    HubspotAPIManagement: Codeunit "Hubspot API Management";
                begin
                    HubspotAPIManagement.RetrieveNewCompaniesAndChanges();
                end;
            }
        }
        area(Navigation)
        {
            action(ShowBCCustomerCard)
            {
                ApplicationArea = All;
                Caption = 'Show BC Customer Card';
                ToolTip = 'Navigates to the related Business Central Customer Card linked to this Hubspot Company.';
                Image = Customer;
                Visible = Rec."Business Central Customer No." <> '';
                trigger OnAction()

                begin
                    Rec.ShowBusinessCentralCustomerCard();
                end;
            }
        }
    }
}
