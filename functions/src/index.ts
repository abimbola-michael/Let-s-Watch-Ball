/* eslint-disable */
/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import { onRequest } from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import axios from "axios";

// Initialize Firebase Admin SDK
//admin.initializeApp();
//const db = admin.firestore();

//var matchesMap: Map<string, Match> = new Map();

// export const fetchAndStoreData = functions.pubsub
//   .schedule("every 1 minutes") // Runs every minute
//   .onRun(async () => {
//     async function readMatches() {
//       var headers = {
//         "x-rapidapi-key": "ddd5e8a399mshe43fb9e23b2e887p1f95aejsn2d5531f5c59a",
//         "x-rapidapi-host": "football-live-stream-api.p.rapidapi.com",
//       };
//       try {
//         // Fetch data from an API
//         const response = await axios.get(
//           "https://football-live-stream-api.p.rapidapi.com/index.php",
//           { headers }
//         );

//         const matchList = response.data;

//         const matches: Match[] = matchList?.map((item: Match) => item) ?? [];
//         for (var i = 0; i < matches.length; i++) {
//           let match = matches[i];
//           let isLive = /[0-9]/.test(match.status);
//           if (isLive && matchesMap.get(match.id) == null) {
//             const response = await axios.get(
//               "https://football-live-stream-api.p.rapidapi.com/stream.php",
//               { headers, params: { id: match.id } }
//             );
//             const linkInfoList = response.data;

//             const linkInfos: LinkInfo[] =
//               linkInfoList?.map((item: LinkInfo) => item) ?? [];
//             if (linkInfos.length > 0 && linkInfos[0].streamLink != null) {
//               match.linkInfos = linkInfos;
//               matchesMap.set(match.id, match);
//             }
//           } else {
//             match.linkInfos = matchesMap.get(match.id)?.linkInfos;
//           }
//           db.collection("matches").doc(match.id).set(match);
//         }
//         for (var match of matchesMap.values()) {
//           const isLive = /[0-9]/.test(match.status);
//           if (!isLive && !match.status.toLowerCase().includes("coming")) {
//             matchesMap.delete(match.id);
//           }
//         }
//         //console.log("Data successfully written to Firestore");
//       } catch (error) {
//         //console.error("Error fetching or storing data:", error);
//         readMatches();
//       }
//     }
//     readMatches();
//   });

// interface Match {
//   league: string;
//   date: string;
//   time: string;
//   status: string;
//   score: string;
//   homeName: string;
//   homeLogo: string;
//   awayName: string;
//   awayLogo: string;
//   id: string;
//   linkInfos?: Array<object>;
// }

// interface LinkInfo {
//   extraTitle: string;
//   streamLink?: string;
//   referer: string;
// }
