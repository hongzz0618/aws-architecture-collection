const {
  SageMakerRuntimeClient,
  InvokeEndpointCommand,
} = require("@aws-sdk/client-sagemaker-runtime");

const sagemakerClient = new SageMakerRuntimeClient({
  region: process.env.AWS_REGION || "us-east-1",
});

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  try {
    // Handle preflight requests
    if (event.httpMethod === "OPTIONS") {
      return {
        statusCode: 200,
        headers: getCorsHeaders(),
        body: JSON.stringify({ message: "CORS preflight successful" }),
      };
    }

    const endpointName = process.env.SAGEMAKER_ENDPOINT_NAME;

    if (!endpointName) {
      throw new Error("SageMaker endpoint name not configured");
    }

    let body;
    try {
      body = JSON.parse(event.body || "{}");
    } catch (parseError) {
      return {
        statusCode: 400,
        headers: getCorsHeaders(),
        body: JSON.stringify({
          error: "Invalid JSON format in request body",
          message: parseError.message,
        }),
      };
    }

    const { data } = body;

    if (!data || !Array.isArray(data)) {
      return {
        statusCode: 400,
        headers: getCorsHeaders(),
        body: JSON.stringify({
          error: 'Invalid request format. Expected { "data": [[...], ...] }',
        }),
      };
    }

    // XGBoost expects CSV format or specific JSON format
    // Convert array data to CSV-like format
    const payload = data.map((row) => row.join(",")).join("\n");

    const command = new InvokeEndpointCommand({
      EndpointName: endpointName,
      ContentType: "text/csv", // XGBoost expects CSV format
      Body: payload,
    });

    const response = await sagemakerClient.send(command);

    // XGBoost returns predictions as text
    const predictions = Buffer.from(response.Body)
      .toString("utf8")
      .trim()
      .split("\n")
      .map(parseFloat);

    return {
      statusCode: 200,
      headers: getCorsHeaders(),
      body: JSON.stringify({
        predictions,
        timestamp: new Date().toISOString(),
        model: "xgboost",
        endpoint: endpointName,
      }),
    };
  } catch (error) {
    console.error("Error:", error);

    return {
      statusCode: 500,
      headers: getCorsHeaders(),
      body: JSON.stringify({
        error: "Internal server error",
        message: error.message,
      }),
    };
  }
};

function getCorsHeaders() {
  return {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };
}
