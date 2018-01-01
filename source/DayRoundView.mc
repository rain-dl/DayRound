using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Activity as Act;
using Toybox.UserProfile;

class DayRoundView extends Ui.WatchFace {

    hidden var hourFont;
    hidden var hourFontWidth;
    hidden var hourFontHeight;
    hidden var minuteFont;
    hidden var minuteFontWidth;
    hidden var minuteFontHeight;
    hidden var secondFont;
    hidden var secondFontWidth;
    hidden var secondFontHeight;
    hidden var ampmFont;
    hidden var sunmoonFont;
    hidden var centerX;
    hidden var centerY;
    private var _timeZoneOffset = 0;
    private var _iconFont;

    private var _backgroundColor;
    private var _useMilitaryFormat;
    private var _hourColor;
    private var _minuteColor;
    private var _ampmColor;
    private var _secondColor;
    private var _dayArcColor;
    private var _nightArcColor;
    private var _sunriseMarkColor;
    private var _sunsetMarkColor;
    private var _timePosMarkColor;
    private var _upperInfo;
    private var _upperInfoPosition;
    private var _showUpperIcon;
    private var _upperIconColor;
    private var _upperIconInfoGap;
    private var _upperInfoColor;
    private var _lowerInfo;
    private var _lowerInfoPosition;
    private var _showLowerIcon;
    private var _lowerIconColor;
    private var _lowerIconInfoGap;
    private var _lowerInfoColor;
    private var _dateFormat;
    private var _arc1Info;
    private var _arc1Radius;
    private var _arc1Width;
    private var _arc1Color;
    private var _arc1Direction;
    private var _arc2Info;
    private var _arc2Radius;
    private var _arc2Width;
    private var _arc2Color;
    private var _arc2Direction;

    private var _firstDraw;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        hourFont = WatchUi.loadResource(Rez.Fonts.id_font_futura_49);
        var dimensions = dc.getTextDimensions("0", hourFont);
        hourFontWidth = dimensions[0];
        hourFontHeight = dimensions[1];

        minuteFont = WatchUi.loadResource(Rez.Fonts.id_font_futura_18);
        dimensions = dc.getTextDimensions("0", minuteFont);
        minuteFontWidth = dimensions[0];
        minuteFontHeight = dimensions[1];

        secondFont = minuteFont;
        secondFontWidth = minuteFontWidth;
        secondFontHeight = minuteFontHeight;

        ampmFont = WatchUi.loadResource(Rez.Fonts.id_font_berlin_sans_fb_7);
        _iconFont = WatchUi.loadResource(Rez.Fonts.id_font_icons);

        sunmoonFont = WatchUi.loadResource(Rez.Fonts.id_font_sun_moon);

        centerX = dc.getWidth() >> 1 - 1;
        centerY = dc.getHeight() >> 1 - 1;

        loadSettings();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    function DebugOutputDateTime(msg, time, isUtc) {
        var t;
        if (isUtc) {
            t = Sys.Time.Gregorian.utcInfo(time, Time.FORMAT_SHORT);
        } else {
            t = Sys.Time.Gregorian.info(time, Time.FORMAT_SHORT);
        }
        Sys.println(Lang.format("$7$: $1$-$2$-$3$ $4$:$5$:$6$", [t.year.format("%02d"), t.month.format("%02d"), t.day.format("%02d"),
            t.hour.format("%02d"), t.min.format("%02d"), t.sec.format("%02d"), msg]));
    }

