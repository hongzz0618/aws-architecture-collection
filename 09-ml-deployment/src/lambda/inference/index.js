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

    // Prepare payload for SageMaker
    const payload = JSON.stringify(data);

    const command = new InvokeEndpointCommand({
      EndpointName: endpointName,
      ContentType: "application/json",
      Body: payload,
    });

    const response = await sagemakerClient.send(command);

    const predictions = JSON.parse(Buffer.from(response.Body).toString("utf8"));

    return {
      statusCode: 200,
      headers: getCorsHeaders(),
      body: JSON.stringify({
        predictions,
        timestamp: new Date().toISOString(),
        model: endpointName,
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
        ...(process.env.ENVIRONMENT === "dev" && { stack: error.stack }),
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
