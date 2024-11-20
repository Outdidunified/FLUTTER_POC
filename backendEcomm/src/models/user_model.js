const { Schema, model } = require('mongoose');
const uuid = require('uuid');
const bcrypt = require('bcrypt');

// Define the user schema
const userSchema = new Schema({
    id: { type: String, unique: true },
    fullName: { type: String, default: "" },
    email: { type: String, unique: true, required: true },
    password: { type: String, required: true },
    phoneNumber: { type: String, default: "" },
    address: { type: String, default: "" },
    city: { type: String, default: "" },
    state: { type: String, default: "" },
    profileProgress: { type: Number, default: 0 },
    profileImage: { type: String, default: "" },
    updatedOn: { type: Date },
    createdOn: { type: Date }
});

// Pre-save hook to generate UUID and hash the password
userSchema.pre('save', function(next) {
    this.id = uuid.v1();
    this.updatedOn = new Date();
    this.createdOn = new Date();

    const salt = bcrypt.genSaltSync(10);
    this.password = bcrypt.hashSync(this.password, salt);

    next();
});

// Pre-update hook to update the `updatedOn` field
userSchema.pre(['update', 'findOneAndUpdate', 'updateOne'], function(next) {
    const update = this.getUpdate();
    delete update._id;
    delete update.id;

    this.updatedOn = new Date();

    next();
});

// Create the model
const UserModel = model('User', userSchema);

module.exports = UserModel;
