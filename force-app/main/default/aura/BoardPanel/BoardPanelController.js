({
    startGame: function (component, event, helper) {

        let gameModeComboBox = component.find("gameMode");

        let selectedValue = gameModeComboBox.get("v.value");

        const selectedMode = component.get("v.selectedMode");

        component.set("v.selectedMode", selectedValue);
        if (selectedMode) {
            const boardComp = component.find("boardComp");

            boardComp.startGame();
        }
    },

    reshuffleBoard: function (component, event, helper) {

        const boardComp = component.find("boardComp");
        boardComp.reshuffleBoard();
        component.set("v.reshuffleDisabled", true);
    },

    onResultHandler: function (component, event, helper) {

        const result = event.getParam("result").toUpperCase();

        if (result === "WIN") {
            component.set("v.reshuffleDisabled", true);
            helper.showToast("YOU WIN!", "Congratulations!!!", "success");

        } else {
            component.set("v.reshuffleDisabled", false);
            helper.showToast("YOU LOSE!", "Don't worry, be happy!!! Click Reshuffle.", "error");
        }

        helper.addResultRecord(component, result);

    }
});

