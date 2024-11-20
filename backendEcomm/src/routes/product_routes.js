const ProductRoutes = require('express').Router();
const ProductController = require('./../controllers/product_controller');

// Route to fetch all products
ProductRoutes.get("/", ProductController.fetchAllProducts);

// Route to create a new product
ProductRoutes.post("/add", ProductController.createProduct);

module.exports = ProductRoutes;
