const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");
const client = new DynamoDBClient();
const TABLE_NAME = process.env.DYNAMODB_TABLE;

exports.handler = async (event) => {
  console.log("Received Kinesis event:", JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    const payload = Buffer.from(record.kinesis.data, "base64").toString("utf8");
    console.log("Decoded payload:", payload);

    try {
      const item = JSON.parse(payload);

      const command = new PutItemCommand({
        TableName: TABLE_NAME,
        Item: {
          userId: { S: item.userId.toString() },
          action: { S: item.action },
          timestamp: { S: item.timestamp },
        },
      });

      await client.send(command);
      console.log(`Stored record for userId=${item.userId}`);
    } catch (err) {
      console.error("Error processing record:", err);
    }
  }

  return { statusCode: 200 };
};
