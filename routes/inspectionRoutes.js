const express = require('express');
const mongoose = require('mongoose');
const Inspection = require('../models/Inspection'); // Adjust the path if needed
const router = express.Router();
const { v4: uuidv4 } = require('uuid'); // For generating unique IDs

// Function to generate a unique inspectionID
function generateUniqueInspectionID() {
  return uuidv4(); // Use your preferred method for generating unique IDs
}

// Function to save inspection data with error handling
async function saveInspectionData(data, retryCount = 0) {
  const maxRetries = 5; // Set a maximum number of retries
  try {
    const newInspection = new Inspection(data);
    await newInspection.save();
    return { success: true, data: newInspection };
  } catch (err) {
    if (err.code === 11000 && retryCount < maxRetries) {
      // Duplicate key error, generate a new ID and retry
      console.log('Duplicate key error, generating a new ID.');
      
      data.inspectionID = generateUniqueInspectionID();
      return await saveInspectionData(data, retryCount + 1); // Retry with new ID
    } else {
      // Other errors or retry limit exceeded
      throw err; // Rethrow for further handling
    }
  }
}

router.post('/', async (req, res) => {
  let inspectionData = req.body.data;
  console.log('Received inspection data:', inspectionData);

  try {
    const result = await saveInspectionData(inspectionData);
    res.status(200).json({
      message: 'Inspection data received and saved successfully',
      data: result.data,
    });
  } catch (err) {
    console.error('Error saving inspection data:', err.message);
    res.status(500).json({
      message: 'Error saving inspection data',
      error: err.message,
    });
  }
});

module.exports = router;
