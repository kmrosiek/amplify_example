/* Amplify Params - DO NOT EDIT
    API_***_GRAPHQLAPIENDPOINTOUTPUT
    API_***_GRAPHQLAPIIDOUTPUT
    API_***_GRAPHQLAPIKEYOUTPUT
    ENV
    REGION
Amplify Params - DO NOT EDIT */

import { default as fetch, Request } from 'node-fetch';

const GRAPHQL_ENDPOINT = process.env.API_***_GRAPHQLAPIENDPOINTOUTPUT;
const GRAPHQL_API_KEY = process.env.API_***_GRAPHQLAPIKEYOUTPUT;

const query = /* GraphQL */ `
  mutation CREATE_TODO($input: CreateTodoInput!) {
    createTodo(input: $input) {
      id
      name
      createdAt
    }
  }
`;

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
export const handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);

    const variables = {
        input: {
            name: 'Hello, Todo!'
        }
    };

    /** @type {import('node-fetch').RequestInit} */
    const options = {
        method: 'POST',
        headers: {
            'x-api-key': GRAPHQL_API_KEY
        },
        body: JSON.stringify({ query, variables })
    };

    const request = new Request(GRAPHQL_ENDPOINT, options);

    let statusCode = 200;
    let body;
    let response;

    try {
        response = await fetch(request);
        body = await response.json();
        if (body.errors) statusCode = 400;
    } catch (error) {
        statusCode = 400;
        body = {
            errors: [
                {
                    status: response.status,
                    message: error.message,
                    stack: error.stack
                }
            ]
        };
    }

    return {
        statusCode,
        body: JSON.stringify(body)
    };
};
