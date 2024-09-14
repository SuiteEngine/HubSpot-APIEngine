table 50101 "Hubspot Setup"
{
    Caption = 'Hubspot Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PK; Code[10])
        {
            Caption = 'PK';
            DataClassification = CustomerContent;
        }
        field(10; "Customer Template"; Code[20])
        {
            Caption = 'Customer Template';
            TableRelation = "Customer Templ.".Code;
            ToolTip = 'The Business Central Customer Template to use when creating a Business Central Customer from a Hubspot Company.', Comment = '%';
            DataClassification = CustomerContent;
        }
        field(20; "Std Hubspot Company Properties"; Text[2048])
        {
            Caption = 'Standard Hubspot Company Properties';
            ToolTip = 'The Standard Hubspot Company Properties to retrieve when making an API Call.', Comment = '%';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }
    /// <summary>
    /// GetSetup.
    /// </summary>
    procedure GetSetup()
    begin
        if not FindFirst() then begin
            Init();
            Insert();
        end;
    end;

}
