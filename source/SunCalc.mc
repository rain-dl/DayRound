using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.System as Sys;

enum {
	NIGHT_END,
	NAUTICAL_DAWN,
	DAWN,
	BLUE_HOUR_AM,
	SUNRISE,
	SUNRISE_END,
	GOLDEN_HOUR_AM,
	NOON,
	GOLDEN_HOUR_PM,
	SUNSET_START,
	SUNSET,
	BLUE_HOUR_PM,
	DUSK,
	NAUTICAL_DUSK,
	NIGHT,
	NUM_RESULTS
}

module SunCalc {

	const PI   = Math.PI,
		RAD  = Math.PI / 180.0,
		PI2  = Math.PI * 2.0,
		DAYS = Time.Gregorian.SECONDS_PER_DAY,
		J1970 = 2440588,
		J2000 = 2451545,
		J0 = 0.0009;

	const TIMES = [
		-18 * RAD,
		-12 * RAD,
		-6 * RAD,
		-4 * RAD,
		-0.833 * RAD,
		-0.3 * RAD,
		6 * RAD,
		null,
		6 * RAD,
		-0.3 * RAD,
		-0.833 * RAD,
		-4 * RAD,
		-6 * RAD,
		-12 * RAD,
		-18 * RAD
		];

	var lastTimeValue = null, lastLng = null, lastLat = null;
	var	n, ds, M, sinM, C, L, sin2L, dec, Jnoon;

	function fromJulian(j) {
		//Sys.println("j = " + j.toString());
		return new Time.Moment((j + 0.5 - J1970) * DAYS);
	}

	function round(a) {
		if (a > 0) {
			return (a + 0.5).toNumber().toFloat();
		} else {
			return (a - 0.5).toNumber().toFloat();
		}
	}

	// lat and lng in radians
	function calculate(time_value, lat, lng, what) {
		if (lastTimeValue != time_value || lastLng != lng || lastLat != lat) {
			var d = time_value.toDouble() / DAYS - 0.5d + J1970 - J2000;
			n = round(d - J0 + lng / PI2);
			ds = J0 - lng / PI2 + n - 1.1574e-5d * 68;
			//Sys.println("ds = " + ds.toString());
			M = 6.240059967d + 0.0172019715d * ds;
			sinM = Math.sin(M);
			C = (1.9148d * sinM + 0.02d * Math.sin(2 * M) + 0.0003d * Math.sin(3 * M)) * RAD;
			L = M + C + 1.796593063d + PI;
			sin2L = Math.sin(2 * L);
			dec = Math.asin( 0.397783703d * Math.sin(L) );
			Jnoon = J2000 + ds + 0.0053d * sinM - 0.0069d * sin2L;
			//Sys.println("sinM = " + sinM.toString());
			//Sys.println("sin2L = " + sin2L.toString());
			//Sys.println("Jnoon = " + Jnoon.toString());
			lastTimeValue = time_value;
			lastLng = lng;
			lastLat = lat;
		}

		if (what == NOON) {
			return fromJulian(Jnoon);
		}

		var x = (Math.sin(TIMES[what]) - Math.sin(lat) * Math.sin(dec)) / (Math.cos(lat) * Math.cos(dec));
		//Sys.println("x = " + x.toString());

		if (x > 1.0 || x < -1.0) {
			return null;
		}

		var ds = J0 + (Math.acos(x) - lng) / PI2 + n - 1.1574e-5d * 68;
		//Sys.println("ds = " + ds.toString());

		var Jset = J2000 + ds + 0.0053d * sinM - 0.0069d * sin2L;
		//Sys.println("sinM = " + sinM.toString());
		//Sys.println("sin2L = " + sin2L.toString());
		//Sys.println("Jset = " + Jset.toString());
		if (what > NOON) {
			return fromJulian(Jset);
		}

		var Jrise = Jnoon - (Jset - Jnoon);
		//Sys.println("Jnoon = " + Jnoon.toString());
		//Sys.println("Jrise = " + Jrise.toString());

		return fromJulian(Jrise);
	}
	
}