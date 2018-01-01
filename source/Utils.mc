using Toybox.Graphics as Gfx;
using Toybox.Lang;

module Utils {

    function getColor(color_property, color_default) {
        if (color_property == 1) {
            return Gfx.COLOR_BLUE;
        }else if (color_property == 2) {
            return Gfx.COLOR_DK_BLUE;
        }else if (color_property == 3) {
            return Gfx.COLOR_GREEN;
        }else if (color_property == 4) {
            return Gfx.COLOR_DK_GREEN;
        }else if (color_property == 5) {
            return Gfx.COLOR_LT_GRAY;
        }else if (color_property == 6) {
            return Gfx.COLOR_DK_GRAY;
        }else if (color_property == 7) {
            return Gfx.COLOR_ORANGE;
        }else if (color_property == 8) {
            return Gfx.COLOR_PINK;
        }else if (color_property == 9) {
            return Gfx.COLOR_PURPLE;
        }else if (color_property == 10) {
            return Gfx.COLOR_RED;
        }else if (color_property == 11) {
            return Gfx.COLOR_DK_RED;
        }else if (color_property == 12) {
            return Gfx.COLOR_YELLOW;
        }else if (color_property == 13) {
            return Gfx.COLOR_WHITE;
        }else if (color_property == 14) {
            return Gfx.COLOR_BLACK;
        }
        return color_default;
    }

}