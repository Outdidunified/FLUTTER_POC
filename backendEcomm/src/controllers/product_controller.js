const ProductModel = require('../models/product_model');

const ProductController = {

    // Create a new product
    createProduct: async function(req, res) {
        try {
            const productData = req.body;
            const newProduct = new ProductModel(productData);
            await newProduct.save();

            return res.json({ success: true, data: newProduct, message: "Product created!" });
        }
        catch(ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Fetch all products
    fetchAllProducts: async function(req, res) {
        try {
            const products = await ProductModel.find();
            return res.json({ success: true, data: products });
        }
        catch(ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Fetch products by category
    fetchProductByCategory: async function(req, res) {
        try {
            const categoryId = req.params.id;
            const products = await ProductModel.find({ category: categoryId });
            return res.json({ success: true, data: products });
        }
        catch(ex) {
            return res.json({ success: false, message: ex });
        }
    },

    // Fetch products by charger type
    fetchProductByChargerType: async function(req, res) {
        try {
            const chargerType = req.params.type.toUpperCase();

            if (!['AC', 'DC'].includes(chargerType)) {
                return res.json({ success: false, message: "Invalid chargerType. Use 'AC' or 'DC'." });
            }

            const products = await ProductModel.find({ chargerType: chargerType });

            if (!products || products.length === 0) {
                return res.json({ success: false, message: "No products found for this charger type." });
            }

            return res.json({ success: true, data: products });
        }
        catch(ex) {
            return res.json({ success: false, message: ex.message });
        }
    },

    // Fetch products by connector type
    fetchProductByConnectorType: async function(req, res) {
        try {
            const connectorType = req.params.type.toLowerCase();  
            console.log('Received connector type:', connectorType); 
            if (!['single', 'dual'].includes(connectorType)) {
                return res.json({ success: false, message: "Invalid connector type. Use 'single' or 'dual'." });
            }
    
            const products = await ProductModel.find({ 'connector.type': connectorType });
    
            if (!products || products.length === 0) {
                return res.json({ success: false, message: "No products found for this connector type." });
            }
    
            return res.json({ success: true, data: products });
        }
        catch(ex) {
            return res.json({ success: false, message: ex.message });
        }
    },

    // Fetch products by connector and charger type
    fetchProductByConnectorAndChargerType: async function(req, res) {
        try {
            const connectorType = req.params.connectorType.toLowerCase(); 
            const chargerType = req.params.chargerType.toUpperCase();  
            
            console.log('Received connector type:', connectorType);
            console.log('Received charger type:', chargerType);
    
            if (!['single', 'dual'].includes(connectorType)) {
                return res.json({ success: false, message: "Invalid connector type. Use 'single' or 'dual'." });
            }
    
            if (!['AC', 'DC'].includes(chargerType)) {
                return res.json({ success: false, message: "Invalid charger type. Use 'AC' or 'DC'." });
            }
    
            const products = await ProductModel.find({ 
                'connector.type': connectorType,
                chargerType: chargerType
            });
    
            console.log('Products found:', products);
    
            if (!products || products.length === 0) {
                return res.json({ success: false, message: "No products found for the given criteria." });
            }
    
            return res.json({ success: true, data: products });
        }
        catch(ex) {
            return res.json({ success: false, message: ex.message });
        }
    },

    // Fetch products by minimum rating
    fetchProductByMinRating: async function(req, res) {
        try {
            const minRating = parseFloat(req.params.rating);  // Get rating from the URL parameter

            // Validate the rating value
            if (isNaN(minRating)) {
                return res.json({ success: false, message: "Invalid rating value." });
            }

            // Find products with ratings greater than or equal to the minRating
            const products = await ProductModel.find({
                averageRating: { $gte: minRating }
            });

            // Check if any products were found
            if (!products || products.length === 0) {
                return res.json({ success: false, message: "No products found with the specified rating." });
            }

            return res.json({ success: true, data: products });
        }
        catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    }

};

module.exports = ProductController;
