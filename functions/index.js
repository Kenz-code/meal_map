/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.createPairing = onCall(async (request) => {
  const uid = request.auth.uid;

  const pairingRef = db.collection("pairings").doc();

  await pairingRef.set({
    uid: uid,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: admin.firestore.Timestamp.fromDate(
        new Date(Date.now() + 120000),
    ),
    used: false,
  });

  return {
    pairingId: pairingRef.id,
    expiresAt: new Date(Date.now() + 120000).toISOString(),
  };
});

exports.completePairing = onCall(async (request) => {
  const {pairingId} = request.data;

  if (!pairingId) {
    throw new Error("Missing pairing ID");
  }

  const pairingRef = db
      .collection("pairings")
      .doc(pairingId);

  const pairingSnap = await pairingRef.get();

  if (!pairingSnap.exists) {
    throw new Error("Pairing does not exist");
  }

  const pairing = pairingSnap.data();


  if (pairing.used) {
    throw new Error("Pairing already used");
  }


  const now = new Date();

  if (pairing.expiresAt.toDate() < now) {
    throw new Error("Pairing expired");
  }


  const token =
      await admin.auth()
          .createCustomToken(pairing.uid);


  await pairingRef.update({
    used: true,
  });


  return {
    token,
  };
});

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
