const express = require('express');
const ProductController = require('../controllers/product_controller');
const ProductRoutes = express.Router();

ProductRoutes.get("/", ProductController.fetchAllProducts);
ProductRoutes.get("/category/:id", ProductController.fetchProductByCategory);
ProductRoutes.get("/chargerType/:type", ProductController.fetchProductByChargerType);
ProductRoutes.get("/connectorType/:type", ProductController.fetchProductByConnectorType);
ProductRoutes.get("/connectorAndCharger/:connectorType/:chargerType", ProductController.fetchProductByConnectorAndChargerType);

ProductRoutes.post("/", ProductController.createProduct);
// In routes file, e.g., productRoutes.js

// In your routes file (product_routes.js)
ProductRoutes.get('/filter-by-rating/:rating', ProductController.fetchProductByMinRating);



module.exports = ProductRoutes;
