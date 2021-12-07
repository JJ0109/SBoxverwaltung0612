/* global QUnit */
/*eslint no-unused-vars: 0*/
sap.ui.define(["sap/ui/test/opaQunit"], function (opaTest) {
  "use strict";

  var Journey = {
    start: function () {
      QUnit.module("Sample journey");
      opaTest("#000: Start", function (Given, When, Then) {
        Given.iResetTestData().and.iStartMyApp("box-process", {
          "sap-language": "EN",
        });
      });
      return Journey;
    },

    test: function () {
      opaTest(
        "#1: ListReport: Check List Report Page loads",
        function (Given, When, Then) {
          Then.onTheMainPage.iSeeThisPage();
        }
      );

      opaTest(
        "#2: Object Page: Check Object Page loads",
        function (Given, When, Then) {
          When.onTheMainPage.onTable().iPressRow({ BoxID: "4133" });
          Then.onTheDetailPage.iSeeThisPage();

          When.iNavigateBack();
          Then.onTheMainPage.iSeeThisPage();
        }
      );

      opaTest("#3: List report: Create box", function (Given, When, Then) {
        Then.onTheMainPage.iSeeThisPage();
        Then.onTheMainPage.onTable().iCheckAction("Create", { enabled: true });

        // Click on Create button
        When.onTheMainPage.onTable().iExecuteAction("Create");
        Then.onTheDetailPage.iSeeObjectPageInEditMode();
        When.onTheDetailPage.iOpenSectionWithTitle("Box");

        // Value help Customer ID
        When.onTheDetailPage
          .onForm({ section: "Box", fieldGroup: "BoxData" })
          .iOpenValueHelp({ property: "to_Patient_PatientID" });
        When.onTheDetailPage
          .onValueHelpDialog()
          .iSelectRows({ 0: "000001" })
          .and.iConfirm();

        // Starting date
        When.onTheDetailPage
          .onForm({ section: "Box", fieldGroup: "DateData" })
          .iChangeField({ property: "BeginDateAusleihe" }, "Jan 1, 2023");

        // End date
        When.onTheDetailPage
          .onForm({ section: "Box", fieldGroup: "DateData" })
          .iChangeField({ property: "EndDateAusleihe" }, "Dec 31, 2024");

        // Description
        When.onTheDetailPage
          .onForm({ section: "Box", fieldGroup: "BoxData" })
          .iChangeField({ property: "Boxname" }, "Box for deletion");

        // Save all
        Then.onTheDetailPage.onFooter().iCheckDraftStateSaved();
        When.onTheDetailPage.onFooter().iExecuteSave();
        Then.onTheDetailPage.iSeeThisPage().and.iSeeObjectPageInDisplayMode();
        When.onTheShell.iNavigateBack();
      });

      opaTest("#4: List report: Delete box", function (Given, When, Then) {
        Then.onTheMainPage.iSeeThisPage();

        Then.onTheMainPage
          .onTable()
          .iCheckDelete({ visible: true, enabled: false });

        // select row to be deleted
        Given.onTheMainPage
          .onTable()
          .iSelectRows({ Description: "Box for deletion" });

        Then.onTheMainPage
          .onTable()
          .iCheckDelete({ visible: true, enabled: true });
        When.onTheMainPage
          .onTable()
          .iExecuteDelete()
          .and.when.onDialog()
          .iConfirm();
        Then.onTheMainPage
          .iSeeDeleteConfirmation()
          .and.onTable()
          .iCheckDelete({ visible: true, enabled: false });
      });

      opaTest(
        "#5: List report: Check actions (Accept, Reject, Available)",
        function (Given, When, Then) {
          Then.onTheMainPage.iSeeThisPage();

          // Check that bound action is inactive without selection
          Then.onTheMainPage
            .onTable()
            .iCheckAction(
              { service: "BoxService", action: "acceptBox" },
              { visible: true, enabled: false }
            );

          // select first row
          Given.onTheMainPage.onTable().iSelectRows({ BoxID: "4132" });

          // Check that bound action is now active after selection
          Then.onTheMainPage
            .onTable()
            .iCheckAction(
              { service: "BoxService", action: "acceptBox" },
              { visible: true, enabled: true }
            );

          // check that "Box status" is Open
          Then.onTheMainPage
            .onTable()
            .iCheckRows({ BoxID: "4132", "Box Status": "Verfügbar" }, 1);

          // trigger action
          When.onTheMainPage.onTable().iExecuteAction({
            service: "BoxService",
            action: "acceptBox",
          });

          // check that "Box status" is now Accepted
          Then.onTheMainPage
            .onTable()
            .iCheckRows({ BoxID: "4132", "Box Status": "Rückgabe" }, 1);

          // unselect first row
          Given.onTheMainPage.onTable().iSelectRows({ BoxID: "4132" });

          // select 2nd row
          Given.onTheMainPage.onTable().iSelectRows({ BoxID: "4131" });

          // check that "Box status" is Open
          Then.onTheMainPage
            .onTable()
            .iCheckRows({ BoxID: "4131", "Box Status": "Verfügbar" }, 1);

          // trigger action
          When.onTheMainPage.onTable().iExecuteAction({
            service: "BoxService",
            action: "rejectBox",
          });

          // check that "Box status" is Open
          Then.onTheMainPage
            .onTable()
            .iCheckRows({ BoxID: "4131", "Box Status": "Außer Haus" }, 1);

          // unselect 2nd row
          Given.onTheMainPage.onTable().iSelectRows({ BoxID: "4131" });

          Then.onTheMainPage.iSeeThisPage();
        }
      );

      return Journey;
    },
    end: function () {
      opaTest("#999: Tear down", function (Given, When, Then) {
        Given.iTearDownMyApp();
      });
      return Journey;
    },
  };
  Journey.run = function () {
    Journey.start().test().end();
  };

  return Journey;
});