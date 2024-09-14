page 50101 "Hubspot Company"
{
    ApplicationArea = All;
    Caption = 'Hubspot Company';
    PageType = Card;
    SourceTable = "Hubspot Company";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Hubspot Id"; Rec."Hubspot Id")
                {
                    ToolTip = 'The Unique Hubspot Record ID of a Hubspot Company.', Comment = '%';
                }
                field("Business Central Customer No."; Rec."Business Central Customer No.")
                {
                    ToolTip = 'The Business Central Customer No. that this Hubspot Company is linked to.', Comment = '%';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'The name of the Company as it is on Hubspot.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'A description of the company according to Hubspot.', Comment = '%';
                }
                field("Website URL"; Rec."Website URL")
                {
                    ToolTip = 'The company''s Website URL according to Hubspot.', Comment = '%';
                }
            }
            group(Address)
            {
                Caption = 'Main Address';

                field("Street Address"; Rec."Street Address")
                {
                    ToolTip = 'The main address street of the company according to Hubspot.', Comment = '%';
                }
                field("Street Address 2"; Rec."Street Address 2")
                {
                    ToolTip = 'The main address street second line of the company according to Hubspot..', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'The main address city of the company according to Hubspot.', Comment = '%';
                }
                field("State / Region"; Rec."State / Region")
                {
                    ToolTip = 'The main address state or region of the company according to Hubspot.', Comment = '%';
                }
                field("Postal Code"; Rec."Postal Code")
                {
                    ToolTip = 'The main address postal code of the company according to Hubspot.', Comment = '%';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'The main address country of the company according to Hubspot..', Comment = '%';
                }
            }
            group(HubspotHousekeeping)
            {
                Caption = 'Hubspot Housekeeping';

                field("Hubspot Modified At"; Rec."Hubspot Last Modified")
                {
                    ToolTip = 'The date and time the company was last modified on Hubspot.', Comment = '%';
                }
            }
            group(Integration)
            {
                Caption = 'Integration';

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("CreateBCCustomer")
            {
                Image = CreateForm;
                ApplicationArea = all;
                Caption = 'Create New Business Central Customer';
                Enabled = Rec."Business Central Customer No." = '';
                ToolTip = 'Creates a new Business Central Customer from data from this Hubspot Company using the Customer Template specified in Hubspot Setup.';
                trigger OnAction()
                var
                    Customer: Record Customer;
                    HubspotAPIManagement: Codeunit "Hubspot API Management";
                    Successtxt: Label 'Business Central Customer %1 was successfully created.', comment = '%1 Customer.No.';
                    FailureErr: Label 'An Error occured when trying to create a Business Central Customer';
                begin
                    If (Rec.CreateNewBCCustomer(Customer)) then begin
                        Rec.Get(Rec."Hubspot Id"); //Refresh the record to get the latest data.
                        HubspotAPIManagement.UpdateHubspotCompanyBCCustomerNo(Rec);
                        Message(Successtxt, Customer."No.");
                    end else
                        Error(FailureErr);
                end;
            }
            action(UpdateBCCustNoOnHubspot)
            {
                Image = UpdateXML;
                ApplicationArea = all;
                Caption = 'Update Business Central Customer No. on Hubspot';
                Enabled = Rec."Business Central Customer No." <> '';
                ToolTip = 'Updates the Business Central Customer No. on Hubspot with the value from this Hubspot Company.';
                trigger OnAction()
                var
                    HubspotAPIManagement: Codeunit "Hubspot API Management";
                    Successtxt: Label 'Business Central Customer No. was successfully updated on Hubspot.';
                    FailureErr: Label 'An Error occured when trying to update the Business Central Customer No. on Hubspot.';
                begin
                    If (HubspotAPIManagement.UpdateHubspotCompanyBCCustomerNo(Rec)) then
                        Message(Successtxt)
                    else
                        Error(FailureErr);
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
