// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.
import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/persist.sql as psql;

const USER_CONFIGURATION = "userconfigurations";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final mysql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [USER_CONFIGURATION] : {
            entityName: "UserConfiguration",
            tableName: "UserConfiguration",
            fieldMetadata: {
                location: {columnName: "location"},
                weatherCondition: {columnName: "weatherCondition"},
                contactNumber: {columnName: "contactNumber"},
                lat: {columnName: "lat"},
                lon: {columnName: "lon"}
            },
            keyFields: ["location", "weatherCondition", "contactNumber"]
        }
    };

    public isolated function init() returns persist:Error? {
        mysql:Client|error dbClient = new (host = host, user = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {[USER_CONFIGURATION] : check new (dbClient, self.metadata.get(USER_CONFIGURATION), psql:MYSQL_SPECIFICS)};
    }

    isolated resource function get userconfigurations(UserConfigurationTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get userconfigurations/[string location]/[string weatherCondition]/[string contactNumber](UserConfigurationTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post userconfigurations(UserConfigurationInsert[] data) returns [string, string, string][]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER_CONFIGURATION);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from UserConfigurationInsert inserted in data
            select [inserted.location, inserted.weatherCondition, inserted.contactNumber];
    }

    isolated resource function put userconfigurations/[string location]/[string weatherCondition]/[string contactNumber](UserConfigurationUpdate value) returns UserConfiguration|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER_CONFIGURATION);
        }
        _ = check sqlClient.runUpdateQuery({"location": location, "weatherCondition": weatherCondition, "contactNumber": contactNumber}, value);
        return self->/userconfigurations/[location]/[weatherCondition]/[contactNumber].get();
    }

    isolated resource function delete userconfigurations/[string location]/[string weatherCondition]/[string contactNumber]() returns UserConfiguration|persist:Error {
        UserConfiguration result = check self->/userconfigurations/[location]/[weatherCondition]/[contactNumber].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(USER_CONFIGURATION);
        }
        _ = check sqlClient.runDeleteQuery({"location": location, "weatherCondition": weatherCondition, "contactNumber": contactNumber});
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}

