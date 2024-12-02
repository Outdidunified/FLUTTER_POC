// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors"); // Import the cors package

// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
// const adminRouter = require("./routes/admin");
// const productRouter = require("./routes/product");
// const userRouter = require("./routes/user");

// INIT
const PORT = process.env.PORT || 3000;
const app = express();
const DB = "mongodb://localhost:27017/ecomdata";

// Middleware
app.use(cors()); // Enable CORS for all origins
app.use(express.json());
app.use(authRouter);
// app.use(adminRouter);
// app.use(productRouter);
// app.use(userRouter);

// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, () => {
  console.log(`connected at port ${PORT}`);
});
