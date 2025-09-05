const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({ status: "ok", ts: new Date().toISOString() });
});

app.listen(port, () => {
  console.log(`Server listening on ${port}`);
});
