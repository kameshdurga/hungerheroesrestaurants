const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "HungerHeroesCopy": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://6735ufue2zekhke5yqvi32zmue.appsync-api.us-east-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-e4bzjze5urhwxe5dpjxm2x4wtq"
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
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://6735ufue2zekhke5yqvi32zmue.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-e4bzjze5urhwxe5dpjxm2x4wtq",
                        "ClientDatabasePrefix": "HungerHeroesCopy_API_KEY"
                    },
                    "HungerHeroesCopy_AWS_IAM": {
                        "ApiUrl": "https://6735ufue2zekhke5yqvi32zmue.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "HungerHeroesCopy_AWS_IAM"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-2:cd10889b-0ad9-45f4-bb85-12c888a9a04d",
                            "Region": "us-east-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_Yxr4bc1os",
                        "AppClientId": "771pbc1n0gnkutoh6jqsc6c7op",
                        "Region": "us-east-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "hungerheroescopy8af78c17230a404fb45b775a463cc24115856-dev",
                        "Region": "us-east-2"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "hungerheroescopy8af78c17230a404fb45b775a463cc24115856-dev",
                "region": "us-east-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';