const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = process.env.PORT || 3000
require('dotenv').config();


mongoose.connect(process.env.MONGO_URI, {
 
}).then(() => {
  console.log('Connected to MongoDB');
}).catch((err) => {
  console.error('Error connecting to MongoDB', err);
});

app.use(express.json());

const userRoutes = require('./api/userRoutes');
const inspectionRoutes = require('./api/inspectionRoutes');

app.use('/', userRoutes);
app.use('/', inspectionRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
