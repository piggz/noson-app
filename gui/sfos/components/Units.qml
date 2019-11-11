import QtQuick 2.9

Item {
    property real scaleFactor: 1.0
    property real fontScaleFactor: 1.0
    property real gridUnit: 8.0 * scaleFactor

    function dp(p) {
        return scaleFactor * p;
    }

    function gu(u) {
        return gridUnit * u;
    }

    function fs(s) {
        if (Android) {
            if (s === "x-small")
                return 10.0 * scaleFactor * fontScaleFactor;
            if (s === "small")
                return 12.0 * scaleFactor * fontScaleFactor;
            if (s === "medium")
                return 14.0 * scaleFactor * fontScaleFactor;
            if (s === "large")
                return 18.0 * scaleFactor * fontScaleFactor;
            if (s === "x-large")
                return 24.0 * scaleFactor * fontScaleFactor;
        } else {
            if (s === "x-small")
                return 9.0 * scaleFactor * fontScaleFactor;
            if (s === "small")
                return 10.0 * scaleFactor * fontScaleFactor;
            if (s === "medium")
                return 11.0 * scaleFactor * fontScaleFactor;
            if (s === "large")
                return 14.0 * scaleFactor * fontScaleFactor;
            if (s === "x-large")
                return 18.0 * scaleFactor * fontScaleFactor;
        }
        return 0.0;
    }

}
