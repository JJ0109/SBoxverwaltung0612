sap.ui.define(["sap/fe/test/ObjectPage"], function (ObjectPage) {
  "use strict";

  // OPTIONAL
  var AdditionalCustomObjectPageDefinition = {
    actions: {},
    assertions: {},
  };

  return new ObjectPage(
    {
      appId: "slah.db",
      componentId: "BoxObjectPage",
      entitySet: "Box",
    },
    AdditionalCustomObjectPageDefinition
  );
});
