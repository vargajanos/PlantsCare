const express = require('express');
const cors = require('cors');
const mysql = require('mysql');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

var pool = mysql.createPool({
    connectionLimit: 10,
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'plantscare_vj'
});

//statisztika 
app.get('/api/plants/stats', (req, res) => {
    pool.query('SELECT * FROM statistics', (error, results) => {
      if (error) {
        return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
      }
      res.status(200).json(results);
    });
  });


//összes növény lekérése
app.get('/api/plants', (req, res) => {
  pool.query('SELECT * FROM plants', (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
    }
    res.status(200).json(results);
  });
});

//egy növény lekérése
app.get('/api/plants/:id', (req, res) => {
  const plantId = req.params.id;
  pool.query('SELECT * FROM plants WHERE id = ?', [plantId], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Növény nem található' });
    }
    res.status(200).json(results[0]);
  });
});

//növény hozzáadása 
app.post('/api/plants', (req, res) => {
  const { name, species, water_interval_days } = req.body;
  if (!name || !species || !water_interval_days) {
    return res.status(400).json({ error: 'Minden mező kitöltése kötelező' });
  }
  
  pool.query('INSERT INTO plants (name, species, water_interval_days) VALUES (?, ?, ?)', 
    [name, species, water_interval_days], (error, results) => {
      if (error) {
        return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
      }
      res.status(200).json({ id: results.insertId, name, species, water_interval_days });
    });
});

//növény modósítása
app.patch('/api/plants/:id', (req, res) => {
  const plantId = req.params.id;
  const { name, species, water_interval_days } = req.body;

  if (!name || !species || !water_interval_days) {
    return res.status(400).json({ error: 'Minden mező kitöltése kötelező' });
  }

  pool.query('UPDATE plants SET name = ?, species = ?, water_interval_days = ? WHERE id = ?', 
    [name, species, water_interval_days, plantId], (error, results) => {
      if (error) {
        return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
      }
      if (results.affectedRows === 0) {
        return res.status(404).json({ error: 'Növény nem található' });
      }
      res.status(200).json({ id: plantId, name, species, water_interval_days });
    });
});

//növény törlése
app.delete('/api/plants/:id', (req, res) => {
  const plantId = req.params.id;
  pool.query('DELETE FROM plants WHERE id = ?', [plantId], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Növény nem található' });
    }
    res.status(200).json({ message: 'Növény sikeresen törölve' });
  });
});



// növény öntözése lekérése id alapján
app.get('/api/plants/:id/waterings', (req, res) => {
  const plantId = req.params.id;
  pool.query('SELECT * FROM watering_logs WHERE plant_id = ?', [plantId], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Növény öntözési naplója nem található' });
    }
    res.status(200).json(results);
  });
});

// új öntözési napló hozzáadása
app.post('/api/waterings', (req, res) => {
  const { date, amount_ml, plant_id, notes } = req.body;

  if (!date || !amount_ml, !plant_id || !notes) {
    return res.status(400).json({ error: 'Minden mező kitöltése kötelező' });
  }

  pool.query('INSERT INTO watering_logs (plant_id, date_watered, amount_ml, notes) VALUES (?, ?, ?, ?)', 
    [plant_id, date, amount_ml, notes], (error, results) => {
      if (error) {
        return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
      }
      res.status(200).json({ id: results.insertId, plant_id: plant_id, date, amount_ml, notes });
    });
});

//törlés id alapján
app.delete('/api/waterings/:id', (req, res) => {
  const logId = req.params.id;
  pool.query('DELETE FROM watering_logs WHERE id = ?', [logId], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Hiba az adatbázis kapcsolatban' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Öntözési napló nem található' });
    }
    res.status(200).json({ message: 'Öntözési napló sikeresen törölve' });
  });
});


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
