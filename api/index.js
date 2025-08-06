const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const path = require('path');

const app = express();

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Database configuration
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Initialize database tables
const initDB = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS registered_faces (
        id SERIAL PRIMARY KEY,
        label VARCHAR(255) NOT NULL UNIQUE,
        descriptors JSONB NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS attendance_log (
        id SERIAL PRIMARY KEY,
        person_name VARCHAR(255) NOT NULL,
        date DATE NOT NULL,
        time TIME NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(person_name, date)
      )
    `);

    console.log('Database tables initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
  }
};

// Initialize database on startup
initDB();

// API Routes

// Get all registered faces
app.get('/api/faces', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM registered_faces ORDER BY created_at DESC');
    
    // Transform data back to face-api.js format
    const faces = result.rows.map(row => ({
      label: row.label,
      descriptors: row.descriptors,
      _label: row.label,
      _distance: 0
    }));
    
    res.json(faces);
  } catch (error) {
    console.error('Error fetching faces:', error);
    res.status(500).json({ error: 'Failed to fetch faces' });
  }
});

// Register a new face
app.post('/api/faces', async (req, res) => {
  try {
    const { label, descriptors } = req.body;
    
    if (!label || !descriptors) {
      return res.status(400).json({ error: 'Label and descriptors are required' });
    }

    // Check if face with this label already exists
    const existingFace = await pool.query('SELECT id FROM registered_faces WHERE label = $1', [label]);
    if (existingFace.rows.length > 0) {
      return res.status(409).json({ error: 'Face with this label already exists' });
    }

    const result = await pool.query(
      'INSERT INTO registered_faces (label, descriptors) VALUES ($1, $2) RETURNING *',
      [label, JSON.stringify(descriptors)]
    );

    res.status(201).json({
      message: 'Face registered successfully',
      face: result.rows[0]
    });
  } catch (error) {
    console.error('Error registering face:', error);
    res.status(500).json({ error: 'Failed to register face' });
  }
});

// Delete a registered face
app.delete('/api/faces/:label', async (req, res) => {
  try {
    const { label } = req.params;
    
    const result = await pool.query('DELETE FROM registered_faces WHERE label = $1 RETURNING *', [label]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Face not found' });
    }

    res.json({ message: 'Face deleted successfully' });
  } catch (error) {
    console.error('Error deleting face:', error);
    res.status(500).json({ error: 'Failed to delete face' });
  }
});

// Clear all registered faces
app.delete('/api/faces', async (req, res) => {
  try {
    await pool.query('DELETE FROM registered_faces');
    res.json({ message: 'All faces cleared successfully' });
  } catch (error) {
    console.error('Error clearing faces:', error);
    res.status(500).json({ error: 'Failed to clear faces' });
  }
});

// Get attendance log
app.get('/api/attendance', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT * FROM attendance_log 
      ORDER BY date DESC, time DESC
      LIMIT 100
    `);
    
    // Transform data to match frontend format
    const attendance = result.rows.map(row => ({
      id: row.id,
      personName: row.person_name,
      date: row.date.toDateString(),
      time: row.time,
      timestamp: row.timestamp
    }));
    
    res.json(attendance);
  } catch (error) {
    console.error('Error fetching attendance:', error);
    res.status(500).json({ error: 'Failed to fetch attendance' });
  }
});

// Mark attendance
app.post('/api/attendance', async (req, res) => {
  try {
    const { personName, date, time } = req.body;
    
    if (!personName || !date || !time) {
      return res.status(400).json({ error: 'Person name, date, and time are required' });
    }

    // Check if attendance already exists for this person today
    const existingAttendance = await pool.query(
      'SELECT id FROM attendance_log WHERE person_name = $1 AND date = $2',
      [personName, date]
    );

    if (existingAttendance.rows.length > 0) {
      return res.status(409).json({ error: 'Attendance already marked for today' });
    }

    const result = await pool.query(
      'INSERT INTO attendance_log (person_name, date, time) VALUES ($1, $2, $3) RETURNING *',
      [personName, date, time]
    );

    res.status(201).json({
      message: 'Attendance marked successfully',
      attendance: {
        id: result.rows[0].id,
        personName: result.rows[0].person_name,
        date: result.rows[0].date.toDateString(),
        time: result.rows[0].time,
        timestamp: result.rows[0].timestamp
      }
    });
  } catch (error) {
    console.error('Error marking attendance:', error);
    res.status(500).json({ error: 'Failed to mark attendance' });
  }
});

// Clear attendance log
app.delete('/api/attendance', async (req, res) => {
  try {
    await pool.query('DELETE FROM attendance_log');
    res.json({ message: 'Attendance log cleared successfully' });
  } catch (error) {
    console.error('Error clearing attendance:', error);
    res.status(500).json({ error: 'Failed to clear attendance' });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Face Recognition API is running' });
});

// Serve static files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '../build')));
  
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../build/index.html'));
  });
}

const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;