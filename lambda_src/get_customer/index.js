const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  console.log("Incoming event:", JSON.stringify(event, null, 2));
  const customerId = event.queryStringParameters?.customerId;

  const tableName = process.env.CUSTOMER_TABLE;
  console.log("Using table:", tableName); // ✅ NEW LOG

  if (!customerId) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: "Missing customerId" }),
    };
  }

  const params = {
    TableName: tableName,
    Key: { customerId },
  };

  try {
    const result = await dynamo.get(params).promise();
    console.log("DynamoDB result:", JSON.stringify(result, null, 2)); // ✅ NEW LOG
    return {
      statusCode: 200,
      body: JSON.stringify(result.Item || {}),
    };
  } catch (err) {
    console.error("Error:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
