const {
  DynamoDBClient,
  PutItemCommand,
  ScanCommand,
} = require("@aws-sdk/client-dynamodb");
const client = new DynamoDBClient();

exports.handler = async (event) => {
  let response;

  try {
    if (event.httpMethod === "GET") {
      // List all items
      const data = await client.send(
        new ScanCommand({ TableName: process.env.TABLE_NAME })
      );
      response = {
        statusCode: 200,
        body: JSON.stringify(data.Items),
      };
    } else if (event.httpMethod === "POST") {
      // Create a new item
      const body = JSON.parse(event.body);
      await client.send(
        new PutItemCommand({
          TableName: process.env.TABLE_NAME,
          Item: {
            id: { S: Date.now().toString() },
            name: { S: body.name || "Unknown" },
          },
        })
      );
      response = {
        statusCode: 201,
        body: JSON.stringify({ message: "Item created" }),
      };
    } else {
      response = {
        statusCode: 405,
        body: JSON.stringify({ error: "Method not allowed" }),
      };
    }
  } catch (err) {
    console.error(err);
    response = {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal Server Error" }),
    };
  }

  return {
    ...response,
    headers: { "Content-Type": "application/json" },
  };
};