    function loadSettings() {
        _backgroundColor = Utils.getColor(App.getApp().getProperty("BackgroundColor"), Gfx.COLOR_BLACK);
        _useMilitaryFormat = App.getApp().getProperty("UseMilitaryFormat");
        _hourColor = Utils.getColor(App.getApp().getProperty("HourColor"), Gfx.COLOR_WHITE);
        _minuteColor = Utils.getColor(App.getApp().getProperty("MinuteColor"), Gfx.COLOR_BLUE);
        _ampmColor = Utils.getColor(App.getApp().getProperty("AMPMColor"), Gfx.COLOR_WHITE);
        _secondColor = Utils.getColor(App.getApp().getProperty("SecondColor"), Gfx.COLOR_YELLOW);
        _dayArcColor = Utils.getColor(App.getApp().getProperty("DayArcColor"), Gfx.COLOR_BLUE);
        _nightArcColor = Utils.getColor(App.getApp().getProperty("NightArcColor"), Gfx.COLOR_DK_GRAY);
        _sunriseMarkColor = Utils.getColor(App.getApp().getProperty("SunriseMarkColor"), Gfx.COLOR_WHITE);
        _sunsetMarkColor = Utils.getColor(App.getApp().getProperty("SunsetMarkColor"), Gfx.COLOR_WHITE);
        _timePosMarkColor = Utils.getColor(App.getApp().getProperty("TimePosMarkColor"), Gfx.COLOR_YELLOW);
        _upperInfo = App.getApp().getProperty("UpperInfo");
        _upperInfoPosition = App.getApp().getProperty("UpperInfoPosition");
        _showUpperIcon = App.getApp().getProperty("ShowUpperIcon");
        _upperIconColor = Utils.getColor(App.getApp().getProperty("UpperIconColor"), Gfx.COLOR_DK_GRAY);
        _upperIconInfoGap = App.getApp().getProperty("UpperIconInfoGap");
        _upperInfoColor = Utils.getColor(App.getApp().getProperty("UpperInfoColor"), Gfx.COLOR_DK_GRAY);
        _lowerInfo = App.getApp().getProperty("LowerInfo");
        _lowerInfoPosition = App.getApp().getProperty("LowerInfoPosition");
        _showLowerIcon = App.getApp().getProperty("ShowLowerIcon");
        _lowerIconColor = Utils.getColor(App.getApp().getProperty("LowerIconColor"), Gfx.COLOR_DK_GRAY);
        _lowerIconInfoGap = App.getApp().getProperty("LowerIconInfoGap");
        _lowerInfoColor = Utils.getColor(App.getApp().getProperty("LowerInfoColor"), Gfx.COLOR_DK_GRAY);
        _dateFormat = App.getApp().getProperty("DateFormat");

        _arc1Info = App.getApp().getProperty("Arc1Info");
        _arc1Radius = App.getApp().getProperty("Arc1Radius");
        _arc1Width = App.getApp().getProperty("Arc1Width");
        _arc1Color = Utils.getColor(App.getApp().getProperty("Arc1Color"), Gfx.COLOR_DK_RED);
        _arc1Direction = App.getApp().getProperty("Arc1Direction");
        _arc2Info = App.getApp().getProperty("Arc2Info");
        _arc2Radius = App.getApp().getProperty("Arc2Radius");
        _arc2Width = App.getApp().getProperty("Arc2Width");
        _arc2Color = Utils.getColor(App.getApp().getProperty("Arc2Color"), Gfx.COLOR_DK_GREEN);
        _arc2Direction = App.getApp().getProperty("Arc2Direction");

        _firstDraw = true;
    }

