// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/file;

string sslDb = "SSL_CONNECT_DB";
string trustStorePath = checkpanic file:getAbsolutePath("./tests/resources/keystore/client/client-truststore.p12");

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLConnection() returns error? {
    Options options = {
        secureSocket: {
            encrypt: true,
            hostNameInCertificate: "ballerina-mysql-test-server",
            cert: {
                path: trustStorePath,
                password: "password"
            }
        }
    };
    Client dbClient = check new(user = user, password = password, database = sslDb, port = port, options = options);
    test:assertEquals(dbClient.close(), ());
}

@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLConnectionWithNoHostName() {
    Options options = {
        secureSocket: {
            encrypt: true,
            cert: {
                path: trustStorePath,
                password: "password"
            }
        }
    };
    Client|error? dbClient = new(user = user, password = password, database = sslDb, port = port, options = options);
    test:assertTrue(dbClient is error, "Connection should not have been established.");
}


@test:Config {
    groups: ["connection", "ssl"]
}
function testSSLWithSelfSignedCertificate() returns error? {
    Options options = {
        secureSocket: {
            encrypt: true,
            trustServerCertificate: true
        }
    };
    Client dbClient = check new(user = user, password = password, database = sslDb, port = port, options = options);
    test:assertEquals(dbClient.close(), ());
}
