const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  const body = JSON.parse(event.body || '{}');
  const { customerId, os, storage, color, budget } = body;

  if (!customerId || !os || !storage || !color || !budget) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: 'Missing fields' }),
    };
  }

  const params = {
    TableName: process.env.CUSTOMER_TABLE,
    Key: { customerId },
    UpdateExpression: "set #os = :os, #storage = :storage, color = :color, budget = :budget",
    ExpressionAttributeNames: {
      "#os": "os",
      "#storage": "storage"
    },
    ExpressionAttributeValues: {
      ":os": os,
      ":storage": storage,
      ":color": color,
      ":budget": budget,
    },
    ReturnValues: "UPDATED_NEW"
  };
  

  try {
    await dynamo.update(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Traits updated successfully' }),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