    function drawBackground(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, _backgroundColor);
        dc.clear();
    }

    function drawTestColors(dc) {
        var sw = 12;
        var x = (dc.getWidth() - sw * 16) / 2;
        var y = (dc.getHeight() - sw * 3) / 2;
        for (var i = 0; i < 16; i++) {
            var c = i * 16;
            dc.setColor(c, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(x + sw * i, y, sw, sw);
            c = c << 8;
            dc.setColor(c, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(x + sw * i, y + sw, sw, sw);
            c = c << 8;
            dc.setColor(c, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(x + sw * i, y + sw + sw, sw, sw);
        }
    }

    function drawAllColors(dc) {
        var sw = 21;
        var x = (dc.getWidth() - sw * 8) / 2;
        var y = (dc.getHeight() - sw * 8) / 2;
        var cv = [0, 85, 170, 255];
        var idx = 0;
        for (var i = 0; i < 4; i++) {
            var r = cv[i] << 16;
            for (var j = 0; j < 4; j++) {
                var g = cv[j] << 8;
                for (var k = 0; k < 4; k++) {
                    var c = r + g + cv[k];
                    dc.setColor(c, Gfx.COLOR_TRANSPARENT);
                    var xx = x + idx % 8 * sw;
                    var yy = y + (idx / 8).toNumber() * sw;
                    dc.fillRectangle(xx, yy, sw, sw);
                    idx++;
                }
            }
        }
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(x - 1, y - 1, sw * 8 + 2, sw * 8 + 2);
    }

    function drawCurrentTime(dc, clockTime, isPartialUpdate) {
        _timeZoneOffset = clockTime.timeZoneOffset;
        var hourDigits = 1;
        var hour = clockTime.hour;
        var is24Hour = Sys.getDeviceSettings().is24Hour;
        if (!is24Hour) {
            if (hour > 12) {
                hour = hour - 12;
            }
        }

        var w = dc.getWidth();
        var h = dc.getHeight();
        var min_sec_x = (w + hourFontWidth) / 2 + 9;
        var hour_y = (h - hourFontHeight) / 2;

        if (!isPartialUpdate) {
            if (_useMilitaryFormat) {
                hour = hour.format("%02d");
                hourDigits = 2;
            } else {
                if (hour >= 10) {
                    hourDigits = 2;
                }
            }

            var x = (w - hourFontWidth) / 2;
            if (hourDigits > 1) {
                x -= hourFontWidth;
            }

            dc.setColor(_hourColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(x, hour_y, hourFont, hour.toString(), Gfx.TEXT_JUSTIFY_LEFT);

            var minute = clockTime.min.format("%02d");
            dc.setColor(_minuteColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(min_sec_x, hour_y, minuteFont, minute, Gfx.TEXT_JUSTIFY_LEFT);

            if (!is24Hour) {
                var ampm;
                if (clockTime.hour > 11) {
                    ampm = "PM";
                } else {
                    ampm = "AM";
                }
                var ampm_x = min_sec_x + minuteFontWidth * 2 + 6;
                dc.setColor(_ampmColor, Gfx.COLOR_TRANSPARENT);
                dc.drawText(ampm_x, hour_y, ampmFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }

        var second = clockTime.sec.format("%02d");
        var sec_y = hour_y + hourFontHeight - 2 - secondFontHeight;
        if (isPartialUpdate) {
            dc.setClip(min_sec_x, sec_y, secondFontWidth * 2, secondFontHeight + 1);
            drawBackground(dc);
        }
        dc.setColor(_secondColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(min_sec_x, sec_y, secondFont, second, Gfx.TEXT_JUSTIFY_LEFT);
    }

    function drawSunIcons(dc) {
        var actInfo = Act.getActivityInfo();
        if(actInfo != null && actInfo.currentLocation != null) {
            var day = Time.today().value() + _timeZoneOffset;
            var lastLoc = actInfo.currentLocation.toRadians();
            //lastLoc = [39.857 * Math.PI / 180, 116.6 * Math.PI / 180];
            Sys.println(lastLoc);

            var sunrise_moment = SunCalc.calculate(day, lastLoc[0], lastLoc[1], SUNRISE);
            var sunset_moment = SunCalc.calculate(day, lastLoc[0], lastLoc[1], SUNSET);
            DebugOutputDateTime("sunrise", sunrise_moment, false);
            DebugOutputDateTime("sunset", sunset_moment, false);
            var sunrise = (sunrise_moment.value() + _timeZoneOffset - day).toDouble();
            var sunset = (sunset_moment.value() + _timeZoneOffset - day).toDouble();
            var sunrise_ad = sunrise / 86400 * 360;
            var sunset_ad = sunset / 86400 * 360;
            var sunrise_ar = Math.toRadians(sunrise_ad);
            var sunset_ar = Math.toRadians(sunset_ad);
            sunrise_ad = 90 - sunrise_ad;
            sunset_ad = 90 - sunset_ad;

            var r = centerX - 3;
            dc.setPenWidth(3);
            dc.setColor(_dayArcColor, Gfx.COLOR_TRANSPARENT);
            dc.drawArc(centerX, centerY, r, Gfx.ARC_CLOCKWISE, sunrise_ad, sunset_ad);
            dc.setColor(_nightArcColor, Gfx.COLOR_TRANSPARENT);
            dc.drawArc(centerX, centerY, r, Gfx.ARC_CLOCKWISE, sunset_ad, sunrise_ad);

            r = r - 1;
            dc.setColor(_sunriseMarkColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX + 0.5 + r * Math.sin(sunrise_ar), centerY + 0.5 - r * Math.cos(sunrise_ar),
                sunmoonFont, "R", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            dc.setColor(_sunsetMarkColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX + 0.5 + r * Math.sin(sunset_ar), centerY + 0.5 - r * Math.cos(sunset_ar),
                sunmoonFont, "S", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

            drawTimePositionIcon(dc);
        }
    }

    function drawTimePositionIcon(dc) {
        var secondsOfDay = Time.now().value() - Time.today().value();
        var timepos_ar = Math.toRadians(secondsOfDay / 86400.0 * 360);
        //timepos_ar = Math.toRadians((secondsOfDay % 60) / 60.0 * 360);
        var points = [ [0, 0], [0, 0], [0, 0] ];
        var ard = 0.04;
        var r = centerX + 2;
        points[0][0] = centerX + 0.5 + r * Math.sin(timepos_ar - ard);
        points[0][1] = centerY + 0.5 - r * Math.cos(timepos_ar - ard);
        points[1][0] = centerX + 0.5 + r * Math.sin(timepos_ar + ard);
        points[1][1] = centerY + 0.5 - r * Math.cos(timepos_ar + ard);
        r = centerX - 8;
        points[2][0] = centerX + 0.5 + r * Math.sin(timepos_ar);
        points[2][1] = centerY + 0.5 - r * Math.cos(timepos_ar);
        dc.setPenWidth(1);
        dc.setColor(_timePosMarkColor, _timePosMarkColor);
        dc.fillPolygon(points);
    }

    function getInfoText(info) {
        var text;
        if (info == 0) {
            var info = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
            text = Lang.format("$1$ ", ((_dateFormat == 1) ? [info.month] : [info.day_of_week]) );
            text += info.day.format("%0.1d");
        } else if (info == 4) {
            var curHeartRate = 0;
            var maxHeartRate = 0;
            if(ActivityMonitor has :HeartRateIterator) {
                var hrIter = ActivityMonitor.getHeartRateHistory(null, true);
                if(hrIter != null){
                    var hr = hrIter.next();
                    curHeartRate = (hr.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && hr.heartRate > 0) ? hr.heartRate : 0;
                    maxHeartRate = hrIter.getMax();
                }
            }
            text = Lang.format("$1$ / $2$", [curHeartRate, maxHeartRate]);
        } else if (info == 5) {
            var altitude = 0;
            var actInfo = Act.getActivityInfo();
            if (actInfo.altitude != null) {
                altitude = actInfo.altitude;
            }
            if (System.getDeviceSettings().elevationUnits == Sys.UNIT_STATUTE) {
                altitude = altitude * 3.38;
                text = altitude.toLong().toString() + "ft";
            } else {
                text = altitude.toLong().toString() + "m";
            }
        } else {
            var actInfo = ActivityMonitor.getInfo();
            switch (info) {
            case 1:
                text = actInfo.calories.toString();
                break;
            case 2:
                text = actInfo.steps.toString();
                break;
            case 3:
                var distance = actInfo.distance / 100;
                if (System.getDeviceSettings().elevationUnits == Sys.UNIT_STATUTE) {
                    distance = distance * 3.38;
                    text = distance.toNumber().toString() + "ft";
                } else {
                    text = distance.toNumber().toString() + "m";
                }
                break;
            case 6:
                text = actInfo.floorsClimbed.toString();
                break;
            case 7:
                text = actInfo.activeMinutesDay.total.toString();
                break;
            }
        }
        return text;
    }

    function drawBatteryIcon(dc, battery, xPos, yPos, width, height, iconColor) {
        dc.setPenWidth(1);

        if(battery <= 15) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        } else {
            dc.setColor(iconColor, Gfx.COLOR_TRANSPARENT);
        }

        dc.drawRectangle(xPos, yPos, width - 1, height);
        dc.fillRectangle(xPos + width - 1, yPos + 3, 1, height - 6);

        var lvl = ((width - 5.0) * (battery / 100.0) + 0.5).toNumber();
        if (lvl >= 1) {
            dc.fillRectangle(xPos + 2, yPos + 2, lvl, height - 4);
        }
    }

    function drawInfo(dc, info, y, showIcon, iconColor, iconInfoGap, infoColor) {
        if (info == 8) {
            var battery = (Sys.getSystemStats().battery + 0.5).toNumber();
            var text = battery.format("%d") + "%";
            var textSize = dc.getTextDimensions(text, Gfx.FONT_TINY);
            var iconSize = [20, 10];
            var w = textSize[0] + iconSize[0] + iconInfoGap;
            var x = centerX - w >> 1;
            drawBatteryIcon(dc, battery, x, y - iconSize[1] >> 1 + 1, iconSize[0], iconSize[1], iconColor);
            x += iconSize[0] + iconInfoGap;
            dc.setColor(infoColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(x, y, Gfx.FONT_XTINY, text, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
        } else {
            var text = getInfoText(info);
            if (info == 0 || !showIcon) {
                dc.setColor(infoColor, Gfx.COLOR_TRANSPARENT);
                dc.drawText(centerX, y, Gfx.FONT_XTINY, text, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            } else {
                var textSize = dc.getTextDimensions(text, Gfx.FONT_TINY);
                var iconSize = dc.getTextDimensions(info.toString(), _iconFont);
                var w = textSize[0] + iconSize[0] + iconInfoGap;
                var x = centerX - w >> 1;
                dc.setColor(iconColor, Gfx.COLOR_TRANSPARENT);
                dc.drawText(x, y, _iconFont, info.toString(), Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
                x += iconSize[0] + iconInfoGap;
                dc.setColor(infoColor, Gfx.COLOR_TRANSPARENT);
                dc.drawText(x, y, Gfx.FONT_XTINY, text, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
            }
        }
    }

    function getArcInfoCurrentAndMaxValue(info) {
        var values = [0, 0];
        if (info == 5) {
            values[0] = Sys.getSystemStats().battery;
            values[1] = 100;
        } else {
            var actInfo = ActivityMonitor.getInfo();
            switch (info) {
            case 0:
                values[0] = actInfo.steps;
                values[1] = actInfo.stepGoal;
                break;
            case 1:
                values[0] = actInfo.distance;
                values[1] = actInfo.stepGoal * UserProfile.getProfile().walkingStepLength / 10;
                break;
            case 2:
                values[0] = actInfo.calories;
                var history = ActivityMonitor.getHistory();
                if(history != null) {
                    for (var i = 0; i < history.size; i++) {
                        var activity = history[i];
                        if (values[1] < activity.calories) {
                            values[1] = activity.calories;
                        }
                    }
                }
                break;
            case 3:
                values[0] = actInfo.floorsClimbed;
                values[1] = actInfo.floorsClimbedGoal;
                break;
            case 4:
                values[0] = actInfo.activeMinutesWeek;
                values[1] = actInfo.activeMinutesWeekGoal;
                break;
            }
        }
        if (values[1] < values[0]) {
            values[1] = values[0];
        }
        return values;
    }

    function drawArcInfo(dc, info, radius, width, color, direction) {
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        var values = getArcInfoCurrentAndMaxValue(info);
        if (values != null) {
            if (values[0] == 0) {
                dc.setPenWidth(1);
                dc.drawLine(centerX, centerY - radius - width >> 1, centerX, centerY - radius + width >> 1);
            } else if (values[0] == values[1]) {
                dc.setPenWidth(width);
                dc.drawCircle(centerX, centerY, radius);
            } else {
                var angle = values[0] * 360.0 / values[1];
                if (direction == 0) {
                    angle = 360 - angle;
                }
                angle += 90;
                if (angle > 360) {
                    angle -= 360;
                }
                dc.setPenWidth(width);
                dc.drawArc(centerX, centerY, radius, direction == 0 ? Gfx.ARC_CLOCKWISE : Gfx.ARC_COUNTER_CLOCKWISE,
                    90, angle);
            }
        }
    }

    // Update the view
    function onUpdate(dc) {
        var clockTime = Sys.getClockTime();
        var isPartialUpdate = !(_firstDraw || clockTime.sec == 0);

        if (!isPartialUpdate) {
            dc.clearClip();
            drawBackground(dc);
        }

        if (!isPartialUpdate) {
            drawSunIcons(dc);

            if (_arc1Info >= 0) {
                drawArcInfo(dc, _arc1Info, _arc1Radius, _arc1Width, _arc1Color, _arc1Direction);
            }

            if (_arc2Info >= 0) {
                drawArcInfo(dc, _arc2Info, _arc2Radius, _arc2Width, _arc2Color, _arc2Direction);
            }

            if (_upperInfo >= 0) {
                drawInfo(dc, _upperInfo, centerY + _upperInfoPosition, _showUpperIcon, _upperIconColor, _upperIconInfoGap, _upperInfoColor);
            }

            if (_lowerInfo >= 0) {
                drawInfo(dc, _lowerInfo, centerY + _lowerInfoPosition, _showLowerIcon, _lowerIconColor, _lowerIconInfoGap, _lowerInfoColor);
            }
        }

        drawCurrentTime(dc, clockTime, isPartialUpdate);

        if (_firstDraw) { _firstDraw = false; }
    }

    function onPartialUpdate(dc) {
        var clockTime = Sys.getClockTime();
        drawCurrentTime(dc, clockTime, true);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
