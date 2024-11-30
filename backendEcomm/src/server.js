const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
const cors = require('cors');
const multer = require('multer'); // For handling file uploads

const app = express();

app.use(cors());

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/ecommerce_db', {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => console.log("MongoDB Connected"))
  .catch(err => console.log("MongoDB Connection Error: ", err));

app.use(express.json()); 
app.use(express.urlencoded({ extended: true }));

// Serve uploaded files from 'uploads' folder
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// User routes
const UserRoutes = require('./routes/user_routes');
app.use("/api/user", UserRoutes);

// Product routes
const ProductRoutes = require('./routes/product_routes');
app.use("/api/product", ProductRoutes);

// Cart routes
const CartRoutes = require('./routes/cart_routes');
app.use("/api/cart", CartRoutes);

// Order routes
const OrderRoutes = require('./routes/order_routes');
app.use("/api/order", OrderRoutes);

// Category routes
const CategoryRoutes = require('./routes/category_routes');
app.use("/api/category", CategoryRoutes);

// Review routes - Add this section
const ReviewRoutes = require('./routes/review_routes');
app.use("/api/review", ReviewRoutes); // Assuming the review routes are in 'review_routes.js'

// Server setup
const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
