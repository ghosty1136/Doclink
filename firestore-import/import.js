const admin = require("firebase-admin");
const fs = require("fs");
const csv = require("csv-parser");

// Initialize Firebase Admin
const serviceAccount = require("./doclink.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// === CONFIG ===
const csvFilePath = "dates.csv"; // Your CSV file name
const targetCollection = "Dates"; // Your Firestore collection name
const BATCH_LIMIT = 500; // Firestore batch write limit

// Generate doc IDs from 'a' to 'z', then 'aa', 'ab'... if needed
function generateAlphabetIds(count) {
  const ids = [];
  const chars = "abcdefghijklmnopqrstuvwxyz";

  function generate(prefix = "") {
    for (let i = 0; i < chars.length && ids.length < count; i++) {
      const id = prefix + chars[i];
      ids.push(id);
    }
  }

  // Keep generating until we reach the desired count
  let prefixList = [""];
  while (ids.length < count) {
    const current = prefixList.shift();
    generate(current);
    if (current.length < 2) {
      for (let i = 0; i < chars.length; i++) {
        prefixList.push(current + chars[i]);
      }
    }
  }

  return ids;
}

async function importCSVInBatches() {
  const rows = [];

  // Read all rows from CSV
  await new Promise((resolve, reject) => {
    fs.createReadStream(csvFilePath)
      .pipe(csv())
      .on("data", (row) => rows.push(row))
      .on("end", resolve)
      .on("error", reject);
  });

  console.log(`Total rows to import: ${rows.length}`);

  const docIds = generateAlphabetIds(rows.length);

  let batchCount = 0;

  for (let i = 0; i < rows.length; i += BATCH_LIMIT) {
    const batch = db.batch();
    const chunk = rows.slice(i, i + BATCH_LIMIT);
    const chunkDocIds = docIds.slice(i, i + BATCH_LIMIT);

    chunk.forEach((row, index) => {
      const cleanedData = {};

      // Clean row: remove undefined/null, trim whitespace
      for (const key in row) {
        if (row[key] !== undefined && row[key] !== null) {
          cleanedData[key.trim()] = row[key].trim();
        }
      }

      const docRef = db.collection(targetCollection).doc(chunkDocIds[index]);
      batch.set(docRef, cleanedData);
    });

    await batch.commit();
    batchCount++;
    console.log(`Batch ${batchCount} committed with ${chunk.length} records.`);
  }

  console.log("CSV import complete.");
}

importCSVInBatches().catch((err) => {
  console.error("Import failed:", err);
});
