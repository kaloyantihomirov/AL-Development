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
        BronzeLevelTxt: Label 'Bronze';
        SilverLevelTxt: Label 'Silver';
        GoldLevelTxt: Label 'Gold';
        NoLevelTxt: Label 'NONE';
        CustPermissionFullLbl: Label 'CustRewardsFull', Locked = true;

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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);

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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);

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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);

        // [When] User opens Customer List page
        CustomerListPage.OpenView();

        // [Then] The Rewards Level action exists
        Assert.IsTrue(CustomerListPage."Reward Levels NTG".Visible(),
                     'Rewards Level action should be visible on Customer List page.');
    end;

    [Test]
    [HandlerFunctions('CustomerRewardsWizardPageHandler')]

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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        Assert.IsFalse(CustomerRewardsExtMgt.IsCustomerRewardsActivated(), CustomerRewardsNotActivatedLbl);

        // [When] The user clicks on the action 
        CustomerListPage.OpenView();
        CustomerListPage."Reward Levels NTG".Invoke();

        // [Then] Wizard opens. Caught by CustomerRewardsWizardPageHandler 
    end;

    [Test]
    [HandlerFunctions('RewardsLevelListModalPageHandler')]
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

        // [Then] Rewards Level List opens. Caught by RewardsLevelListModalPageHandler
    end;

    [Test]

    procedure TestCustomerCardPageHasRewardsFields()
    var
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] Customer Card Page has reward fields when opened
        // [Given] Customer Card Page

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);

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

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
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

    //TODO: NOT REALLY SURE THAT THIS WILL WORK
    [Test]

    procedure TestCustomerHasCorrectRewardPointsAfterPostedSalesOrders()
    var
        Customer: Record Customer;
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] Customer posts 4 Sales orders and his reward points are correctly calculated
        // [Given] A customer with 4 posted orders

        Initialise();
        Commit();

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        ActivateCustomerRewards();
        LibrarySales.CreateCustomer(Customer);

        // [When] Customer posts 4 sales orders
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");

        // [Then] Reward Points are correctly calculated
        CustomerCardPage.OpenView();
        CustomerCardPage.GoToRecord(Customer);
        VerifyCustomerRewardPoints(4, CustomerCardPage.RewardPoints.AsInteger());
    end;

    [Test]
    procedure TestCustomerHasNoRewardLevelAfterPostedSalesOrders()
    var
        Customer: Record Customer;
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] Customer has no reward level after posting 2 orders (needs 1 more for bronze (>=3))
        // [Given] A customer with 2 posted orders

        Initialise();
        Commit();

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        ActivateCustomerRewards();
        AddRewardLevel(BronzeLevelTxt, 3);
        LibrarySales.CreateCustomer(Customer);

        CustomerCardPage.OpenView();
        CustomerCardPage.GoToRecord(Customer);
        VerifyCustomerRewardPoints(0, CustomerCardPage.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCardPage.RewardLevel.Value);

        // [When] Customer posts 2 orders
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");

        // [Then] No reward level is set on the customer, but points are updated
        CustomerCardPage.GoToRecord(Customer);
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCardPage.RewardLevel.Value);
        VerifyCustomerRewardPoints(2, CustomerCardPage.RewardPoints.AsInteger());
    end;

    [Test]
    procedure TestCustomerHasBronzeRewardLevelAfterPostedSalesOrders()
    var
        Customer: Record Customer;
        CustomerCardPage: TestPage "Customer Card";
    begin
        // [Scenario] Customer has the correct reward level based on posted orders
        // [Given] A customer with 4 posted orders

        Initialise();
        Commit();

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        ActivateCustomerRewards();
        LibrarySales.CreateCustomer(Customer);
        AddRewardLevel(BronzeLevelTxt, 4);
        CustomerCardPage.OpenView();
        CustomerCardPage.GoToRecord(Customer);
        VerifyCustomerRewardPoints(0, CustomerCardPage.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCardPage.RewardLevel.Value);

        // [When] Customer posts 4 orders
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");

        // [Then] Reward Level and points are correctly set
        CustomerCardPage.GoToRecord(Customer);
        VerifyCustomerRewardPoints(4, CustomerCardPage.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(BronzeLevelTxt, CustomerCardPage.RewardLevel.Value);
    end;

    [Test]
    procedure TestCustomerHasSilverRewardLevelAfterPostedSalesOrders()
    var
        Customer: Record Customer;
        CustomerCard: TestPage "Customer Card";
    begin
        // [Scenario] Customer posts 4 sales orders and then has the silver reward level set
        // [Given] A customer with 4 posted sales orders, a bronze level for 2+ orders, and silver level for 4+ orders

        Initialise();
        Commit();

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        ActivateCustomerRewards();
        LibrarySales.CreateCustomer(Customer);
        AddRewardLevel(BronzeLevelTxt, 2);
        AddRewardLevel(SilverLevelTxt, 4);

        //The customer has 0 reward points and no reward level with 0 posted orders
        CustomerCard.OpenView();
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(0, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCard.RewardLevel.Value);

        CreateAndPostSalesOrder(Customer."No.");

        //The customer has 1 reward points for the posted order and still no reward level set
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(1, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(NoLevelTxt, CustomerCard.RewardLevel.Value);

        CreateAndPostSalesOrder(Customer."No.");

        //The customer has 2 reward points for the posted orders and bronze reward level set
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(2, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(BronzeLevelTxt, CustomerCard.RewardLevel.Value);

        CreateAndPostSalesOrder(Customer."No.");

        //The customer has 3 reward points for the posted orders and still bronze reward level set
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(3, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(BronzeLevelTxt, CustomerCard.RewardLevel.Value);


        CreateAndPostSalesOrder(Customer."No.");

        // [Then] Reward points (4) and reward level (silver) are correctly set on the card
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(4, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(SilverLevelTxt, CustomerCard.RewardLevel.Value);
    end;

    [Test]
    procedure TestCustomerHasGoldRewardLevelAfterPostedSalesOrders()
    var
        Customer: Record Customer;
        CustomerCard: TestPage "Customer Card";
    begin
        // [Scenario] Customer has the correct reward level set 
        // [Given] A customer with 5 orders, and bronze reward level for 3+ orders, silver for 4+, and gold for 5+

        Initialise();
        Commit();

        LibraryLowerPermissions.SetExactPermissionSet(CustPermissionFullLbl);
        ActivateCustomerRewards();
        LibrarySales.CreateCustomer(Customer);
        AddRewardLevel(BronzeLevelTxt, 3);
        AddRewardLevel(SilverLevelTxt, 4);
        AddRewardLevel(GoldLevelTxt, 5);

        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");
        CreateAndPostSalesOrder(Customer."No.");

        //Customer has 4 reward points and silver reward level
        CustomerCard.OpenView();
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(4, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(SilverLevelTxt, CustomerCard.RewardLevel.Value);
        // [When] Customer posts their 5th order
        CreateAndPostSalesOrder(Customer."No.");
        // [Then] Customer has 5 reward points and gold reward level set
        CustomerCard.GoToRecord(Customer);
        VerifyCustomerRewardPoints(5, CustomerCard.RewardPoints.AsInteger());
        VerifyCustomerRewardLevel(GoldLevelTxt, CustomerCard.RewardLevel.Value);
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

    local procedure CreateAndPostSalesOrder(SellToCustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LibraryRandom: Codeunit "Library - Random";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, SellToCustomerNo);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', 1);
        SalesLine.Validate("Unit Price", LibraryRandom.RandIntInRange(5000, 10000));
        SalesLine.Modify(true);
        LibrarySales.PostSalesDocument(SalesHeader, true, true);
    end;

    local procedure AddRewardLevel(Level: Text[20]; MinimumPoints: Integer)
    var
        RewardLevel: Record "Reward Level NTG";
    begin
        if RewardLevel.Get(Level) then begin
            RewardLevel."Minimum Reward Points" := MinimumPoints;
            RewardLevel.Modify();
        end
        else begin
            RewardLevel.Init();
            RewardLevel.Level := Level;
            RewardLevel."Minimum Reward Points" := MinimumPoints;
            RewardLevel.Insert();
        end;
    end;

    [PageHandler]
    procedure CustomerRewardsWizardPageHandler(var CustomerRewardsWizard: TestPage "Customer Rewards Wizard NTG")
    begin
    end;

    [ModalPageHandler]
    procedure RewardsLevelListModalPageHandler(var RewardsLevelList: TestPage "Reward Levels List NTG")
    begin
    end;

}