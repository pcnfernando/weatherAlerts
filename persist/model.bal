import ballerina/persist as _;
type UserConfiguration record {|
    readonly string location;
    readonly string weatherCondition;
    readonly string contactNumber;
    decimal lat;
    decimal lon;
|};
