const mongoose = require('mongoose');
const Inspection = require('../models/Inspection'); // Adjust the path if needed

// Create the serverless function handler
export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      const inspectionData = req.body;
      console.log('Received inspection data:', inspectionData);

      // Connect to MongoDB if not already connected
      if (mongoose.connection.readyState !== 1) {
        await mongoose.connect(process.env.MONGO_URI, {});
      }

      const newInspection = new Inspection(inspectionData);
      await newInspection.save();

      res.status(200).json({ message: 'Inspection data received and saved successfully', data: inspectionData });
    } catch (err) {
      console.error('Error saving inspection data:', err.message);
      res.status(500).json({ message: 'Error saving inspection data', error: err.message });
    }
  } else {
    // Handle any non-POST requests
    res.setHeader('Allow', ['POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}
