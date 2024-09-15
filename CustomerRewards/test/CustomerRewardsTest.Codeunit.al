codeunit 50151 CustomerRewardsTest
{
    // [FEATURE] [Customer Rewards]

    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        MockCustomerRewardsExtMgt: Codeunit MockCustomerRewardsExtMgt;
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
        LibrarySales: Codeunit "Library - Sales";
        CustomerRewardsNotActivatedLbl: Label 'Customer Rewards should not be activated';
        CustomerRewardsActivatedLbl: Label 'Customer Rewards should be activated';
        BronzeLevelTxt: Label 'BRONZE';
        SilverLevelTxt: Label 'SILVER';
        GoldLevelTxt: Label 'GOLD';
        NoLevelTxt: Label 'NONE';

    [Test]

    procedure TestOnInstallLogic()
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt Setup NTG";
        CustomerRewardsInstallLogic: Codeunit "Cust. Rewards Inst. Logic NTG";
    begin
        // [Scenario] Check default codeunit is specified for handling events on install
        // [Given] Customer Rewards Setup Table

        Initialise();

        // [When] Install logic is run
        CustomerRewardsInstallLogic.SetDefaultCustomerRewardsExtMgtCodeunit();

        // [Then] Default Customer Rewards Ext. Mgt codeunit is specified
        Assert.AreEqual(1, CustomerRewardsExtMgtSetup.Count, 'CustomerRewardsExtMgtSetup must have exactly one record.');

        CustomerRewardsExtMgtSetup.Get();

        Assert.AreEqual(Codeunit::"Customer Rewards Ext. Mgt. NTG",
                        CustomerRewardsExtMgtSetup."Customer Rewards Ext. Mgt. Codeunit ID",
                        'Codeunit does not match default');

    end;

    [Test]

    procedure TestCustomerRewardsWizardTermsPage()
    var
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Check Terms Page on Wizard
        // [Given] The Customer Rewards Wizard
        Initialise();

        LibraryLowerPermissions.SetO365BusFull();

        // [When] The Wizard is opened
        CustomerRewardsWizardPage.OpenView();

        // [Then] The terms page and fields behave as expected
        Assert.IsFalse(CustomerRewardsWizardPage.EnableFeature.AsBoolean(), 'Enable feature should be unchecked');
        Assert.IsFalse(CustomerRewardsWizardPage.ActionNext.Visible(), 'Next should not be visible');
        Assert.IsFalse(CustomerRewardsWizardPage.ActionBack.Visible(), 'Back should not be visible');
        Assert.IsFalse(CustomerRewardsWizardPage.ActionFinish.Enabled(), 'Finish should be disabled');

        CustomerRewardsWizardPage.EnableFeature.SetValue(true);
        Assert.IsTrue(CustomerRewardsWizardPage.EnableFeature.AsBoolean(), 'Enable feature should be checked');
        Assert.IsTrue(CustomerRewardsWizardPage.ActionNext.Visible(), 'Next should be visible');
        Assert.IsFalse(CustomerRewardsWizardPage.ActionFinish.Enabled(), 'Finish should be disabled');

        CustomerRewardsWizardPage.Close();
    end;

    procedure TestCustomerRewardsWizardActivationPageErrorsWhenNoActivationCodeEntered()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Error message when user tried to activate Customer Rewards without activation code
        // [Given] The Customer Rewards Wizard
        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] User invokes activate action without entering activation code
        OpenCustomerRewardsWizardActivationPage(CustomerRewardsWizardPage);
        Assert.IsTrue(CustomerRewardsWizardPage.ActionBack.Visible(), 'Back should be visible');
        Assert.IsTrue(CustomerRewardsWizardPage.ActionFinish.Visible(), 'Finish should be visible');
        Assert.IsFalse(CustomerRewardsWizardPage.ActionFinish.Enabled(), 'Finish should be disabled');

        // [Then] Error message displayed
        asserterror CustomerRewardsWizardPage.ActionActivate.Invoke();
        Assert.AreEqual(GetLastErrorText(), 'Activation code cannot be blank.', 'Invalid error message');
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
    end;

    [Test]

    procedure TestCustomerRewardsWizardActivationPageErrorsWhenShorterActivationCodeEntered()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Error when user tries to activate Customer Rewards with shorter activation code.
        // [Given] Customer Rewards Wizard
        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        OpenCustomerRewardsWizardActivationPage(CustomerRewardsWizardPage);

        // [When] User enters shorter than 14 symbols code
        CustomerRewardsWizardPage.Activationcode.SetValue('#X8@-P!Z6%Q&a'); //13 symbols

        // [Then] Error is thrown
        asserterror CustomerRewardsWizardPage.ActionActivate.Invoke();
        Assert.AreEqual(GetLastErrorText(), 'Activation code must have 14 digits.', 'Invalid error message');
        // [Then] Customer Rewards is still not activated
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
    end;

    [Test]

    procedure TestCustomerRewardsWizardActivationPageErrorsWhenLongerActivationCodeEntered()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Error when a user tries to activate Customer Rewards with a longer activation code.
        // [Given] Customer Rewards Wizard

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();

        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        OpenCustomerRewardsWizardActivationPage(CustomerRewardsWizardPage);

        // [When] Users enter an activation code that is longer than 14 chars.
        CustomerRewardsWizardPage.Activationcode.SetValue('&F7$-K@8#M2%L^9'); //15 symbols

        // [Then] An error is thrown
        asserterror CustomerRewardsWizardPage.ActionActivate.Invoke();
        Assert.AreEqual(GetLastErrorText(), 'Activation code must have 14 digits.', 'Invalid error message');
        // [Then] Customer Rewards is still not activated
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
    end;

    [Test]

    procedure TestCustomerRewardsWizardActivationPageErrorsWhenInvalidActivationCodeEntered()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Error when users try to activate Customer Rewards with an invalid activation code.
        // [Given] Customer Rewards Wizard

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
        MockCustomerRewardsExtMgt.MockActivationResponse(false);

        // [When] Users enter invalid activation code but with the correc length
        OpenCustomerRewardsWizardActivationPage(CustomerRewardsWizardPage);
        CustomerRewardsWizardPage.Activationcode.SetValue('XK9Y-P3V8-LQ5R');

        // [Then] Error is thrown
        asserterror CustomerRewardsWizardPage.ActionActivate.Invoke();
        Assert.AreEqual(GetLastErrorText(),
                        'Activation failed. Please check the activation code you entered.',
                        'Invalid error message');
        // [Then] Customer Rewards is still not activated
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
    end;

    [Test]

    procedure TestCustomerRewardsWizardActivationPageDoesNotProduceErrorWhenValidActivationCodeEntered()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG";
    begin
        // [Scenario] Customer Rewards is activated when the user enters a correct activation code.
        // [Given] Customer Rewards Wizard

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
        MockCustomerRewardsExtMgt.MockActivationResponse(true);

        // [When] The user enter a correct activation key.
        OpenCustomerRewardsWizardActivationPage(CustomerRewardsWizardPage);
        CustomerRewardsWizardPage.Activationcode.SetValue('XK9Y-P3V8-LQ5R');
        CustomerRewardsWizardPage.ActionActivate.Invoke();
        CustomerRewardsWizardPage.Close();

        // [Then] Customer Rewards is successfully activated.
        Assert.IsTrue(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsActivatedLbl);
    end;

    [Test]

    procedure TestRewardsLevelListPageDoesNotOpenWhenExtensionIsNotActivated()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        RewardsLevelListPage: TestPage "Reward Levels List NTG";
    begin
        // [Scenario] Opening Rewards Level List produces an error if extension not activated
        // [Given] Rewards Level List Page
        // [Given] Unactivated Customer Rewards extension

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] The user opens the Rewards Level List page 
        // [Then] An error is thrown
        asserterror RewardsLevelListPage.OpenView();
        Assert.AreEqual(GetLastErrorText(), 'Customer Rewards is not activated.', 'Invalid error message');
    end;

    [Test]

    procedure TestRewardsLevelListPageOpensWhenExtensionIsActivated()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        RewardsLeveListPage: TestPage "Reward Levels List NTG";
    begin
        // [Scenario] Rewards Level List Page should open when extension is activated
        // [Given] An activated Customer Rewards extension
        // [Given] A Rewards Level List Page

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
        ActivateCustomerRewards();
        Assert.IsTrue(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] The user opens Rewards Level List page
        // [Then] No error is thrown
        RewardsLeveListPage.OpenView();
    end;

    //TODO: THERE IS SOMETHING DIFFERENT THAN HOW THE AUTHORS DID THIS TEST, SO IF IT DOES NOT PASS, CHECK IT
    [Test]
    procedure TestRewardLevelsActionExistsOnCustomerListPage()
    var
        CustomerListPage: TestPage "Customer List";
    begin
        // [Scenario] Reward Levels action exists on Customer List page
        // [Given] Customer List page

        LibraryLowerPermissions.SetO365BusFull();

        // [When] User opens Customer List page
        CustomerListPage.OpenView();

        // [Then] The Rewards Level action exists
        Assert.IsTrue(CustomerListPage."Reward Levels NTG".Visible(),
                     'Rewards Level action should be visible on Customer List page.');
    end;

    [Test]
    [HandlerFunctions('CustomerRewardsWizardModalPageHandler')]

    procedure TestRewardLevelsActionOnCustomerListPageOpensCustomerRewardsWizardWhenNotActivated()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerListPage: TestPage "Customer List";
    begin
        // [Scenario] Reward Levels Action opens Customer Rewards Wizard when extension is not activated
        // [Given] Not activated Customer Rewards
        // [Given] Customer List Page
        // [Given] Reward Levels Action on page

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] The user clicks on the action 
        CustomerListPage.OpenView();
        CustomerListPage."Reward Levels NTG".Invoke();

        // [Then] Wizard opens. Caught by CustomerRewardsWizardModalPageHandler 
    end;

    [Test]
    [HandlerFunctions('RewardsLevelListPageHandler')]
    procedure TestRewardLevelsActionOnCustomerListPageOpensRewardsLevelListPageWhenActivated()
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        CustomerListPage: TestPage "Customer List";
    begin
        // [Scenario] Reward Level action opens Rewards Level List Page when extension is activated
        // [Given] Activated Customer Rewards extension
        // [Given] Customer List Page
        // [Given] Reward Level action

        Initialise();
        Commit();

        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);
        ActivateCustomerRewards();
        Assert.IsTrue(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] User opens Customer List page and invokes action
        CustomerListPage.OpenView();
        CustomerListPage."Reward Levels NTG".Invoke();

        // [Then] Rewards Level List opens. Caught by RewardsLevelListPageHandler
    end;

    [Test]

    procedure TestCustomerCardPageHasRewardsFields()
    var
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] Customer Card Page has reward fields when opened
        // [Given] Customer Card Page

        LibraryLowerPermissions.SetO365BusFull();

        //[When] The user opens the Customer Card page 
        CustomerCardPage.OpenView();

        //[Then] The reward fields are visible and not editable
        Assert.IsTrue(CustomerCardPage.RewardPoints.Visible(), 'Reward Points should be visible');
        Assert.IsFalse(CustomerCardPage.RewardPoints.Editable(), 'Reward Points should not be editable');
        Assert.IsTrue(CustomerCardPage.RewardLevel.Visible(), 'Reward Level should be visible');
        Assert.IsFalse(CustomerCardPage.RewardLevel.Editable(), 'Reward Level should not be editable');
    end;

    [Test]
    procedure TestNewCustomerHasZeroRewardPointsAndNoRewardLevel()
    var
        Customer: Record Customer;
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] New Customer has zero reward points and no reward level
        // [Given] A new customer

        Initialise();
        Commit();

        LibraryLowerPermissions.SetO365BusFull();
        ActivateCustomerRewards();

        // [When] New customer
        LibrarySales.CreateCustomer(Customer);
        CustomerCardPage.OpenView();
        CustomerCardPage.GoToRecord(Customer);

        // [Then] No reward level
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCardPage.RewardLevel.Value);
        // [Then] No reward points
        VerifyCustomerRewardPoints(0, CustomerCardPage.RewardPoints.AsInteger());
    end;


    local procedure Initialise()
    var
        ActivationCodeInfo: Record "Activation Code Inform. NTG";
        RewardLevel: Record "Reward Level NTG";
        Customer: Record Customer;
    begin
        Customer.ModifyAll("Reward Points NTG", 0);
        ActivationCodeInfo.DeleteAll();
        RewardLevel.DeleteAll();
        UnbindSubscription(MockCustomerRewardsExtMgt);
        BindSubscription(MockCustomerRewardsExtMgt);
        MockCustomerRewardsExtMgt.Setup();
    end;

    local procedure OpenCustomerRewardsWizardActivationPage(var CustomerRewardsWizardPage: TestPage "Customer Rewards Wizard NTG")
    begin
        CustomerRewardsWizardPage.OpenView();
        CustomerRewardsWizardPage.EnableFeature.SetValue(true);
        CustomerRewardsWizardPage.ActionNext.Invoke();
    end;

    local procedure ActivateCustomerRewards()
    var
        ActivationCodeInfo: Record "Activation Code Inform. NTG";
    begin
        ActivationCodeInfo.Init();
        ActivationCodeInfo.ActivationCode := '12345678901234';
        ActivationCodeInfo."Date Activated" := Today;
        ActivationCodeInfo."Expiration Date" := CalcDate('<1Y>', Today);
        ActivationCodeInfo.Insert();
    end;

    local procedure VerifyCustomerRewardLevel(ExpectedLevel: Text; ActualLevel: Text)
    begin
        Assert.AreEqual(ExpectedLevel, ActualLevel, 'Reward Level should be the same');
    end;

    local procedure VerifyCustomerRewardPoints(ExpectedPoints: Integer; ActualPoints: Integer)
    begin
        Assert.AreEqual(ExpectedPoints, ActualPoints, 'Reward Points should be the same');
    end;

    [ModalPageHandler]
    procedure CustomerRewardsWizardModalPageHandler(var CustomerRewardsWizard: TestPage "Customer Rewards Wizard NTG")
    begin
    end;

    [PageHandler]
    procedure RewardsLevelListPageHandler(var RewardsLevelList: TestPage "Reward Levels List NTG")
    begin
    end;

}