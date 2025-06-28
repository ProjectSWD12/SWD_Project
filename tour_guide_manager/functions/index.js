const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.cleanupExcursions = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();
  const now = new Date();

  const todayStr = now.toISOString().split('T')[0]; // "YYYY-MM-DD"
  const cutoff = "23:55";

  try {
    const snapshot = await db.collection('excursions')
      .where('date', '==', todayStr)
      .get();

    const batch = db.batch();
    snapshot.forEach(doc => {
      const data = doc.data();
      if (data.time && data.time < cutoff) {
        batch.delete(doc.ref);
      }
    });

    await batch.commit();
    res.status(200).send('Cleanup complete.');
  } catch (e) {
    console.error('Error:', e);
    res.status(500).send('Error during cleanup.');
  }
});
