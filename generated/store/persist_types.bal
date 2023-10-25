// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type UserConfiguration record {|
    readonly string location;
    readonly string weatherCondition;
    readonly string contactNumber;
    decimal lat;
    decimal lon;
|};

public type UserConfigurationOptionalized record {|
    string location?;
    string weatherCondition?;
    string contactNumber?;
    decimal lat?;
    decimal lon?;
|};

public type UserConfigurationTargetType typedesc<UserConfigurationOptionalized>;

public type UserConfigurationInsert UserConfiguration;

public type UserConfigurationUpdate record {|
    decimal lat?;
    decimal lon?;
|};

