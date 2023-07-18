import ballerina/test;

HttpTool[] tools = [
    {
        name: "httpGet",
        path: "/example-get/{pathParam}",
        method: GET,
        description: "test HTTP GET tool"
    },
    {
        name: "httpPostWithSimpleSchema",
        path: "/example-post",
        method: POST,
        description: "test HTTP POST tool with simple schema",
        requestBody: {
            properties: {
                attribute1: {'type: STRING},
                attribute2: {'type: INTEGER},
                attribute3: {'type: "array", items: {'type: STRING}}
            }
        }
    },
    {
        name: "httpDeleteWithComplexSchema",
        path: "/example-delete",
        method: DELETE,
        description: "test HTTP DELETE tool with complex schema",
        requestBody: {
            'type: "object",
            properties:
                {
                model: {'type: "string", default: "davinci"},
                prompt: {
                    oneOf: [
                        {'type: "string", default: "test"},
                        {'type: "array", items: {'type: "string"}},
                        {'type: "array", items: {'type: "integer"}},
                        {
                            'type: "array",
                            items: {
                                'type: "array",
                                items: {'type: "integer"}
                            }
                        }
                    ]
                },
                suffix: {'type: "string"}
            }
        }
    },
    {
        name: "testDefaultWithNull",
        path: "/example-delete",
        method: DELETE,
        description: "test HTTP DELETE tool with complex schema",
        requestBody: {
            'type: "object",
            properties:
                {
                model: {'type: "string"},
                prompt: {
                    oneOf: [
                        {'type: "string", default: ()},
                        {'type: "array", items: {'type: "string"}},
                        {'type: "array", items: {'type: "integer"}},
                        {
                            'type: "array",
                            items: {
                                'type: "array",
                                items: {'type: "integer", default: ()}
                            }
                        }
                    ]
                },
                suffix: {'type: "string"}
            }
        }
    }
];

isolated function getMock(HttpInput input) returns string|error {
    return "";
}

@test:Config {}
function testHttpToolKitInitialization() {
    string serviceURL = "http://test-wifi-url.com";
    HttpServiceToolKit|error httpToolKit = new (serviceURL, tools, {auth: {token: "<API-TOKEN>"}}, {"timeout": "10000"});
    if httpToolKit is error {
        test:assertFail("HttpToolKit is not initialized due to an error");
    }
    Tool[]|error tools = httpToolKit.getTools();
    if tools is error {
        test:assertFail("Error occurred while getting tools from HttpToolKit");
    }
    test:assertEquals(tools.length(), 4);

    test:assertEquals(tools[0].name, "httpGet");
    test:assertEquals(tools[0].description, "test HTTP GET tool");
    test:assertEquals(tools[0].parameters, {
        'type: "object",
        properties: {
            path: {
                'const: "/example-get/{pathParam}"
            },
            pathParameters: {'type: OBJECT, required: ["pathParam"], properties: {pathParam: {'type: STRING}}}
        }
    });

    test:assertEquals(tools[1].name, "httpPostWithSimpleSchema");
    test:assertEquals(tools[1].description, "test HTTP POST tool with simple schema");
    test:assertEquals(tools[1].parameters, {
        'type: "object",
        properties: {
            path: {
                'const: "/example-post"
            },
            requestBody: {
                'type: "object",
                properties: {
                    attribute1: {'type: "string"},
                    attribute2: {'type: "integer"},
                    attribute3: {'type: "array", items: {'type: "string"}}
                }
            }
        }
    });

    test:assertEquals(tools[2].name, "httpDeleteWithComplexSchema");
    test:assertEquals(tools[2].description, "test HTTP DELETE tool with complex schema");
    test:assertEquals(tools[2].parameters, {
        'type: "object",
        properties: {
            path: {
                'const: "/example-delete"
            },
            requestBody: {
                'type: "object",
                properties:
                {
                    model: {'type: "string", default: "davinci"},
                    prompt: {
                        oneOf: [
                            {'type: "string", default: "test"},
                            {'type: "array", items: {'type: "string"}},
                            {'type: "array", items: {'type: "integer"}},
                            {
                                'type: "array",
                                items: {
                                    'type: "array",
                                    items: {'type: "integer"}
                                }
                            }
                        ]
                    },
                    suffix: {'type: "string"}
                }
            }
        }
    });

    test:assertEquals(tools[3].name, "testDefaultWithNull");
    test:assertEquals(tools[3].description, "test HTTP DELETE tool with complex schema");
    test:assertEquals(tools[3].parameters, {
        'type: "object",
        properties: {
            path: {
                'const: "/example-delete"
            },
            requestBody: {
                'type: "object",
                properties:
                {
                    model: {'type: "string"},
                    prompt: {
                        oneOf: [
                            {'type: "string"},
                            {'type: "array", items: {'type: "string"}},
                            {'type: "array", items: {'type: "integer"}},
                            {
                                'type: "array",
                                items: {
                                    'type: "array",
                                    items: {'type: "integer"}
                                }
                            }
                        ]
                    },
                    suffix: {'type: "string"}
                }
            }
        }
    });

}
