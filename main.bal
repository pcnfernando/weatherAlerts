import weatherAlerts.store;

import ballerina/http;
import ballerina/log;
import ballerina/task;
import ballerinax/twilio;

const string WEATHER_API = "https://api.openweathermap.org";

final http:Client weatherEP = check new (WEATHER_API);

final store:Client storeEP = check new ();

configurable string API_KEY = ?;
configurable string TWILIO_ACC_SId = ?;
configurable string TWILIO_AUTH_TOKEN = ?;
configurable string FROM_NUMBER = ?;

service /weather on new http:Listener(9090) {
    isolated resource function post configure(Config payload) returns http:Created|http:InternalServerError {
        do {
            var [lon, lat] = check getGeoLocation(payload.location);
            store:UserConfiguration userConfig = {
                location: payload.location,
                weatherCondition: payload.weatherCondition,
                contactNumber: payload.contactNumber,
                lon,
                lat
            };
            [string, string, string][] unionResult = check storeEP->/userconfigurations.post([userConfig]);
            log:printInfo(string `User configuration added successfully for ${unionResult[0].toString()}`);
        } on fail var e {
            log:printError("Error encounterd configuring user preferences", e);
            return http:INTERNAL_SERVER_ERROR;
        }
        return http:CREATED;
    }

    isolated resource function get triggerJob() returns http:InternalServerError|http:Ok {
        do {
	        _ = check task:scheduleJobRecurByFrequency(new Job(), 3600);
        } on fail var e {
        	log:printError("Error encounterd while triggering the task", e);
        }
        return http:OK;
    }
}

// function init() returns error? {
//     // Run the task every hour
//     _ = check task:scheduleJobRecurByFrequency(new Job(), 3600);
// }

class Job {
    *task:Job;

    public function execute() {
        stream<store:UserConfiguration, error?> streamResult = storeEP->/userconfigurations;
        do {
            check from store:UserConfigurationInsert config in streamResult
                let WeatherAPIResponse response = check weatherEP->/data/'2\.5/onecall(lat = config.lat,
                    lon = config.lon, exclude = "current, minutely, daily", appid = API_KEY
                )
                where matchesConfiguredCondition(config.weatherCondition, response)
                do {
                    log:printInfo("Sending alert to " + config.contactNumber);
                    error? sendSmsAlertResult = sendSmsAlert(config.contactNumber, config.location, config.weatherCondition);
                    if sendSmsAlertResult is error {
                        log:printError("Error encounterd while sending the alert to " + config.contactNumber, sendSmsAlertResult);
                    }
                };
        } on fail var e {
            log:printError("Error encounterd while executing the scheuled task", e);
        }
    }
}

twilio:ConnectionConfig smsConfig = {twilioAuth: {accountSId: TWILIO_ACC_SId, authToken: TWILIO_AUTH_TOKEN}};

twilio:Client twilioEP = check new (smsConfig);

function sendSmsAlert(string contact, string location, string condition) returns error? {
    string msg = string `Weather alert: ${condition} likely at ${location} within the hour`;
    _ = check twilioEP->sendSms(FROM_NUMBER, contact, msg);
}

function matchesConfiguredCondition(string condition, WeatherAPIResponse response) returns boolean {
    log:printInfo("Checking weather condition for " + condition + "for " + response.toString());
    HourlyItem hourly = response.hourly[0];
    return hourly.pop > 0.5d && getWeatherConditionFromId(hourly.weather[0].id) == condition;
}

function getWeatherConditionFromId(int conditionId) returns string {
    match conditionId / 100 {
        5 => {
            return "Rain";
        }
        6 => {
            return "Snow";
        }
        _ => {
            return "Other";
        }
    }
}

isolated function getGeoLocation(string location) returns [decimal, decimal]|error {
    GeoLocationItem[] response = check weatherEP->/geo/'1\.0/direct(q = location, appid = API_KEY);
    if response.length() == 0 {
        return error("No geo location found for the given location name");
    }
    GeoLocationItem geoLocation = response[0];
    return [geoLocation.lon, geoLocation.lat];
}

type Config record {|
    string location;
    string weatherCondition;
    string contactNumber;
|};

type GeoLocationItem record {
    string name;
    decimal lat;
    decimal lon;
};

type WeatherItem record {
    int id;
};

type HourlyItem record {
    int dt;
    WeatherItem[] weather;
    decimal pop;
};

type WeatherAPIResponse record {
    HourlyItem[] hourly;
};
