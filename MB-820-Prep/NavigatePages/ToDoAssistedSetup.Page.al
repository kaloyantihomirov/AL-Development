page 50100 ToDoAssistedSetup
{
    PageType = NavigatePage;
    SourceTable = ToDo;
    SourceTableTemporary = true;
    Caption = 'Add a To-Do for the Team';
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Step1)
            {
                Visible = Step1Visible;

                group("Welcome")
                {
                    Caption = 'Welcome to the to-do assisted setup';

                    group(group11)
                    {
                        Caption = '';
                        InstructionalText = 'Use this guide to register a to-do task for you and your team';
                    }
                }
                group("Let's go")
                {
                    Caption = 'Let''s go';
                    group(group12)
                    {
                        Caption = '';
                        InstructionalText = 'Select Next to get started';
                    }
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;

                group("group21")
                {
                    Caption = 'Enter information about the to-do task';

                    field("No."; Rec."No.")
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                    }
                    field(Urgency; Rec.Urgency)
                    {
                        ApplicationArea = All;
                    }
                    field("Start Date"; Rec."Start Date")
                    {
                        ApplicationArea = All;
                    }
                    field("End Date"; Rec."End Date")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Step3)
            {
                Caption = 'That''s it';
                InstructionalText = 'Select Finish to save the to-do.';
                Visible = Step3Visible;
            }
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Back")
            {
                ApplicationArea = All;
                Caption = '&Back';
                Enabled = BackEnable;
                InFooterBar = true;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action("Next")
            {
                ApplicationArea = All;
                Caption = '&Next';
                Enabled = NextEnable;
                InFooterBar = true;
                Image = NextRecord;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action("Finish")
            {
                ApplicationArea = All;
                Caption = '&Finish';
                Enabled = FinishEnable;
                InFooterBar = true;
                Image = Approve;

                trigger OnAction()
                begin
                    Finished();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        EnableControls();
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        //Assuming we have a record with an empty primary key in the "ToDo" table
        ToDoRec.Get();
        ToDoRec.Init();
        Rec := ToDoRec;
        CurrPage.Update();
    end;

    var
        ToDoRec: Record ToDo;
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        ClientTypeManagement: Codeunit "Client Type Management";
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step: Option Start,Fill,Finish;
        BackEnable: Boolean;
        NextEnable: Boolean;
        FinishEnable: Boolean;
        FinishActionEnabled: Boolean;
        TopBannerVisible: Boolean;


    local procedure EnableControls()
    begin
        ResetControls();
        case Step of
            Step::Start:
                ShowStep1();
            Step::Fill:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure StoreRecordVar()
    begin
        ToDoRec.TransferFields(Rec, true);
        ToDoRec.Insert();
    end;

    local procedure ShowStep1()
    begin
        Step1Visible := true;
        BackEnable := false;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visible := true;
        BackEnable := true;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowStep3()
    begin
        Step3Visible := true;
        BackEnable := true;
        NextEnable := false;
        FinishEnable := true;
        FinishActionEnabled := true;
    end;

    local procedure ResetControls()
    begin
        FinishEnable := false;
        BackEnable := true;
        NextEnable := true;
        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;

        EnableControls();
    end;

    local procedure Finished()
    begin
        StoreRecordVar();
        CurrPage.Close();
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType())) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
               MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
            then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue;
    end;

}