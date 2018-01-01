using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class DayRoundApp extends App.AppBase {

    private var _dayRoundView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        _dayRoundView = new DayRoundView();
        return [ _dayRoundView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        _dayRoundView.loadSettings();
        Ui.requestUpdate();
    }

}