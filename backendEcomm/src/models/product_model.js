const { Schema, model } = require('mongoose');

const productSchema = new Schema({
    category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
    chargerId: { type: String, required: true },
    chargerType: { type: String, required: true }, 
    maxCurrent: { type: Number, required: true },
    price: { type: Number, required: true },
    images: { type: [String], default: [] },
    brand: { type: String, required: true },
    chargingSpeed: { type: String, required: true },
    compatibility: { type: [String], required: true }, 
    warranty: { type: String, required: true },
    connector: {
        type: {
            type: String, 
            enum: ["single", "dual"], 
            required: true
        },
        details: { type: String, default: "" } 
    },
    installationIncluded: { type: Boolean, required: true },
    stockAvailability: { type: Number, required: true },
    description: { type: String, default: "" },
    averageRating: { type: Number, default: 0 }, // Add average rating field
    updatedOn: { type: Date },
    createdOn: { type: Date }
});

// Middleware to handle timestamps
productSchema.pre('save', function (next) {
    this.updatedOn = new Date();
    this.createdOn = new Date();
    next();
});

productSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function (next) {
    const update = this.getUpdate();
    delete update._id;
    update.updatedOn = new Date();
    next();
});

const ProductModel = model('Product', productSchema);

module.exports = ProductModel;
