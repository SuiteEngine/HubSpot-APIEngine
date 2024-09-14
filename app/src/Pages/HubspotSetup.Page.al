page 50102 "Hubspot Setup"
{
    ApplicationArea = All;
    Caption = 'Hubspot Setup';
    PageType = Card;
    SourceTable = "Hubspot Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Customer Template"; Rec."Customer Template")
                {
                    ToolTip = 'The Business Central Customer Template to use when creating a Business Central Customer from a Hubspot Company.', Comment = '%';
                }
                field("Std Hubspot Company Properties"; Rec."Std Hubspot Company Properties")
                {
                    ToolTip = 'The Standard Hubspot Company Properties to retrieve when making an API Call.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("InitializeDemo")
            {
                Image = Start;
                ApplicationArea = all;
                Caption = 'Start (Initialize) Demo';
                ToolTip = 'Cleans up data in BC and on Hubspot to prepare for a new demo. 1) Deletes BC Demo Customers on Hubspot. 2) Deletes Hubspot Companies that are not BC Demo Customers. 3) Deletes BC Customers that were created from Hubspot Companies.';
                trigger OnAction()
                var
                    HubspotDemoUtilities: Codeunit "HubspotDemoUtilities";
                begin
                    If Dialog.Confirm('Are you sure you want to initialize the data to the start of the demo?', true, 'Yes', 'No') then
                        HubspotDemoUtilities.Run();
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
