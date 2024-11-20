const ProductModel = require('./../models/product_model');

const ProductController = {
    // Method to create a new product
    createProduct: async function(req, res) {
        try {
            const productData = req.body;
            
            // Check if a product with the same chargerId already exists
            const existingProduct = await ProductModel.findOne({ chargerId: productData.chargerId });

            if (existingProduct) {
                // If the product exists, return a response indicating that
                return res.json({ success: false, message: "Product with this chargerId already exists." });
            }

            // If product does not exist, create a new one
            const newProduct = new ProductModel(productData);
            await newProduct.save();

            return res.json({ success: true, data: newProduct, message: "Product created!" });
        }
        catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },

    // Method to fetch all products
    fetchAllProducts: async function(req, res) {
        try {
            const products = await ProductModel.find();
            return res.json({ success: true, data: products });
        }
        catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    }
};

module.exports = ProductController;
