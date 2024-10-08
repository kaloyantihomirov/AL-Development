table 50100 "Reward Level NTG"
{
    Caption = 'Reward Level';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Level; Text[20])
        {            
            Caption = 'Level';
        }
        field(2; "Minimum Reward Points"; Integer)
        {
            Caption = 'Minimum Reward Points';
            MinValue = 0;
            NotBlank = true;

            trigger OnValidate()
            var
                RewardLevel : Record "Reward Level NTG";
                tempPoints : Integer;
            begin
                tempPoints := "Minimum Reward Points";
                RewardLevel.SetRange("Minimum Reward Points", tempPoints);
                if not RewardLevel.IsEmpty() then
                    Error('Minimum Reward Points must be unique');
            end;
        }
    }
    
    keys
    {
        key(PK; Level)
        {
            Clustered = true;
        }
        key("Minimum Reward Points"; "Minimum Reward Points") { }
    }

    trigger OnInsert()
    begin
        Validate("Minimum Reward Points");
    end;

    trigger OnModify()
    begin
        Validate("Minimum Reward Points");
    end;
}