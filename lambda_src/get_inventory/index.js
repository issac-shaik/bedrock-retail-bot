const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const customerId = event.queryStringParameters?.customerId;

    if (!customerId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing customerId' }),
      };
    }

    // Step 1: Fetch customer's traits
    const customer = await dynamo.get({
      TableName: process.env.CUSTOMER_TABLE,
      Key: { customerId },
    }).promise();

    if (!customer.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Customer not found' }),
      };
    }

    const { os, storage, color, budget } = customer.Item;

    // Step 2: Query inventory based on traits (simple scan + filter for now)
    const inventoryResult = await dynamo.scan({
      TableName: process.env.INVENTORY_TABLE,
      FilterExpression: '#os = :os AND #storage = :storage AND #color = :color AND #budget = :budget',
      ExpressionAttributeNames: {
        '#os': 'os',
        '#storage': 'storage',
        '#color': 'color',
        '#budget': 'budget',
      },
      ExpressionAttributeValues: {
        ':os': os,
        ':storage': storage,
        ':color': color,
        ':budget': budget,
      }
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify(inventoryResult.Items || []),
    };
  } catch (err) {
    console.error('Error fetching inventory:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
