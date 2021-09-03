const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "api": {
  "plugins": {
    "awsAPIPlugin": {
    "enclosure": {
      "endpointType": "REST",
"endpoint": "<YOUR_ENDPOINT>",
                    "region": "<YOUR_REGION>",
                    "authorizationType": "NONE"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "<YOUR_POOL_ID>",
                            "Region": "<YOUR_REGION>"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "<YOUR_POOL_ID>",
                        "AppClientId": "<YOUR_APP_CLIENT_ID>",
                        "Region": "<YOUR_REGION>"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                }
            }
        }
    }
}''';
