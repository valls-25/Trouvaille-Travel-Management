const express = require('express');
const router = express.Router();
const db = require('../database');

// Save comment
router.post('/add', (req, res) => {
  const { text, userName, location, profileImage, rating } = req.body;

  const query = `
    INSERT INTO Comments (text, userName, location, profileImage, rating)
    VALUES (?, ?, ?, ?, ?)
  `;
  db.query(query, [text, userName, location, profileImage, rating], (err, result) => {
    if (err) {
      console.error('Error inserting comment:', err);
      return res.status(500).json({ success: false });
    }
    res.json({ success: true, id: result.insertId });
  });
});

// Get all comments
router.get('/all', (req, res) => {
  db.query('SELECT * FROM Comments ORDER BY createdAt DESC', (err, results) => {
    if (err) {
      console.error('Error fetching comments:', err);
      return res.status(500).json({ success: false });
    }
    res.json(results);
  });
});

module.exports = router;
