const express = require('express');
const Inspection = require('../models/Inspection');
const router = express.Router();

router.post('/', async (req, res) => {
  try {
    const inspectionData = req.body;
    console.log('Received inspection data:', inspectionData);

    const newInspection = new Inspection(inspectionData);
    await newInspection.save();

    res.status(200).json({ message: 'Inspection data received and saved successfully', data: inspectionData });
  } catch (err) {
    console.error('Error saving inspection data:', err);
    res.status(500).json({ message: 'Error saving inspection data', error: err });
  }
});

module.exports = router;
