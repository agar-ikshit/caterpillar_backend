const express = require('express');
const mongoose = require('mongoose');
const Inspection = require('../models/Inspection'); // Adjust the path if needed
const router = express.Router();
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');
require('dotenv').config(); // Ensure your .env variables are loaded

const { MongoClient } = require('mongodb');

const client = new MongoClient(process.env.MONGO_URI || "");
const dbName = "caterpillar_hackathon";
const collectionName = "caterpillar_backend";

function generateUniqueInspectionID() {
  return uuidv4();
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
    // Generate the report using OpenAI's API directly
    const dataString = JSON.stringify(inspectionData, null, 2);
    const TEMPLATE = `
You are a very enthusiastic servicing agent from Caterpillar. Given the following inspection data, provide a detailed report within 800 words. The report should highlight any issues found, suggest potential actions, and summarize the overall condition.

Inspection Data:
${dataString}

Report (within 800 words):
`;

    const apiKey = process.env.OPENAI_API_KEY;

    const response = await axios.post('https://api.openai.com/v1/chat/completions', {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: TEMPLATE }],
      max_tokens: 800
    }, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`
      }
    });

    const aiResponseText = response.data.choices[0].message.content;

    // Save the AI-generated report to MongoDB
    await client.connect();
    const collection = client.db(dbName).collection(collectionName);

    await collection.insertOne({
      inputData: inspectionData,
      report: aiResponseText,
      timestamp: new Date(),
    });

    console.log('Data and report saved to database');

    // Save the inspection data
    const result = await saveInspectionData(inspectionData);

    // Respond with the AI-generated report
    res.status(200).json({
      message: 'Inspection data received, saved successfully, and report generated',
      data: result.data,
      report: aiResponseText,
    });
  } catch (error) {
    console.error('Error handling the POST request:', error.message);
    res.status(500).json({
      message: 'Internal Server Error',
      error: error.message,
    });
  } finally {
    await client.close();
  }
});

module.exports = router;
