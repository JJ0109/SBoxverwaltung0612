sap.ui.define(["sap/fe/test/ListReport"], function (ListReport) {
  "use strict";

  // OPTIONAL
  var AdditionalCustomListReportDefinition = {
    actions: {},
    assertions: {},
  };

  return new ListReport(
    {
      appId: "slah.db",
      componentId: "BoxList",
      entitySet: "Box",
    },
    AdditionalCustomListReportDefinition
  );
});
