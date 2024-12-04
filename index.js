const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Créer l'application Express
const app = express();

// Utiliser CORS pour permettre les requêtes de Flutter
app.use(cors());

// Configurer Express pour accepter les données au format JSON
app.use(express.json());

// Configuration de la connexion à la base de données MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',    // Ton utilisateur MySQL
  password: '',    // Ton mot de passe MySQL
  database: 'imen',  // Le nom de ta base de données
});
const secretKey = process.env.SECRET_KEY; 
// Vérifier la connexion à la base de données
db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    process.exit(1);  // Quitter si la connexion échoue
  }
  console.log('Connexion réussie à la base de données MySQL');
});

// ===== Route pour l'enregistrement (Register) =====
app.post('/register', (req, res) => {
    const { email, password } = req.body;
  
    // Validate input
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required.' });
    }
  
    // Check if the email is already in use
    const emailQuery = 'SELECT * FROM users WHERE email = ?';
    db.query(emailQuery, [email], (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (result.length > 0) {
        return res.status(409).json({ error: 'Email is already registered.' });
      }
  
      // Hash the password
      const hashedPassword = bcrypt.hashSync(password, 10);
  
      // Insert new user into the database
      const query = 'INSERT INTO users (email, password) VALUES (?, ?)';
      db.query(query, [email, hashedPassword], (err, result) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }
  
        // Send success response
        res.status(201).json({ message: 'User successfully registered!' });
      });
    });
  });
  
  // ===== Route pour la connexion (Login) =====
  app.post('/login', (req, res) => {
    const { email, password } = req.body;
  
    const query = `SELECT * FROM users WHERE email = ?`;
    
    db.query(query, [email], (err, result) => {
      if (err || result.length === 0) {
        return res.status(400).json({ error: 'Utilisateur non trouvé ' });
      }
  
      const user = result[0];
  
      // Compare the provided password with the hashed password in the database
      bcrypt.compare(password, user.password, (err, isMatch) => {
        if (err) {
          return res.status(500).json({ error: 'Erreur lors de la vérification du mot de passe' });
        }
  
        if (!isMatch) {
          return res.status(400).json({ error: 'Mot de passe incorrect' });
        }
  
        // If the password matches, return a success message (excluding sensitive data)
        return res.status(200).json({
          message: `Bienvenue, ${user.email}!`,
          user: {
            email: user.email,
            // You can return other safe information if needed, but **never** return the password
          },
        });
      });
    });
  });
  
  // ===== Route pour la déconnexion (Logout) =====
  // La déconnexion se fait du côté client, donc ici on renvoie simplement un message
  app.post('/logout', (req, res) => {
    // Rien à faire du côté serveur, car le token est géré du côté client
    res.json({ message: 'Déconnexion réussie' });
  });
// ===== Routes pour les rooms =====
// Route pour obtenir toutes les rooms
app.get('/rooms', (req, res) => {
  db.query('SELECT * FROM rooms', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Route pour ajouter une nouvelle room
app.post('/rooms', (req, res) => {
  const { room_id, room_name, capacity, building, floor } = req.body;
  const query = `
    INSERT INTO rooms (room_id, room_name, capacity, building, floor)
    VALUES (?, ?, ?, ?, ?)
  `;
  db.query(query, [room_id, room_name, capacity, building, floor], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Room added successfully!', roomId: result.insertId });
  });
});

// Route pour mettre à jour une room existante
app.put('/rooms/:room_id', (req, res) => {
  const { room_id } = req.params;
  const { room_name, capacity, building, floor } = req.body;
  const query = `
    UPDATE rooms
    SET room_name = ?, capacity = ?, building = ?, floor = ?
    WHERE room_id = ?
  `;
  db.query(query, [room_name, capacity, building, floor, room_id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Room not found' });
    }
    res.json({ message: 'Room updated successfully' });
  });
});

// Route pour supprimer une room
app.delete('/rooms/:room_id', (req, res) => {
  const { room_id } = req.params;
  const query = 'DELETE FROM rooms WHERE room_id = ?';
  db.query(query, [room_id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Room not found' });
    }
    res.json({ message: 'Room deleted successfully' });
  });
});

// ===== Routes pour les teachers =====
// Route pour obtenir tous les teachers
app.get('/teachers', (req, res) => {
  db.query('SELECT * FROM teachers', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Route pour ajouter un nouveau teacher
app.post('/teachers', (req, res) => {
  const { teacher_id, first_name, last_name, email, department, phone } = req.body;
  const query = `
    INSERT INTO teachers (teacher_id, first_name, last_name, email, department, phone)
    VALUES (?, ?, ?, ?, ?, ?)
  `;
  db.query(query, [teacher_id, first_name, last_name, email, department, phone], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Teacher added successfully!', teacherId: result.insertId });
  });
});

// ===== Routes pour les subjects =====
// Route pour obtenir tous les subjects
app.get('/subjects', (req, res) => {
  db.query('SELECT * FROM subjects', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Route pour ajouter un nouveau subject
app.post('/subjects', (req, res) => {
  const { subject_id, subject_name, subject_code, department, description } = req.body;
  const query = `
    INSERT INTO subjects (subject_id, subject_name, subject_code, department, description)
    VALUES (?, ?, ?, ?, ?)
  `;
  db.query(query, [subject_id, subject_name, subject_code, department, description], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Subject added successfully!', subjectId: result.insertId });
  });
});

// ===== Routes pour les sessions =====
// Route pour obtenir toutes les sessions
app.get('/sessions', (req, res) => {
  db.query('SELECT * FROM sessions', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Route pour ajouter une nouvelle session
app.post('/sessions', (req, res) => {
  const { session_id, subject_id, teacher_id, room_id, class_id, session_date, start_time, end_time } = req.body;
  const query = `
    INSERT INTO sessions (session_id, subject_id, teacher_id, room_id, class_id, session_date, start_time, end_time)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(query, [session_id, subject_id, teacher_id, room_id, class_id, session_date, start_time, end_time], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Session added successfully!', sessionId: result.insertId });
  });
});


// Lancer le serveur sur le port 3000
const PORT = process.env.PORT || 3060;
app.listen(PORT, () => {
  console.log(`Le serveur fonctionne sur le port ${PORT}`);
});
